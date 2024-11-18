# pointer2
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int fuzz(char *);

int main(int argc, char **argv) {
    printf("Let's see if you passed the right flag...\n");
    if (argc == 2)
        if (strlen(*(argv + 1)) == 32)
            if (!fuzz(*(argv + 1)))
                printf("Wrong Direction.");
            else if (!strncmp(*(argv + 1), "302753d5b52596eb75b8", 0x14))
                if (!strncmp(*(argv + 1) + 20, "9c11cc30e5c7", 12))
                    printf("True.");
                else
                    printf("Try again.");
            else
                printf("Try again.");
        else
            printf("Try again.");
    else
        printf("Try again.");
}

int fuzz(char *key) {
    char char1[10], char2[10], char3[10], char4[10];
    memset(char1, 0, 10);
    memset(char2, 0, 10);
    memset(char3, 0, 10);
    memset(char4, 0, 10);

    strncpy(char1, key, 8);
    strncpy(char2, key + 8, 8);
    strncpy(char3, key + 16, 8);
    strncpy(char4, key + 24, 8);

    memset(key, 0, 32);

    strcat(key, char3);
    strcat(key, char1);
    strcat(key, char4);
    strcat(key, char2);

    return 1;
}
```
Bài này khi run ta phải truyền vào 1 tham số, vì `argc(ARGument Count)` phải bằng 2(1 cho tên chương trình, 1 cho tham số truyền vào), còn `argv(ARGument Vector)` là một mảng con trỏ trỏ liệt kê tất cả các đối số, nên `argv[0]` sẽ là tên chương trình và `argv[1]` sẽ là tham số ta truyền vào(flag).
Chương trình sẽ kiểm tra độ dài rồi truyền input vào hàm `fuzz()`, hàm `fuzz()` đơn giản chỉ là chia chuỗi ra thành 4 phần và sắp xếp lại theo thứ tự 3->1->4->2. Sau đó sẽ so sánh với `302753d5b52596eb75b89c11cc30e5c7`. Như vậy ta chỉ cần chia ra rồi sắp xếp lại đúng thứ tự là được.
# flag
`b52596ebcc30e5c7302753d575b89c11`