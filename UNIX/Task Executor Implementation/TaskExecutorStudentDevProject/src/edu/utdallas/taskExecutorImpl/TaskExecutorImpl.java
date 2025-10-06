package edu.utdallas.taskExecutorImpl;

import edu.utdallas.taskExecutor.Task;
import edu.utdallas.taskExecutor.TaskExecutor;

public class TaskExecutorImpl implements TaskExecutor {
    private final BlockingFIFO queue;
    private final Thread[] workers;
    
    public TaskExecutorImpl(int num) {
        queue = new BlockingFIFO(100);
        workers = new Thread[num];
        initializeThreadPool(num);
    }
    //Initialize num worker threads
    private void initializeThreadPool(int num) {
        for (int i = 0; i < num; i++) {
            workers[i] = new Thread(new TaskRunner(), "Thread " + i);
            workers[i].start();
        }
    }
    
    @Override
    public void addTask(Task createTask) {
        try {
            queue.put(createTask);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
    
    //Task Runner implements the provided pseudo code logic
    private class TaskRunner implements Runnable {
        @Override
        public void run() {
            while (true) {
                try {
                    Task createTask = queue.take();
                    executeTaskSafely(createTask);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }
        
        //Separate method to catch errors for executes
        private void executeTaskSafely(Task task) {
            try {
                task.execute();
            } catch (Exception e) {
                System.err.println("Error -  " + e.getMessage());
            }
        }
    }
}