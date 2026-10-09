package watchfan;

/* This code is based on original FanWatcher code from an Oracle blog
 * blog that is not longer readily available.  Stated with code from
 * 12c whitepaper and then heavily modified for demo
*/

import oracle.simplefan.FanSubscription;
import oracle.simplefan.FanEventListener;
import oracle.simplefan.FanManager;
import oracle.simplefan.LoadAdvisoryEvent;
import oracle.simplefan.NodeDownEvent;
import oracle.simplefan.NodeUpEvent;
import oracle.simplefan.ServiceDownEvent;
import oracle.simplefan.ServiceUpEvent;
import java.util.Properties;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class WatchFan {

    private static String PROP_FILE="watchfan.properties";

    // GG add timestamp data to output
    LocalDateTime now = null;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
    private FanManager fanManager;
    private FanSubscription fanSubscription;

    WatchFan() {
        System.out.println("Hello Oracle FAN monitor.");

        Properties onsProps = new Properties();

        // Get settings
        Properties propFile = new Properties();
        try {
          propFile.load(new FileInputStream(PROP_FILE));
        } catch (IOException e) {e.printStackTrace();}

        // Setup or Fan connection
        fanManager = FanManager.getInstance();

        // Check for connection type
        String onsconnect = propFile.getProperty("onsConnect");

        if ( onsconnect.equals("LOCAL") ) {
            String oraclehome = propFile.getProperty("oracle.ons.oraclehome");
            System.setProperty("oracle.ons.oraclehome", oraclehome);
            System.out.println("Using local connection home: "+oraclehome);
        } else if ( onsconnect.equals("REMOTE") ) {
            String onsnodes = propFile.getProperty("onsNodes");
            onsProps.setProperty("onsNodes", onsnodes);
            System.out.println("Using remote connection servers: "+onsnodes);
            fanManager.configure(onsProps);
        } else {
            System.out.println("ERROR! invalid onsconnect setting in config file.");
        }

        // Get the service we are monitoring
        String servicename = propFile.getProperty("serviceName");
        System.out.println("Monitoring Service: "+servicename);

        // Subscribe the fan to service
        Properties subProp = new Properties();
        subProp.setProperty("serviceName", servicename);
        fanSubscription = fanManager.subscribe(subProp);

        fanSubscription.addListener(new FanEventListener() {

            public void handleEvent(ServiceDownEvent arg0) {
                // GG add timestamp data to output
                now = LocalDateTime.now();

                System.out.println(now.format(formatter) +" Service Down Event!, DB: "+arg0.getDatabaseUniqueName()+
                        ", Service: "+arg0.getServiceName() + ", Drain Timeout: "+arg0.getDrainTimeout()+", Observed at: " + arg0.getTimestamp());
                System.out.println("         Reason: "+arg0.getReason()+ ", Kind: "+arg0.getKind());
                if (arg0.getKind().toString().equals("MEMBER")) {
                    System.out.println("         Node Name: "+arg0.getServiceMemberEvent().getNodeName()+", Instance Name: "+arg0.getServiceMemberEvent().getInstanceName());
                }
            }

            public void handleEvent(ServiceUpEvent arg0) {
                // GG add timestamp data to output
                now = LocalDateTime.now();

                System.out.println(now.format(formatter) +" Service Up Event!, DB: "+arg0.getDatabaseUniqueName()+
                        ", Service: "+arg0.getServiceName() + ", Cardinality: "+arg0.getCardinality());
                System.out.println("         Reason: "+arg0.getReason()+ ", Kind: "+arg0.getKind()+", Observed at: " + arg0.getTimestamp());
                if (arg0.getKind().toString().equals("MEMBER")) {
                    System.out.println("         Node Name: "+arg0.getServiceMemberEvent().getNodeName()+", Instance Name: "+arg0.getServiceMemberEvent().getInstanceName());
                }
            }

            public void handleEvent(NodeDownEvent arg0) {
                // GG add timestamp data to output
                now = LocalDateTime.now();

                System.out.println(now.format(formatter) +" Node Down Event!, Node: "+arg0.getNodeName()+", Incarnation: "+arg0.getIncarnation() +", Observed at: " + arg0.getTimestamp());
            }

            public void handleEvent(NodeUpEvent arg0) {
                // GG add timestamp data to output
                now = LocalDateTime.now();

                System.out.println(now.format(formatter) +" Node Up Event!, Node: "+arg0.getNodeName()+", Incarnation: "+arg0.getIncarnation()+", Observed at: " + arg0.getTimestamp());
            }

            public void handleEvent(LoadAdvisoryEvent arg0) {
                // GG add timestamp data to output
                now = LocalDateTime.now();

                System.out.println(now.format(formatter) +"Load Advisory event!"+ ", DB: " + arg0.getDatabaseUniqueName()+", Instance: " +
                         arg0.getInstanceName()+ ", Service: " + arg0.getServiceName());
                System.out.println("         Observed at: " + arg0.getTimestamp() + ", Service Quality : " + arg0.getServiceQuality()+ ", Percent: " + arg0.getPercent());
            }
        }
    );
}

/**
* @param args
*/
public static void main(String[] args) {
// TODO Auto-generated method stub
WatchFan wf = new WatchFan();

int i = 0;
while ( i < 100000)  {
    try {
        Thread.sleep(100);
        i++;
    } catch (Exception e) {
        System.out.println(e);
    }
    }

        System.out.println("execution ended");
    }

}



