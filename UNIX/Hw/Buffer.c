#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
    // Create three files using creat
    int file1 = creat("file1.txt", 0644);
    int file2 = creat("file2.txt", 0644);
    int file3 = creat("file3.txt", 0644);

    // Check if file creation is successful
    if (file1 == -1 || file2 == -1 || file3 == -1) {
        perror("Error creating files");
        return 1;
    }

    // Set up buffering for the three files
    setbuf(fdopen(file1, "w"), NULL);  // Fully buffered
    setbuf(fdopen(file2, "w"), _IOLBF);  // Line buffered
    setbuf(fdopen(file3, "w"), _IONBF);  // Unbuffered

    // Write content to the files
    fprintf(stdout, "Writing to file1.txt (Fully buffered)\n");
    fprintf(file1, "Open for reading and appending (writing at end of file).\n");

    fprintf(stdout, "Writing to file2.txt (Line buffered)\n");
    fprintf(file2, "The file is created if it does not exist.\n");

    fprintf(stdout, "Writing to file3.txt (Unbuffered)\n");
    fprintf(file3, "Output is always appended to the end of the file.\n");

    // Close the files
    fclose(fdopen(file1, "w"));
    fclose(fdopen(file2, "w"));
    fclose(fdopen(file3, "w"));

    // Read and display content with different buffering
    FILE *readFile1 = fopen("file1.txt", "r");
    FILE *readFile2 = fopen("file2.txt", "r");
    FILE *readFile3 = fopen("file3.txt", "r");

    // Read and display content from file1 (Fully buffered)
    printf("Reading from file1.txt (Fully buffered):\n");
    char ch;
    while ((ch = fgetc(readFile1)) != EOF) {
        putchar(ch);
    }
    printf("\n");

    // Read and display content from file2 (Line buffered)
    printf("Reading from file2.txt (Line buffered):\n");
    while ((ch = fgetc(readFile2)) != EOF) {
        putchar(ch);
    }
    printf("\n");

    // Read and display content from file3 (Unbuffered)
    printf("Reading from file3.txt (Unbuffered):\n");
    while ((ch = fgetc(readFile3)) != EOF) {
        putchar(ch);
    }
    printf("\n");

    // Close the files
    fclose(readFile1);
    fclose(readFile2);
    fclose(readFile3);

    return 0;
}