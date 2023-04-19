

# input by hand

# input=b"abcdef1"
# output=b"YWJjZGVm"

# input by file
fp1 = open("text_in.txt","r")
fp2 = open("text_out.txt","r")
data1 = fp1.read()
data2 = fp2.read()
input = bytes(data1,'utf-8')
output= bytes(data2,'utf-8')

#find key when known cipher and plain 
a =[]
print(len(output))
print(len(input))
if(len(input)%3==1):
    input += b"="
    input += b"="
if(len(input)%3==2):
    input += b"="
print((input))
for i in range(0,len(input),3):
    a.append((input[i]>>2)& 63)
    a.append(((input[i]<<4)&0x30) | ((input[i+1]>>4)))
    a.append((input[i+2]>>6) | ((input[i+1]<<2)&0x3C))
    a.append(input[i+2]&63)
key=[0]*64
print(a)
for i in range(len(output)):
    if(key[a[i]]==0):
        key[a[i]]=output[i]
for i in range(len(key)):
    print(i, "=" ,chr(key[i]))
for i in range(len(key)):
    if(key[i]==0):
        key[i]=ord("=")
    print(chr(key[i]),end="")
#decrypt
