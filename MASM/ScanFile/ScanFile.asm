
.386
.model flat,stdcall
option casemap:none
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD;Since we will call WinMain later, we must define its function prototype first so that we will be able to invoke it.
;include \masm32\include\masm32rt.inc
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comctl32.inc
include \masm32\include\Shlwapi.inc
includelib \masm32\lib\Shlwapi.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comctl32.lib
.data
ClassName db "SimpleWinClass",0 ;the name of our window class
AppName db "Scan File",0 ; the name of our window
editClass db "edit",0
buttonClass db "button",0
editText db "Input String",0
editText2 db "Result",0
buttonName db "Search",0
columnPath db "File path",0
WC_LISTVIEW db "SysListView32", 0
findFailstr db "Wrong Path",0
salt db "*.*",0
itemText db "Test",0
 currentDir db ".", 0
 beforeDir db "..",0
 temp db 1 dup(0)
 varClear db 3072 dup(0)
 buffer db 1024 dup(0) ;buffer to store the text retrieved from the edit box
collumnW db 1
  w32fd WIN32_FIND_DATA <>

  line_break db 13,10,0

.data?
hInstance HINSTANCE ? ;Instance handle of our program(1)
CommandLine LPSTR ?	  ;The unfamiliar data types, HINSTANCE and LPSTR, are really new names for DWORD You can look them up in windows.inc
hwndButton HWND ?
hwndEdit HWND ?
hListControl HWND ?

  file_handle HANDLE ?
  local_file_handle HANDLE ?
lvColumn LV_COLUMN <>
lvItem LVITEM <>

saved_buffer db 1024 dup(?)
local_path db 1024 dup(?)

.const
listControlID equ 1001
buttonID equ 1002
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
                1000,\
                500,\
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

; strlen PROC						
; push ebp
; mov ebp,esp
; pushad

; mov edi,[ebp+8]
; mov edx,edi
; L1:
	; cmp BYTE PTR[edi],0h
	; jz done
	; inc edi
	; jmp L1
; done:
; sub edi,edx
; mov eax,edi

; popad
; mov esp,ebp
; pop ebp
; ret
; strlen ENDP   ;string length

ListViewThread proc lParam:DWORD
	push ebp
	mov ebp,esp
;mov ecx,0
    ; Lấy đường dẫn từ ô nhập
    invoke GetWindowText, hwndEdit, ADDR buffer, 1024
	
    ; Gọi hàm đệ quy để tìm kiếm file
    push OFFSET buffer
    call SearchRecursive
	mov esp,ebp
	pop ebp
    ret
ListViewThread endp
SearchRecursive proc
    push ebp
    mov ebp, esp
	;pushad
	; tạo biến local
	sub esp, 3072                ; Allocate space on the stack for the local variable
	
    lea edi, [ebp-3072]          ; Get the address of the local variable
								 ;1024: +salt
								;2048 : fullpath
								;3072: origin
    ; làm sạch biến cục bộ trên stack
	mov esi, offset varClear
	mov ecx,3072
	rep movsb
	
	; copy tham số vào biến cục bộ origin
	lea edi, [ebp-3072]
	mov esi, [ebp + 8] 
	push esi
    mov ecx, 1024        ; Length of the string to copy
    rep movsb ; copy esi to edi
	
	; copy tham số vào biến cục bộ salt
	lea edi, [ebp-1024]
	mov esi, [ebp + 8] 
	push esi
    mov ecx, 1024         ; Length of the string to copy
    rep movsb ; copy esi to edi
	
    ;thêm "*.*" vào đường dẫn để tìm
	lea ebx,[ebp-1024] ;path 
	mov esi, [ebp + 8] ;tham số path truyền vào
	invoke PathCombine, ebx ,esi, OFFSET salt
	
	
	; Tìm file đầu tiên
    push OFFSET w32fd
    push ebx
    call FindFirstFile
    mov file_handle, eax

    test eax, eax
    jz ExitSearchRecursive

    FindNextFileLoop:
        ; Kiểm tra nếu là thư mục
        mov esi, DWORD PTR [w32fd + WIN32_FIND_DATA.dwFileAttributes]
        test esi, FILE_ATTRIBUTE_DIRECTORY
        jnz SkipDirectory   ;nếu là thư mục thì nhảy đến SkipDirectory
		
		;Nếu là file thì in ra
        ; Lấy đường dẫn tuyệt đối
		lea ebx, [ebp-3072] ;Biến cục bộ lưu đường dẫn file hiện tại
		lea edi, [ebp-2048]	;biến cục bộ lưu đường dẫn tuyệt đối để in ra
        invoke PathCombine, edi, ebx, OFFSET w32fd.cFileName

        ; Thêm item vào ListView
        mov eax, LVIF_TEXT
        mov edx, OFFSET lvItem
        mov [edx + 0], eax
        mov [edx + 20], edi
        invoke SendMessage, hListControl, LVM_INSERTITEM, -1, ADDR lvItem
		jmp find_next_file
    SkipDirectory:
		;jg ExitSearchRecursive
        ; Kiểm tra nếu là thư mục và không phải thư mục cha hoặc thư mục hiện tại . or ..
        invoke lstrcmp, ADDR w32fd.cFileName, ADDR currentDir
        je find_next_file
        invoke lstrcmp, ADDR w32fd.cFileName, ADDR beforeDir
        je find_next_file

        ; Tạo đường dẫn mới cho đệ quy
		;clear buffer
		lea edi, offset buffer         
		mov esi, offset varClear
		mov ecx,1024
		rep movsb
	
		lea edi, [ebp-3072]	;path orgin
        invoke PathCombine, OFFSET buffer, edi, OFFSET w32fd.cFileName

		mov eax, LVIF_TEXT
        mov edx, OFFSET lvItem
		mov [edx + 0], eax
        mov [edx + 20], OFFSET buffer
        invoke SendMessage, hListControl, LVM_INSERTITEM, -1, ADDR lvItem
        ; Đệ quy vào thư mục con
		;ecx
		

		push file_handle
        push OFFSET buffer
        call SearchRecursive

		add esp,4
		pop file_handle

    find_next_file:
        ; Tìm file tiếp theo
        push OFFSET w32fd
        push file_handle
        call FindNextFile

        .if eax != 0
        jmp FindNextFileLoop
        .endif
	
    ExitSearchRecursive:

       ;Đóng handle
       push file_handle
       call FindClose
	;popad

	mov esp, ebp
    pop ebp
    ret
SearchRecursive endp





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
		invoke CreateWindowEx, WS_EX_CLIENTEDGE,
                    ADDR buttonClass, NULL,
                    WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,
                    75, 70, 150, 25, hWnd, buttonID, hInstance, NULL
		mov hwndButton,eax
		invoke SetWindowText,hwndButton,ADDR buttonName

		invoke CreateWindowEx, WS_EX_CLIENTEDGE, ADDR WC_LISTVIEW, NULL, WS_VISIBLE or WS_CHILD or LVS_REPORT or LVS_EDITLABELS, 300, 35, 600, 400, hWnd, listControlID, hInstance, NULL
		mov hListControl, eax


		

mov eax, LVCF_TEXT
or eax, LVCF_WIDTH
mov edx, OFFSET lvColumn
mov [edx + 0], eax            ; LVCOLUMN.mask
mov ecx,595
mov [edx + 8], ecx  ; LVCOLUMN.cx
mov [edx + 12], OFFSET columnPath  ; LVCOLUMN.pszText
invoke SendMessage, hListControl, LVM_INSERTCOLUMN, 0, OFFSET lvColumn
		



		
	.elseif uMsg==WM_COMMAND
		mov eax,wParam
		 
        .IF lParam==0
            .IF  ax==buttonID
            .ELSE
                ;invoke DestroyWindow,hWnd
            .ENDIF
        .ELSE
			.IF ax==buttonID
			invoke SendMessage, hListControl, LVM_DELETEALLITEMS, 0, 0

			invoke CreateThread, NULL, 0, ADDR ListViewThread, NULL, 0, NULL
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