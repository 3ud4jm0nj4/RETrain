 0x4006e5:    push   rbp
   0x4006e6:    mov    rbp,rsp
   0x4006e9:    call   0x400702
   0x4006ee:    mov    cl,al
;    0x4006f0:    mov    eax,0xae5fe432
;    0x4006f5:    add    eax,0x51a01bce
;    0x4006fa:    inc    eax
;    0x4006fc:    jae    0x400706
   0x4006fe:    mov    al,cl
   0x400700:    leave
   0x400701:    ret


   0x400702:    push   rbx
   0x400703:    push   rdi
   0x400704:    push   rbp
   0x400705:    mov    rbp,rsp
   0x400708:    mov    rdx,rax
;    0x40070b:    dec    eax
;    0x40070d:    jmp    0x40070e
; ;    0x40070f:    ror    BYTE PTR [rax-0x75],0xfa    
;                                                    0x40070e:    inc    eax
                                                   0x400710:    mov    rdi,rdx
   0x400713:    xor    al,al
   0x400715:    xor    ecx,ecx
   0x400717:    dec    rcx
   0x40071a:    repnz scas al,BYTE PTR es:[rdi]
   0x40071c:    not    ecx
   0x40071e:    dec    ecx
;    0x400720:    mov    eax,0x92185987
;    0x400725:    xor    eax,0x32963a85         xor sets SF=1
;    0x40072a:    jns    0x4006b7
;    0x40072c:    mov    eax,0xc3bc42d9
;    0x400731:    xor    eax,0x1ed2c907
;    0x400736:    jns    0x400742
   0x400738:    push   0x50
   0x40073a:    pop    r9                   ;r9=0x50
   0x40073c:    xor    r8d,r8d
   0x40073f:    cmp    r8d,0x539            ;for(r8d = 0; r8d < 1337; ++r8d)
   0x400746:    jl     0x400763
   0x400748:    jmp    0x400774
   ; 0x40074a:    dec    eax
   ; 0x40074c:    jmp    0x40074d
   ; ; 0x40074e:    rol    BYTE PTR [rcx-0x7d],0xc0
   ; ; 0x400752:    add    DWORD PTR [rax+0x669ec28e],edi
   ;                                                        0x40074d:    inc    eax
                                                         0x40074f:    add    r8d,0x1
                                                         ; 0x400753:    mov    eax,0x669ec28e
   ; 0x400758:    add    eax,0x99613d72
   ; 0x40075d:    inc    eax
   ; 0x40075f:    jae    0x400724
   0x400761:    jmp    0x40073f
;    0x400763:    mov    eax,0xe72b5c52
;    0x400768:    add    eax,0x18d4a3ae
;    0x40076d:    jne    0x400747
   0x40076f:    xor    r11d,r11d
   0x400772:    jmp    0x4007ac
;    0x400774:    mov    eax,0xea3e6566
;    0x400779:    xor    eax,0x5f69faeb
;    0x40077e:    jns    0x4007b6
   0x400780:    lea    rax,[rip+0x164]        # 0x4008eb
   0x400787:    lea    r8,[rax]
;    0x40078a:    mov    eax,0xb5de3358
;    0x40078f:    xor    eax,0x459f236e
;    0x400794:    jns    0x400797
   ; 0x400796:    dec    eax
   ; 0x400798:    jmp    0x400799
   ; ; 0x40079a:    shr    BYTE PTR [rdx+0x1],0x41
   ; ; 0x40079e:    pop    rdx
   ;  0x400799:    inc    eax
   0x40079b:    push   0x1
   0x40079d:    pop    r10

   ; 0x40079f:    dec    eax

   ; ; 0x4007a1:    jmp    0x4007a2
   ; ; 0x4007a3:    rol    BYTE PTR [rbp+0x33],0xc9

   ; 0x4007a2:    inc    eax
   0x4007a4:    xor    r9d,r9d

   0x4007a7:    jmp    0x400834
;    0x4007ac:    dec    eax
;    0x4007ae:    jmp    0x4007af
; ;    0x4007b0:    rol    BYTE PTR [rbx+rdi*1-0x27],0x7c  disassemble sai
; ;    0x4007b5:    add    ch,bl
; ;    0x4007b7:    xchg   edx,eax
;                                 0x4007af:    inc    eax
                                0x4007b1:    cmp    r11d,ecx
                                0x4007b4:    jl     0x4007b8
                                0x4007b6:    jmp    0x40074a
;    0x4007b8:    mov    eax,0x2b71234a
;    0x4007bd:    add    eax,0xd48edcb6
;    0x4007c2:    inc    eax
;    0x4007c4:    jae    0x400774
   0x4007c6:    movsxd r10,r11d
;    0x4007c9:    mov    eax,0xef8ac85b
;    0x4007ce:    xor    eax,0xe71ae312
;    0x4007d3:    js     0x4007ff
   0x4007d5:    mov    rbx,rdx
   0x4007d8:    add    rbx,r10
;    0x4007db:    mov    eax,0x46d3a79d
;    0x4007e0:    add    eax,0xb92c5863
;    0x4007e5:    jne    0x4007ee
   0x4007e7:    movsxd r10,r11d
;    0x4007ea:    mov    eax,0xf45102a7
;    0x4007ef:    xor    eax,0xae9accbc
;    0x4007f4:    js     0x40085f
   0x4007f6:    mov    rax,rdx
   0x4007f9:    add    rax,r10
   0x4007fc:    mov    al,BYTE PTR [rax]
   0x4007fe:    xor    al,r9b
   0x400801:    mov    BYTE PTR [rbx],al
   0x400803:    movsxd r10,r11d
   0x400806:    mov    rax,rdx
   0x400809:    add    rax,r10
   0x40080c:    mov    al,BYTE PTR [rax]
   0x40080e:    xor    r9b,al
;    0x400811:    mov    eax,0x91ecf78
;    0x400816:    add    eax,0xf6e13088
;    0x40081b:    inc    eax
;    0x40081d:    jae    0x4007be
   0x40081f:    add    r11d,0x1
;    0x400823:    mov    eax,0x15690edd
;    0x400828:    xor    eax,0xd68c1903
;    0x40082d:    jns    0x400888
   0x40082f:    jmp    0x4007ac
;    0x400834:    mov    eax,0x4759bfd0
;    0x400839:    add    eax,0xb8a64030
;    0x40083e:    inc    eax
;    0x400840:    jae    0x400847
   0x400842:    cmp    r9d,ecx
   0x400845:    jl     0x400849
   0x400847:    jmp    0x400850
   0x400849:    test   r10b,r10b
   0x40084c:    jne    0x400857
   0x40084e:    jmp    0x40089f
   0x400850:    mov    al,r10b
   0x400853:    leave
   0x400854:    pop    rdi
   0x400855:    pop    rbx
   0x400856:    ret


   0x400857:    movsxd r11,r9d
;    0x40085a:    mov    eax,0x5f9c75ce
;    0x40085f:    xor    eax,0x5d98bd96
;    0x400864:    js     0x4008a0
   0x400866:    mov    r10,rdx
   0x400869:    add    r10,r11
;    0x40086c:    dec    eax   ;Ignore because will dec under
;    0x40086e:    jmp    0x40086f
; ;    0x400870:    rol    BYTE PTR [rbp-0x76],0x1a  dec sai
;                                                 0x40086f:    inc    eax  ;Ignore because just dec above
                                                0x400871:    mov    r11b,BYTE PTR [r10]
;    0x400874:    mov    eax,0xf8eca7d8
;    0x400879:    add    eax,0x7135828
;    0x40087e:    jne    0x40081c
   0x400880:    movsxd rax,r9d
   0x400883:    mov    r10,r8
   0x400886:    add    r10,rax
;    0x400889:    mov    eax,0x3b4ad836
;    0x40088e:    xor    eax,0xf1d7dbea
;    0x400893:    jns    0x400818
   0x400895:    mov    al,BYTE PTR [r10]
   0x400898:    cmp    r11b,al
   0x40089b:    je     0x4008c3
   0x40089d:    jmp    0x4008da
   0x40089f:    xor    r10b,r10b
;    0x4008a2:    mov    eax,0x2e4ef210
;    0x4008a7:    add    eax,0xd1b10df0
;    0x4008ac:    jne    0x40087e
;    0x4008ae:    mov    eax,0x1bff10d0
;    0x4008b3:    xor    eax,0x9dd00315
;    0x4008b8:    jns    0x40091d
   0x4008ba:    add    r9d,0x1
   0x4008be:    jmp    0x400834
;    0x4008c3:    mov    eax,0x451c2342
;    0x4008c8:    add    eax,0xbae3dcbe
;    0x4008cd:    jne    0x400901
   0x4008cf:    push   0x1
   0x4008d1:    pop    r10  ;r10=1
;    0x4008d3:    dec    eax
;    0x4008d5:    jmp    0x4008d6
; ;    0x4008d7:    shr    bl,0x3
;                                             0x4008d6:    inc    eax
                                            0x4008d8:    jmp    0x4008dd

   0x4008da:    xor    r10b,r10b
;    0x4008dd:    mov    eax,0x5e82d693
;    0x4008e2:    add    eax,0xa17d296d
;    0x4008e7:    jne    0x40090a
   0x4008e9:    jmp    0x4008a2




   0x4008eb:    rex.W pop rdi
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