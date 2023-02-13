INCLUDE Irvine32.inc 
.data
helloW db "Hello World!",0
textSize dd ($-helloW)
byteWritten dd ?
consoleHandle HANDLE ?

.code
main PROC
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov consoleHandle,eax
invoke WriteConsole,
	consoleHandle,
	ADDR helloW,
	textSize,
	ADDR byteWritten,
	0
invoke ExitProcess,0
main ENDP
END main