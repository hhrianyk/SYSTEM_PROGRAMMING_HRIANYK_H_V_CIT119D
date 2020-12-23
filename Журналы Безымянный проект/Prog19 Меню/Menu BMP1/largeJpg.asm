    include \masm64\include64\masm64rt.inc
    .data?
    hInstance dq ? ; ���������� ��������
    hWnd      dq ? ; ���������� ����
    hIcon     dq ? ; ���������� ������
    hCursor   dq ? ; ���������� �������
    sWid      dq ? ; ������ �������� (�����. �������� �� x)
    sHgt      dq ? ; ������ �������� (�����. �������� �� y)
   hImage  dq ?
   hStatic dq ?
.data
      classname db "template_class",0
      caption db "��� ��� ���",0
.code
entry_point proc
 GdiPlusBegin        ; initialise GDIPlus
 mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
 mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
 mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
 mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � �������� 
 mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
  mov hImage,rv(ResImageLoad,20) ; ������ �������� Bitmap
    call main
 GdiPlusEnd         ; GdiPlus cleanup
    invoke ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; ���������� ��������� ����������
    LOCAL lft :QWORD    ;  ���. ���������� ���������� � ����� 
    LOCAL top :QWORD     ; � ���������� ������ �� ����� ���. ����.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; �����. ������ ���������
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; ����� ����
    mov wc.lpfnWndProc,ptr$(WndProc) ; ����� ��������� WndProc
    mov wc.cbClsExtra,0       ; ���������� ������ ��� ��������� ������
    mov wc.cbWndExtra,0       ; ���������� ������ ��� ��������� ����
   mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
   mrm wc.hIcon,  hIcon       ; ����� ������
   mrm wc.hCursor,hCursor     ; ����� �������
    mrm wc.hbrBackground,0    ; hBrush ���� ����
    mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; ��� ������
   mrm wc.hIconSm,hIcon
invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
    mov wid,512   ; ������ ����������������� ���� � ��������
    mov hgt,380   ; ������ ����������������� ���� � ��������
    mov rax,sWid  ; �����. �������� �������� �� x
    sub rax,wid   ; ������ � = �(��������) - �(���� ������������)
    shr rax,1     ; ��������� �������� �
    mov lft,rax   ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt
    shr rax, 1
    mov top, rax
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
       ADDR classname,ADDR caption, \
       WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
         lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; ���������� ����������� ����
    call msgloop
    ret
main endp

msgloop proc
    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD
 mov pmsg, ptr$(msg) ; ��������� ������ ��������� ���������
 jmp gmsg            ; jump directly to GetMessage()
mloop:
 invoke TranslateMessage,pmsg
 invoke DispatchMessage,pmsg
gmsg:
 test rax, rv(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
 jnz mloop
 ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
.switch uMsg
    .case WM_COMMAND   ; ���� ������� ����
       .switch wParam
          .case 10002    ; ���� ������� ������ Exit
invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0
          .case 10004    ; ���� ������� ������ About
            .data
              msgtxt db "masm64",10
                     db "����� BMP (JPG) �����",0
            .code
invoke MsgboxI,hWin,ptr$(msgtxt),"������� ������ About In Window",MB_OK,10
rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0 ; ���������� ����
       .endsw
    .case WM_CREATE
invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0,WS_CHILD or WS_VISIBLE or SS_BITMAP,\
        0,0,0,0,hWin,hInstance,0,0    
mov hStatic,rax
;mov hStatic,rv(bitmap_image,hInstance,hWin,0,0)
invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hImage; ��������� ����

invoke LoadMenu,hInstance,100 ; ��������� ���� �� exe-�����
invoke SetMenu,hWin,rax ; ��������� ���� � �����
        .return 0
    .case WM_CLOSE ;
        invoke SendMessage,hWin,WM_DESTROY,0,0
    .case WM_DESTROY ; 
        invoke PostQuitMessage,NULL
.endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp
    end




















