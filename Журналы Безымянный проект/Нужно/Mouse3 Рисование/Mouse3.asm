.686   ; ��������� ����������� ���� ���������������
.model flat,stdcall ; ������� �������� ������ ������ � ���������� OC Windows
option casemap:none ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
 uselib user32,kernel32,gdi32
IDM_EXIT 	equ 1
IDM_ABOUT 	equ 2
IDM_CLEAN 	equ 3
IDM_BLACK 	equ 4
IDM_RED 	equ 5
IDM_BLUE	equ 6
IDM_GREEN	equ 7
IDI_ICON	equ 8
.data 	
ClassName 	db "SimpleWinClass",0
AppName  	db " ��������� ������",0
MenuName 	db "FirstMenu",0
About_string db "��������� ��� ��������� ������", 0
wc  WNDCLASSEX <>
msg	MSG <>
hwnd HWND ?
hInstance HINSTANCE ?
x dd ? 
y dd ?
bTracking BOOL FALSE ;����� ��������� ���� �� ���� ��������: true � false
hdc	 	HDC ?
color 	RGBQUAD<255,255,255>
hPen 	dd 0
col_black 	RGBQUAD<0,0,0>
col_red 	RGBQUAD<255,0,0>
col_green 	RGBQUAD<0,255,0>
col_blue 	RGBQUAD<0,0,255>
.code ; 
start: 
invoke  GetModuleHandle,0 ; 
mov     hInstance,eax
mov     wc.cbSize,SIZEOF WNDCLASSEX
mov     wc.style, CS_HREDRAW or CS_VREDRAW
mov     wc.lpfnWndProc, OFFSET WndProc
mov     wc.cbClsExtra,NULL
mov     wc.cbWndExtra,NULL
push    hInstance
pop     wc.hInstance
invoke  LoadIcon, hInstance,IDI_ICON ; ������ 
mov      wc.hIcon, eax	
mov     wc.hIconSm,0
mov     wc.hbrBackground,COLOR_WINDOW+1
invoke  GetStockObject, WHITE_BRUSH   
mov     wc.lpszMenuName,OFFSET MenuName
mov     wc.lpszClassName,OFFSET ClassName
invoke  LoadCursor,NULL,IDC_ARROW        ; ������ �������
mov     wc.hCursor,eax
invoke  RegisterClassEx,addr wc   ; 
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW, \ 
  CW_USEDEFAULT,CW_USEDEFAULT,600,400,;  ���������� ����
     0,0, hInstance,0 ; ����������� ������������� ���� � ���� � ���������� ���������
	mov     hwnd,eax
invoke ShowWindow,hwnd,SW_SHOWNORMAL ; ��������� ����
.WHILE TRUE
    invoke  GetMessage,ADDR msg,0,0,0 ; ������ ���������
    or eax, eax
    jz Quit
    invoke DispatchMessage,ADDR msg ; �������� ���������
.ENDW
Quit:
mov     eax,msg.wParam
invoke  ExitProcess, eax

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM,\ 
   lParam:LPARAM
LOCAL ps:PAINTSTRUCT
LOCAL rect:RECT
.IF uMsg==WM_CREATE
	invoke GetDC,hWnd ; �������� ���������� ��������� ����������
	mov hdc, eax
invoke CreatePen,PS_SOLID,1,dword ptr col_black ; �������� ���� 
; ������� ����� (�� ���������) 
mov hPen, eax
.ELSEIF uMsg==WM_LBUTTONDOWN; ������ ������� ����� ������ ����
  mov bTracking,TRUE  ; ������������ �������� � TRUE
  push word ptr lParam ; ������������ � � � ��� ������� ������
	pop word ptr x
	push word ptr lParam+2
	pop word ptr y
invoke MoveToEx,hdc,x,y,0 ; ����������� �������� ��������� � ����� x,y
.ELSEIF uMsg==WM_LBUTTONUP ; ��� ������ ����� ������ ����
	mov bTracking, FALSE   ; ������������ �������� � FALSE
.ELSEIF uMsg==WM_MOUSEMOVE ;��������� ��� ����������� ������� 
; ��� ��������� ������� ����� �� �������� ��������� ������� 
.IF bTracking
	push word ptr lParam
	pop word ptr x
	push word ptr lParam+2
	pop word ptr y
invoke SelectObject,hdc,hPen
invoke LineTo,hdc,x,y ; ��������� �����
.ENDIF
.ELSEIF uMsg==WM_COMMAND
    mov eax,wParam
   	.IF ax==IDM_ABOUT
invoke  MessageBox,0,ADDR About_string,OFFSET AppName,MB_OK 
	.ELSEIF ax==IDM_CLEAN  ; ��������
invoke  GetClientRect,hWnd,ADDR rect ; ����������� ��������� ����
	invoke FillRect,hdc,ADDR rect, 0; ���������� ����
	.ELSEIF ax==IDM_BLACK
invoke CreatePen,PS_SOLID,1,dword ptr col_black ; �������� ������� ����
	mov hPen, eax
	.ELSEIF ax==IDM_RED
invoke CreatePen,PS_SOLID,1,dword ptr col_red ; �������� �������� ����		
	mov hPen, eax
	.ELSEIF ax==IDM_BLUE
invoke CreatePen,PS_SOLID,1,dword ptr col_blue ; �������� ������ ����
	mov hPen, eax
	.ELSEIF ax==IDM_GREEN
invoke CreatePen,PS_SOLID,1,dword ptr col_green ; �������� �������� ����
	mov hPen,eax
   	.ELSE
       	invoke DestroyWindow,hWnd
   	.ENDIF
.ELSEIF uMsg==WM_DESTROY      ; ����������� ���� 
	invoke ReleaseDC,hWnd,hdc
	invoke PostQuitMessage,0
.ELSE WM_MOUSEMOVE
   	invoke DefWindowProc,hWnd,uMsg,wParam,lParam
	ret
.ENDIF
xor    eax,eax
ret
WndProc endp 
end start   

