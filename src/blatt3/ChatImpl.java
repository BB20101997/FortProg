package blatt3;

import java.net.MalformedURLException;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;
import java.util.function.Consumer;

public class ChatImpl {
    
    public static void main(String[] tArgs) {
        //I don't care if I get too many arguments
        if(tArgs.length >= 1) {
            switch(tArgs[0]){
                case "SERVER":{
                    new ChatServerImpl().start();
                }
                case "CLIENT":{
                    new ChatClientImpl().startup();
                    break;
                }
                default:{
                    System.out.println("Usage: java "+ChatImpl.class.getName()+" <SERVER|CLIENT>");
                    System.exit(1);
                }
            }
        } else {
            System.out.println("Usage: java "+ChatImpl.class.getName()+" <SERVER|CLIENT>");
            System.exit(1);
        }
    }
    
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
    
    public static class ChatClientImpl implements ChatClient {
        
        private final transient Map<String, Consumer<String>> actions = new HashMap<>();
        transient         ChatClient we;
        private transient ChatServer server;
        private transient String     name;
        private boolean connected = false;
        
        {
            actions.put(":q", this::quit);
        }
        
        void sendToServer(String msg) {
            try{
                server.send("[" + name + "]:" + msg);
            } catch(RemoteException e){
                connected = false;
                System.out.println("Connection lost!");
                System.exit(1);
            }
        }
        
        @Override
        public synchronized void send(final String msg) throws RemoteException {
            System.out.println(msg);
        }
        
        @SuppressWarnings("unused")
        private void quit(String msg) {
            connected = false;
            try{
                connected = false;
                server.logout(we);
                System.exit(0);
            } catch(RemoteException ignore){
            }
            System.out.println("Connection closed!");
        }
        
        void startup() {
            try(Scanner in = new Scanner(System.in)){
                
                String addr = null;
                do{
                    try{
                        if(addr != null) {
                            System.out.print("Try again");
                        } else {
                            System.out.print("Please enter the address of the Server");
                        }
                        System.out.println(", leave blank for localhost, ':q' to abort!");
                        addr = in.nextLine();
                        if(addr.isEmpty()) {
                            addr = "localhost";
                        } else if(addr.equals(":q")) {
                            System.exit(0);
                        }
                        server = (ChatServer) Naming.lookup("rmi://" + addr + "/" + ChatServer.RMI_NAME);
                    } catch(MalformedURLException | UnknownHostException url){
                        System.out.println("404 Not found");
                    } catch(ConnectException | NotBoundException r){
                        System.out.println("503 Service Unavailable");
                    }
                } while(server == null);
                
                we = (ChatClient) UnicastRemoteObject.exportObject(this, 0);
                
                //we synchronize so we don't receive messaged between connection an displaying all Connected Users
                synchronized(this){
                    do{
                        if(name != null) {
                            if(name.isEmpty()) {
                                System.out.println("Your Username may NOT be empty!");
                            } else {
                                System.out.println("409 Conflict");
                                System.out.println("Username already in use, try again:");
                            }
                        } else {
                            System.out.println("Please choose a Username:");
                        }
                        name = in.nextLine();
                    } while(name.isEmpty() || !server.register(we, name));
                    
                    connected = true;
                    System.out.println("Connection successful you may quit by entering ':q'!");
                    List<String> userNames = server.getUsers();
                    
                    //the size value of userName is always of by one but the content is correct
                    if(userNames.size() < 2) {
                        System.out.println("No other users are currently Connected, you are alone!");
                    } else {
                        System.out.println("The following " + (userNames.size() - 1) + " User(s) is/are Connected:");
                        for(String s : userNames){
                            if(!s.equals(name)) {
                                //We don't want to list us
                                System.out.println(s);
                            }
                        }
                    }
                }
                
                while(connected){
                    String msg = in.nextLine();
                    actions.getOrDefault(msg, this::sendToServer).accept(msg);
                }
            } catch(RemoteException e){
                e.printStackTrace();
            }
        }
        
    }
    
    public static class ChatServerImpl implements ChatServer {
        
        private static final String DISCONNECT = "[Server]:Client '%s' disconnected!";
        private static final String CONNECTED  = "[Server]:New Client '%s' joining!";
        Map<String, ChatClient> clients = new HashMap<>();
        
        @SuppressWarnings("InfiniteLoopStatement")
        void start() {
            try{
                Registry r = getOrCreateRegistry();
                if(r == null) {
                    System.err.println("Registry not found!");
                    System.exit(1);
                }
                r.rebind(ChatServer.RMI_NAME, UnicastRemoteObject.exportObject(this, 0));
                System.out.println("Server started!");
                synchronized(this){
                    /* yes it might be better to not sync on this as some methods do this as well and everytime we wake up we 'pause' the server */
                    while(true){
                        /*
                         * theoretically exporting and binding an Object
                         * should start the Registry and keep the Process going
                         * but in practice this has proven unreliable
                         * therefor we wait
                        */
                        try{
                            wait();
                        } catch(InterruptedException ignore){
                        }
                    }
                }
            } catch(RemoteException e){
                System.exit(1);
            }
        }
        
        @Override
        public synchronized boolean register(final ChatClient c, final String name) throws RemoteException {
            if(!clients.containsKey(name)) {
                //the client is not in the map therefor we tell everyone and add him
                send(String.format(CONNECTED, name));
                clients.put(name, c);
                return true;
            }
            return false;
        }
        
        @Override
        public synchronized List<String> getUsers() throws RemoteException {
            List<String> list = new ArrayList<>();
            list.addAll(clients.keySet());
            return list;
        }
        
        @Override
        public synchronized void logout(final ChatClient c) throws RemoteException {
            //we only logout clients who are logged-in
            clients.entrySet()
                   .stream()
                   .filter(e -> e.getValue().equals(c))
                   .findFirst()
                   .ifPresent((Map.Entry<String, ChatClient> e) -> {
                       clients.remove(e.getKey());
                       try{
                           send(String.format(DISCONNECT, e.getKey()));
                       } catch(RemoteException e1){
                           e1.printStackTrace();
                       }
                   });
        }
        
        @Override
        public synchronized void send(final String msg) throws RemoteException {
            /* if a Client typed in :stop-server we stop the server */
            if(msg.matches("\\[[a-zA-Z]*]::stop-server")) {
                send("[Server]: Shutting down ...");
                System.exit(0);
            }
            System.out.println(msg);
            List<String> disconnectedNames = new ArrayList<>();
            clients.entrySet().removeIf(e -> {
                try{
                    e.getValue().send(msg);
                    return false;
                } catch(RemoteException ignored){
                    /*
                     * if a Client lost the connection unexpectedly this is where we find out
                     * this means Clients will only be notified about dropouts when a message is send
                     * this doesn't include logout they will be dealt with in the logout function
                     * */
                    disconnectedNames.add(e.getKey());
                    return true;
                }
            });
            
            disconnectedNames.forEach(name -> {
                try{
                    /* tell everyone about who has left unexpectedly
                    * */
                    send(String.format(DISCONNECT, name));
                } catch(RemoteException ignored){
                }
            });
            
        }
    }
}
