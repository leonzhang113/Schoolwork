#include <stdio.h>
#include <errno.h>
#include <fcntl.h>

int main(){
    int fd = open("test.txt", O_RDONLY);
    int fd2 = 10;

    if (dup2(fd, fd2) != -1){
        printf("Duplicated");
    }
    else{
        perror("dup2 failed");
    }

    return 0;
}

int dup2(int fd, int fd2){
    if(fd < 0 || fd >= 256 || fd2 < 0 || fd2 >= 256){
        errno = EBADF;
        return -1;
    }
    if (lseek(fd, 0, SEEK_CUR) == -1 && errno == EBADF){
        return -1;
    }
    if (fd == fd2){
        return fd2;
    }
    close(fd2);

    int tempfd, dupfd = -1;
    tempfd = dup(fd);
    if(tempfd == -1) {
        return -1;
    }
    
    if(tempfd == fd2){
        return fd2;
    } else{
        dupfd = dup2(tempfd, fd2);
        close(tempfd);
        return dupfd;
    }
}

