
include Irvine32.inc
inputSize=32
.data
num1 db inputSize DUP(0)
num2 db inputSize DUP(0)
sum db inputSize DUP(0)

msg1 db "Enter the fist num:",0
msg1len dd ($-msg1)
msg2 db "Enter the second num:",0,0
msg2len dd ($-msg2)
msg3 db "Result:",0
msg3len dd ($-msg3)
stdHandle HANDLE ?
byteRead dd ?
byteWrite dd ?
result db inputSize DUP(0)
.code

main PROC
	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov stdHandle, eax
	invoke WriteConsole,stdHandle,ADDR msg1, msg1len, ADDR byteWrite,0

	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdHandle, eax
	invoke ReadConsole,stdHandle, ADDR num1, inputSize, ADDR byteRead, 0
	
	mov edi, offset num1
	call atoi
	mov DWORD PTR[SUM],eax

	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov stdHandle, eax
	invoke WriteConsole,stdHandle,ADDR msg2, msg2len, ADDR byteWrite,0

	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdHandle, eax
	invoke ReadConsole,stdHandle, ADDR num2, inputSize, ADDR byteRead, 0

	mov edi, offset num2
	call atoi
	add DWORD PTR[SUM],eax
	
	mov esi, OFFSET result
    add esi, 10d
    mov eax, DWORD PTR [SUM] ; lay gia tri cua sum
    mov ecx, 10d ; cho ecx = 10
    mov edi , 1d
	L1:
    xor edx, edx
    div ecx
    add edx, 48d ;convert to ascii
    mov BYTE PTR [esi], dl
    dec esi
    inc edi
    test eax, eax
    jnz L1
    inc esi

	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov stdHandle, eax
	invoke WriteConsole,stdHandle,esi, inputSize, ADDR byteWrite,0

	invoke ExitProcess,0

atoi:
	mov eax,0 ;sum
	mov ebx,0 ;digit
atoi_start:
	 movzx esi, BYTE PTR [edi]
	 cmp esi, 0Ah          ; Check for \n
     je done
	 cmp esi, 0dh          ; Check for \n
     je done
	 test esi, esi           ; Check for end of string 
     je done
	 sub esi,48
	 imul eax,10d
	 add eax,esi
	 inc edi
	 jmp atoi_start
done:
	ret
main ENDP
END main