// main.c
@import MyMath;  // 导入模块

#include <stdio.h>

int main() {
    int a = 5, b = 3;
    printf("Add: %d\n", add(a, b));
    printf("Subtract: %d\n", subtract(a, b));
    return 0;
}
