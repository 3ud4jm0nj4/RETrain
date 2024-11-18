INCLUDE Irvine32.inc
inputSize =1024
.data
plainText db inputSize dup(0),0
cipherText db inputSize dup(0),0
cipherPrintText db inputSize dup (0),0
key db inputSize dup(0),0
data_len dd ? 
key_len dd ?
array db 256 dup(0)
msg1 db "key: ", 0
msg1len dd $-msg1
msg2 db "plainText: ", 0
msg2len dd $-msg2
msg3 db "cipherText: ", 0
msg3len dd $-msg3
hInput dd ?
hOutput dd ?
byteRead dd ?
byteWritten dd ?
J dd 0

.code

strlen proc
push ebp
mov ebp,esp
mov edi,[ebp+8]
mov edx,edi
L1:
	cmp BYTE PTR[edi],0dh ; 0dh 0ah is end of string
	jz done
	inc edi
	jmp L1
done:
sub edi,edx
mov eax,edi
mov esp,ebp
pop ebp
ret
strlen endp

itohex proc ;from int to hex to print
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]	;cipherText
	mov ecx,DWORD PTR [data_len]		;count var
	mov edx,offset cipherPrintText
	dec eax ;prepare for loop
	nexthex:
		inc eax			;go through each element in cipher Text
		mov esi,0		;var to check 
		cmp ecx,0		;countdown cipher len and check
		jle done
		dec ecx
		movzx ebx,BYTE PTR[eax]	;take hex one by one 
		shr ebx,4		;shift right to get 4 first bits
		cmp bl,9
		jle addBase10	;if 1-9
	addHex:
		add bl,37h		;if A-F
		mov BYTE PTR[edx],bl
		inc edx
		inc esi
		cmp esi,2
		je nexthex
	nextdigit:
		movzx ebx,BYTE PTR[eax] ;get hex again to convert 4 last bit
		and ebx,0fh				;xor 1111 to get 4 last bit
		cmp bl,9				
		jle addBase10			;if 1-9
		jmp addHex				;if A-F
	

	addBase10:
		add bl,30h				;get number in ascii to print
		mov BYTE PTR[edx],bl	;save to cipherTextPrint
		inc edx					;i++
		inc esi					;check bit in 1 hex digit
		cmp esi,2				;if 2 go to next hex
		je nexthex
		jmp nextdigit			;else go to 2nd digit in current hex
	done:
	mov BYTE PTR[edx],0dh		;push 0dh to calculate strlen
	mov esp,ebp
	pop ebp
	ret
itohex endp
main PROC
invoke GetStdHandle,STD_INPUT_HANDLE
mov hInput,eax
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov hOutput,eax

invoke WriteConsole,  ;print "Key:"
		hOutput,
		ADDR msg1,
		msg1len,
		ADDR byteWritten,
		0

invoke ReadConsole,  ;read Key
		hInput,
		ADDR key,
		inputSize,
		ADDR byteRead,
		0
push offset key				;calculate strlen key
call strlen
mov DWORD PTR[key_len],eax

;	Init array 
xor ebx,ebx
mov edi, offset array
L1:
	mov BYTE PTR [edi+ebx],bl	;init Array 1->255
	inc ebx
	cmp ebx, 256
	jl L1

xor ecx,ecx ;i=0
xor ebx,ebx ;j=0
L2:
	mov esi, offset key		;esi = key
	mov edi, offset array	;edi = array
	xor eax,eax
	add edi,ecx
	mov al,BYTE PTR [edi]	;get element in array one by one a[i]=array[i]
	add ebx,eax   ;ebx=ebx+array[i]

	xor eax,eax
	mov eax,ecx
	mov ch,BYTE PTR[key_len]  
	div ch						;i mod len(key)
	xor ch,ch
	xor edx,edx
	mov dl,ah
	add esi,edx					;key[i%len(key)]
	xor eax,eax
	mov al,BYTE PTR [esi]		
	add ebx, eax	;ebx = ebx + key[i%len(key)]  (j= j + array[i] + ord(key[i % len(key)]))
	
		
	mov eax,ebx
	mov ebx,256
	div bx			;j mod 256
	xor ebx,ebx
	mov bx,dx

	;swap(array[i],array[j])
	xor eax,eax
	mov eax,edi
	mov dh,BYTE PTR [eax] ;array[i]

	
	mov eax,offset array
	add eax,ebx
	mov dl,BYTE PTR [eax] ;array[j]
	
	mov BYTE PTR[eax],dh  ;swap array[i],array[j]
	mov eax,edi
	mov BYTE PTR[eax],dl
	inc ecx
	cmp ecx,256			;loop 256 times
	jl L2


invoke WriteConsole, ;print "plainText:"
		hOutput,
		ADDR msg2,
		msg2len,
		ADDR byteWritten,
		0
invoke ReadConsole,	;Read plain text 
		hInput,
		ADDR plainText,
		inputSize,
		ADDR byteRead,
		0
push offset plainText
call strlen
mov DWORD PTR[data_len],eax

;Encrypt
xor ecx,ecx ;count to data_len (is i)
xor esi,esi ; i=0
xor edi,edi ; j=0
L3:
	;swap(array[(i+1)%256],array[(j+array[i])%256)
	mov eax,ecx ;get i
	add eax,1	;i=i+1
	xor ebx,ebx ;(i+1)%256
	mov bx,256	
	xor edx,edx
	div bx
	xor ebx,ebx
	mov eax,offset array
	add eax,edx	;get array[(i+1)%256]
	mov bl,BYTE PTR [eax]
	mov esi,ebx        ;store arr[i+1] to esi

	mov edi,DWORD PTR [J] ;get J value
	add edi,esi		;j=j+arr[i]
	mov eax,edi
	xor ebx,ebx
	mov bx,256		;j mod 256
	xor edx,edx
	div bx
	xor ebx,ebx
	mov eax, offset array
	add eax, edx	;get array[(j+array[i])%256]
	mov bl,BYTE PTR[eax] ;store arr[j+array[i]] to bl
	mov DWORD PTR [J],edx
	mov edx,esi
	mov BYTE PTR[eax],dl  ;arr[j+array[i]]=arr[i+1]

	movzx edi,BYTE PTR[eax] ;store arr[i+1] to edi

	mov esi,ebx ;store arr[j+S[i]] to esi

	mov eax,ecx
	add eax,1
	xor ebx,ebx
	mov bx,256
	xor edx,edx
	div bx		;get (i+1) %256 again
	xor ebx,ebx
	mov ebx,esi ;store arr[j+S[i]] to ebx 
	mov eax,offset array 
	add eax,edx	;get offset arr[i]
	mov BYTE PTR[eax],bl ; arr[i]=arr[j]

	movzx esi, BYTE PTR[eax] ;store arr[j+S[i]] to esi

	add edi,esi		;edi = arr[i]+arr[j]
	mov eax,edi
	mov bx,256
	xor edx,edx
	div bx			;edi mod 256
	xor ebx,ebx					
	mov eax,offset array
	add eax, edx
	mov bl,BYTE PTR[eax] 	;store S[(S[i] + S[j]) % 256] to bl

	mov eax, offset plainText	
	add eax,ecx
	xor bl,BYTE PTR[eax]	;xor stream key with plain Text

	mov eax, offset cipherText	;save to cipher Text
	add eax,ecx
	mov BYTE PTR[eax],bl
	
	inc ecx
	cmp cl,BYTE PTR[data_len]
	jl L3

invoke WriteConsole,  ;print "cipherText:"
		hOutput,
		ADDR msg3,
		msg3len,
		ADDR byteWritten,
		0
push offset cipherText
call itohex			;convert int to hex to print
push offset cipherPrintText
call strlen
invoke WriteConsole, 
		hOutput,
		ADDR cipherPrintText,
		eax,
		ADDR byteWritten,
		0

invoke ExitProcess, 0
main ENDP
END main
