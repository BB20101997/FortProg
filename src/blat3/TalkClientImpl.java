package blat3;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.Scanner;

public class TalkClientImpl implements TalkClient {
    
    private static final String  REG       = "TalkClient";
    volatile             boolean connected = false;
    transient TalkClient other;
    transient String     name;
    
    private static Registry getOrCreateRegistry() {
        try{
            return LocateRegistry.createRegistry(Registry.REGISTRY_PORT);
        } catch(RemoteException re){
            try{
                return LocateRegistry.getRegistry();
            } catch(RemoteException re2){
                return null;
            }
        }
    }
    
    public static void main(String[] tArgs) {
        Registry r = getOrCreateRegistry();
        switch(tArgs.length){
            case 1:{
                try{
                    TalkClientImpl we = new TalkClientImpl();
                    we.name = tArgs[0];
                    r.rebind(REG, UnicastRemoteObject.exportObject(we, 0));
                    we.talk();
                    r.unbind(REG);
                } catch(RemoteException | NotBoundException e){
                    e.printStackTrace();
                    System.exit(1);
                }
                break;
            }
            case 2:{
                try{
                    TalkClientImpl we = new TalkClientImpl();
                    we.name = tArgs[0];
                    we.connect((TalkClient) Naming.lookup("rmi://"+tArgs[1]+"/"+REG));
                    we.other.connect((TalkClient) UnicastRemoteObject.exportObject(we, 0));
                    we.talk();
                } catch(RemoteException | NotBoundException | MalformedURLException | NullPointerException e){
                    e.printStackTrace();
                    System.exit(1);
                }
                break;
            }
            default:{
                System.err.println("Usage");
                System.err.println("To receive a call: java blat3.TalkClientImpl <user>");
                System.err.println("To call someone: java blat3.TalkClientImpl <user> <host>");
                System.exit(1);
            }
        }
        System.exit(0);
    }
    
    public void talk() {
        waitForOther();
        connected = true;
        System.out.println("Welcome to talk, type ':q' to quit.");
        try{
            other.send("You are connected to " + name + ".");
            try(Scanner in = new Scanner(System.in)){
                String msg;
                while(connected){
                    msg = in.nextLine();
                    if(connected) {
                        if(msg.equals(":q")) {
                            other.bye();
                            bye();
                        } else {
                            other.send(msg);
                        }
                    }
                }
            }
        } catch(RemoteException e){
            e.printStackTrace();
            System.exit(1);
        }
    }
    
    @Override
    public synchronized void connect(final TalkClient other) throws RemoteException {
        this.other = other;
        connected = true;
        notify();
    }
    
    @Override
    public synchronized void bye() throws RemoteException {
        if(connected) {
            System.out.println("Connection closed!");
            connected = false;
        }
    }
    
    @Override
    public void send(final String msg) throws RemoteException {
        if(connected) {
            System.out.println(msg);
        }
    }
    
    private synchronized void waitForOther() {
        while(!connected){
            try{
                this.wait();
            } catch(InterruptedException ignore){
            }
        }
    }
}
