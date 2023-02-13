INCLUDE Irvine32.inc
inputSize=10000
.data
soPhantu dd 0
byteHandle dd ?
stdHandle HANDLE ?
arraychar db inputSize dup(?) 
arrayint dd 3200 dup(?)
result db 32 dup(?),0
number dd 32 dup(?),0
.code

itoa PROC
push ebp
mov ebp,esp
mov esi,[ebp+8] 
xor eax,eax
mov eax,DWORD PTR [esi]
mov DWORD PTR[result],0  ; bien de in
mov ecx,offset result
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
itoa ENDP		;int to ascii


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
mov ecx,eax	;lay so phan tu mang

mov edx, offset arrayint ;lay mang int
mov eax,DWORD PTR[edx]
mov ebx,DWORD PTR[edx]
compare:			;max=eax min =ebx
cmp eax, DWORD PTR[edx]
jl goodMax
continue:
cmp ebx, DWORD PTR[edx]
jg goodMin
continue2:
add edx,8
dec ecx
test ecx,ecx
jnz compare
jmp print

goodMax:
mov eax,DWORD PTR[edx]
jmp continue

goodMin:
mov ebx,DWORD PTR[edx]
jmp continue2
;tim Min Max
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

print:
mov DWORD PTR[number],eax
push offset number
call itoa
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ecx,
		32,
		ADDR byteHandle,
		0
mov DWORD PTR[number],ebx
push offset number
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
