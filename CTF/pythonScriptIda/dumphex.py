with open("data.bin", "wb") as f:
    data = idc.get_bytes(addr,size)
    f.write(data)