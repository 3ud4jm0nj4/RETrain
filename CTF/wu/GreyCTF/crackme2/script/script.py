from pwn import *
from unicorn import *
from unicorn.x86_const import *

context.arch = 'amd64'
elf = ELF('./crackme2')

key = 0xad23773b
offset = 0x38c
data = 0x0040d0a0

STOP_ADDRESS = 0

def emulate(sc):
    STACK = 0x2000000
    ADDRESS = 0x1000000
    mu = Uc(UC_ARCH_X86, UC_MODE_64)
    mu.mem_map(ADDRESS, 2 * 1024 * 1024)
    mu.mem_map(STACK, 2 * 1024 * 1024)
    mu.mem_write(ADDRESS, sc)
    mu.reg_write(UC_X86_REG_RSP, STACK+2*1024)
    mu.reg_write(UC_X86_REG_RBP, STACK+2*1024)
    mu.hook_add(UC_HOOK_CODE, hook_code)
    mu.emu_start(ADDRESS, ADDRESS + len(sc))
    eax = mu.reg_read(UC_X86_REG_EAX)
    ecx = mu.reg_read(UC_X86_REG_ECX)
    llen = STOP_ADDRESS-ADDRESS
    return eax, ecx, llen

def hook_code(mu, address, size, user_data):
    global STOP_ADDRESS
    if mu.mem_read(address, size) == b'\xc3':
        STOP_ADDRESS = address
        mu.emu_stop()


full_sc = b''

try:
    while True:
        llen = u32(elf.read(data+offset*4, 4))
        sc = b''
        print(llen)
        for i in range(1,llen+1):
            sc += xor(elf.read(data+offset*4+i*4, 4),p32(key))
        
        print(disasm(sc, offset=data+offset*4+4))

        offset, key, sz = emulate(sc)
        full_sc += sc[:sz]
        print(hex(offset), hex(key))
except Exception as e:
    print(e)
    pass
f = open('sc.bin','wb')
f.write(full_sc)
f.close()