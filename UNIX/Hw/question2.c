#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *a;
    char b[128];
    a = popen("bad command", "r");
    if (a == NULL) {
        printf("couldn't open pipe\n");
    } else {
        if (fgets(b, sizeof(b), a) == NULL) {
            printf("command could not be executed\n");
        }
        pclose(a);
    }
    return 0;
}

