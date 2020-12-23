include \masm64\include64\masm64rt.inc
 IDM_Functions equ 10002
 IDM_EXIT  equ 10003  ;  ����� � ���������
 IDM_ABOUT equ 10005  ;  ����� � ���������
.data
    hInstance dq ? ; ���������� ��������
    hWnd      dq ? ; ���������� ����
    hIcon     dq ? ; ���������� ������
    hCursor   dq ? ; ���������� �������
    sWid      dq ? ; ������ �������� (�����. �������� �� x)
    sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
  classname db "template_class",0
  caption db "���� � Menu. masm64",0
.code
entry_point proc
 mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
 mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
 mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
 mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � �������� 
 mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
;mov hBrush,rvcall(CreateSolidBrush,00C4C4C4h)
    call main ; ����� ��������� main
  rcall ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; ���������� ��������� ����������
    LOCAL lft :QWORD    ;  ���. ���������� ���������� � ����� 
    LOCAL top :QWORD      ; � ���������� ������ �� ����� ���. ����.
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
    mrm wc.hbrBackground,0;hBrush ���� ����
    mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; ��� ������
   mrm wc.hIconSm,hIcon
invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
    mov wid, 500 ; ������ ����������������� ���� � ��������
   mov hgt, 250 ; ������ ����������������� ���� � ��������
    mov rax,sWid ; �����. �������� �������� �� x
    sub rax,wid ; ������ � = �(��������) - �(���� ������������)
    shr rax,1   ; ��������� �������� �
    mov lft,rax ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
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
    mov pmsg, ptr$(msg)      ; ��������� ������ ��������� ���������
    jmp gmsg                 ; jump directly to GetMessage()
mloop:
    rcall TranslateMessage,pmsg
    rcall DispatchMessage,pmsg
gmsg:
    test rax, rvcall(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
    jnz mloop
    ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    LOCAL dfbuff[260]:BYTE
    LOCAL pbuff :QWORD
    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case IDM_Functions ; 10002
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case IDM_EXIT  ; 10003
invoke MsgboxI,hWin,"masm64","������������� rcall � rvcall",MB_OK,10
          .case IDM_ABOUT ; 10005
invoke MessageBox,hWin,"������� ������ ���� ABOUT","Button1",MB_ICONINFORMATION
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

         .endsw

      .case WM_CREATE
        rcall LoadMenu,hInstance,10000
        rcall SetMenu,hWin,rax
        .return 0

      .case WM_CLOSE
rcall SendMessage,hWin,WM_DESTROY,0,0
      .case WM_DESTROY
        rcall PostQuitMessage,NULL
    .endsw
    rcall DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp
   end
