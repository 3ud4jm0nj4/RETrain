;document :http://www.interq.or.jp/chubu/r6/masm32/masm006.html
;https://www.geocities.ws/SiliconValley/Heights/6778/icztut1.htm
;TUTORIAL FOR THIS : http://www.interq.or.jp/chubu/r6/masm32/tute/tute009.html
.386
.model flat,stdcall
option casemap:none
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD;Since we will call WinMain later, we must define its function prototype first so that we will be able to invoke it.
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
.data
ClassName db "SimpleWinClass",0 ;the name of our window class
AppName db "Reverse Text Machine",0 ; the name of our window
editClass db "edit",0
editText db "Input String",0
editText2 db "Result",0
.data?
hInstance HINSTANCE ? ;Instance handle of our program(1)
CommandLine LPSTR ?	  ;The unfamiliar data types, HINSTANCE and LPSTR, are really new names for DWORD You can look them up in windows.inc
hwndButton HWND ?
hwndEdit HWND ?
hwndEdit2 HWND ?
buffer db 512 dup(?) ;buffer to store the text retrieved from the edit box
buffer2 db 512 dup(?)
.const
buttonID equ 1
editID equ 2
IDM_HELLO equ 1
IDM_CLEAR equ 2
IDM_GETTEXT equ 3
IDM_EXIT equ 4
.code
start:
invoke GetModuleHandle,NULL 	;get the instance handle of our program.
								;Under Win32, hmodule == hinstance mov hInstance,eax
mov hInstance,eax
invoke GetCommandLine			;get the command line, You don't have to call this funtion IF
								;your program doesn't process the command line
mov CommandLine,eax
invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT	;call the main function
invoke ExitProcess,eax			;quit our program. The exit code is returned in eax from WinMain.
; I'll outline the steps required to create a window on the desktop below:
; 1.Get the instance handle of your program (required)
; 2.Get the command line (not required unless your program wants to process a command line)
; 3.Register window class (required ,unless you use predefined window types, eg. MessageBox or a dialog box)
; 4.Create the window (required)
; 5.Show the window on the desktop (required unless you don't want to show the window immediately)
; 6.Refresh the client area of the window
; 7.Enter an infinite loop, checking for messages from Windows
; 8.If messages arrive, they are processed by a specialized function that is responsible for the window
; 9.Quit program if the user closes the window
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	; it receives four parameters: the instance handle of our program, the instance handle of the previous instance of our program, the command line and window state at first appearance.
	;Under Win32, there's NO previous instance. Each program is alone in its address space, so the value of hPrevInst is always 0.
	LOCAL wc:WNDCLASSEX					;create local variables on stack
	LOCAL msg:MSG			;LOCAL directive allocates memory from the stack for local variables used in the function
	LOCAL hwnd:HWND
; WNDCLASSEX STRUCT DWORD				name of class	https://learn.microsoft.com/en-us/windows/win32/winmsg/about-window-classes#system-classes
  ; cbSize            DWORD      ?
  ; style             DWORD      ?
  ; lpfnWndProc       DWORD      ?
  ; cbClsExtra        DWORD      ?
  ; cbWndExtra        DWORD      ?
  ; hInstance         DWORD      ?
  ; hIcon             DWORD      ?
  ; hCursor           DWORD      ?
  ; hbrBackground     DWORD      ?
  ; lpszMenuName      DWORD      ?
  ; lpszClassName     DWORD      ?
  ; hIconSm           DWORD      ?
; WNDCLASSEX ENDS
; cbSize: The size of WNDCLASSEX structure in bytes. We can use SIZEOF operator to get the value.
; style: The style of windows created from this class. You can combine several styles together using "or" operator.
; lpfnWndProc: The address of the window procedure responsible for windows created from this class.
; cbClsExtra: Specifies the number of extra bytes to allocate following the window-class structure. The operating system initializes the bytes to zero. You can store window class-specific data here.
; cbWndExtra: Specifies the number of extra bytes to allocate following the window instance. The operating system initializes the bytes to zero. If an application uses the WNDCLASS structure to register a dialog box created by using the CLASS directive in the resource file, it must set this member to DLGWINDOWEXTRA.
; hInstance: Instance handle of the module.
; hIcon: Handle to the icon. Get it from LoadIcon call.
; hCursor: Handle to the cursor. Get it from LoadCursor call.
; hbrBackground: Background color of windows created from the class.
; lpszMenuName: Default menu handle for windows created from the class.
; lpszClassName: The name of this window class.
; hIconSm: Handle to a small icon that is associated with the window class. If this member is NULL, the system searches the icon resource specified by the hIcon member for an icon of the appropriate size to use as the small icon.

	mov   wc.cbSize,SIZEOF WNDCLASSEX                   ; fill values in members of wc
    mov   wc.style, CS_HREDRAW or CS_VREDRAW			;https://learn.microsoft.com/en-us/windows/win32/winmsg/window-classes
    mov   wc.lpfnWndProc, OFFSET WndProc   ; The single most important member in the WNDCLASSEX is lpfnWndProc. lpfn stands for long pointer to function
    mov   wc.cbClsExtra,NULL
    mov   wc.cbWndExtra,NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground,COLOR_WINDOW+1
    mov   wc.lpszMenuName,NULL
    mov   wc.lpszClassName,OFFSET ClassName
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov   wc.hIcon,eax
    mov   wc.hIconSm,eax
    invoke LoadCursor,NULL,IDC_ARROW
    mov   wc.hCursor,eax
    invoke RegisterClassEx, addr wc   	; register our window class
	;https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexa
	; CreateWindowExA proto dwExStyle:DWORD,\ https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
   ; lpClassName:DWORD,\					https://learn.microsoft.com/en-us/windows/win32/winmsg/about-window-classes
   ; lpWindowName:DWORD,\
   ; dwStyle:DWORD,\
   ; X:DWORD,\
   ; Y:DWORD,\
   ; nWidth:DWORD,\
   ; nHeight:DWORD,\
   ; hWndParent:DWORD ,\
   ; hMenu:DWORD,\
   ; hInstance:DWORD,\
   ; lpParam:DWORD
    invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
                ADDR ClassName,\
                ADDR AppName,\
                WS_OVERLAPPEDWINDOW,\
                CW_USEDEFAULT,\
                CW_USEDEFAULT,\
                300,\
                200,\
                NULL,\
                NULL,\
                hInst,\
                NULL
    mov   hwnd,eax						;On successful return from CreateWindowEx, the window handle is returned in eax
    invoke ShowWindow, hwnd,CmdShow               ; display our window on desktop
    invoke UpdateWindow, hwnd                                 ; refresh the client area

    .WHILE TRUE                                                         ; Enter message loop
                invoke GetMessage, ADDR msg,NULL,0,0
                .BREAK .IF (!eax)
                invoke TranslateMessage, ADDR msg
                invoke DispatchMessage, ADDR msg
   .ENDW
    mov     eax,msg.wParam                                            ; return exit code in eax
    ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    .IF uMsg==WM_DESTROY                           ; if the user closes our window
        invoke PostQuitMessage,NULL             ; quit our application
	; CreateWindowExA proto dwExStyle:DWORD,\ https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
   ; lpClassName:DWORD,\					https://learn.microsoft.com/en-us/windows/win32/winmsg/about-window-classes
   ; lpWindowName:DWORD,\
   ; dwStyle:DWORD,\					https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
   ; X:DWORD,\
   ; Y:DWORD,\
   ; nWidth:DWORD,\
   ; nHeight:DWORD,\
   ; hWndParent:DWORD ,\
   ; hMenu:DWORD,\
   ; hInstance:DWORD,\
   ; lpParam:DWORD
	.elseif uMsg== WM_CREATE
		invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
						ADDR editClass,NULL,\
                        WS_CHILD or \ ;The window is a child window. A window with this style cannot have a menu bar.
						WS_VISIBLE or \	;The window is initially visible.
						WS_BORDER or \
						ES_LEFT or \
						ES_AUTOHSCROLL,\
                        75,35,150,25,hWnd,8,hInstance,NULL
		mov  hwndEdit,eax
        invoke SetFocus, hwndEdit
		invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
						ADDR editClass,NULL,\
                        WS_CHILD or \ ;The window is a child window. A window with this style cannot have a menu bar.
						WS_VISIBLE or \	;The window is initially visible.
						WS_BORDER or \
						ES_LEFT or \
						ES_AUTOHSCROLL or \
						ES_READONLY,\
                        75,70,150,25,hWnd,7,hInstance,NULL
		mov hwndEdit2,eax
	.elseif uMsg==WM_COMMAND
		mov eax,wParam
		 
        .IF lParam==0
            .IF  ax==IDM_GETTEXT
                invoke GetWindowText,hwndEdit,ADDR buffer,512
				mov edi,offset buffer
				mov ebx,offset buffer2
              
				L1:
				dec eax
                xor ecx,ecx
				mov cl,BYTE PTR[edi+eax]
				mov BYTE PTR [ebx],cl
                mov BYTE PTR [ebx+1],0
                inc ebx
				cmp eax,0
				jg L1

				invoke SetWindowText,hwndEdit2,ADDR buffer2
            .ELSE
                invoke DestroyWindow,hWnd
            .ENDIF
        .ELSE
			.IF ax==8
				shr eax,16
				.IF ax==EN_CHANGE
                    invoke SendMessage,hWnd,WM_COMMAND,IDM_GETTEXT,0
                .ENDIF
            .ENDIF
        .ENDIF


    .ELSE
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam     ; Default message processing
        ret
    .ENDIF
    xor eax,eax
    ret
WndProc endp

end start