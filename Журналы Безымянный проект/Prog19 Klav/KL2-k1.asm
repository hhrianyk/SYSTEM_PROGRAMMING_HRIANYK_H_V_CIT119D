    include \masm64\include64\masm64rt.inc
    .data
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
classname db "template_class",0
caption db "�����  �������� � Windows-����",0
Hello db "�������� ������ �� ����������. ������� �� ������ �������. masm64",0
char1 dq 20h; ������ ��������, ������� ��������� �������� �� ����������
.code
entry_point proc
  mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
call main
    invoke ExitProcess,0
    ret
entry_point endp

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
   mov wid, 720 ; ������ ����������������� ���� � ��������
   mov hgt, 320 ; ������ ����������������� ���� � ��������
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
push wParam    ; �� �������� ��������� ��������� ������
pop  char1   ; � ������������ � ������ ��� ������ � ����
invoke InvalidateRect,hWnd,0,TRUE ; ����� ������� � WM_PAINT

 .case WM_PAINT   ; ���� ���� ��� � ������������� 
  invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
invoke TextOut,hdc,20,20,\ ; ���������� ������ ������
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




















