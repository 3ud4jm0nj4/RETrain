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