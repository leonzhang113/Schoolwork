#include <stdio.h>
#include <string.h>
#define NUM_STUDENTS 10

typedef struct Student{
    int StudentID;
    char Name[50];
    float GPA;
} Student;

void getRidOfNewLine(char* str){
    str[strcspn(str, "\n")] = 0; // Remove the newline character
}

int main(){
    Student students[NUM_STUDENTS];
    for (int i = 0; i < NUM_STUDENTS; i++){
        printf("Enter the following for Student %d\n", i+1);
        printf("Enter StudentID:");
        scanf("%d", &students[i].StudentID);
        getchar();

        printf("Enter Name:");
        fgets(students[i].Name, sizeof(students[i].Name), stdin);
        getRidOfNewLine(students[i].Name);

        printf("Enter GPA:");
        scanf("%f", &students[i].GPA);
        getchar();
    }

    const char* fileName = "student_info.bin";
    FILE* file = fopen(fileName, "wb");
    fwrite(students, sizeof(Student), NUM_STUDENTS, file);
    fclose(file);

    printf("\nOriginal file content:\n");
    file = fopen(fileName, "rb");
    Student temp;
    while (fread(&temp, sizeof(Student), 1, file)){
        printf("StudentID: %d, Name: %s, GPA: %.2f\n", temp.StudentID, temp.Name, temp.GPA);
    }
    fclose(file);

    const char* reversedFileName = "student_info_reversed.bin";
    FILE* original = fopen(fileName, "rb");
    FILE* copy = fopen(reversedFileName, "wb");
    fseek(original, 0, SEEK_END);
    long fileSize = ftell(original);
    for (long i = fileSize - sizeof(Student); i >= 0; i -= sizeof(Student)){
        Student temp;
        fseek(original, i, SEEK_SET);
        fread(&temp, sizeof(Student), 1, original);
        fwrite(&temp, sizeof(Student), 1, copy);
    }
    fclose(copy);
    fclose(original);

    printf("\nReversed file content:\n");
    file = fopen(reversedFileName, "rb");
    while (fread(&temp, sizeof(Student), 1, file)){
        printf("StudentID: %d, Name: %s, GPA: %.2f\n", temp.StudentID, temp.Name, temp.GPA);
    }
    fclose(file);

    printf("\nOriginal file content from 4th record:\n");
    file = fopen(fileName, "rb");
    fseek(file, (3) * sizeof(Student), SEEK_SET);
    while (fread(&temp, sizeof(Student), 1, file)){
        printf("StudentID: %d, Name: %s, GPA: %.2f\n", temp.StudentID, temp.Name, temp.GPA);
    }
    fclose(file);
    
    return 0;
}
