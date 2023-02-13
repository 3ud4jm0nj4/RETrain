
include Irvine32.inc
inputSize=100
.data
input db inputSize DUP(?)
stdHandle HANDLE ?
byteRead dd ?
.code

main PROC
invoke GetStdHandle, STD_INPUT_HANDLE
mov stdHandle, eax
invoke ReadConsole,stdHandle, ADDR input, inputSize, ADDR byteRead, 0

invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle, eax
invoke WriteConsole,stdHandle, ADDR input, inputSize, ADDR byteRead,0

invoke ExitProcess,0
main ENDP
END main