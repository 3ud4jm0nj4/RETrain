;CONCEPT:
;VA,RVA,Offset: https://tech-zealots.com/malware-analysis/understanding-concepts-of-va-rva-and-offset/
.386
.model flat, stdcall
option casemap :none

include D:\masm32\include\windows.inc
include D:\masm32\include\kernel32.inc ;include winAPI( GetStdHandle,ReadConsole,CreateFile....)
include D:\masm32\include\msvcrt.inc
include D:\masm32\include\comdlg32.inc
includelib D:\masm32\lib\msvcrt.lib
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\comdlg32.lib

extrn printf :near
extrn system :near

SIZEOF_NT_SIGNATURE equ sizeof DWORD
SIZEOF_IMAGE_FILE_HEADER equ 14h
 inputSize = 1000
 buffer_size = 40
 .data
 result db inputSize dup(?)
 ;string
 dos_header_str db "DOS_HEADER",0
 dos_header_strS dd $-dos_header_str
 DOSHeader 					db		"- DOS Header", 10, 13, 0
 PEHeader 					db		10, 13, "- PE Header", 10, 13, 0
 FileHeader					db		10, 13, 10, 13, "    + File Header", 10, 13, 0
 OptHeader 					db		10, 13, 10, 13, "    + Optional Header", 10, 13, 0
 DataDir 					db		10, 13, 10, 13, 10, 13 , "		++ Data Directories", 10, 13, 10, 13, 0
 Sections 					db		10, 13, 10, 13, "- Sections", 0
 Imports 					db 		10, 13, 10, 13, "- Imports", 0
 Exports 					db 		10, 13, 10, 13, 10, 13, "- Exports", 10, 13, 10, 13, 0
 no_exports 					db 		9, "[-] No exports table found", 0
 sectionless 				db 		10, 13, 9, "[-] Sectionless PE", 10, 13, 0
 endl						db		10,13,0

 ;DOS_HEADER
 e_magic_str db 9,"e_magic: 0x",0
 e_lfanew_str db 10, 13, 9, "e_lfanew: 0x", 0

 ;PE_HEADER
 signature_str 				db		9, "signature: 0x", 0
 machine_str 				db		10, 13, 9, "machine: 0x", 0
 timeDateStamp_str			db		10, 13, 9, "TimeDateStamp: 0x",0
 numberOfSections_str 		db		10, 13, 9, "numberOfSections: 0x", 0
 sizeOfOptionalHeader_str 	db		10, 13, 9, "sizeOfOptionalHeader: 0x", 0
 characteristics_str 		db		10, 13, 9, "characteristics: 0x", 0
 ;Optional Header
	magic_str 					db		9, "magic: 0x", 0
	addressOfEntryPoint_str 	db		10, 13, 9, 9, "addressOfEntryPoint: 0x", 0
	imageBase_str 				db		10, 13, 9, 9, "imageBase: 0x", 0
	sectionAlignment_str 		db		10, 13, 9, 9, "sectionAlignment: 0x", 0
	fileAlignment_str 			db		10, 13, 9, 9, "fileAlignment: 0x", 0
	majorSubsystemVersion_str 	db		10, 13, 9, 9, "majorSubsystemVersion: 0x", 0
	sizeOfImage_str 			db		10, 13, 9, 9, "sizeOfImage: 0x", 0
	sizeOfHeaders_str 			db		10, 13, 9, 9, "sizeOfHeaders: 0x", 0
	subsystem_str 				db		10, 13, 9, 9, "subsystem: 0x", 0
	numberOfRvaAndSizes_str 	db		10, 13, 9, 9, "numberOfRvaAndSizes: 0x", 0
;Data Directories
	ex_dir_rva 					db 		9, 9, 9, "export directory RVA(Relative virtual address): 0x", 0
	ex_dir_size 				db 		10, 13, 9, 9, 9, "export directory size: 0x", 0
	imp_dir_rva 				db 		10, 13, 9, 9, 9, "import directory RVA(Relative virtual address ): 0x", 0
	imp_dir_size 				db 		10, 13, 9, 9, 9,  "import directory size: 0x", 0
 ;Section Headers
	sec_name 					db		10, 13, 10, 13, 9, "name: ", 0
	virt_size 					db 		10, 13, 9, "virtual size: 0x", 0
	virt_address 				db 		10, 13, 9, "virtual address: 0x", 0
	raw_size 					db 		10, 13, 9, "raw size: 0x", 0
	raw_address 				db 		10, 13, 9, "raw address: 0x", 0
	reloc_address 				db 		10, 13, 9, "relocation address: 0x", 0
	linenumbers 				db 		10, 13, 9, "linenumbers: 0x", 0
	reloc_number 				db 		10, 13, 9, "relocations number: 0x", 0
	linenumbers_number 			db 		10, 13, 9, "linenumbers number: 0x", 0
	characteristics 			db 		10, 13, 9, "characteristics: 0x", 0
;Imports
	dll_name 					db 		10, 13, 10, 13, 9, "DLL name: ", 0
	functions_list 				db 		10, 13, 10, 13, 9, "Functions list: ", 10, 13, 0
	hint 						db 		10, 13, 9, 9, "Hint: 0x", 0
	function_name 				db 		9, "Name: ", 0
;Exports
	numberOfFunctions 			db 		10, 13, 9, "NumberOfFunctions: 0x", 0
	nName 						db 		9, "nName: ", 0
	nBase						db		10, 13, 9, "nBase: 0x", 0
	numberOfNames				db		10, 13, 9, "numberOfNames: 0x", 0
	exportedFunctions			db		10, 13, 9, "Function list:", 10, 13, 0
	RVA							db		10, 13, 9, "RVA: 0x", 0
	ordinal						db		9, "Ordinal: 0x", 0
	funcName					db		9, "Name: ", 0
 Format 						db 		"%x", 0

 ;input/output element
 stdHandleOut HANDLE ? 
 stdHandleIn HANDLE ?
 bytesWritten dd 0
 bytesRead dd 0

 ;file element
 fileHandle HANDLE ?
 fileName db inputSize dup(0)
 buffer db buffer_size dup(?)

 ;mapping element
 hMap HANDLE ?
 pMapping dd ?

 ;Handlers
	sections_count 				dd 		?
	sizeOfOptionalHeader 		dd 		?
;var
nBaseValue					dd		?
exportsRVA 					dd 		?
exportedNamesOffset			dd		?
exportedFunctionsOffset		dd		?
exportedOrdinalsOffset		dd		?
numberOfNamesValue				dd		?
sectionHeaderOffset 		dd 		?
importsRVA 					dd 		?
 .code

 main PROC
;getHandle 
 	invoke GetStdHandle,STD_INPUT_HANDLE  
	mov stdHandleIn,eax
	invoke GetStdHandle,STD_OUTPUT_HANDLE  
	mov stdHandleOut,eax
 ;get the link of file 

	invoke ReadConsole,
		stdHandleIn,
		ADDR fileName,
		inputSize,
		ADDR bytesWritten,
		0

;String nhap vao luon bao gom 0xd, 0xa(13,10) = carriage return. Mot meo nho de NULL ket thuc chuoi da nhap
mov eax, offset fileName
add eax, bytesWritten
sub eax,2
mov byte ptr [eax],0


;Load file
invoke CreateFile,
		addr fileName, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		mov fileHandle,eax


;kiem tra neu file handle hop le
cmp eax, INVALID_HANDLE_VALUE
	je quit
invoke CreateFileMapping, fileHandle, 0, PAGE_READONLY, 0, 0, 0
mov hMap,eax


;kiem tra xem map handle co hop le khong
cmp eax, INVALID_HANDLE_VALUE
je quit
invoke MapViewOfFile, hMap, FILE_MAP_READ, 0, 0, 0
mov pMapping,eax


; Kiem tra xem file co duoc mapped chinh xac trong bo nho hay khong 
cmp eax,0
je quit

;DOS_HEADER

;structure of IMAGE_DOS_HEADER (this is declared in windows.inc)
;IMAGE_DOS_HEADER STRUCT
;  e_magic           WORD      ?
;  e_cblp            WORD      ?
;  e_cp              WORD      ?
;  e_crlc            WORD      ?
;  e_cparhdr         WORD      ?
;  e_minalloc        WORD      ?
;  e_maxalloc        WORD      ?
;  e_ss              WORD      ?
;  e_sp              WORD      ?
;  e_csum            WORD      ?
;  e_ip              WORD      ?
;  e_cs              WORD      ?
;  e_lfarlc          WORD      ?
;  e_ovno            WORD      ?
;  e_res             WORD   4 dup(?)
;  e_oemid           WORD      ?
;  e_oeminfo         WORD      ?
;  e_res2            WORD  10 dup(?)
;  e_lfanew          DWORD      ?
;IMAGE_DOS_HEADER ENDS

;DOS HEADER EXTRACTION
mov edi,pMapping					;lay dia chi dau tien cua file PE
assume edi: ptr IMAGE_DOS_HEADER	;dat edi la struct INMAGE_DOS_HEADER trong windows.inc 

;PRINT OUT DOS HEADER INFORMATION
	push offset DOSHeader
	call print
	push offset e_magic_str
	call print
	movzx edx, [edi].e_magic        ;dat edx bang gia tri cua e_magic
	call print_f

	push offset e_lfanew_str
	call print
	mov edx, [edi].e_lfanew
	call print_f
;PE_HEADER

;structure of IMAGE_NT_HEADER(PE HEADER) (this is declared in windows.inc)
;IMAGE_NT_HEADERS STRUCT
;  Signature         DWORD                   ?
;  FileHeader        IMAGE_FILE_HEADER       <>
;  OptionalHeader    IMAGE_OPTIONAL_HEADER32 <>
;IMAGE_NT_HEADERS ENDS

;check if the file is a PE file
	add edi, edx							;edi la dau file PE, cong voi lfanew se ra dia chi cua PE Header
	assume edi: ptr IMAGE_NT_HEADERS		;dat edi la struct IMAGE_NT_HEADER trong windows.inc 
	cmp [edi].Signature, IMAGE_NT_SIGNATURE ;so sanh xem chu ki co giong chu ky cua PE Header khong(IMAGE_NT_SIGNATURE equ 00004550h ) dc khai bao trong windows.inc
	jne quit

;PRINT OUT PE HEADER INFORMATION
	push offset PEHeader
	call print
	push offset signature_str   
	call print
	mov edx, [edi].Signature				;signature la 0x4550 la "PE"
	call print_f

	add edi, SIZEOF_NT_SIGNATURE ;SIZEOF_NT_SIGNATURE =(DWORD) 4bytes
	assume edi: ptr IMAGE_FILE_HEADER		;dat edi la struct IMAGE_FILE_HEADER
	
	;structure of IMAGE_FILE_HEADER (this is declared in windows.inc)
	;IMAGE_FILE_HEADER STRUCT
  ;Machine               WORD    ?
  ;NumberOfSections      WORD    ?
  ;TimeDateStamp         DWORD   ?
  ;PointerToSymbolTable  DWORD   ?
  ;NumberOfSymbols       DWORD   ?
  ;SizeOfOptionalHeader  WORD    ?
  ;Characteristics       WORD    ?
  ;IMAGE_FILE_HEADER ENDS

	push offset FileHeader
	call print 

	push offset machine_str					
	call print
	movzx edx, [edi].Machine				;CPU type find in here(https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types)
	call print_f							;An image file can be run only on the specified machine or on a system that emulates the specified machine.

	push offset numberOfSections_str		;Number Of Section
	call print
	movzx edx, [edi].NumberOfSections
	push edx
	pop sections_count ;get offset number Of Sections to sections_count
	call print_f

	push offset timeDateStamp_str			;time when compile the program 
	call print								;convert hex to int then use Unix Time Stamp(https://www.unixtimestamp.com/) to see 
	mov edx, [edi].TimeDateStamp
	call print_f

	push offset sizeOfOptionalHeader_str	;Size Of Optional Header it had the size is the dynamic
	call print								;Size generally will be 224 bytes
	movzx edx, [edi].SizeOfOptionalHeader
	push edx
	pop sizeOfOptionalHeader
	call print_f

	push offset characteristics_str			;it is the File's characteristics
	call print								;https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#characteristics
	movzx edx, [edi].Characteristics		;the offset of Characteristics equal sum of all e.g: 0x102 = 0x100+0x2
	call print_f

	;structure of IMAGE_OPTIONAL_HEADER (this is declared in windows.inc)
;	IMAGE_OPTIONAL_HEADER32 STRUCT
;  Magic                         WORD       ?
;  MajorLinkerVersion            BYTE       ?
;  MinorLinkerVersion            BYTE       ?
;  SizeOfCode                    DWORD      ?
;  SizeOfInitializedData         DWORD      ?
;  SizeOfUninitializedData       DWORD      ?
;  AddressOfEntryPoint           DWORD      ?
;  BaseOfCode                    DWORD      ?
;  BaseOfData                    DWORD      ?
;  ImageBase                     DWORD      ?
;  SectionAlignment              DWORD      ?
;  FileAlignment                 DWORD      ?
;  MajorOperatingSystemVersion   WORD       ?
;  MinorOperatingSystemVersion   WORD       ?
;  MajorImageVersion             WORD       ?
;  MinorImageVersion             WORD       ?
;  MajorSubsystemVersion         WORD       ?
;  MinorSubsystemVersion         WORD       ?
;  Win32VersionValue             DWORD      ?
;  SizeOfImage                   DWORD      ?
;  SizeOfHeaders                 DWORD      ?
;  CheckSum                      DWORD      ?
;  Subsystem                     WORD       ?
;  DllCharacteristics            WORD       ?
;  SizeOfStackReserve            DWORD      ?
;  SizeOfStackCommit             DWORD      ?
;  SizeOfHeapReserve             DWORD      ?
;  SizeOfHeapCommit              DWORD      ?
;  LoaderFlags                   DWORD      ?
;  NumberOfRvaAndSizes           DWORD      ?
;  DataDirectory                 IMAGE_DATA_DIRECTORY IMAGE_NUMBEROF_DIRECTORY_ENTRIES dup(<>)
;IMAGE_OPTIONAL_HEADER32 ENDS
	add edi, SIZEOF_IMAGE_FILE_HEADER ;(14h)
	assume edi: ptr IMAGE_OPTIONAL_HEADER
	
	push offset OptHeader
	call print

	push offset magic_str		;this file is 32-bit or 64-bit 
	call print					;0x10b is(PE32) 32-bit and 0x20b is(PE32+) 64-bit
	movzx edx, [edi].Magic		;https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#optional-header-image-only
	call print_f

	push offset addressOfEntryPoint_str  ;It is the address of the first instruction 
	call print
	mov edx, [edi].AddressOfEntryPoint
	call print_f

	push offset imageBase_str			;eg ImageBase = 0x140000000 and Import Directory RVA(Relative virtual address ) is 0x0001F300 ==> VA(virtual address) is 0x14001F300
	call print
	mov edx, [edi].ImageBase
	call print_f

	push offset sectionAlignment_str   ;eg: SectionAlignment = 0x1000 means each section only should start at multiples of this 0x1000 
	call print						;section argument is in the memory
	mov edx, [edi].SectionAlignment
	call print_f

	push offset fileAlignment_str	;file element is when the file is on the raw disk
	call print
	mov edx, [edi].FileAlignment
	call print_f

	push offset majorSubsystemVersion_str
	call print
	movzx edx, [edi].MajorSubsystemVersion
	call print_f

	push offset sizeOfImage_str  ;total size of the Image in memory not on disk
	call print
	mov edx, [edi].SizeOfImage
	call print_f

	push offset sizeOfHeaders_str	;total size of all header(dos header,dos stub,file header,...) combined except the actual data 
	call print
	mov edx, [edi].SizeOfHeaders
	call print_f

	push offset subsystem_str		;The subsystem that is required to run this image. For more information, see https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#windows-subsystem
	call print
	movzx edx, [edi].Subsystem
	call print_f

	push offset numberOfRvaAndSizes_str  ;The number of data-directory entries in the remainder of the optional header. Each describes a location and size.
	call print
	mov edx, [edi].NumberOfRvaAndSizes
	call print_f

	;DATA_DIRECTORY
	;struct of DATA_DIRECTORY (this is declared in windows.inc)
;IMAGE_DIRECTORY_ENTRY_EXPORT                equ  0 // Export Directory
;IMAGE_DIRECTORY_ENTRY_IMPORT                equ  1 // Import Directory
;IMAGE_DIRECTORY_ENTRY_RESOURCE              equ  2 // Resource Directory
;IMAGE_DIRECTORY_ENTRY_EXCEPTION             equ  3 // Exception Directory
;IMAGE_DIRECTORY_ENTRY_SECURITY              equ  4 // Security Directory
;IMAGE_DIRECTORY_ENTRY_BASERELOC             equ  5 // Base Relocation Table
;IMAGE_DIRECTORY_ENTRY_DEBUG				 equ  6 // Debug Directory
;IMAGE_DIRECTORY_ENTRY_COPYRIGHT             equ  7 // (X86 usage)
;IMAGE_DIRECTORY_ENTRY_GLOBALPTR             equ  8 // RVA of GP
;IMAGE_DIRECTORY_ENTRY_TLS                   equ  9 // TLS Directory
;IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG           equ 10 // Load Configuration Directory
;IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT          equ 11 // Bound Import Directory in headers
;IMAGE_DIRECTORY_ENTRY_IAT                   equ 12 // Import Address Table
;IMAGE_NUMBEROF_DIRECTORY_ENTRIES            equ 16
	
;in the case where the size of OH(Optional Header) is 0, it won't work well.In that case we must trust the value in NumberOfRvaAndSizes, as long as it is less than 0x10( max is 16d)
	;check
	mov edx, sizeOfOptionalHeader
	sub edx, IMAGE_OPTIONAL_HEADER.NumberOfRvaAndSizes + 4 
	cmp edx, 0
	je sections_start

	;IMAGE_DATA_DIRECTORY

	add edi,60h ;address of the Image Data Directory Start

	push offset DataDir		; Export Directory
	call print
	push offset ex_dir_rva
	call print

	mov edx, dword ptr [edi]	;Import Directory
	mov exportsRVA, edx
	call print_f
	push offset ex_dir_size
	call print
	mov edx, dword ptr [edi + 4h]
	call print_f

	push offset imp_dir_rva
	call print
	mov edx, dword ptr [edi + 8h]
	mov importsRVA, edx
	call print_f
	push offset imp_dir_size
	call print
	mov edx, dword ptr [edi + 0Ch]
	call print_f


;struct of SECTION_HEADER(it is declared in windows.inc) ;https://0xrick.github.io/win-internals/pe5/#sections
;IMAGE_SECTION_HEADER STRUCT
;    Name1 db IMAGE_SIZEOF_SHORT_NAME dup(?)
;    union Misc
;        PhysicalAddress dd  ?  ;A union defines multiple names for the same thing, 
;        VirtualSize dd      ?	;this field contains the total size of the section when it’s loaded in memory.
;    ends
;    VirtualAddress dd       ?
;    SizeOfRawData dd        ?
;    PointerToRawData dd     ?
;    PointerToRelocations dd ?
;    PointerToLinenumbers dd ?
;    NumberOfRelocations dw  ?
;    NumberOfLinenumbers dw  ?
;    Characteristics dd      ?
;IMAGE_SECTION_HEADER ENDS

;SECTIONS
	sub edi, 60h  ;set edi = address of OPTIONAL_HEADER
	sections_start:
		add edi, sizeof IMAGE_OPTIONAL_HEADER ;add edi with size of OPTIONAL_HEADER to get address of SECTION_HEADER
		assume edi: ptr IMAGE_SECTION_HEADER	
		mov sectionHeaderOffset, edi  
		push offset Sections
		call print
		mov ebx, sections_count  
		cmp ebx, 0
		jne sections
		push offset sectionless ;file PE dont have section
		call print
		
		sections:
			cmp ebx, 0
			je imports
			sub ebx, 1

			push offset sec_name	;name of section
			call print
			push edi
			call print


			push offset virt_size	;size of this section in memory
			call print
			mov edx, dword ptr [edi + 8h]
			call print_f

			push offset virt_address	;eg base address(Image Base)=400000, virtual address = 1000 ==> section start at 401000
			call print					
			mov edx, [edi].VirtualAddress
			call print_f

			push offset raw_size		;size of this section on disk
			call print					;e.g: File Alignment is 200h, virtual size = 50h so remaining 150h are filled with zeros
			mov edx, [edi].SizeOfRawData
			call print_f

			push offset raw_address		;on the disk at which byte offset this section starts 
			call print					
			mov edx, [edi].PointerToRawData
			call print_f

			push offset reloc_address
			call print
			mov edx, [edi].PointerToRelocations
			call print_f
			push offset linenumbers
			call print
			mov edx, [edi].PointerToLinenumbers
			call print_f
			push offset reloc_number
			call print
			movzx edx, [edi].NumberOfRelocations
			call print_f
			push offset linenumbers_number
			call print
			movzx edx, [edi].NumberOfLinenumbers
			call print_f

			push offset characteristics			;calculate the sum in https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#section-flags
			call print							;to see characteristics
			mov edx, [edi].Characteristics
			call print_f
			add edi, 28h
			jmp sections

;struct of IMPORT_DIRECTORY (this is declared in windows.inc)
;IMAGE_IMPORT_DESCRIPTOR STRUCT
;    union
;        Characteristics dd      ?
;        OriginalFirstThunk dd   ?
;	 ends
;    TimeDateStamp dd    ?
;    ForwarderChain dd   ?
;    Name1 dd            ?
;    FirstThunk dd       ?
;IMAGE_IMPORT_DESCRIPTOR ENDS

imports:
		push offset Imports
		call print
		mov edi, importsRVA		;get RVA address import
		call RVAtoOffset		;get RAW address import(on disk) to get information
		mov edi, eax
		add edi, pMapping		;Add to Image Base( Base Address)
		assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
		next_import_DLL:
			cmp [edi].OriginalFirstThunk, 0
			jne extract_import
			cmp [edi].TimeDateStamp, 0
			jne extract_import
			cmp [edi].ForwarderChain, 0
			jne extract_import
			cmp [edi].Name1, 0
			jne extract_import
			cmp [edi].FirstThunk, 0
			jne extract_import
			jmp exports ;no more imports to extract, go to exports
			
			extract_import:
				push edi
				mov edi, [edi].Name1
				call RVAtoOffset	;get Raw address of Name1
				pop edi
				mov edx, eax
				add edx, pMapping
				push offset dll_name	;DLL Name
				call print
				push edx
				call print

				cmp [edi].OriginalFirstThunk, 0
				jne useOriginalFirstThunk
				mov esi, [edi].FirstThunk
				jmp useFirstThunk
				useOriginalFirstThunk:
					mov esi, [edi].OriginalFirstThunk
				useFirstThunk:
				push edi
				mov edi, esi
				call RVAtoOffset ;get Raw address of OriginalFirstThunk 
				pop edi
				add eax, pMapping
				mov esi, eax
				push offset functions_list	;functions list
				call print
				extract_functions:
					cmp dword ptr [esi], 0
					je next_DLL
					test dword ptr [esi], IMAGE_ORDINAL_FLAG32
					jnz useOrdinal
					push edi
					mov edi, dword ptr [esi]
					call RVAtoOffset
					pop edi
					mov edx, eax
					add edx, pMapping
					assume edx:ptr IMAGE_IMPORT_BY_NAME
					mov cx, [edx].Hint ;point to the Hint
					movzx ecx, cx
					push offset hint
					call print
					push edx
					mov edx, ecx
					call print_f
					pop edx
					push offset function_name
					call print
					lea edx, [edx].Name1 ;point to the function Name
					push edx
					call print
					jmp next_import
					useOrdinal:
						mov edx, dword ptr [esi]
						and edx, 0FFFFh
						call print_f
						push offset endl
						call print
					next_import:
						add esi, 4
						jmp extract_functions
					next_DLL:
						add edi, sizeof IMAGE_IMPORT_DESCRIPTOR
						jmp next_import_DLL
	;struct of EXPORT_DIRECTORY (this is declared in windows.inc)
;IMAGE_EXPORT_DIRECTORY STRUCT
;  Characteristics           DWORD      ?
;  TimeDateStamp             DWORD      ?
;  MajorVersion              WORD       ?
;  MinorVersion              WORD       ?
;  nName                     DWORD      ?
;  nBase                     DWORD      ?
;  NumberOfFunctions         DWORD      ?
;  NumberOfNames             DWORD      ?
;  AddressOfFunctions        DWORD      ?
;  AddressOfNames            DWORD      ?
;  AddressOfNameOrdinals     DWORD      ?
;IMAGE_EXPORT_DIRECTORY ENDS
;Exports
	exports:
		push offset Exports
		call print
		
		cmp exportsRVA, 0
		jne extract_exports
		push offset no_exports
		call print
		jmp quit
		
		extract_exports:
			mov edi, exportsRVA
			call RVAtoOffset
			mov edi, eax
			add edi, pMapping
			assume edi:ptr IMAGE_EXPORT_DIRECTORY
			;nName
			push edi
			mov edi, [edi].nName
			call RVAtoOffset
			add eax, pMapping
			pop edi
			push offset nName
			call print
			push eax
			call print
			;nBase
			push offset nBase
			call print
			mov edx, [edi].nBase
			mov nBaseValue, edx
			call print_f
			;numberOfFunctions
			push offset numberOfFunctions
			call print
			mov edx, [edi].NumberOfFunctions
			call print_f
			;NumberOfNames
			push offset numberOfNames
			call print
			mov edx, [edi].NumberOfNames
			mov numberOfNamesValue, edx
			call print_f
			;exported functions
			push offset exportedFunctions
			call print
			;check for ordinal exports
			mov edx, [edi].NumberOfFunctions
			cmp edx, [edi].NumberOfNames
			;je noOrdinalExports
			;ordinal exports
			push edi
			mov edi, [edi].AddressOfNameOrdinals
			call RVAtoOffset
			add eax, pMapping
			mov exportedOrdinalsOffset, eax
			pop edi
			noOrdinalExports:
				;AddressOfFunctions
				push edi
				mov edi, [edi].AddressOfFunctions
				call RVAtoOffset
				add eax, pMapping
				mov exportedFunctionsOffset, eax
				pop edi
				;AddressOfNames
				push edi
				mov edi, [edi].AddressOfNames
				call RVAtoOffset
				add eax, pMapping
				mov exportedNamesOffset, eax
				pop edi
				next_export:
					cmp numberOfNamesValue, 0
					jle quit
					mov eax, exportedOrdinalsOffset
					mov dx, [eax]
					movzx edx, dx 
					mov ecx, edx
					shl edx, 2
					add edx, exportedFunctionsOffset
					add ecx, nBaseValue
					;RVA
					push offset RVA
					call print
					mov edx, dword ptr [edx]
					call print_f
					;Ordinal
					push offset ordinal
					call print
					mov edx, ecx
					call print_f
					;name
					push offset funcName
					call print
					mov edx, dword ptr exportedNamesOffset
					mov edi, dword ptr [edx]
					call RVAtoOffset
					add eax, pMapping
					push eax
					call print
					;increment indexes
					dec numberOfNamesValue
					add exportedNamesOffset, 4 ;point to the next name in the array
					add exportedOrdinalsOffset, 2
					jmp next_export


print proc 
		pushad ;(lenh pushad roi popad de giu nguyen gia tri cho cac thanh ghi) push theo thu tu EAX(+28), ECX(+24), EDX(+20), EBX(+16), ESP(+12) (original value), EBP(+8), ESI(+4), and EDI(+0) ==> Offset_e_magic_str(+36) dia_chi_lenh_tiep_theo(+32)
		mov ebx, dword ptr [esp + 36]   ;mov gia tri offset_e_magic_str vao ebx
		invoke lstrlen, ebx				;kiem tra chieu dai str tra ve eax
		invoke WriteConsole, stdHandleOut, ebx, eax, addr bytesWritten, 0
		popad
		ret 4							;return and pop 4 bytes from stack( pop offset_e_magic_str)
print endp


print_f proc	
		pushad					;(lenh pushad roi popad de giu nguyen gia tri cho cac thanh ghi)
		push edx				;push gia tri hex can in
		push offset Format		;Format hex
		call printf				
		add esp, 8				;xoa Format va edx khoi stack
		popad
		ret
	print_f endp	
;Offset of entry point in EXE file = (AddressOfEntryPoint – .section[VirtualAddress]) + .section[PointerToRawData]
RVAtoOffset proc
		mov edx, sectionHeaderOffset  ;get address of sectionHeader
		assume edx:ptr IMAGE_SECTION_HEADER
		mov ecx, sections_count		  ;get number of sections
		sections_cicle:
			cmp ecx, 0
			jle end_routine
				cmp edi, [edx].VirtualAddress	;cmp importsRVA vs RVA of current Section					;find the location of import in where section ?
				jl next_section					;if less jump to next_section
					mov eax, [edx].VirtualAddress
					add eax, [edx].SizeOfRawData ;Virtual Address + SizeOfRawData = address of next section
					cmp edi, eax				;cmp importsRVA vs next sections address
					jge next_section			;if greater or equal ==> jump
						mov eax, [edx].VirtualAddress
						sub edi, eax			;imports RVA - RVA of current section = Size of data begin at start current section to the import
						mov eax, [edx].PointerToRawData	;add this size with Raw address of this section to get Raw address of import
						add eax, edi
						ret
			next_section:
				add edx, sizeof IMAGE_SECTION_HEADER   ;get address of nextsection
				dec ecx
		jmp sections_cicle
		end_routine:
			mov eax, edi
			ret
	RVAtoOffset endp
quit:
invoke CloseHandle, fileHandle
invoke CloseHandle, hMap
invoke ExitProcess,0
 main endp
 end main