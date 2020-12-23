.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc   ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32, user32;
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD 

.data? 
hInstance HINSTANCE ? 
CommandLine LPSTR ? 
Value dd ? 
.data 
ClassName db "MASM Builder",0 
Caption db "Исследование функции AnimateWindow",0 
.code 
start: 
invoke GetModuleHandle, NULL ; отримання дескриптора програми
mov    hInstance,eax         ; збереження дескриптора програми
invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT 
invoke ExitProcess,eax 

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
LOCAL wc :WNDCLASSEX 
LOCAL msg :MSG 
LOCAL hWnd :HWND 
mov wc.cbSize,SIZEOF WNDCLASSEX 
mov wc.style,CS_BYTEALIGNCLIENT 
mov wc.lpfnWndProc,offset WndProc 
mov wc.cbClsExtra,NULL 
mov wc.cbWndExtra,NULL 
push hInst 
pop wc.hInstance 
mov wc.hbrBackground,COLOR_BTNFACE+1 
mov wc.lpszClassName,OFFSET ClassName 
invoke LoadIcon,NULL,IDI_APPLICATION 
mov wc.hIcon,eax 
mov wc.hIconSm,eax 
invoke LoadCursor,NULL,IDC_ARROW 
mov wc.hCursor,eax 
invoke RegisterClassEx,addr wc 
invoke CreateWindowEx,0,ADDR ClassName,ADDR Caption,WS_OVERLAPPEDWINDOW,600,400,300,200,0,0,hInst,0 
mov hWnd,eax 
INVOKE ShowWindow,hWnd,SW_SHOWNORMAL 
INVOKE UpdateWindow,hWnd 
.WHILE TRUE 
invoke GetMessage,ADDR msg,0,0,0 
.BREAK .IF (!eax) 
invoke TranslateMessage,ADDR msg 
invoke DispatchMessage,ADDR msg 
.ENDW 
mov eax,msg.wParam 
ret 
WinMain endp 

WndProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM 
.IF uMsg == WM_DESTROY 
invoke PostQuitMessage,NULL 
.ELSEIF uMsg == WM_CREATE 
invoke AnimateWindow,hWnd,1000,AW_BLEND+AW_ACTIVATE 
invoke GetWindowLongA,hWnd,GWL_EXSTYLE;  or WS_EX_LAYERED
or eax,WS_EX_LAYERED 
invoke SetWindowLongA,hWnd,GWL_EXSTYLE,eax 
mov Value,150 ; это значение прозрачности окна: 0 - полностью прозрачно и 255 - непрозрачно 
invoke SetLayeredWindowAttributes,hWnd,Value,Value,LMA_COLORKEY + LMA_ALPHA 
.ELSE 
invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
ret 
.ENDIF 
xor eax,eax 
ret 
WndProc endp 
end start
