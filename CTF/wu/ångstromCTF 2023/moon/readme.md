# moon
![](https://i.imgur.com/JvGUTMx.png)
## Overview
Bài cho một file ELF64:

![](https://i.imgur.com/Um4sqSx.png)

Chạy thử, chương trình bắt chúng ta nhập đầu vào là số rất nhiều lần, nếu nhập chữ thì sẽ bị break ngay:

![](https://i.imgur.com/KjYdpp3.png)

## IDA
Load vào ida64, đầu tiên chúng ta có thể thấy chương trình có 1293 hàm được đánh số từ 0 đến 1292:

![](https://i.imgur.com/yoylgbc.png)

Vì số lượng hàm quá lớn chúng ta không thể xem chế độ graph được,chúng ta có thể chỉnh `max graph` lên số to bằng cách `Option->General->Graph-Max number of nodes` ở đây mình để là 10000:

![](https://i.imgur.com/1HGkRhx.png)

Vào hàm main:

![](https://i.imgur.com/HmvyVnC.png)

Hàm sẽ bắt chúng ta nhập vào lần lượt từng số nguyên `%d` sau đó nhảy lần lượt từng hàm từ 0 đến 1292 để làm gì đó. Đầu tiên ta vào hàm `func0`:

![](https://i.imgur.com/hhY2ReA.png)

Hàm này sẽ cộng `n`(số chúng ta nhập vào) lần những hằng số kia vào một mảng`check`, sau khi đọc những hàm còn lại thì đều có cấu trúc tương tự, cuối cùng chương trình sẽ so sánh mảng check này với một mảng `needed` đã có sẵn:

![](https://i.imgur.com/Awy2Lo9.png)

Túm cái váy lại, là chương trình này là hệ phương trình 1293 ẩn, 1293 hàm là 1293 hệ số mỗi cột, vì vậy ta cần lấy ra `1293x1293` hệ số ra và giải hệ phương trình. Để lấy hệ số ta dùng script:
```python=
f = open('./moon', 'rb')
data = f.read()

adr = 0x11B6
matrix = []
for i in range(1293):
    matrix.append([])
for i in range(1293):
    adr+=0x0f
    j = 0
    while True:
        if data[adr+1]==0x05:
            matrix[j].append(int.from_bytes(data[adr+2:adr+6],byteorder="little"))
            adr+=0x14
        elif data[adr+1]==0x83:
            matrix[j].append(int.from_bytes(data[adr+3:adr+4],byteorder='little'))
            adr+=0x12
        else:
            matrix[j].append(0)
            adr+=0x0e
        if int.from_bytes(data[adr-7:adr-4],byteorder='big')!=0x488b05:
            break
        j+=1
    adr-=0x04

neededBin = data[0x01FA8060:0x1faa8c8]
for i in range(0,len(neededBin),8):
    matrix[i>>3].append(int.from_bytes(neededBin[i:i+8],byteorder='little'))

csv = open("Matrix.txt", "w")
csv.write("[")
for i in range(1293):
    for j in range(1293):
        csv.write(str(matrix[j][i]))
        csv.write(",")
    if(i!=1292):
     csv.write("],\n[")
    else:
     csv.write("]")
csv.close()
```

Sau đó ta sẽ được một file `Matrix.txt` chứa tham số từ đó chia ra 1293 tham số 1 mảng và sử dụng NumPy để giải hệ phương trình, nhưng vì hệ số dump ra đang là theo chiều dọc của ma trận nên chúng ta phải xoay ma trận ngược lại.Sau đó tính 1293 biến đổi sang ascii, ta lấy được flag
# Script
Đâu là script rút gọn, nếu bạn muốn xem script đầy đủ thì ở [đây](https://github.com/3ud4jm0nj4/RETrain/blob/main/CTF/wu/%C3%A5ngstromCTF%202023/moon/script.py):
```python=
import numpy as np

# Tạo ma trận hệ số
A = np.array([<ma trận hệ số>])
A2=np.transpose(A)
# Tạo vector vế phải
B = np.array([<mảng needed>])

# Giải hệ phương trình bằng phương pháp linalg.solve của NumPy
X = np.linalg.solve(A2, B)

rs = []
flag = ''
# In kết quả
for i in X:
    flag += chr((round(i)))


print(flag)

```
## flag
`actf{3verything_is_just_linear_algebr4_33e431e52e896c92}`