###### tags: `study`

# Something good

## Thần chú
* Nếu rand() mãi k ra thì chuyển sang Linux compile

## Hardware BreakPoint and Software BreakPoint

>Tài liệu tham khảo :[Debugger flow control: Hardware breakpoints vs software breakpoints](http://www.nynaeve.net/?p=80),[Debugger flow control: More on breakpoints (part 2)](http://www.nynaeve.net/?p=81)

### I-Software BreakPoint

* Software BreakPoint đơn giản là viết một lệnh `int 3` (opcode 0xCC) lên đầu byte của breakpoint.

### II-Hardware BreakPoint

* Hardware BreakPoint là ngắt trên bộ nhớ, sử dụng thanh ghi "Dr" để ngắt.
* Chỉ có thể đặt 4 Breakpoint trên x86 và 8 Hardware BreakPoint trên x64.
* Điểm mạnh của Hardware BreakPoint là có thể sử dụng để dừng các truy cập không thực thi vào các vị trí bộ nhớ.Về bản chất, có thể sử dụng Hardware BreakPoint để yêu cầu bộ xử lý dừng khi một biến( đĩa chỉ) cụ thể được đọc hoặc đọc/viết vào. Nhưng cũng có thể ngắt trên mã thực thi, nhưng việc này thì nên làm với Software BreakPoint, vì có thể đặt vô số breakpoint.
* Chỉ hỗ trợ ngắt trên các vùng nhớ bằng lũy thừa 2 chiều dài và có chiều dài nhỏ hơn hoặc bằng kích thước của con trỏ gốc(x32 4 byte(BYTE-WORD-DWORD), x64 8 byte(BYTE-WORD-DWORD-QWORD))

## RVA,VA and Raw(Offset)

* RVA(Relative Virtual Address): Địa chỉ tương đối trong bộ nhớ ảo của một chương trình(Địa chỉ khi chương trình chạy load vào trong bộ nhớ ảo)
* VA(Virtual Addresss): Địa chỉ tuyệt đối trong bộ nhớ ảo của một chương trình(Địa chỉ khi chương trình chạy load vào trong bộ nhớ ảo)
* Raw address(offset):Địa chỉ khi chương trình chưa chạy, địa chỉ trong bộ nhớ vậy lý, dữ liệu thô.
* RVA = VA – ImageBase
## IDA

>[Cheat Sheet](https://www.hex-rays.com/products/ida/support/freefiles/IDA_Pro_Shortcuts.pdf)
>[Trick IDA](https://swarm.ptsecurity.com/ida-pro-tips/)
* C: convert Data to Code
* D: convert Code to Data
* Shift+E: lấy dữ liệu
* P: tạo function
* Shift+F7 để mở cửa sổ Segments
* Shift+F2: chạy script
* Ctrl+E: show entry point table
* Bôi đen + A: Đổi chuỗi hex thành string 
* Y : sửa kiểu dữ liệu 
* Bôi đen + ALT + A: đổi kiểu chuỗi thành UTF 16LE,  32,...
### script
* set_reg_value(value,"rax"): set giá trị thanh ghi
* get_reg_value("r8"): lấy giá trị thanh ghi
* Appcall.resolve_api(get_reg_value("r8"),get_reg_value("r9")): gọi hàm
* [PythonIDA Cheatsheet](https://github.com/3ud4jm0nj4/idapython-cheatsheet)
## _ACRTIMP_ALT FILE* __cdecl __acrt_iob_func(unsigned);
#define stdin  (__acrt_iob_func(0))
#define stdout (__acrt_iob_func(1))
#define stderr (__acrt_iob_func(2))

## PEB Structure
[PEB32](https://lttqstudy.wordpress.com/2011/08/31/tib-va-peb/)
[PEB32](https://processhacker.sourceforge.io/doc/ntpebteb_8h_source.html)
[PEB64](https://rinseandrepeatanalysis.blogspot.com/p/peb-structure.html)
[resolveAPIfromPEB](https://www.nirsoft.net/kernel_struct/vista/LDR_DATA_TABLE_ENTRY.html)

## Core Function in DLL

[Core Function](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ee391633(v=vs.85))

## Api Hassed 
[Api Hashed](https://github.com/tildedennis/malware/blob/master/neutrino_bot_5.1/api_hashes)
## Exception
[exception](https://limbioliong.wordpress.com/2022/01/09/understanding-windows-structured-exception-handling-part-1/)
## web rev
[script js](https://velog.io/@mm0ck3r/Dreamhack-Secure-Mail)
## Script Python
### Lib:
`pip install monkeyhex`: in ra hex
## Script 
```python=
###########################################################################
# Rotating bits (tested with Python 2.7)
 
from __future__ import print_function   # PEP 3105
 
# max bits > 0 == width of the value in bits (e.g., int_16 -> 16)
 
# Rotate left: 0b1001 --> 0b0011
rol = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))
 
# Rotate right: 0b1001 --> 0b1100
ror = lambda val, r_bits, max_bits: \
    ((val & (2**max_bits-1)) >> r_bits%max_bits) | \
    (val << (max_bits-(r_bits%max_bits)) & (2**max_bits-1))
 
max_bits = 16  # For fun, try 2, 17 or other arbitrary (positive!) values
 
print()
for i in xrange(0, max_bits*2-1):
    value = 0xC000
    newval = rol(value, i, max_bits)
    print("0x%08x << 0x%02x --> 0x%08x" % (value, i, newval))
 
print()
for i in xrange(0, max_bits*2-1):
    value = 0x0003
    newval = ror(value, i, max_bits)
    print("0x%08x >> 0x%02x --> 0x%08x" % (value, i, newval))
```


# Trick
1. Ctrl insert / Shift Insert = Ctrl C/ Ctrl V
2. Compile không hiện terminal:
`gcc -mwindows myprogram.c -o myprogram.exe`

## VSCODE:
- bôi đen shift+ Tab: thụt lề
# Rev GO
-Tìm hàm github gihub.com -> github.dev
- ReGoSym : chạy cái [này](https://github.com/mandiant/GoReSym) `GoReSym.exe -t -d -p /path/to/input.exe > data.json` lấy file json, vào ida File->Script file-> chọn file python `goresym_rename.py` trong [github](https://github.com/mandiant/GoReSym/tree/master/IDAPython) vừa tải -> chọn file json vừa tạo được

