#include <stdio.h>

int main() {
    int bufferSize = 1024;
    char buffer [bufferSize];

    FILE *f1 = fopen("f1.txt", "w");
    FILE *f2 = fopen("f2.txt", "w");
    FILE *f3 = fopen("f3.txt", "w");

    setvbuf(f1, NULL, _IOFBF, bufferSize);
    setvbuf(f2, NULL, _IOLBF, bufferSize);
    setvbuf(f3, NULL, _IONBF, bufferSize);

    fprintf(f1, "Open for reading and appending (writing at end of file). The file is created if it does not exist. Output is always appended to the end of the file. POSIX is silent on what the initial read position is when using this mode. For glibc, the initial file position for reading is at the beginning of the file, but for Android/BSD/MacOS, the initial file position for reading is at the end of the file.\n");
    fprintf(f2, "Open for reading and appending (writing at end of file). The file is created if it does not exist. Output is \nalways appended to the end of the file. POSIX is silent on what the initial read position is when using \nthis mode. For glibc, the initial file position for reading is at the beginning of the file, but for \nAndroid/BSD/MacOS, the initial file position for reading is at the end of the file.\n");
    fprintf(f3, "Open for reading and appending (writing at end of file). The file is created if it does not exist. Output is always appended to the end of the file. POSIX is silent on what the initial read position is when using this mode. For glibc, the initial file position for reading is at the beginning of the file, but for Android/BSD/MacOS, the initial file position for reading is at the end of the file.\n");

    fclose(f1);
    fclose(f2);
    fclose(f3);

    f1 = fopen("f1.txt", "r");
    char ch;
    printf("file1 output using character-at-a-time I/O: \n");
    while((ch = fgetc(f1)) != EOF){
        putchar(ch);
    }
    fclose(f1);

    f2 = fopen("f2.txt", "r");
    printf("\nfile2 output using line-at-a-time I/O: \n");
    char line[100];
    while(fgets(line, sizeof(line), f1) != NULL){
        fputs(line, stdout);
    }
    fclose(f2);

    f3 = fopen("f3.txt", "r");
    printf("\nfile3 output using direct I/O: \n");
    size_t bytes;
    while((bytes = fread(buffer, 1, sizeof(buffer), f3)) > 0){
        fwrite(buffer, 1, bytes, stdout);
    }

    fclose(f3);

    return 0;

}