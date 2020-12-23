.686 	             ; ��������� ����������� ���� ���������������
.model flat,stdcall  ;������� �������� ������ ������ � ���������� �� Windows
option casemap:none  ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
   WinMain proto :DWORD,:DWORD
.data 			                    ; ��������� ����������� ������
   ClassName db "SimpleWinClass",0
AppName  db "��������� ��������� �� ����������",0 ; �������� ����
char WPARAM 20h ; ������ ��������, ������� ��������� �������� �� ����������
   hInstance HINSTANCE ?
.code ; ��������� ������ �������� ������
start: ; ����� ������ ��������� � ������ start
invoke  GetModuleHandle, NULL      ; ��������� ����������� ���������
mov   hInstance,eax 	           ; ���������� ����������� ���������
invoke WinMain, hInstance,  SW_SHOWDEFAULT
       invoke ExitProcess,eax ; ���������� ���������� �� Windows � ������������ ��������
   WinMain proc hInst:HINSTANCE, CmdShow:DWORD
LOCAL wc:WNDCLASSEX ; �������������� ����� ��� ���������
LOCAL   msg:MSG             ; �������������� ����� ��� ��������� MSG 
LOCAL   hwnd:HWND        ;  �������������� ����� ��� ����� ���������
push  hInst  		         ; ���������� � ����� ����������� ���������
pop     wc.hInstance                 ; ����������� ����������� � ���� ���������
mov  wc.cbSize,SIZEOF WNDCLASSEX               ; ���������� ������ ���������
mov wc.style, CS_HREDRAW or CS_VREDRAW   ; ����� � ��������� ����
mov  wc.lpfnWndProc, OFFSET WndProc         ; ����� ��������� WndProc
mov  wc.hbrBackground,COLOR_WINDOW+1                               ; ���� ����
mov     wc.lpszMenuName,NULL                                        ; ��� ������� ����
mov     wc.lpszClassName,OFFSET ClassName                             ; ��� ������
invoke  LoadIcon,NULL,IDI_APPLICATION                       ; ������ �����������
mov     wc.hIcon,eax                                  ; ���������� �������� �����������
mov     wc.hIconSm,eax                                ; ���������� ���������� ������
invoke  LoadCursor,NULL,IDC_ARROW                                 ; ������ �������
mov     wc.hCursor,eax
mov     wc.cbClsExtra,NULL                            ; ���������� ������ ��� ���������
mov  wc.cbWndExtra,NULL           ; ���������� ������ ��� �������������� ��������
invoke  RegisterClassEx, ADDR wc              ; ������� ����������� ������ ����
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,\
  CW_USEDEFAULT,CW_USEDEFAULT,500,400,\ ; ������ �� ������ ����
      0,0,hInst,0 			           ; �����������
       mov   hwnd,eax
invoke  ShowWindow, hwnd,SW_SHOWNORMAL    ; ��������� ����
invoke UpdateWindow, hwnd ; ���������� ���������� ������� ���� ���������� WM_PAINT
.WHILE TRUE                           ; ���� ��������, ��
invoke  GetMessage, ADDR msg,0,0,0    ; ������ ���������
         .BREAK .IF (!eax)       ; ��������� ����� ��� ���������� �������
 invoke TranslateMessage, ADDR msg  ; ���������� � �������
 invoke DispatchMessage, ADDR msg ; �������� ��������� ����. ����
.ENDW                       ; ��������� ����� ������������� ���������
       mov     eax,msg.wParam
ret  				         ; ����������� �� ���������
WinMain endp 		  ; ��������� ��������� � ������ WinMain 
WndProc proc hWnd:HWND, uMsg:UINT,\
 wParam:WPARAM, lParam:LPARAM
LOCAL hdc:HDC   	 ; �������������� ����� ��� ����� ����
LOCAL ps:PAINTSTRUCT ; �������������� ����� ��� ��������� PAINTSTRUCT
.IF uMsg==WM_DESTROY         ; ���� ���� ��������� �� ����������� ����
      invoke PostQuitMessage, NULL ; �������� ��������� �� �����������
.ELSEIF  uMsg==WM_CHAR    ; ���� ���� ��������� �� ����������
           push wParam    ; �� �������� ��������� ��������� ������
           pop  char   ; � ������������ � ������ ��� ������ � ����
invoke InvalidateRect, hWnd, NULL, TRUE ; ����� ������� � WM_PAINT
.ELSEIF uMsg==WM_PAINT      ; ���� ���� ��������� � ������������� 
invoke BeginPaint,hWnd,ADDR ps ; ����� ��������� � ���������� ��������� 
mov     hdc,eax 		  ; ���������� ���������
invoke TextOut,hdc,20,20,\ ; ���������� ������ ������
      addr char,\          ; ����� �������� ������
          1                ; ���������� ������ ������
invoke EndPaint,hWnd, ADDR ps          
.ELSE 		; ������
   invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; ��������� � �������� ��������� � WndProc
   ret 	  ; ����������� �� ���������
.ENDIF    ; ��������� ��������� .IF � .ELSEIF
xor     eax,eax      ; ������������� � ���������
ret                  ; ����������� �� ���������
WndProc endp ; ��������� ��������� WndProc
end start    ; ��������� ��������� � ������ start
