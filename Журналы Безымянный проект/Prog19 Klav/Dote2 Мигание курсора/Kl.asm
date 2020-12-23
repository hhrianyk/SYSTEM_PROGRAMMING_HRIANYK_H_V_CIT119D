.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib user32,kernel32
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
EditId equ 1010
IDM_INC equ 1001
IDM_RESET equ 1002
IDM_CHANGE equ 1003
IDM_SHOW equ 1004
IDM_ABOUT equ 1005
IDM_EXIT equ 1006
.data
ClassName db "WinClass",0
AppName  db "LAB 13",0
EditClassName db "edit",0
MenuName db "FirstMenu",0     
_str db "��������� � ��������� �������",0
_head db "����������",0
cFreq dd ?
nFreq dd ?
curShow db 0
curPic dd 1
hCursor HCURSOR 0
.data?
hInstance dd ?
CommandLine dd ?
hWndEdit HWND ?
hMenu HMENU ?
.code                                  	    ; ��������� ������� �������� ������
 start:                                		    ; ���� ������� ��������
invoke GetModuleHandle, NULL    ; ��������� ����������� ��������
mov    hInstance,eax                     ; ���������� ����������� ��������
invoke GetCommandLine               ; ���������� ���������� ����� �������
mov    CommandLine,eax
invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
invoke SetCaretBlinkTime,nFreq ; ���������� ��� ��������� �������
invoke LoadCursor, NULL, IDC_ARROW
invoke ExitProcess, eax
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR,\
  CmdShow:DWORD
LOCAL wc:WNDCLASSEX 	; ������������ �����  �� ���������
LOCAL msg:MSG 		; ������������ ����� �� ��������� MSG 
LOCAL hwnd:HWND  ; ������������ ����� �� ����� ��������
mov wc.cbSize,SIZEOF WNDCLASSEX       ; ������� ����� ���������
mov wc.style, CS_HREDRAW or CS_VREDRAW ; ����� �� �������� ����
mov wc.lpfnWndProc, OFFSET WndProc      ; ������ ��������� WndProc
mov wc.cbClsExtra,NULL               ; ������� ����� ��� ���������
mov wc.cbWndExtra,NULL  ; ������� ����� ��� ���������� ��������
push  hInstance              ; ���������� � ����� ����������� ��������
pop  wc.hInstance          ; ���������� ����������� � ���� ���������
mov  wc.hbrBackground, COLOR_WINDOW+1  ; ���� ����
mov  wc.lpszMenuName, NULL             ; ��� ������� ����
mov  wc.lpszClassName, OFFSET ClassName  ; ��� �����
invoke LoadIcon, NULL, IDI_APPLICATION    ; ������ ���������
mov     wc.hIcon,eax                ; ���������� ������ ���������
mov     wc.hIconSm,eax              ; ���������� ���������� ������
invoke  LoadCursor,NULL,IDC_ARROW         ; ������ �������
mov   wc.hCursor, eax
invoke RegisterClassEx, addr wc  ; ������� ��������� ����� ����
invoke LoadMenu, hInst, OFFSET MenuName ; ��������� ������ ����
mov hMenu,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,\
 ADDR AppName, WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
   CW_USEDEFAULT,350,130,NULL,hMenu,\
     hInst,NULL
	mov   hwnd, eax
invoke ShowWindow, hwnd, SW_SHOWNORMAL       ; �������� ����
	invoke UpdateWindow, hwnd
.WHILE TRUE                                 ; ���� �������, ��
invoke  GetMessage, ADDR msg,NULL,0,0       ; ������� �����������
	.BREAK .IF (!eax)           ; ��������� ����� ��� �������� �����
invoke TranslateMessage, ADDR msg   ; ���������� �� �����
invoke DispatchMessage, ADDR msg    ; �������� �� ��������������
				; �� WndProc proc
.ENDW
	mov     eax,msg.wParam
	ret           ; ���������� � ���������
WinMain endp     ; ��������� ��������� � ���� WinMain 


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.IF uMsg==WM_DESTROY       ; ���� � ����������� ��� �������� ����
    invoke PostQuitMessage, NULL ; �������� ����������� ��� ��������
.elseif uMsg==WM_CREATE    ; ���� � ����������� ��� ��������� ����
invoke LoadCursor, NULL, IDC_ARROW
mov hCursor,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR EditClassName,0,\
   WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT,30,\
    20,230,25,hWnd,EditId,\
      hInstance,NULL
           mov hWndEdit,eax
           invoke SetFocus,hWndEdit
invoke GetCaretBlinkTime ; ������� ������� ��������� �������
           mov nFreq,eax
           mov cFreq,eax
.elseif uMsg==WM_SETCURSOR
            invoke SetCursor,hCursor; ���������� ����� �������
.elseif uMsg==WM_COMMAND      ; ������� ���������� �� ����
            mov eax,wParam
			    .IF ax==EditId ; ���������� ������������ ����
                shr eax,16
                .if ax==EN_CHANGE
                    jmp m1
                .endif
            .elseif ax==IDM_ABOUT ; ���� � ����������� "�� ������"
     invoke MessageBox,NULL,addr _str,addr _head,MB_ICONERROR
    .elseif ax==IDM_RESET ; ���� � ����������� "�������� ������� �������"
invoke SetCaretBlinkTime,nFreq ; ���������� ������� ��������� 
                push nFreq
                pop cFreq
    .elseif ax==IDM_INC ; ���� � ����������� "��������� ������� ��������
m1:             mov eax,cFreq
                add eax,200
                mov cFreq,eax
invoke SetCaretBlinkTime,cFreq  ; ���������� ������� ��������� 
                invoke SetFocus,hWndEdit
    .elseif ax==IDM_SHOW ; ���� � ����������� "��������\�������� ������"
invoke ShowCursor,curShow          ; �������� ��� ������� ������
                .if curShow==1
                    mov al,0
                    mov curShow,al
                .else
                    mov al,1
                    mov curShow,al
                .endif
    .elseif ax==IDM_CHANGE ; ���� � ����������� "�������� ��� �������"
         .if curPic==1
          invoke LoadCursor, NULL, IDC_CROSS
          mov hCursor,eax
         xor ecx,ecx
         mov curPic,ecx
    .else
         invoke LoadCursor, NULL, IDC_ARROW
         mov hCursor,eax
         mov ecx,1
         mov curPic,ecx
    .endif
        invoke SetCursor,hCursor 	; ���������� ����� �������
.elseif
invoke DestroyWindow,hWnd  ; �������� ���� 
.endif
.else
invoke DefWindowProc, hWnd, uMsg, wParam, lParam ; �������� ���� 
	ret
.endif
	xor    eax,eax                                         ; ����������� �� ���������
	ret                                                              ; ���������� � ���������
WndProc endp                                      ; ��������� ��������� WndProc
end start                                              ; ��������� �������� � ���� start

