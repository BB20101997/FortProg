package blat2;

public class IntVar {

    private int value = 0;

    public IntVar() {
    }

    /* Little helper to sleep a period of time */
    private static void sleep(long time) {
        try {
            Thread.sleep(time);
        } catch (InterruptedException ignore) {
        }
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public void doubleIt() {
        int tmp = getValue();
        tmp *= 2;
        sleep(1000);
        setValue(tmp);
    }

    public synchronized void syncDouble() {
        doubleIt();
    }

    public void incIt() {
        int tmp = getValue();
        tmp += 1;
        sleep(1000);
        setValue(tmp);
    }

    public synchronized void syncInc() {
        incIt();
    }

    /**
     * Execute two @link{Runnable}s concurrently, whereas the second one is
     * started after a given delay
     *
     * @param v
     *            IntVar both Runnables operate on
     *
     * @param pause
     *            Interval to sleep before starting the second Runnable
     *
     * @param r1
     *            first Runnable to be executed
     * @param r2
     *            second Runnable to be executed
     */
    private static void test(final IntVar v, long pause, Runnable r1,
            Runnable r2) {
        Thread t1 = new Thread(r1);
        Thread t2 = new Thread(r2);

        t1.start();
        sleep(pause);
        t2.start();

        // wait for both to finish
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException ignore) {
        }

        System.out.println(v.getValue());
    }

    // Yields 0
    private static void zero() {
        final IntVar v = new IntVar();
        Runnable r1 = v::incIt;

        Runnable r2 = v::doubleIt;

        test(v, 500, r1, r2);
    }

    // Yields 1
    private static void one() {
        final IntVar v = new IntVar();
        Runnable r1 = v::incIt;

        Runnable r2 = v::doubleIt;

        test(v, 500, r2, r1);
    }

    // Yields 2
    private static void two() {
        final IntVar v = new IntVar();
        Runnable r1 = v::incIt;

        Runnable r2 = v::doubleIt;

        test(v, 1500, r1, r2);
    }

    // Same as zero, but with synchronization; yields 2
    private static void syncZero() {
        final IntVar v = new IntVar();
        Runnable r1, r2;

        r1 = v::syncInc;

        r2 = v::syncDouble;

        test(v, 500, r1, r2);
    }

    public static void main(String[] args) {
        zero();
        one();
        two();
        syncZero();
    }

}
