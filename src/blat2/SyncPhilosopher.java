package blat2;

/**
 * Created by bennet on 25.10.17.
 */

public class SyncPhilosopher implements Runnable {
    
    private int    num;
    private Object left, right;
    
    public SyncPhilosopher(int num, Object left, Object right) {
        this.num = num;
        this.left = left;
        this.right = right;
    }
    
    public static void main(String[] args) {
        int count = 5;
        
        if(args.length > 0) {
            try{
                count = Integer.parseInt(args[0]);
            } catch(NumberFormatException ignore){
            }
        }
        
        Object[]          sticks = new Object[count];
        SyncPhilosopher[] phils  = new SyncPhilosopher[count];
        
        for(int i = 0; i < count; ++i){
            sticks[i] = new Object();
        }
        
        for(int i = 0; i < count; ++i){
            phils[i] = new SyncPhilosopher(i, sticks[i], sticks[(i + 1) % count]);
            new Thread(phils[i]).start();
        }
    }
    
    private void snooze() {
        try{
            Thread.sleep((long) (1000 * Math.random()));
        } catch(InterruptedException ignore){
        }
    }
    
    public void run() {
        while(true){
            System.out.println("Philosopher " + num + " is thinking");
            snooze();
            synchronized(left){
                synchronized(right){
                    System.out.println("Philosopher " + num + " is eating");
                    snooze();
                }
            }
        }
    }
    
}
