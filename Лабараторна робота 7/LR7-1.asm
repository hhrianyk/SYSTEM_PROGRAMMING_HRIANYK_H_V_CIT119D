    include \masm64\include64\masm64rt.inc
    .data
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
title1 db "���.7 SetKeyboardStatemasm64",0      
classname db "template_class",0
caption db "SetKeyboardState",0
Hello db "�������� �� ������. ",0
txt01 db "��������������� ������� SetKeyboardState ��������� 256-��������� ������ ����� ����� ��������� � ������� ����� �������� � ���������.",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0

char1 dq 30h; ������ ��������, ������� ��������� �������� �� ����������
x dq 0;
y dq 20;
 Keys db 250 dup(81h ),0  
 K db 0;
.code
entry_point proc
   invoke GetKeyboardState , addr Keys
    
 mov Keys[VK_LSHIFT],1;
 

mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
      ;  mov hStatic, rv(GetDlgItem,hWin,101)
       ; invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
          .case 103 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 106
            mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
call main
           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
 
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
call main

    .case 117    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     .case 115    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main proc
    LOCAL wc  :WNDCLASSEX ; ���������� ��������� ����������
    LOCAL lft :QWORD ;  ���. ���������� ���������� � ����� 
    LOCAL top :QWORD  ; � ���������� ������ �� ����� ���. ����.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; �����. ������ ���������
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; ����� ����
    mov wc.lpfnWndProc,ptr$(WndProc) ; ����� ��������� WndProc
    mov wc.cbClsExtra,0 ; ���������� ������ ��� ��������� ������
    mov wc.cbWndExtra,0 ; ���������� ������ ��� ��������� ����
   mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
   mrm wc.hIcon,  hIcon ; ����� ������
   mrm wc.hCursor,hCursor ; ����� �������
   mrm wc.hbrBackground,0 ; ���� ����
    mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; ��� ������
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
   mov wid, 420 ; ������ ����������������� ���� � ��������
   mov hgt, 620 ; ������ ����������������� ���� � ��������
    mov rax,sWid ; �����. �������� �������� �� x
    sub rax,wid ; ������ � = �(��������) - �(���� ������������)
    shr rax,1   ; ��������� �������� �
    mov lft,rax ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
  ; ---------------------------------
  ; centre window at calculated sizes
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
            ADDR classname,ADDR caption, \
            WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
            lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; ���������� ����������� ����
  call msgloop
    ret
main endp

msgloop proc
    LOCAL msg  :MSG
    LOCAL pmsg :QWORD
    mov pmsg,ptr$(msg) ; ��������� ������ ��������� ���������
    jmp gmsg           ; jump directly to GetMessage()
  mloop:
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg ; �������� �� ������������ � WndProc
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
    jnz mloop
    ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
LOCAL hdc:HDC   	; �������������� ����� ��� ����������� ����
LOCAL ps:PAINTSTRUCT ; ��� ��������� PAINTSTRUCT
LOCAL rect:RECT      ; ��� ��������� ��������� RECT
.switch uMsg
 
 .case WM_DESTROY ; ���� ���� ��������� ��� ����������� ���� 
        invoke PostQuitMessage,NULL
  .case WM_CHAR    ; ���� ���� ��������� �� ����������
   mov Keys[VK_SHIFT],80h
   mov Keys[WM_CHAR+1],80h
 invoke SetKeyboardState, addr Keys
push wParam    ; �� �������� ��������� ��������� ������
pop  char1   ; � ������������ � ������ ��� ������ � ����
inc char1
invoke InvalidateRect,hWnd,0,TRUE ; ����� ������� � WM_PAINT
invoke GetKeyboardState, addr K
mov r15 ,x
cmp r15,420
JNE m2
mov x,0;
add y,20
m2: add x ,10 

;invoke GetKeyboardState , addr Keys
;mov Keys[VK_SHIFT],80h

; invoke SetKeyboardState, addr Keys
 
 .case WM_PAINT   ; ���� ���� ��� � ������������� 
  invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
  invoke TextOut,hdc,x,y,\ ; ���������� ������ ������
      addr char1,1; ����� �������� ������ � ���. ������ ������
invoke GetClientRect,hWnd,ADDR rect ; ��������� � ��������� rect 
                       ; ������������� ����
invoke  DrawText, hdc,ADDR Hello,-1, ADDR rect, \ ; ��������� ������
DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke EndPaint,hWnd, ADDR ps            ; ���������� ���������
.endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end




















