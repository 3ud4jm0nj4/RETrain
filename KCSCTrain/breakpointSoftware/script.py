cipher = [ 0x7D, 0x08, 0xED, 0x47, 0xE5, 0x00, 0x88, 0x3A, 0x7A, 0x36, 0x02, 0x29, 0xE4]
nonce = [ 0x33, 0xBF, 0xAD, 0xDE]
key=[0]*512
flag=[]
for i in range(256):
    key[i+256] =i
    key[i]=nonce[i%4]
v13=0
for j in range(256):
    v13=(v13+key[j]+key[j+256])%256
    temp = key[v13 + 256]
    key[v13 + 256] = key[j + 256]
    key[j + 256] = temp
v13=0
v10=0
temp=0
for k in range(13):
    v10 = (v10 + 1) % 256
    v13 = (v13 + key[v10 + 256]) % 256
    temp = key[v13 + 256]
    key[v13 + 256] = key[v10 + 256]
    key[v10 + 256] = temp
    v8 = (key[v13 + 256] + key[v10 + 256]) % 256
    flag.append(cipher[k]^key[v8+256])
    print(chr(flag[k]),end="")
