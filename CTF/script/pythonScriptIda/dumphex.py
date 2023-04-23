with open("data.bin", "wb") as f:
    data = idc.get_bytes(addr,size)
    f.write(data)

with open("data.bin", "wb") as f:
    start_addr = 0x00000000023A9060
    end_addr = 0x00000000023AB8C7
    for addr in range(start_addr, end_addr+8, 8):
        data = idc.get_qword(addr)
        f.write(data.to_bytes(8, byteorder='little'))