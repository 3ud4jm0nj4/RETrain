
include Irvine32.inc
inputSize=32
.data
input db inputSize DUP(?)
stdHandle HANDLE ?
byteRead dd ?
.code

main PROC
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdHandle, eax
	invoke ReadConsole,stdHandle, ADDR input, inputSize, ADDR byteRead, 0
	mov ebx, offset input
	mov eax, inputSize
UPPER:
	cmp BYTE PTR[ebx],60h
	jl SET
	sub BYTE PTR[ebx],20h
	cmp eax,0
	jz BYE
	jmp UPPER
SET:
	inc ebx
	dec eax
	cmp eax,0
	jz BYE
	jmp UPPER
BYE:

	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov stdHandle, eax
	invoke WriteConsole,stdHandle,ADDR input, inputSize, ADDR byteRead,0

	invoke ExitProcess,0
main ENDP
END main