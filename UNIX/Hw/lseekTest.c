#include <stdio.h>
#include <fcntl.h>
#include <string.h>

int main() {
    int fd = open("test.txt", O_RDWR | O_APPEND);
    char buffer[100];
    int bytesRead;
    int offset = 10;

    lseek(fd, offset, SEEK_CUR);
    printf("Reading from lseek position %d: ", offset);
    while ((bytesRead = read(fd, buffer, sizeof(buffer))) > 0) {
        write(STDOUT_FILENO, buffer, bytesRead);
    }

    char *data = "this is text input from program\n";
    lseek(fd, 10, SEEK_CUR);
    write(fd, data, strlen(data));
    close(fd);

}
