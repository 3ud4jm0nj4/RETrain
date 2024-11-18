
from z3 import *

data = [
        0x48, 0x5f, 0x36, 0x35, 0x35, 0x25, 0x14, 0x2c, 0x1d, 0x01, 0x03, 0x2d,
        0x0c, 0x6f, 0x35, 0x61, 0x7e, 0x34, 0x0a, 0x44, 0x24, 0x2c, 0x4a, 0x46,
        0x19, 0x59, 0x5b, 0x0e, 0x78, 0x74, 0x29, 0x13, 0x2c
        ]

flag = [BitVec(f'{i:2}', 8) for i in range(len(data))] #khoi tao index cho flag 
s = Solver()
# giới hạn flag chỉ nằm trong mã ascii in ra được
for f in flag:
    s.add(f > 0x20, f <= 0x7f)

xored = 0x50
for r8d in range(0x539):
    for r11d in range(len(flag)):
        flag[r11d]=flag[r11d]^xored
        xored = xored ^ flag[r11d]
#add thêm điều kiện để lấy flag đúng 
for f, d in zip(flag, data):
    s.add(f == d)
#nếu thành công thì in ra sat và ngược lại là unsat
print(s.check())
#s.model là list hợp lệ chương trình tính được
m = s.model()
# ví list bị đảo lộn thứ tự nên ta sẽ sắp xếp lại theo index cho đúng thứ tự và lưu vào model
model = sorted([(d, m[d]) for d in m], key = lambda x: str(x[0]))
for m in model:
     print(chr(m[1].as_long()), end='')