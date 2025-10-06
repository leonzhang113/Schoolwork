package edu.utdallas.taskExecutorImpl;

import edu.utdallas.taskExecutor.Task;

/* BlockingFIFO built on array data structure,
   Uses Objects notFull and notEmpty as described
   in the bounded buffer pseudo code as locks 
*/
public class BlockingFIFO {
    private final Task[] queue;
    private int count, nIn, nOut;
    private final Object notFull = new Object();
    private final Object notEmpty = new Object();

    public BlockingFIFO(int capacity) {
        queue = new Task[capacity];
        count = nIn = nOut = 0;
    }

    /* Put method follows pseudo code from both BlockingFIFO and the
       solution for the race condition where the while loop makes the
       thread re-check the count and the notFull and notEmpty objects
       are used as locks. Synchronized is used on the current thread
       to make sure only one thread can modify nIn and count at a time.
    */
    public void put(Task createTask) throws InterruptedException {
        while (true) {
            if (count >= queue.length) {
                synchronized (notFull) {
                    notFull.wait();
                }
            }
            synchronized (this) {
                if (count >= queue.length) {
                    continue;
                }
                
                queue[nIn] = createTask;
                nIn = (nIn + 1) % queue.length;
                count++;

                synchronized (notEmpty) {
                    notEmpty.notify();
                }
                return; 
            }
        }
    }

    /* Take method follows similar structure to the put method
       and uses the while loop and synchronized blocks for
       the same reasons. Only one thread modifies the nOut variable 
       and count at a time.
     */
    public Task take() throws InterruptedException {
        while (true) {
            if (count == 0) {
                synchronized (notEmpty) {
                    notEmpty.wait();
                }
            }
            
            synchronized (this) {
                if (count == 0) {
                    continue; 
                }

                Task createTask = queue[nOut];
                nOut = (nOut + 1) % queue.length;
                count--;

                synchronized (notFull) {
                    notFull.notify();
                }
                return createTask; 
            }
        }
    }
}
