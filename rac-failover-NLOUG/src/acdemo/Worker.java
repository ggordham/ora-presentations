package acdemo;

import javax.sql.DataSource;
import java.sql.*;
import oracle.ucp.jdbc.ValidConnection;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.oracle.OracleJDBCConnectionPoolStatistics;
import java.util.Random;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;

// added for replay statistics
import oracle.jdbc.replay.ReplayStatistics;
import oracle.jdbc.replay.ReplayableConnection;

/**
 * Worker thread that runs the workload in a loop. This simulates a servlet
 * execution that accesses the database.
 *
 * In a loop the threads will:
 *  1. Grab a connection from the pool
 *  2. Execute SQL
 *  3. Release the connection from the pool
 *  4. Sleep to simulate time used for the business execution
 *
 * @author Jean de Lavarene
 * @Contributing author Kuassi Mensah
 */
class Worker implements Runnable {
  PoolDataSource ds;
  Random random;
  Boolean cpuIntensive;
  Worker(PoolDataSource _ds) {
    ds = _ds;
    random = new Random();
  }

  /**
   * This method contains the database workload. We're just executing some
   * basic select queries to simulate some load. We could also have transactions
   * here. This method can be modified to cover AC in some more advanced cases:
   *
   * 1. STATIC vs. DYNAMIC: are you changing the database session states dynamically
   *    within transactions? If so your application is DYNAMIC and AC will disable replay
   *    after the first successful commit because it would not be able to reset the
   *    correct session states during a replay.
   * 2. Are you using the JDBC concrete classes such as oracle.sql.ARRAY or oracle.sql.VARCHAR?
   *    If so AC will be disabled because it will not be able to use proxies for these classes.
   * 3. You can cast the connection object to a oracle.jdbc.replay.ReplayableConnection
   *    to for example call "disableReplay()" if there is a specific action that you know
   *    should never been replayed. See Javadoc:
   *      https://docs.oracle.com/en/database/oracle/oracle-database/19/jajdb/oracle/jdbc/replay/ReplayableConnection.html
   */
  void databaseWorkload(Connection c) throws SQLException {
    // nothing terribly smart here: we just want to make some
    // roundtrips to the database.
    for(int i=0;i<10;i++) {
      // PreparedStatement pstmt = c.prepareStatement("SELECT "+i+" from dual");
      PreparedStatement pstmt = c.prepareStatement("SELECT ENAME from EMP4AC WHERE ROWNUM < 10 and EMPNO = 1282");
      ResultSet rs = pstmt.executeQuery();
      while(rs.next())
      {
        String row = rs.getString(1);
        // trick the JIT:
        if(row.equals("")) {
          System.exit(1);
        }
      }
      pstmt.close();
    }
    {
       PreparedStatement pstmt = c.prepareStatement("insert into emp4AC(empno,ename,sal) values(?,?,?)");
       int empno = (int)System.nanoTime()%999999;
       pstmt.setInt(1,empno);
       pstmt.setString(2,"Bob"+empno);
       pstmt.setInt(3,8000);
       try{
            pstmt.executeUpdate();
            if (ACDemo.VERBOSE) { System.out.println("Adding row to emp4AC"); }

        } catch(SQLException insertsqlex)
        {
         if (insertsqlex instanceof SQLIntegrityConstraintViolationException) {
            if (insertsqlex.getMessage().startsWith("ORA-00001: unique constraint (HR.PK_EMP) violated")){
              System.out.println("in catch block for constraint violation\n");
              empno++;
            }
         }
         else throw insertsqlex;
       }
      pstmt.close();
    }
    // c.rollback();


     // commit the data
     c.commit();
  }

  public void run() {
    long counter = 0;
     boolean retry = false;
    while(true) {
      Connection c = null;
     DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:MM:SS");
     Calendar cal = Calendar.getInstance();

      long nanoTimeStart=0,timeSpentOnDb = 0;
      try {
        // Step 1: Get a connection from UCP. This corresponds to the beginning
        // of the AC request. The replay driver will now start recording all the
        // JDBC calls.
        c = ds.getConnection();
        // Make sure auto commit if off:
        c.setAutoCommit(false);

        /*
         *  Print connection instance
         */
        /*
          ResultSet rs;
          Statement stmt = c.createStatement();

          rs =

           stmt.executeQuery("select '... Connected to '||sys_context('userenv','instance_name') from dual");

          while (rs.next()) {
              // Only display for VERBOSE operation
              if (ACDemo.VERBOSE) { System.out.println( dateFormat.format(cal.getTime()) + "  " + rs.getString(1)); }
          }
          rs.close();
          stmt.close();
          */
           if (retry) {
              System.out.println(" Application driven connection retry succeeded");
              retry = false;
           }

        nanoTimeStart = System.nanoTime();

        // Step 2: run the workload
        if (ACDemo.VERBOSE) { System.out.println("Executing databaseWorkload()"); }
        databaseWorkload(c);

        // GG AC statistics if set to true
        if ( ACDemo.PRINTACSTAT ) {

            // Caputre replay statistics
            ReplayStatistics stats = (((oracle.jdbc.replay.ReplayableConnection) c).getReplayStatistics(ReplayableConnection.StatisticsReportType.FOR_ALL_CONNECTIONS));

            ACDemo.acTotalCalls          = stats.getTotalCalls();
            ACDemo.acTotalProtectedCalls = stats.getTotalProtectedCalls();
            ACDemo.TotalReplayAttempts   = stats.getTotalReplayAttempts();
            ACDemo.FailedReplayCount     = stats.getFailedReplayCount();
            ACDemo.SuccessfulReplayCount = stats.getSuccessfulReplayCount();
            ACDemo.TotalCallsAffectedByOutages = stats.getTotalCallsAffectedByOutages();
            ACDemo.TotalRequests         = stats.getTotalRequests();
        }

      } catch (SQLException ea) {
        // Application developers have to write code to recover
        // from database errors. With AC they would still have to do so but
        // it'll only be exercised if  AC wasn't able to do its magic.
        //
        // Fast Connection Failover
        try {
         if (c == null ||!((ValidConnection)c).isValid()){
          ea.printStackTrace();
          System.out.println("Application error handling: attempting to get a new connection "+ea.getMessage()+".");
           c.close();
           String fcfInfo = ((OracleJDBCConnectionPoolStatistics) ds.getStatistics()).getFCFProcessingInfoProcessedOnly();
           System.out.println("FCF information: " + fcfInfo);
            retry = true;
         } else {
          System.out.println("unknown exception: " + ea);
          }
        }catch (SQLException ea1) {}
        //
        synchronized (ACDemo.statsLock) {
          ACDemo.nbOfExceptions++;
          if(ACDemo.applicationCrashOnErrors && ACDemo.nbOfExceptions > 20)
          {
            // I'm a very poorly written application and I will crash after
            // 20 exceptions:
            System.err.println("20 fatal exceptions.");
            System.err.println("");
            System.err.println("*** APPLICATION CRASHED ***");
            System.err.println("");
            System.exit(1);
          }
        }
        if(ACDemo.VERBOSE) {
          ea.printStackTrace();

          System.err.println("."+ea.getMessage()+".");
        }

      } finally {
        timeSpentOnDb = (System.nanoTime()-nanoTimeStart)/1000000; // in ms
        try {
          if (c != null) {
            // Step 3: release the connection into the pool. This corresponds
            // to the end of the AC request. The AC driver stops recording and
            // can purge the replay queue.
            c.close();
            if (ACDemo.VERBOSE) { System.out.println("Closed connection"); }
          }
        } catch (SQLException ea) {}
      }

      // don't update the state for the first run:
      if(counter > 0) {
        synchronized (ACDemo.statsLock) {
          ACDemo.operationsCompleted++;
          // ACDemo.timeSpentOnGetConnection += timeSpentOnGetConnection;
          ACDemo.timeSpentOnDb += timeSpentOnDb;
        }
      }
      // Step 4: sleep to simulate the business processing time
      if (ACDemo.threadThinkTime > 0) {
        // Introduce delay between requests for processing webpages
        long timeToSleep = ACDemo.threadThinkTime +
          random.nextInt((ACDemo.threadThinkTime<10)?10:ACDemo.threadThinkTime/10);
        try {
          Thread.sleep(timeToSleep);
        } catch (Exception ea) {}
      }
      counter++;
    }
  }
}
