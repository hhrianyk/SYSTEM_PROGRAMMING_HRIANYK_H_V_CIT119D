 
include \masm64\include64\masm64rt.inc ; ����������

IDI_ICON  EQU 1001
MSGBOXPARAMSA STRUCT
   cbSize          DWORD ?,?
   hwndOwner       QWORD ?
   hInstance       QWORD ?
   lpszText        QWORD ?
   lpszCaption     QWORD ?
   dwStyle         DWORD ?,?
   lpszIcon        QWORD ?
   dwContextHelpId QWORD ?
   lpfnMsgBoxCallback QWORD ?
   dwLanguageId       DWORD ?,?
MSGBOXPARAMSA ENDS

mMul macro x, y ;; ������ � ������ mSub
fld x ;; �������� x
fld y ;; �������� y
fmul ;; x*y
endm ;; ��������� �������

.data ; 
a real4 2.7   ; ������� �1 ������������ 64 ������� ��������� 2
b real4 5.2   ; ������� b1 ������������ 64 ������� ;�������  d 
const1 real4 1.1
const2 real4 3.0
 
res1 dd 0,0; ������� res1 ������������ 64 �������; ����� �������

;����� ��� MessageBox
title1 db "���.4-2.1 �������. masm64",0
txt1 db "�����:  (1,1ab � 3)/ab",10,
"����: a=2.7, b=5.2",10,10,
"���������: %d",10,"����� ����� � ������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 25 dup(0),0
buf2 dq 25 dup(0),0
;����� ��� window
txt01 db "�����:  (1,1ab � 3)/ab",0
txt02 db"����: a=2.7, b=5.2",0
txt03 db"���������: %d  " 
txt04 db"����� ����� � ������: %ph",0
autor db"�����: ������ �.�., ��.ʲ�-119�",0

params MSGBOXPARAMSA <>

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
    classname db "template_class",0
    caption db "����� � Windows-����",0
    Hello db "������ ��������� ����������� � windows ����!!!",10,
	" masm64",0

.code;c����� ����
entry_point proc

finit ; ������������� FPU
;mov ecx,4;
mMul [a],[b]
fmul const1
fsub const2
fdiv a
fmul b

 fisttp res1
 ;movsxd  rax,res1

        ;��������� MessageBox
     invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1
     invoke wsprintf,ADDR buf2,ADDR txt03,res1
    invoke wsprintf,ADDR txt03,ADDR txt04,ADDR res1

     invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    
    mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
    mov params.hwndOwner,0    ; ���������� ���� ���������
    invoke GetModuleHandle,0   ; ��������� ����������� ���������
    mov params.hInstance,rax  ; ���������� ����������� ���������
         lea rax,buf1
    mov params.lpszText,rax   ; ����� ���������
         lea rax,title1
    mov params.lpszCaption,rax     ; ����� �������� ����
    mov params.dwStyle,MB_USERICON ; ����� ����
    mov params.lpszIcon,IDI_ICON    ; ������ ������
    mov params.dwContextHelpId,0  ;�������� �������
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ���� ���������
         lea rcx,params
    invoke MessageBoxIndirect
    
  mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,IDI_ICON,IDI_ICON) ; �������� � ���������� ����������a ������
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
    mov wc.cbClsExtra,0 ; ���������� ������ �� ��������� ������
    mov wc.cbWndExtra,0 ; ���������� ������ �� ��������� ����
    mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
    mrm wc.hIcon,  hIcon ; ����� ������
    mrm wc.hCursor,hCursor ; ����� �������
    mrm wc.hbrBackground,4 ; ���� ����
    mov wc.lpszMenuName,0 ; ���������� ��� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; �� ������
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
   mov wid, 450 ; ������ ����������������� ���� � �������
   mov hgt, 190 ; ������ ����������������� ���� � �������
    mov rax,sWid ; �����. �������� �������� �� x
    sub rax,wid ; ������ � = �(��������) - �(���� �����������)
    shr rax,1   ; ��������� �������� �
    mov lft,rax ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
  ; ---------------------------------
  ; centre window at calculated sizes
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
            ADDR classname,ADDR title1  , \
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
LOCAL hdc:HDC   	; �������������� ����� �� ����������� ����
LOCAL ps:PAINTSTRUCT ; �� ��������� PAINTSTRUCT
LOCAL rect:RECT      ; �� ��������� ��������� RECT

.switch uMsg
 .case WM_DESTROY ; ���� ���� ��������� ��� ����������� ����
        invoke PostQuitMessage,NULL
 .case WM_PAINT   ; ���� ���� ��� � ������������� 
  invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
  invoke GetClientRect,hWnd,ADDR rect ; ��������� � ��������� rect 
                             ; ������������� ����
  invoke  DrawText, hdc,ADDR txt1,0, ADDR rect, \ ; ��������� ������
   DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke TextOut,hdc,10,10,ADDR txt01,22
    invoke TextOut,hdc,50,40,ADDR txt02,21
    invoke TextOut,hdc,50,70,ADDR buf2,13
    invoke TextOut,hdc,50,90,ADDR txt03,41
   invoke TextOut,hdc,80,130,ADDR autor,31
 

  invoke EndPaint,hWnd, ADDR ps                ; ���������� ���������
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end