# pointer1
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int check_key(char *);
int sthIdontknow(char, char);

int main(void) {
    char *usrInp;
    printf("Key? ");
    usrInp = (char *)malloc(33);
    scanf("%s", usrInp);

    int len = strlen(usrInp);
    if (len == 32) {
        int (*check)(char *) = check_key;
        if (check(&usrInp)) {
            printf("Correct key.\n");
            printf("Flag is: flag{%s}\n", usrInp);
        } else
            printf("Wrong key.\n");
    } else
        printf("Invalid.\n");
    free(usrInp);

    return 0;
}

int check_key(char *key) {
    char sth[] = "pearldarkk";
    char mySth[] = {0x45, 0xd, 0x50, 0x1c, 0x5d, 0xa, 0x46, 0x2d,
                    0x5e, 0x1f, 0x44, 0x17, 0x54, 0x2d, 0x6, 0x11,
                    0x54, 0x6, 0x34, 0x7, 0x41, 0xe, 0x52, 0x2d,
                    0x19, 0x16, 0x3e, 0x1, 0x6, 0x5a, 0x1c, 0x56};
    void *c1 = sth, *c2 = key;
    while (c2 < key + 1 && !(sthIdontknow(*(char *)(c1 + (((char *)c2 - key) % 0xA)), *(char *)c2) ^ *mySth)) {
        c2 = (char *)c2 + 1;
        ++*mySth;
    }

    if (c2 == key + 1)
        return 1;
    return 0;
}

int sthIdontknow(char b, char k) {
    char b2;
    for (size_t i = 0; i < 8; ++i) {
        if (((b >> i) & 1) == ((k >> i) & 1))
            b2 = ((1 << i) ^ -1) & b & 255;
        else
            b2 = ((1 << i) & 255) | b;
        b = (char)b2;
    }
    return b;
}
```
Bài này ta xét hàm `check_key(char *)` có `key` là input mình nhập vào, `sth[]` và mySth[]. Vòng while, Hàm `sthIdontknow()` sẽ được truyền từng phần tử của `sth[]` và input của mình nhập, rồi sau đó `xor` với `mySth[]`, bắt buộc phải bằng 0 để vòng while có thể thực hiện tiếp, do đó `sthIdontknow()` sẽ phải trả về mảng giống với `mySth[]`.
Xét hàm `sthIdontknow()` đơn giản so sánh từng bit của kí tự hiện tại của `sth[]` và input mình nhập vào, nếu giống thì chuyển thành 0 khác thì chuyển thành 1, ta có thể thấy nó là một phép `xor`, do đó muốn tìm flag ta chỉ cần lấy `mySth[]` xor với `pearldarkk` sẽ ra được flag 
# script
```python
mySth = [0x45, 0xd, 0x50, 0x1c, 0x5d, 0xa, 0x46, 0x2d,
                    0x5e, 0x1f, 0x44, 0x17, 0x54, 0x2d, 0x6, 0x11,
                    0x54, 0x6, 0x34, 0x7, 0x41, 0xe, 0x52, 0x2d,
                    0x19, 0x16, 0x3e, 0x1, 0x6, 0x5a, 0x1c, 0x56]
sth = [0x70 ,0x65,0x61 ,0x72 ,0x6C ,0x64 ,0x61 ,0x72 ,0x6B ,0x6B] #"pearldarrk"

for i in range(len(mySth)):
    mySth[i]=mySth[i]^sth[i%10]
    print(chr(mySth[i]),end="")

```
# flag
`5h1n1n'_5t4r5_ju5t_l1k3_ur_sm1l3`
