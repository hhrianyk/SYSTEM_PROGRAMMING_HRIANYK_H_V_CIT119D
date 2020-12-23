.686        ; директива визначення типу мікропроцесора
.model flat,stdcall    ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32
@ MACRO a0,a1,a2
a0
 a1
  a2
  ENDM
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
.const
IDM_CREATE_PROCESS equ 1 ; кнопка "Create Process"
IDM_TERMINATE equ 2 ;кнопка "Terminate Process"
IDM_EXIT equ 3 ;кнопка "Exit"
.data
ClassName db "Win32ASMProcessClass",0
AppName  db "Win32 ASM Process Example",0
MenuName db "FirstMenu",0
processInfo PROCESS_INFORMATION <> ; інформація про процес і його первинну нитку
programname db "1-1.exe",0
.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?
hMenu HANDLE ?
ExitCode DWORD ?

.code
start:
	 invoke GetModuleHandle, NULL ; отримання дескриптора програми
    mov   hInstance,eax         ; збереження дескриптора програми
	invoke GetCommandLine
	mov CommandLine,eax
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess,eax ;повернення керування ОС та вивільнення ресурсів

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX ; резервування стека  під структуру
    LOCAL   msg:MSG             ; резервування стека під структуру MSG 
    LOCAL   hwnd:HWND        ;  резервування стека під хендл програми
@<push hInst>,<pop wc.hInstance>,<mov wc.cbSize,SIZEOF WNDCLASSEX>
@<mov wc.style,CS_HREDRAW or CS_VREDRAW>,<mov wc.lpszClassName,OFFSET ClassName>
@<mov wc.lpfnWndProc,OFFSET WndProc>,<mov wc.hbrBackground,COLOR_WINDOW+1>
@<mov wc.cbWndExtra,0>,<mov wc.lpszMenuName,OFFSET MenuName>,<mov wc.cbClsExtra,0>
	invoke LoadIcon,NULL,IDI_APPLICATION
@<mov wc.hIcon,eax>,<mov wc.hIconSm,eax>
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc   ; функція реєстрації класу вікна
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR AppName,\
       WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT,300,200,0,0,hInst,0
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL  ; видимість вікна
	invoke UpdateWindow, hwnd   ; оновлення клієнтської області вікна
	invoke GetMenu,hwnd
	mov  hMenu,eax
	.WHILE TRUE
            invoke GetMessage, ADDR msg,NULL,0,0
            .BREAK .IF (!eax)
            invoke TranslateMessage, ADDR msg
            invoke DispatchMessage, ADDR msg ; відсилання повідомлення процедурі вікна
	.ENDW
	mov     eax,msg.wParam
	ret
WinMain endp
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	LOCAL startInfo:STARTUPINFO  ; резервування стека 
	.IF uMsg==WM_DESTROY    ; якщо є повідомлення про знищення вікна
		invoke PostQuitMessage,NULL  ; передача повідомлення про знищення
	.ELSEIF uMsg==WM_INITMENUPOPUP ; якшо обрано повідомлення від спливаючого меню
invoke GetExitCodeProcess,processInfo.hProcess,ADDR ExitCode ; відновлює статус закінчення вказаного процесу
		.if eax==TRUE
			.if ExitCode==STILL_ACTIVE ; якщо активний
			invoke EnableMenuItem,hMenu,\ ;вибір пункта меню
			 IDM_CREATE_PROCESS,\; пункт меню, який обрано
			  MF_GRAYED ; блоковано
				invoke EnableMenuItem,hMenu,IDM_TERMINATE,\
				   MF_ENABLED ; пункт меню включено
			.else
				invoke EnableMenuItem,hMenu,IDM_CREATE_PROCESS,MF_ENABLED
				invoke EnableMenuItem,hMenu,IDM_TERMINATE,MF_GRAYED
			.endif
		.else
			invoke EnableMenuItem,hMenu,IDM_CREATE_PROCESS,MF_ENABLED
			invoke EnableMenuItem,hMenu,IDM_TERMINATE,\
			MF_GRAYED ; пункт меню заблокирован
		.endif
	.ELSEIF uMsg==WM_COMMAND
		mov eax,wParam
		.if lParam==0
			.if ax==IDM_CREATE_PROCESS
				.if processInfo.hProcess!=0
					invoke CloseHandle,processInfo.hProcess ; закриття хендлу процесу
					mov processInfo.hProcess,0
				.endif
				invoke GetStartupInfo,ADDR startInfo ; Відновлює структуру STARTUPINFO
				invoke CreateProcess,ADDR programname,0,0,0,FALSE,\
                                        NORMAL_PRIORITY_CLASS,\
                                        NULL,NULL,ADDR startInfo,ADDR processInfo
				invoke CloseHandle,processInfo.hThread ; закриття хендлу потоку
			.elseif ax==IDM_TERMINATE
invoke GetExitCodeProcess,processInfo.hProcess,ADDR ExitCode ;відновлює статус закінчення вказаного процесу
				.if ExitCode==STILL_ACTIVE
					invoke TerminateProcess,processInfo.hProcess,0 ; закінчує процес і його нитки
				.endif
				invoke CloseHandle,processInfo.hProcess
				mov processInfo.hProcess,0
			.else
				invoke DestroyWindow,hWnd
			.endif
		.endif
	.ELSE
	invoke DefWindowProc,hWnd,uMsg,wParam,lParam ;обробка та до WndProc
      ret                       ; повернення з процедури
    .ENDIF                      ; закінчення логічної структури
xor   eax,eax
ret  			        ; повернення з процедури
WndProc endp 		        ; закінчення процедури WndProc
end start 			; закінчення програми з ім’ям start

