
base64="=hs=RF/tuI=W3d=YnSvV7OUQbZcN4J2=1GL+ejA8=r=lpg5ak=Bo0qyDHm==M9=P"
ciphertext="S/jeutjaJvhlNA9Du/GaJBhLbQdjd+n1Jy9BcD3="
arrbin=[]
arrtemp=""
arrtemp2=[]

for i in range(len(ciphertext)):
    for j in  range(len(base64)):  
        if(ord(ciphertext[i])==ord(base64[j])):
            arrbin.append('{:06b}'.format(j))
            break
arrtemp="".join(map(str,arrbin))
for h in range(0,len(arrtemp),8):
    arrtemp2.append(arrtemp[h:h+8])
for i in range(len(arrtemp2)):
    print(chr(int(arrtemp2[i],2)),end="")