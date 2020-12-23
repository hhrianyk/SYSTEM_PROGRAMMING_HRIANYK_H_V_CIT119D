.686 	           ; ��������� ���������� ���� �������������
.model flat,stdcall ; �������� ����� ����� ����� �� ����� �� Windows
option casemap:none          ; �������� ����� �� ������� ����
include \masm32\include\windows.inc   ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib kernel32, user32;
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD 
@m macro a0,a1,a2,a3 ;; ������ ��������� ������ ����� ������
 a0
  a1
   a2
    a3
	endm
.data? 
hInstance HINSTANCE ? 
CommandLine LPSTR ? 
Value dd ? 
.data 
ClassName db "MASM Builder",0 
Caption db "������������ ������� AnimateWindow",0 
.code 
start: 
invoke GetModuleHandle, NULL ; ��������� ����������� ��������
mov    hInstance,eax         ; ���������� ����������� ��������
invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT 
invoke ExitProcess,eax 

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
LOCAL wc :WNDCLASSEX 
LOCAL msg :MSG 
LOCAL hWnd :HWND
@m<mov wc.cbSize,SIZEOF WNDCLASSEX>,<mov wc.style,CS_HREDRAW or CS_VREDRAW>,<mov wc.lpfnWndProc,offset WndProc> 
@m<mov wc.cbClsExtra,0>,<mov wc.cbWndExtra,0>,<push hInst>,<pop wc.hInstance>
@m<mov wc.hbrBackground, COLOR_BTNFACE+1>,<mov wc.lpszClassName,OFFSET ClassName>,<invoke LoadIcon,0,IDI_APPLICATION>
@m<mov wc.hIcon,eax>,<mov wc.hIconSm,eax>,<invoke LoadCursor,0,IDC_ARROW>,<mov wc.hCursor,eax >
invoke RegisterClassEx,addr wc  ;  ���������� ����� ����
invoke CreateWindowEx,0,ADDR ClassName,ADDR Caption,WS_OVERLAPPEDWINDOW,350,80,400,200,0,0,hInst,0 
mov hWnd,eax 
INVOKE ShowWindow,hWnd,SW_SHOWNORMAL 
INVOKE UpdateWindow,hWnd 
.WHILE TRUE 
invoke GetMessage,ADDR msg,0,0,0 ; ������� �����������
.BREAK .IF (!eax) 
invoke TranslateMessage,ADDR msg 
invoke DispatchMessage,ADDR msg  ; �������� �� ��������������
.ENDW 
mov eax,msg.wParam 
ret              ; ���������� � ���������
WinMain endp     ; ��������� ��������� � ���� WinMain

WndProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM 
.IF uMsg == WM_DESTROY 
invoke PostQuitMessage,NULL 
.ELSEIF uMsg == WM_CREATE ; 
invoke AnimateWindow,hWnd,1000,AW_BLEND+AW_ACTIVATE 
invoke GetWindowLongA,hWnd,GWL_EXSTYLE; or WS_EX_LAYERED
or eax,WS_EX_LAYERED 
invoke SetWindowLongA,hWnd,GWL_EXSTYLE,eax 
mov Value,150 ; ��� �������� ������������ ����: 0 - ��������� ��������� � 255 - ����������� 
invoke SetLayeredWindowAttributes,\ ; ���������� ��������������� � ���������
  hWnd,Value,Value,LMA_COLORKEY + LMA_ALPHA 
@m<.ELSE>,<invoke DefWindowProc,hWnd,uMsg,wParam,lParam>,<ret>,<.ENDIF>
@m<xor eax,eax>,<ret>,<WndProc endp>,<end start>