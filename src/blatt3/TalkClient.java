package blatt3;

import java.rmi.Remote;
import java.rmi.RemoteException;

/** This is an interface for a simple RMI talk client */
public interface TalkClient extends Remote {
    
    /** Connect to the talk client */
    public void connect(TalkClient other) throws RemoteException;
    
    /** Say good bye to the talk client */
    public void bye() throws RemoteException;
    
    /** Send a message to the talk client */
    public void send(String msg) throws RemoteException;
}
