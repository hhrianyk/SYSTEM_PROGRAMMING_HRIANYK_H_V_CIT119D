; ��������� ������ ��������� ���� �� �������� ����� 
; �� �������� ������ ������ ������ � ���������� ������� ����.
; �������� ������ ��������� ����������� �� ������� ������� F1
.686 	            ; ��������� ����������� ���� ���������������
.model flat,stdcall ;������� �������� ������ ������ � ���������� �� Windows
option casemap:none ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32
@ MACRO a0,a1,a2,a3
a0
 a1
  a2
   a3
ENDM
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
.data
AppName db "��� ����������",0
NewName db "����� ��������!!!",0
hInstance  HINSTANCE ?
CommandLine LPSTR ?
.code
start:
  invoke GetModuleHandle, NULL
  mov    hInstance,eax
  invoke GetCommandLine
  mov    CommandLine,eax
  invoke WinMain, hInstance,NULL,CommandLine,SW_SHOWDEFAULT
invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE, 
CmdLine:LPSTR,CmdShow:DWORD
  LOCAL wc:WNDCLASSEX
  LOCAL msg:MSG
  LOCAL hwnd:HWND
  LOCAL X:DWORD 
  LOCAL Y:DWORD
  @<mov X,500>,<mov Y,350>,<mov wc.cbSize,SIZEOF WNDCLASSEX> 
  mov wc.style, CS_HREDRAW or CS_VREDRAW OR CS_DBLCLKS ; ������� ������
@<mov wc.lpfnWndProc, OFFSET WndProc>,<mov wc.cbClsExtra,0>,<mov wc.cbWndExtra,0>
@<push hInstance>,<pop wc.hInstance>,<mov wc.hbrBackground,COLOR_BTNFACE+1>
@<mov wc.lpszMenuName,0>,<mov wc.lpszClassName,OFFSET AppName>
  invoke LoadIcon,NULL,IDI_APPLICATION
 @<mov wc.hIcon,eax>,<mov wc.hIconSm,eax>  
  invoke LoadCursor,NULL,IDC_ARROW
  mov   wc.hCursor,eax
 invoke RegisterClassEx, addr wc
 INVOKE CreateWindowEx,NULL,ADDR AppName,
ADDR AppName, WS_OVERLAPPEDWINDOW,200, 200,
X,Y,NULL, NULL,hInst,NULL
  mov   hwnd,eax
  invoke ShowWindow, hwnd,SW_SHOWNORMAL
  invoke UpdateWindow, hwnd
  .WHILE TRUE
  begin:  invoke GetMessage, ADDR msg,NULL,0,0
    .BREAK .IF (!eax)
    invoke TranslateMessage, ADDR msg
    invoke DispatchMessage, ADDR msg
  .ENDW
  mov eax,msg.wParam
  ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM,lParam:LPARAM  
  .IF uMsg==WM_DESTROY
    invoke PostQuitMessage,NULL
  .ELSEIF uMsg==WM_RBUTTONDBLCLK ; ������� ������� �� ����. ��.
     invoke SetWindowText,hWnd,ADDR NewName ; �������� ����� ��������� ����
  .ELSEIF uMsg==WM_KEYDOWN
.IF wParam == VK_F1
      invoke SetWindowText,hWnd,ADDR AppName ; ��������������� �����
    .endif
    .ELSE
      invoke DefWindowProc,hWnd,uMsg,wParam,lParam   
      ret
    .ENDIF
  xor eax,eax
  ret
WndProc endp
end start