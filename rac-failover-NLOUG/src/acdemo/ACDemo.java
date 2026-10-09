package acdemo;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Properties;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
// GG Added for database driver information
import java.sql.DatabaseMetaData;

import javax.sql.DataSource;

import oracle.ucp.admin.UniversalConnectionPoolManagerImpl;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;
import oracle.ucp.admin.UniversalConnectionPoolManager;
import oracle.ucp.UniversalConnectionPoolAdapter;
import oracle.ucp.UniversalConnectionPoolException;
import oracle.ucp.UniversalConnectionPoolStatistics;

/**
 * This demo of Application Continuity uses the Universal Connection Pool (UCP) and
 * the JDBC thin driver to simulate a web workload with servlets concurrently
 * requesting connections from the pool to execute SQL on the database.
 * In order to show the effect of application continuity the database sessions need to be
 * killed manually. Without AC this demo will crash. With AC only a small response time
 * increase should be seen.
 *
 * This demo is packaged in a jar to facilitate its execution.
 * See runreplay and runnoreplay script files.
 * Beforehand,  you need to change the configuration parameters in "acdemo.properties".
 *
 * Note that the demo will run forever and needs to be killed.
 *
 * @author Jean de Lavarene
 * @contributing author Kuassi Mensah
 * @contributing author Troy Anthony
 */
public class ACDemo extends Thread {

  // Number of concurrent threads running in the application
  // UCP is tuned to have MAX and MIN limit set to this

  // How often should the thread print statistics.   Time in milliseconds
  static final int DELAY_BETWEEN_PRINTING_STATS = 5 * 1000;
  static boolean VERBOSE = true;
  static boolean PRINTACSTAT = false;
  private static String PROP_FILE="acdemo.properties";
  static int connectionWaitTimeout = 3; // seconds

  static int nbOfThreads = 0;
  static int ucpPoolSize = 0;
  static int threadThinkTime = 0;
  // Do not require validateConnectionOnBorrow if patch 31112088 applied
  static boolean validateConnectionOnBorrow = false;

  static boolean applicationCrashOnErrors = true;
  static boolean fastConnectionFailover = false;

  static boolean cpuIntensive = false;

  static final Object statsLock = new Object();
  static int operationsCompleted = 0;

  // timeSpentOnDb should not include wait time
  static long timeSpentOnDb = 0;

  static int nbOfExceptions = 0;

  // AC statistics
  static long acTotalCalls = 0;
  static long acTotalProtectedCalls = 0;
  static long TotalReplayAttempts = 0;
  static long FailedReplayCount = 0;
  static long SuccessfulReplayCount = 0;
  static long TotalCallsAffectedByOutages = 0;
  static long TotalRequests = 0;

  static public void main(String args[])
    throws SQLException {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if(args.length > 0) {
      PROP_FILE = args[0];
    }
    try {
      Properties prop = new Properties();
      try {
        prop.load(new FileInputStream(PROP_FILE));
      } catch (IOException e) {e.printStackTrace();}

      // get swetting if we print AC statistics
      PRINTACSTAT = Boolean.parseBoolean(prop.getProperty("print_ac_stats","false"));

      nbOfThreads = Integer.parseInt(prop.getProperty("number_of_threads"));
      ucpPoolSize = Integer.parseInt(prop.getProperty("ucp_pool_size"));
      threadThinkTime = Integer.parseInt(prop.getProperty("thread_think_time","20"));
      VERBOSE = Boolean.parseBoolean(prop.getProperty("verbose","false"));
      applicationCrashOnErrors = Boolean.parseBoolean(prop.getProperty("application_crash_on_errors","true"));
      fastConnectionFailover = Boolean.parseBoolean(prop.getProperty("fastConnectionFailover","false"));
      validateConnectionOnBorrow = Boolean.parseBoolean(prop.getProperty("validateConnectionOnBorrow","false"));
      connectionWaitTimeout = Integer.parseInt(prop.getProperty("connectionWaitTimeout","3"));
      PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();
      pds.setConnectionFactoryClassName(prop.getProperty("datasource"));
      // Set DataSource Property
      pds.setUser(prop.getProperty("username","HR"));
      pds.setPassword(prop.getProperty("password","HR"));
      pds.setURL(prop.getProperty("url"));
      pds.setConnectionPoolName(UCP_POOL_NAME);
      pds.setConnectionWaitTimeout(connectionWaitTimeout);
      pds.setFastConnectionFailoverEnabled(fastConnectionFailover);
      pds.setValidateConnectionOnBorrow(validateConnectionOnBorrow);
      pds.setInitialPoolSize(ucpPoolSize);
      pds.setMinPoolSize(ucpPoolSize);
      pds.setMaxPoolSize(ucpPoolSize);
      pds.setConnectionProperties(prop);

      System.out.println("######################################################");
      System.out.println("Connecting to            " + prop.getProperty("url"));
      System.out.println(" # of Threads:           " + nbOfThreads);
      System.out.println(" UCP pool size:          " + ucpPoolSize);
      System.out.println("FCF Enabled:             " + pds.getFastConnectionFailoverEnabled());
      System.out.println("VCoB Enabled:            " + pds.getValidateConnectionOnBorrow());
      System.out.println("ONS Configuration:       " + pds.getONSConfiguration());
      System.out.println("Enable Intensive Wload:  " + cpuIntensive);
      System.out.format("Thread think time:        %d ms\n",
        threadThinkTime);
      System.out.println("Print AC Statistics:     " + PRINTACSTAT);
      System.out.println("######################################################");
      System.out.println("");

      // Start the connection pool with the PoolManager:
      UniversalConnectionPoolManager poolManager =
        UniversalConnectionPoolManagerImpl.getUniversalConnectionPoolManager();
      poolManager.createConnectionPool((UniversalConnectionPoolAdapter)pds);
      System.out.println("Starting the pool now... (please wait)");
      long start = System.currentTimeMillis();
      poolManager.startConnectionPool(UCP_POOL_NAME);
      long end = System.currentTimeMillis();
      System.out.println("Pool is started in "+(end-start)+"ms");

      // GG get driver versions
      conn = pds.getConnection();
      DatabaseMetaData metaData = conn.getMetaData();

      System.out.println("Driver Name:         " + metaData.getDriverName());
      System.out.println("JDBC Driver Version: " + metaData.getDriverVersion());
      System.out.println("######################################################");
      conn.close();
      // GG - End

      ACDemo u = new ACDemo();
      u.runDemo(pds);
    } catch (SQLException sqlea) {
      do{
        sqlea.printStackTrace();
        sqlea = sqlea.getNextException();
      }
      while(sqlea != null);
    }
    catch (Exception ea) {
      System.out.println("Error during execution: " + ea);
      ea.printStackTrace();
    } finally {
         if (rs != null) rs.close();
         if (pstmt != null) pstmt.close();
         if (conn != null) conn.close();
    }

  }

  /**
   * Start the worker threads:
   */
  private void runDemo(PoolDataSource pds)
    throws Exception {

    Thread[] t = new Thread[nbOfThreads];

    for (int i = 0; i < nbOfThreads; ++i) {
      t[i] = new Thread(new Worker(pds));
      t[i].start();
    }

    /*  Stats thread - displays some UCP statistics */
    Thread stat = new PrintStatThread();
    stat.start();

    //if ( PRINTACSTAT ) {
        /*  AC Stats thread - displays AC client statistics
             Note: The acchk utility is database resident in 19.12 and provides view-based access to the Application Continuity statistics.
             The acchk utility is available from within Orachk prior to Oracle Database 19c
        */
    /*
        Thread acStat = new PrintACStatThread(pds);
        acStat.start();

    }
    */

    // Wait for all threads to be done:
    for (int i = 0; i < nbOfThreads; ++i) {
      t[i].join();
    }
    needToPrintStats = false;
    stat.interrupt();
    //acStat.interrupt();

  }

  static boolean needToPrintStats = true;
  static String UCP_POOL_NAME="actest";
}
