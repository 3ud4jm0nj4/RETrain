from z3 import *
s=Solver()

flag=[BitVec("%d"%i,8)for i in range(16)]
s.add(flag[0]==ord("C"))
s.add(flag[1]==ord("T"))
s.add(flag[2]==ord("F"))
s.add(flag[3]==ord("{"))
s.add(flag[14]==ord("}"))
s.add(flag[15]==0)

shuffle=[ 0x02, 0x06, 0x07, 0x01, 0x05, 0x0B, 0x09, 0x0E, 0x03, 0x0F,
  0x04, 0x08, 0x0A, 0x0C, 0x0D, 0x00]

for i in range(15):
    s.add(flag[i]>=0x21)
    s.add(flag[i]<=0x7e)
#pbshuffle 128 bit
shuff_flag=[]
#shuffle - DATA DEFAULT FROM AUTHOR
for i in range(16):
    if shuffle[i]&0x80 :
        shuff_flag.append(0)
    else:
        shuff_flag.append(flag[shuffle[i] & 15])

addArray=[0xDEADBEEF,0xFEE1DEAD,0x13371337,0x67637466]
XORArray=[0x49B45876,0x385F1A8D,0x34F823D4,0xAAF986EB]

for i in range(0,4):
    packed=Concat(shuff_flag[i*4+3],shuff_flag[i*4+2],shuff_flag[i*4+1],shuff_flag[i*4])
    tmp=((packed+addArray[i]))&0xffffffff
    tmp=tmp ^ XORArray[i]
    tmp2=Concat(flag[i*4+3],flag[i*4+2],flag[i*4+1],flag[i*4])
    s.add(tmp2==tmp)
s.check()
m = s.model()
for i in range(15):
    print(chr(m[flag[i]].as_long()),end='')