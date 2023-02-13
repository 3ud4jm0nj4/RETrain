INCLUDE Irvine32.inc
inputSize=10000
.data
msg1 db "Tong Le:",0
soPhantu dd 0

arraychar db inputSize dup(?) 
msg2 db "Tong Chan:",0
arrayint dd 3200 dup(?)
byteHandle dd ?
stdHandle HANDLE ?
oddSum dd 0
evenSum dd 0
varPrint db inputSize dup(?)
.code



itoa PROC				;int to ascii
push ebp
mov ebp,esp
mov esi,[ebp+8] 
xor eax,eax
mov eax,DWORD PTR [esi]
mov DWORD PTR[varPrint],0  ; bien de in
mov ecx,offset varPrint
mov BYTE PTR[ecx],0Ah	
dec ecx
mov BYTE PTR[ecx],0dh
xor edi,edi
mov edi,10
sub1: 
dec ecx
mov BYTE PTR[ecx],0
xor edx,edx
div edi
add edx,30h
add BYTE PTR[ecx],dl   ;store in ecx
test eax,eax
jnz sub1
mov esp,ebp
pop ebp
ret
itoa ENDP		

main PROC
invoke GetStdHandle,STD_INPUT_HANDLE ;nhap so phan tu
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ADDR soPhantu,
		inputSize,
		ADDR byteHandle,
		0
xor edi,edi
mov edi,offset soPhanTu
call atoi	;chuyen so phan tu thanh int va luu vao esi
xor esi,esi
mov esi,eax
mov ebx,offset arraychar
input:
dec esi
invoke GetStdHandle,STD_INPUT_HANDLE
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ebx,
		inputSize,
		ADDR byteHandle,
		0
add ebx,10
test esi,esi
jnz input
	


mov edi,offset soPhanTu 
call atoi
xor ecx,ecx
mov ecx,eax				;lay so phan tu vao ecx

mov ebx, offset arraychar
mov edx, offset arrayint
reverseCharToInt:
mov edi,ebx
call atoi
mov DWORD PTR [edx],eax
add edx,8
add ebx,10
dec ecx
test ecx,ecx
jnz reverseCharToInt ;chuyen mang char thanh mang int



mov edi,offset soPhanTu 
call atoi
xor ecx,ecx
mov ecx,eax	
xor ebx,ebx
mov ebx,2
mov edi,offset arrayint
paritySum:
dec ecx
xor eax,eax
xor edx,edx
mov eax,DWORD PTR [edi]
div ebx
cmp dl,0
jz calEvenSum

calOddSum:
mov esi,offset oddSum
imul eax,2
add eax,1
add DWORD PTR [esi],eax
add edi,8
jmp check

calEvenSum:
mov esi,offset evenSum
imul eax,2
add DWORD PTR [esi],eax
add edi,8
jmp check

check:
test ecx,ecx
jnz paritySum
jmp doneVIP




atoi:
	mov eax,0 
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

doneVIP:


invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ADDR msg2,
		10,
		ADDR byteHandle,
		0

push offset evenSum
call itoa
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ecx,
		32,
		ADDR byteHandle,
		0

invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ADDR msg1,
		8,
		ADDR byteHandle,
		0
push offset oddSum
call itoa
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ecx,
		32,
		ADDR byteHandle,
		0

invoke ExitProcess, 0
main ENDP
END main
