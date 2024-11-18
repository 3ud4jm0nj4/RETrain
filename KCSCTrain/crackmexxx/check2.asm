   0x4006e5:    push   rbp
   0x4006e6:    mov    rbp,rsp
   0x4006e9:    call   0x400702
   0x4006ee:    mov    cl,al

   0x4006fe:    mov    al,cl
   0x400700:    leave
   0x400701:    ret

   0x400702:    push   rbx
   0x400703:    push   rdi
   0x400704:    push   rbp
   0x400705:    mov    rbp,rsp
   0x400708:    mov    rdx,rax
   0x400710:    mov    rdi,rdx
   0x400713:    xor    al,al
   0x400715:    xor    ecx,ecx
   0x400717:    dec    rcx
   0x40071a:    repnz scas al,BYTE PTR es:[rdi]
   0x40071c:    not    ecx
   0x40071e:    dec    ecx                  ;ecx = str len
   0x400738:    push   0x50
   0x40073a:    pop    r9                   ;r9=0x50
   0x40073c:    xor    r8d,r8d
   0x40073f:    cmp    r8d,0x539            ;for(r8d = 0; r8d < 1337; ++r8d)
   0x400746:    jl     0x400763             ;be hon thi nhay den 763
   0x400748:    jmp    0x400774             ;neu lon hon hoac bang ket thuc vong lap
   0x40074a:
   0x40074f:    add    r8d,0x1               ;r8+=1
  
   0x400761:    jmp    0x40073f             ;jump to 73f
   0x400763:
   0x40076f:    xor    r11d,r11d           ;reset bien dem thu 2
   0x400772:    jmp    0x4007ac            ; bat dau vong lap
   0x400774:
   0x400780:    lea    rax,[rip+0x164]        # 0x4008eb ; save cipher to r8
   0x400787:    lea    r8,[rax]

   0x40079b:    push   0x1
   0x40079d:    pop    r10


   0x4007a4:    xor    r9d,r9d      ;r9d = 0

   0x4007a7:    jmp    0x400834
   0x4007ac:
0x4007b1:    cmp    r11d,ecx            ;so sanh r11 voi do dai chuoi
0x4007b4:    jl     0x4007b8            ;neu nho hon thi nhay den 7b8
0x4007b6:    jmp    0x40074a            ;neu da dat den do dai chuoi ket thuc vong nhay den 74a
0x4007b8:
   0x4007c6:    movsxd r10,r11d         ;mov 32bit to 64 bit, luu count do dai chuoi vao r10

   0x4007d5:    mov    rbx,rdx          ;rdx la dia chi cua chuoi mov rbx, offset flag
   0x4007d8:    add    rbx,r10          ;tang dia chi chuoi len tung ki tu flag[i]

   0x4007e7:    movsxd r10,r11d         ; mov again

   0x4007f6:    mov    rax,rdx          ;rax = offset flag
   0x4007f9:    add    rax,r10          ;flag[i]
   0x4007fc:    mov    al,BYTE PTR [rax] ;al= flag[i]
   0x4007fe:    xor    al,r9b               ;xor flag[i] vs r9b( r9b = 0x50)
   0x400801:    mov    BYTE PTR [rbx],al    ;flag[i] = flag[i] ^ 0x50
   0x400803:    movsxd r10,r11d             ; mov i to r 10
   0x400806:    mov    rax,rdx
   0x400809:    add    rax,r10
   0x40080c:    mov    al,BYTE PTR [rax]    ;al = flag[i] 
   0x40080e:    xor    r9b,al               ; 0x50 xor flag[i] => luu gia tri cua flag                                            ;vua xor vao r9b
   0x40081f:    add    r11d,0x1             ;i=i+1
   0x40082f:    jmp    0x4007ac             ;loop to 7ac



   0x400834:
   0x400842:    cmp    r9d,ecx          ;compare r9d vs len(flag)
   0x400845:    jl     0x400849         ;for r9d in range(len(flag)):
   0x400847:    jmp    0x400850
   0x400849:    test   r10b,r10b        ;test r10 co bang 0 hay k
   0x40084c:    jne    0x400857         ;neu khong = thi 
   0x40084e:    jmp    0x40089f
   0x400850:    mov    al,r10b
   0x400853:    leave
   0x400854:    pop    rdi
   0x400855:    pop    rbx
   0x400856:    ret
   0x400857:    movsxd r11,r9d          ;mov bien den voao r11
   0x400866:    mov    r10,rdx          ;mov dia chi flag vao r10
   0x400869:    add    r10,r11          ;lay dia chi cua flag[i]
   0x400871:    mov    r11b,BYTE PTR [r10] ;r11b = flag[i]
   0x400880:    movsxd rax,r9d          ;mov bien dem voaf rax 
   0x400883:    mov    r10,r8           ;r8 la cipher, mov r8 vao r10
   0x400886:    add    r10,rax          ;lay dia chir cua cipher[i]
   0x400895:    mov    al,BYTE PTR [r10] ;al = cipher [i]
   0x400898:    cmp    r11b,al          ;so sanh flag[i] == cipher [i]
   0x40089b:    je     0x4008c3         ;neu bang thi tiep tuc vong lap 
   0x40089d:    jmp    0x4008da
   0x40089f:    xor    r10b,r10b
   0x4008a2:
   0x4008ba:    add    r9d,0x1
   0x4008be:    jmp    0x400834
   0x4008c3:
   0x4008cf:    push   0x1
   0x4008d1:    pop    r10  ;lai cho r10 = 1 de thoa man tesst ban dau vong lap
   0x4008d8:    jmp    0x4008dd 
   0x4008da:    xor    r10b,r10b    ; neu flag[i] khac cipher[i] thi nhay vao day, r10b=0 de check dau vong lap fail
   0x4008dd:
   0x4008e9:    jmp    0x4008a2

   0x4008eb:    rex.W pop rdi       ;phan nay la data de so sanh voi key 
   0x4008ed:    ss xor eax,0x2c142535
   0x4008f3:    sbb    eax,0xc2d0301
   0x4008f8:    outs   dx,DWORD PTR ds:[rsi]
   0x4008f9:    xor    eax,0xa347e61
   0x4008fe:    rex.R and al,0x2c
   0x400901:    rex.WX
   0x400902:    rex.RX sbb DWORD PTR [rcx+0x5b],r11d
   0x400906:    (bad)
   0x400907:    js     0x40097d
   0x400909:    sub    DWORD PTR [rbx],edx
   0x40090b:    sub    al,0x0
   0x40090d:    mov    rdx,rax
   0x400910:    mov    QWORD PTR [rbp-0x18],rdx
   0x400914:    cmp    QWORD PTR [rbp-0x18],0x0
   0x400919:    je     0x400927
   0x40091b:    mov    edi,0x4009d1
   0x400920:    call   0x400400 <puts@plt>
   0x400925:    jmp    0x400931
   0x400927:    mov    edi,0x4009da
   0x40092c:    call   0x400400 <puts@plt>
   0x400931:    nop
   0x400932:    add    rsp,0x38
   0x400936:    pop    rbx
   0x400937:    pop    rbp
   0x400938:    ret