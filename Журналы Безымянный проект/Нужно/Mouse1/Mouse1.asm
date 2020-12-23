.686 	            ; ��������� ����������� ���� ���������������
.model flat,stdcall ;������� �������� ������ ������ � ���������� �� Windows
option casemap:none ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32
   WinMain proto :DWORD,:DWORD
.data 
wcex label WNDCLASSEX
    cbSize dd sizeof WNDCLASSEX  ; ���������� ������ ���������
    style dd 0                    ; �����
    lpfnWndProc dd offset WndProc ; ����� ��������� WndProc
    cbClsExtra dd 0               ; ���������� ������ ��� ���������
    cbWndExtra dd 0         ; ���������� ������ ��� �������������� ��������
    hInstance dd 004000000h ; ����������
    hIcon dd 4F00h          ; ���������� ������
    hCursor dd 4F00h        ; ���������� �������
    hbrBackground dd COLOR_WINDOW+1 ; ���� ����
    lpszMenuName dd 0               ; ��� ������� ����
    lpszClassName dd offset ClassName ; ������ ��� ����� ������ ����
    hIconSm dd 4F00h                ; ���������� ��������� ������
    ClassName db 'SimpleWinClass',0 ; ��� ������ ����
    AppName db '��������� ��������� �� ����� ������� �����',0
	
MouseClick db 0  ; ��������� ���������� ��� ������
myXY POINT <>  ; ��������� ���������� �- �� �-���������
.code
start:
invoke WinMain, hInstance, SW_SHOWDEFAULT
invoke ExitProcess,eax ; ���������� ��������� Windows �� ���������� �������
invoke WinMain,hInstance,SW_SHOWDEFAULT
       invoke ExitProcess,eax ; ���������� ���������� �� Windows � ������������ ��������
WinMain proc hInst:HINSTANCE, CmdShow:DWORD
LOCAL msg:MSG   ; �������������� ����� ��� ��������� MSG 
LOCAL hwnd:HWND ; �������������� ����� ��� ����� ���������
invoke  RegisterClassEx, ADDR wcex    ; ������� ����������� ������ ����
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,\
  CW_USEDEFAULT,CW_USEDEFAULT,450,350,0,0,hInst,0
     mov hwnd,eax
invoke ShowWindow,hwnd,SW_SHOWNORMAL ; ��������� ����
invoke UpdateWindow,hwnd ; ���������� ���������� ������� ���� ���������� WM_PAINT
.WHILE TRUE                        ; ���� �������, ��
invoke  GetMessage, ADDR msg,0,0,0 ; ������ ���������
         .BREAK .IF (!eax)        ; ��������� ����� ��� ���������� �������
 invoke TranslateMessage,ADDR msg ; ���������� � �������
 invoke DispatchMessage,ADDR msg ; �������� ��������� ����. ����
.ENDW                       ; ��������� ����� ������������� ���������
    mov eax,msg.wParam
ret  				  ; ����������� �� ���������
WinMain endp 		  ; ��������� ��������� � ������ WinMain 

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
LOCAL hdc:HDC   	 ; �������������� ����� ��� ����� ����
LOCAL ps:PAINTSTRUCT ; �������������� ����� ��� ��������� PAINTSTRUCT
.IF uMsg==WM_DESTROY         ; ���� ���� ��������� �� ����������� ����
       invoke PostQuitMessage,NULL ; �������� ��������� �� �����������
.ELSEIF uMsg==WM_LBUTTONDOWN       ; ��������� �� ����� ������� 
mov eax,lParam  ; 32-��������� ���������� ������� �����
and eax,0ffffh  ; ��������� ������� ����� - ���������� �
mov myXY.x,eax	; ���������� ���������� X
mov eax,lParam  ; 32-��������� ���������� ������� �����
shr eax,16 		; ����� ������ �� 4 ����� ��� ���������  Y
mov myXY.y,eax  ; ���������� ���������� Y
mov MouseClick,TRUE 	; ������������� ��������� ���������
    invoke InvalidateRect,hWnd,NULL,TRUE ; ��� ������������� ����
.ELSEIF uMsg==WM_PAINT      ; ���� ���� ��������� � ������������� 
invoke BeginPaint,hWnd, ADDR ps ; ���������� ���������
mov  hdc,eax 		  ; ���������� ���������
     .IF MouseClick  		; �������� ������������ ������
invoke lstrlen,ADDR AppName ; ����������� ����� ������ 
invoke TextOut,hdc,\ 		; ��������� ������
 myXY.x,myXY.y,\ 		; ���������� ������ ������
  ADDR AppName,\ 		; ����� �������� ������
   eax 			; ���������� ������ ������
	 .ENDIF
invoke EndPaint,hWnd, ADDR ps
.ELSE 		; �����
   invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; ��������� � �������� ��������� � WndProc
   ret 	  ; ����������� �� ���������
.ENDIF    ; ��������� ��������� .IF � .ELSEIF
xor eax,eax ; ������������� � ���������
ret         ; ����������� �� ���������
WndProc endp ; ��������� ��������� WndProc
end start    ; ��������� ��������� � ������ start