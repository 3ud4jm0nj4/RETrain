INCLUDE Irvine32.inc
inputSize =100
.data
string db inputSize dup(?),0
subString db inputSize dup(?),0
position dd 0
positionSub dd 0,0
stdHandle HANDLE ?
byteHandle dd ?
ten dd 10
positionVIP db inputSize dup(?),0
currentString dd 0
strlenString dd 0
strlenSubString dd 0

.code

strlen PROC						
push ebp
mov ebp,esp
mov edi,[ebp+8]
mov edx,edi
L1:
	cmp BYTE PTR[edi],0dh
	jz done
	inc edi
	jmp L1
done:
sub edi,edx
mov eax,edi
mov esp,ebp
pop ebp
ret
strlen ENDP   ;string length


itoa PROC
push ebp
mov ebp,esp
mov al,BYTE PTR [currentString]
mov DWORD PTR[positionVIP],0
mov ecx,offset positionVIP
inc eax
mov BYTE PTR[ecx],0Ah
dec ecx
mov BYTE PTR[ecx],0dh
sub1: 
dec ecx
mov BYTE PTR[ecx],0
xor edx,edx
div WORD PTR[ten]
add edx,30h
add BYTE PTR[ecx],dl   ;store in ecx
test eax,eax
jnz sub1
mov esp,ebp
pop ebp
ret
itoa ENDP		;int to ascii


find_substring PROC 
push ebp
mov ebp,esp
mov edi,[ebp+8]					;substring
mov esi,[ebp+12]				;String
xor ebx,ebx
xor edx,edx
mov bl,0						;phan tu hien tai cua mang string
mov bh,0						;SubString check

cmp1: 
cmp bl,BYTE PTR [strlenString]	;kiem tra vi tri hien tai dang xet cua String xem het chua
jge done						
mov BYTE PTR[currentString],bl	;luu tru vi tri hien tai
xor eax,eax						
mov al,BYTE PTR[currentString] ;vi tri hien tai cua string 
cmp2:
xor edx,edx
movzx edx,bh					; vi tri hien tai c?a substring
movsx ecx,byte ptr [esi+eax]	; lay ki tu hien tai c?a sub string
cmp BYTE PTR [edi+edx],cl
jz same
jnz different

same:
inc dl
cmp dl,BYTE PTR [strlenSubString]	;neu vi trí hi?n t?i c?a subString = ?? dài c?a string thì in ra 
je print 
inc al							;tang vi tri cua string len 1
inc bh							;tang vi tri c?a subString lên 1
jmp cmp2

different:
inc bl
xor bh,bh
jmp cmp1


print:
call itoa
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle,eax
invoke WriteConsole,
		stdHandle,
		ecx,
		32,
		ADDR byteHandle,
		0
inc bl
xor bh,bh
jmp cmp1

done:
mov esp,ebp
pop ebp
ret
find_substring ENDP



main PROC
invoke GetStdHandle,STD_INPUT_HANDLE
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ADDR string,
		inputSize,
		ADDR byteHandle,
		0
push offset String
call strlen
mov DWORD PTR[strlenString],eax

invoke GetStdHandle,STD_INPUT_HANDLE
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ADDR subString,
		inputSize,
		ADDR byteHandle,
		0
push offset subString
call strlen
mov DWORD PTR[strlenSubString],eax
call find_substring
invoke ExitProcess, 0
main ENDP
END main
