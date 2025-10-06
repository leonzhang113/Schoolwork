#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define WORK_QUEUE_SIZE 5
#define WORKER_THREAD_COUNT 3

// Structure to represent a work item.
typedef struct {
    int work_id; // Identifier for the work.
} WorkItem;

// Work queue and synchronization primitives.
WorkItem work_queue[WORK_QUEUE_SIZE];
int work_count = 0;
pthread_mutex_t queue_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t queue_cond = PTHREAD_COND_INITIALIZER;

void* master_thread(void* arg) {
    int work_id = 0;

    while (1) {
        WorkItem work;
        work.work_id = work_id++;

        // Lock the queue and add work.
        pthread_mutex_lock(&queue_mutex);

        if (work_count < WORK_QUEUE_SIZE) {
            work_queue[work_count] = work;
            work_count++;
            printf("Master thread added work item %d to the queue.\n", work.work_id);

            // Signal a worker thread that there is work to do.
            pthread_cond_signal(&queue_cond);
        }

        // Unlock the queue.
        pthread_mutex_unlock(&queue_mutex);

        // Sleep to simulate time taken to generate new work.
        sleep(1);
    }

    return NULL;
}

void* worker_thread(void* arg) {
    pthread_t tid = pthread_self();
    printf("Worker thread %lu started.\n", (unsigned long)tid);

    while (1) {
        WorkItem work;

        // Lock the queue to take work.
        pthread_mutex_lock(&queue_mutex);

        while (work_count == 0) {
            // Wait for work to be available.
            pthread_cond_wait(&queue_cond, &queue_mutex);
        }

        // Get the next work item.
        work = work_queue[0];
        // Move the remaining items up.
        for (int i = 0; i < work_count - 1; i++) {
            work_queue[i] = work_queue[i + 1];
        }
        work_count--;

        // Unlock the queue.
        pthread_mutex_unlock(&queue_mutex);

        // Do the work.
        printf("Worker thread %lu is processing work item %d.\n", (unsigned long)tid, work.work_id);

        // Sleep to simulate work being done.
        sleep(rand() % 3 + 1);
    }

    return NULL;
}