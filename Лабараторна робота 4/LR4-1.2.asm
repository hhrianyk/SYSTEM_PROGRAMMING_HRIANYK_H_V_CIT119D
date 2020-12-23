include \masm64\include64\masm64rt.inc; ���������� ��� �����������


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


DATE2 STRUCT              ; ��� ������ ���������
  _firm      db 22 dup(?) ; ���� ����������a �������� ����'������ �����
  _computer  db 10 dup(?) ; ���� ����'����
  _modem     db 10 dup(?) ; ���� ����
  _price     dq   ?       ; ���� (� �������)
  _quantity  dq   ?       ; ������� �������� �������
DATE2 ENDS        ; ��������� ������ ���������

.data             
ASUS DATE2 <"����'������ ������", "ASUS" , "512 �� SSD",940,5>      ; ��������� � ������ ASUS
HP   DATE2 <"����'������ ������", "HP",    "256 �� SSD",761,5>      ; ��������� � ������ HP
Acer DATE2 <"����'������ ������", "Acer",  "512 �� SSD",673,8>      ; ��������� � ������ ACER 
MSI  DATE2 <"����'������ ������", "MSI",   "256 �� SSD",672,7>      ; ���������� ������ MSI

txt1  db"������ ����������� ��������.",10,
" ��������� �������� ����� (������������� '������� �������� ������� ��������� �� ����').",10,10,
"| ����. ��������      |����'����|����      |����|�����|",10,\
"|����'������ ������| ASUS  |512 �� SSD|940$|      5|",10,\
"|����'������ ������| HP      |256 �� SSD|761$|      5|",10,\
"|����'������ ������| Acer   |512 �� SSD|673$|      8|",10,\
"|����'������ ������| MSI     |256 �� SSD|672$|      7|",10,10,\
"�����: ������ �.�., ��.ʲ�-119�",0


txt01 db"������ ����������� ��������.",10,0
txt2  db" ��������� �������� ����� (������������� '������� �������� ������� ��������� �� ����').",10,10,0
txt3  db"| ����. ��������____|����'����|����______|����|�����|",0
txt4  db"|����'������ ������| ASUS____|512 �� SSD|940$|      5|",0
txt5  db"|����'������ ������| HP______|256 �� SSD|761$|      5|",0
txt6  db"|����'������ ������| Acer_____|512 �� SSD|673$|      8|",0
txt7  db"|����'������ ������| MSI_____|256 �� SSD|672$|      7|",0
autor db"�����: ������ �.�., ��.ʲ�-119�",0

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
    classname db "template_class",0
   

buf1 dq 5 dup(?),0
st1 db "���.4-1.2 ���������. masm64", 0 
ifmt db "�������� �����:  %d$ ",0;�������� �����
_res1 dq 0  
 params MSGBOXPARAMSA <>    
.code 				
entry_point proc

mov rax, ASUS._price ; �������� ������ ������ ������ ���������
mul  ASUS._quantity  ; ASUS._price*ASUS._quantity
mov _res1,rax;       ; ���������� �����

mov rax, HP._price ; �������� ������ ������ ������ ���������
mul  HP._quantity  ; HP._price*HP._quantity
add _res1,rax;       ; ���������� �����

mov rax, Acer._price ; �������� ������ ������ ������ ���������
mul  Acer._quantity  ; Acer._price*Acer._quantity
add _res1,rax;       ; ���������� �����

mov rax, MSI._price ; �������� ������ ������ ������ ���������
mul  MSI._quantity  ; MSI._price*MSI._quantity
add _res1,rax;       ; ���������� �����

invoke wsprintf,ADDR buf1,ADDR ifmt,_res1

     mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
     mov params.hwndOwner,0     ; ���������� ���� ���������
     invoke GetModuleHandle,0   ; ��������� ����������� ���������
     mov params.hInstance,rax   ; ���������� ����������� ���������
         lea rax,txt1
     mov params.lpszText,rax   ; ����� ��������
         lea rax,st1
     mov params.lpszCaption,rax     ; ����� ������� ����
     mov params.dwStyle,MB_USERICON ; ����� ����
     mov params.lpszIcon,IDI_ICON    ; ������ ������
     mov params.dwContextHelpId,0  ;�������� �������
     mov params.lpfnMsgBoxCallback,0 ;
     mov params.dwLanguageId,LANG_NEUTRAL ; ���� ��������
         lea rcx,params
    invoke MessageBoxIndirect

    lea rax,buf1
     mov params.lpszText,rax   ; ����� ��������
         lea rax,st1
     mov params.lpszCaption,rax     ; ����� ������� ����
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
   mov wid, 750 ; ������ ����������������� ���� � �������
   mov hgt, 340 ; ������ ����������������� ���� � �������
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
            ADDR classname,ADDR st1  , \
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
   invoke TextOut,hdc,10,10,ADDR txt01,32
    invoke TextOut,hdc,50,40,ADDR txt2,92
   invoke TextOut,hdc,50,70,ADDR txt3,57
    invoke TextOut,hdc,50,90,ADDR txt4,55
    invoke TextOut,hdc,50,110,ADDR txt5,55
   invoke TextOut,hdc,50,130,ADDR txt6,56
   invoke TextOut,hdc,50,150,ADDR txt7,55
   invoke TextOut,hdc,80,250,ADDR autor,31
   invoke TextOut,hdc,80,200,ADDR buf1,25

  invoke EndPaint,hWnd, ADDR ps                ; ���������� ���������
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end
