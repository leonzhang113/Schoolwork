#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <math.h>

bool onlyDigits(const char* str){
    for (int i = 0; str[i] != '\0'; i++){
        if(!isdigit(str[i])){
            return false;
        }
    }
    return true;
}

bool is_prime(int num){
    if (num <= 1) return false;
    if (num <= 3) return true;
    if (num % 2 == 0 || num % 3 == 0) return false;
    for (int i = 5; i < sqrt(num); i += 6){
        if (num % i == 0 || num % (i + 2) == 0)
            return false;
    }
    return true;
}

int makeBigInteger(char *num){
    int sum;
    for(int i = 0; i < strlen(num); i++){
        int intVal = num[i] - '0';
        sum += intVal * pow(10, strlen(num) - 1 - i);
    }
    return sum;
}

int main(){
    char input[256];

    while (fgets(input, sizeof(input), stdin)){
        input[strcspn(input, "\n")] = 0;
        if (strcmp(input, "exit") == 0){
            break;
        }
        if (strcmp(input, "0") == 0 || strcmp(input, "1") == 0){
            printf("%s neither\n", input);
        } else if (!onlyDigits(input)){
            printf("%s malformed\n", input);
        } else{
            int num = makeBigInteger(input);
            if (is_prime(num)){
                printf("%s probably prime\n", input);
            } else{
                printf("%s composite\n", input);
            }
        }
    }

    return 0;
}
