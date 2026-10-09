package acdemo;

import oracle.ucp.admin.UniversalConnectionPoolManagerImpl;
import oracle.jdbc.replay.ReplayStatistics;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Every x seconds (5s by default) this thread prints statistics into the standard output.
 * These statistics include some basic UCP statistics as well as the average database
 * response time which is used to show that AC can affect the response time
 * when it needs to reconnect and replay.
 *
 * @author Jean de Lavarene
 */
class PrintStatThread extends Thread {

    private static void display_replay_statistics(ReplayStatistics rs) {
      System.out.println("Client Statistics: ");
       System.out.println("FailedReplayCount="+rs.getFailedReplayCount());
       System.out.println("ReplayDisablingCount="+rs.getReplayDisablingCount());
       System.out.println("SuccessfulReplayCount="+rs.getSuccessfulReplayCount());
       System.out.println("TotalCalls="+rs.getTotalCalls());
       System.out.println("TotalCallsAffectedByOutages="+rs.getTotalCallsAffectedByOutages());
       System.out.println("TotalCallsAffectedByOutagesDuringReplay="+ rs.getTotalCallsAffectedByOutagesDuringReplay());
       System.out.println("TotalCallsTriggeringReplay="+rs.getTotalCallsTriggeringReplay());
       System.out.println("TotalCompletedRequests="+rs.getTotalCompletedRequests());
       System.out.println("TotalProtectedCalls="+rs.getTotalProtectedCalls());
       System.out.println("TotalReplayAttempts="+rs.getTotalReplayAttempts());
       System.out.println("TotalRequests="+rs.getTotalRequests());
       System.out.println("Protected Percentage="+((int)((double)rs.getTotalProtectedCalls()/(double)rs.getTotalCalls()*100)));
    }

  public void run() {

    // GG add timestamp data to output
    LocalDateTime now = null;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");

    while (true) {
      try {
        Thread.sleep(ACDemo.DELAY_BETWEEN_PRINTING_STATS);
        long operationsCompleted = 0;
        long timeSpentOnDb = 0;
        synchronized (ACDemo.statsLock) {
          operationsCompleted = ACDemo.operationsCompleted;
          timeSpentOnDb = ACDemo.timeSpentOnDb;
          ACDemo.operationsCompleted = 0;
          ACDemo.timeSpentOnDb = 0;
        }
        long avgDBResponseTime = (operationsCompleted==0)?0:timeSpentOnDb/operationsCompleted;
        long ucpBorrowedConnectionCount = UniversalConnectionPoolManagerImpl
                .getUniversalConnectionPoolManager()
                .getConnectionPool(ACDemo.UCP_POOL_NAME)
                .getStatistics()
                .getBorrowedConnectionsCount();
        long ucpPendingRequests = UniversalConnectionPoolManagerImpl
                .getUniversalConnectionPoolManager()
                .getConnectionPool(ACDemo.UCP_POOL_NAME)
                .getStatistics().getPendingRequestsCount();
        long ucpWaitTime = UniversalConnectionPoolManagerImpl
            .getUniversalConnectionPoolManager()
            .getConnectionPool(ACDemo.UCP_POOL_NAME)
            .getStatistics().getAverageConnectionWaitTime();
        long totalBorrowed = UniversalConnectionPoolManagerImpl
            .getUniversalConnectionPoolManager()
            .getConnectionPool(ACDemo.UCP_POOL_NAME)
            .getStatistics().getCumulativeConnectionBorrowedCount();

        // GG added more statistics abut UCP
        long availableConnections =  UniversalConnectionPoolManagerImpl
            .getUniversalConnectionPoolManager()
            .getConnectionPool(ACDemo.UCP_POOL_NAME)
            .getStatistics().getAvailableConnectionsCount();

        long connectionsCreated =  UniversalConnectionPoolManagerImpl
            .getUniversalConnectionPoolManager()
            .getConnectionPool(ACDemo.UCP_POOL_NAME)
            .getStatistics().getTotalConnectionsCount();
            //.getStatistics().getConnectionsCreatedCount();

        long avgObtConWaitms =  UniversalConnectionPoolManagerImpl
            .getUniversalConnectionPoolManager()
            .getConnectionPool(ACDemo.UCP_POOL_NAME)
            .getStatistics().getAverageConnectionWaitTime();

        // GG add timestamp data to output
        now = LocalDateTime.now();
        // GG Added more statistics
        System.out.println(now.format(formatter) + ": "+connectionsCreated+" Connections, "+availableConnections+" Available, "+avgObtConWaitms+" ms AVG wait to obtain, " + ACDemo.nbOfExceptions + " SQL Exceptions");
        System.out.print("          " + ucpBorrowedConnectionCount + " borrowed, "+ucpPendingRequests+" pending, "+ucpWaitTime+"ms getConnection wait, TotalBorrowed " + totalBorrowed);

        // Print the average response time:
        if(avgDBResponseTime > 0) {
          System.out.print(", avg response time from db " + avgDBResponseTime + "ms");
        }
        System.out.print("\n");

        // GG AC statistics
        System.out.printf("          %,9d Req, %,9d Calls, %,9d Protected, %3d Outages, Replay: %3d Attempts, %3d Failed, %3d Success %n",
                      ACDemo.TotalRequests, ACDemo.acTotalCalls, ACDemo.acTotalProtectedCalls, ACDemo.TotalCallsAffectedByOutages, ACDemo.TotalReplayAttempts, ACDemo.FailedReplayCount, ACDemo.SuccessfulReplayCount);

      } catch (Exception ea) {}
    }
  }
}
