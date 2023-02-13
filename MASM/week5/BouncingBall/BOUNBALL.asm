;document
;int 10h: http://sbisc.sharif.edu/~vahdat/UPI2010/8086_bios_and_dos_interrupts.html
STACK SEGMENT PARA STACK
	DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'
	windowWidth dw 140h ;320 pixels
	windowHeight dw 0C8h ;200 pixels
	timeAux db 0	;variable used when checking if the tim has changed
	ballX DW 00h	;X position(column) of the ball DW = DEFINE WORD(16bit)
	ballY DW 00h	;y position(column) of the ball
	ballSize DW 7h 	;size of the ball( how many pixels does the ball have in width and height)
	ballSpeedX DW 5h	
	ballSpeedY DW 5h
	numberGenerated DW 10h
DATA ENDS

CODE SEGMENT PARA 'CODE'

	MAIN PROC FAR
	ASSUME CS:CODE,DS:DATA,SS:STACK  ;assum as code, data and stack segments the repective registers
	PUSH DS 		;push to the stack the DS segments
	sub AX,AX		;clean AX register
	push AX		    ;push AX to the stack
	mov AX, DATA	;save on the AX register the contents of the DATA segments
	mov DS,AX 		;save on the DS segment the contents of AX
	pop AX			;release the top item from the stack to the AX register
	pop AX			;release the top item from the stack to the AX register
	

		
		MOV AH,00h ;set to video mode https://en.wikipedia.org/wiki/INT_10H
		MOV AL, 0Dh ; 320x200 16 color graphics (EGA,VGA) https://stanislavs.org/helppc/int_10.html
		int 10h		;call interupt 10h
		
		; By default, there are 16 colors for text and only 8 colors for background.
		; There is a way to get all the 16 colors for background, which requires turning off the "blinking attribute".		
		; the emulator and windows command line prompt do not support background blinking, however to make colors look the
		; same in dos and in full screen mode it is required to turn off the background blinking.
		; use this code for compatibility with dos/cmd prompt full screen mode: 
		mov     ax, 1003h ;must do this to change the background to white
		mov     bx, 0   ; disable blinking. 
		int     10h
	
		mov AH,0Bh	;set the configuration https://en.wikipedia.org/wiki/INT_10H
		mov BH,00h	;to the background color
		mov BL,0Fh  ;choose color https://en.wikipedia.org/wiki/BIOS_color_attributes
	    int 10h
			call generateRandomNumberWidth
			mov ballX,dx
			call generateRandomNumberHeight
			mov ballY,dx
			
		

		cmp dx,0
		jnz cmp1
		call move45
		jmp checkTime
		cmp1:
		cmp dx,1
		jnz cmp2
		call move135
		jmp checkTime
		cmp2:
		cmp dx,2
		jnz cmp3
		call move225
		jmp checkTime
		cmp3:
		cmp dx,3
		call move135
		jmp checkTime
		
		
		checkTime:
			mov ah,2Ch		;get the system time use int 21h http://spike.scu.edu.au/~barry/interrupts.html
			int 21h			;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
			
			cmp dl,timeAux	;is the current time equal to the previous one(timeAux)?
			je checkTime	;if it is the same check again
			;if it's different then draw,move,etc
			mov timeAux,dl	;update time

			
			call clearScreen
		
			call moveBall	
			
			call drawBall	
			
			jmp checkTime
			
			
			
		RET

	MAIN ENDP
	
	moveBall proc near
			
			mov ax,ballSpeedX	;move the ball horizontally
			add ballX,ax
			
			cmp ballX,00h			
			jl negSpeedX		;BallX<0 (Yes collided)

			mov ax,windowWidth
			sub ax,ballSize
			cmp ballX,ax	
			jg negSpeedX		;BallX>windowWidth-ballSize(Yes->collided)
			

			mov ax,ballSpeedY	;move the ball vertically
			add ballY,ax

			
			cmp ballY,0h			
			jl negSpeedY		;BallY<0 (Yes collided)							

			mov ax,windowHeight
			sub ax,ballSize
			cmp ballY,ax	
			jg negSpeedY		;BallY>windowHeight-ballSize(Yes->collided)
	ret
		negSpeedX:
			neg ballSpeedX ;ballSpeedX=-ballSpeedX
		
			ret
		
		negSpeedY:
			neg ballSpeedY ;ballSpeedY=-ballSpeedY
			
			ret
			
	moveBall endp
	
	move45 proc near
	neg ballSpeedY
	ret
	move45 endp
	
	move135 proc near
	neg ballSpeedX
	neg ballSpeedY
	ret
	move135 endp
	
	move225 proc near
	neg ballSpeedX
	ret
	move225 endp
	
	move315 proc near
	;default
	ret
	move315 endp
	
	drawBall proc near
		mov CX,ballX	;set the initial column(X)
		mov DX,ballY	;set the initial line (Y)
		
		drawstart:
			mov CX,ballX
			cmp DX,ballY
			je draw17
			mov bx,BallY
			add bx,6
			cmp DX,bx
			je draw17
			mov bx,BallY
			add bx,1
			cmp DX,bx
			je draw26
			mov bx,BallY
			add bx,5
			cmp DX,bx
			je draw26
			jmp draw345
		
	draw17:	;draw row 1 and 7
		mov bx,cx
		inc cx ;draw 3x1,4x1,5x1 and 3x7,4x7,5x7
		inc cx
		L1:
		call drawBlack	
		inc cx
		mov bx,BallX
		add bx,5
		cmp cx,bx
		jl L1
		INC DX
		mov bx,BallY
		add bx,7
		cmp DX,bx
		jge done
		jmp drawstart
	
	
	draw26:	;draw row 2 and 6
		inc cx
		call drawBlack
		inc cx			
		n2:
		call drawRed
		inc cx		
		mov bx,BallX
		add bx,4
		cmp cx,bx
		jle n2
		call drawBlack
		INC DX
		jmp drawstart
	
	draw345: ;draw row 3,4 and 5
		call drawBlack
		inc cx
				
		nn2:
		call drawRed
		inc cx
		mov bx,BallX
		add bx,5
		cmp cx,bx
		jle nn2
		
		call drawBlack
		INC DX
		jmp drawstart		
	done:
	ret
	drawBall endp
	
	drawBlack proc near
		xor bx,bx
		mov AH,0Ch	;set the configuration to writing a pixel
		mov AL,8h	;choose color
		mov BH,00h ;set the page number
		int 10h		;execute the configuration

		ret
	drawBlack endp
	
	drawRed proc near
		xor bx,bx
		mov AH,0Ch	;set the configuration to writing a pixel
		mov AL,04h	;choose color
		mov BH,00h ;set the page number
		int 10h		;execute the configuration

		ret
	drawRed endp
	
	clearScreen proc near
			MOV AH,00h ;set to video mode https://en.wikipedia.org/wiki/INT_10H
			MOV AL, 0Dh ; 320x200 16 color graphics (EGA,VGA) https://stanislavs.org/helppc/int_10.html
			int 10h		;call interupt 10h			

			mov AH,0Bh	;set the configuration https://en.wikipedia.org/wiki/INT_10H
			mov BH,00h	;to the background color
			mov BL,0Fh  ;choose color https://en.wikipedia.org/wiki/BIOS_color_attributes
			int 10h
		ret
	clearScreen endp
		generateRandomNumberWidth proc
		mov ah,2Ch		;get the system time use int 21h http://spike.scu.edu.au/~barry/interrupts.html
		int 21h			;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
		mov AX,DX
		mov cx,140h
		xor dx,dx
		div cx
    ret   
	generateRandomNumberWidth endp 
	
	generateRandomNumberHeight proc
		mov ah,2Ch		;get the system time use int 21h http://spike.scu.edu.au/~barry/interrupts.html
		int 21h			;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
		mov AX,DX
		mov cx,0C8h
		xor dx,dx
		div cx
    ret   
	generateRandomNumberHeight endp 
	
	generateRandomNumber proc
		mov ah,2Ch		;get the system time use int 21h http://spike.scu.edu.au/~barry/interrupts.html
		int 21h			;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
		mov AX,DX
		mov cx,4h
		xor dx,dx
		div cx
    ret   
	generateRandomNumber endp 
	
	
CODE ENDS
END
