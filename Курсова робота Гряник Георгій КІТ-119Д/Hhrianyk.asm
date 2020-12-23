include \masm64\include64\masm64rt.inc
.data	
colorBlack dd 196920
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y)
      tEdit     dq ? ; ����� ���� ����� 
       buffer BYTE 260 dup(?) ;;; ��� �������� ������
         pbuf dq buffer ;;; ��� MessageBox,�.�.�� ������������ ADDR
         
classname db "template_class",0
caption db "�������� ������",0
MouseClick db 0  ; ���� ������� 
myXY POINT <>  ; ��������� ��� �- �� �-���������

 mas dd 25000 ; ������� �����
 j dq 3       ;������ cos
 k dq 3       ;������ sin
 t dd 0.0     ; ������� ���� ������ 

 a dq 1.    ;a
 b dq 80.0  ;b
 c dq 1.0   ;c
 d dq 80.0 ; d 

;������ ��� ������
 a1 dd 0  
 b1 dd 0
 c1 dd 0
 d1 dd 0 ; 
 divK2 dd 100
 
;����������� ���� ��������� ������������
 plus dd 1.
 plus1 dd 1  
 minus dd 5.
 one dd 1.

 delta dd  0.0175 ; ���� ������  

 xdiv2 dq ?    ; �������� �� X 
 ydiv2 dq ?    ; �������� �� Y
 xdiv  dq 620  ; ������ ����
 ydiv  dq 520  ; ������ ����
 tmp dd 0       ; ��������� ����������
 divK dd 100. ; ���������� �����������
 xr dd 0. 	; ���������� �������
 yr dd 0    ;; ���������� �������
 temp1 dd 0; �� ���� �������

;����� ��� ������
text01 db "x=%d y=%d",0

txt02 db "     ���������� ���������     ",10,10,
"        ���������� ���������    ",10,10, 
"����� ������: %d",10,
"����� ����: %dx%d",10,10,
"���:",10,
"A=%d",10,
"B=%d	",10,
"C=%d",10,
"D=%d",10,10,
"�������: ",10,
"x=�os(at)-cos^%d(bt)",10,
"y=sin(ct)-sin^%d(dt)",10,10,
"ʳ������ �����: %d",0 
txt03 db "%d",0
 

buf1 dq 3 dup(0),0
buf2 dq 100 dup(0),0
 
;��� ���������� �� ������
_file1 db "Help.txt",0 ; ���� �� 
hFile01 HANDLE ?
from_file db 4096 dup(?)
read_by_file dq ?
write_by_file dq ?
file01_size dq ?
;���������� �� ������
title2 db "���������� �� ������",0
msg2 db "�������! ���� '��� ��������' �� ��������!",0
buf dq 0

.code
entry_point proc
 

    GdiPlusBegin        ; initialise GDIPlus
    ;����� ������ ����
  mov rax ,xdiv
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� �
  mov xdiv2,rax
  mov rax ,ydiv
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� Y
  mov ydiv2,rax

 

 mov hBmp, rv(ResImageLoad,20); ������������ ����

  mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR) ; �������� � ���������� ����������a ������
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
 ;Paint main
  invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon;��������� ����
 
    

    invoke ExitProcess,0
    ret
entry_point endp


mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����

invoke SendMessage,rv(GetDlgItem,hWin,106),\ ; ��������� ���� �� ����������� ������ ����������
              STM_SETIMAGE,IMAGE_ICON,lParam
                         ; 102 - jpg
        .return TRUE
  mov tEdit, rvcall(GetDlgItem,hWin,301)
invoke SetFocus, tEdit ; ��������� ������� � ���� ����� 

      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
          .case 101 ; ������ ������������ ������� �����
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,2000,0,ADDR Rrecision,hIcon
        
 
          .case 102 ;������������ ������� �����
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,3000,0,ADDR Conditions,hIcon
     
 
          .case 103 ; ������������ �������
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,4000,0,ADDR formulas,hIcon
    
 
          .case 104;�������� ������
          call Paint
                    
          .case  105;������� ��������
            ; invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
           
          .case 10004; �������� ���������� ��� ��������
          invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
          mov hFile01,rax ; ���������� ����������� �����
           .if hFile01 == INVALID_HANDLE_VALUE ; ���� CreateFile ���������� ������
           invoke MsgboxI,0,addr msg2,"���� �� ������",MB_OK,0 ; ��������� �� ������
          ret
         .endif ; ���� ������������� ��������� �����  �� ���������� ��
         invoke GetFileSize,hFile01,0 ; ��������� ������� ����� 01
         mov file01_size,rax; 
         invoke ReadFile,hFile01,addr from_file,file01_size,addr read_by_file,0;��������� �����
         invoke MessageBox,0,addr from_file,addr title2,MB_OK,10 ; ������ MessageBox
         invoke CloseHandle,hFile01
 

         .case  10005;;����� ������������ �����������
            fld a
            fld b
            fld c
            fld d
            fld divK
            fistp dword ptr divK2
            fistp dword ptr d1
            fistp dword ptr c1
            fistp dword ptr b1
            fistp dword ptr a1
          invoke wsprintf,ADDR buf1,ADDR txt02, divK2, xdiv, ydiv, a1, b1,c1, d1,j,k,mas
          invoke MsgboxI,hWin,ADDR buf2,"Info",MB_OK,10
          
          .case 10002;��� �����
          invoke MsgboxI,hWin,"�����: ������ �.�., ��.ʲ�-119�","�����",MB_OK,10
          
          .case 10003;������� ��������
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
          
          .case 10007;��������� ������������
           invoke DialogBoxParam,hInstance,600,0,ADDR ChangeSettings,hIcon

        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp
;//////////////////////////////////////////////////////////////////////////
Rrecision proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; ��������� ������������ �������(������� �����
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg

        .return TRUE 
      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
          .case 201 ; ������ ���������� 1000
      mov mas ,1000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ;������� ����
          .case 202 ; ������ ���������� 2000
      mov mas ,2000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ;������� ����

         .case 203 ; ������ ���������� 5000
      mov mas ,5000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;;������� ����
         .case 204 ; ������ ���������� 10 000
      mov mas ,10000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;������� ����
          .case 205 ; ������ ���������� 25000
      mov mas ,25000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ������� ����
           .case 206 ; ������ ���������� 50 000
      mov mas ,50000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ������� ����
           .case 212 ; ������ ���������� 75 000
      mov mas ,75000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ������� ����
            .case 207 ; ������ ���������� 100 000
      mov mas ,100000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;������� ����
          .case 208 ; ������ ���������� 1 000 000
      mov mas ,1000000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ������� ����
            .case 209 ; ������ ���������� 1 000 000
      mov mas ,1000000000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;   ������� ����       
 
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
Rrecision endp
;////////////////////////////////////////
Conditions proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD;���� ������� ����� ��� ���������� �������
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        ;invoke SetWindowText,301,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
 
       
            invoke wsprintf,ADDR buf1,ADDR txt03, a1 
            invoke SetDlgItemText,hWin,301,addr buf1 ;������� �������� a
            
            invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;������� �������� b
            
            invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;������� �������� c
            
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;������� �������� d

            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;������� �������� plus
 .return TRUE

      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
     .case 312  ;a-plus
     
            fld a
            fsub plus
            fld st(0)
            fstp  a
            fistp dword ptr a1
              invoke wsprintf,ADDR buf1,ADDR txt03, a1
            invoke SetDlgItemText,hWin,301,addr buf1 ;������� �������� a
     .case 313 ;a+plus
            fld a
            fadd plus
            fld st(0)
            fstp  a
            fistp dword ptr a1
             invoke wsprintf,ADDR buf1,ADDR txt03, a1
            invoke SetDlgItemText,hWin,301,addr buf1 ;������� �������� a
            
     .case 314 ;b-plus
            fld  b
            fsub plus
            fld st(0)
            fstp  b
            fistp dword ptr b1
             invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;������� �������� b
     .case 315 ;b+plus
            fld b
            fadd plus
            fld st(0)
            fstp  b
            fistp dword ptr b1
             invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;������� �������� b
            
     .case 316 ;c-plus
            fld c
            fsub plus
            fld st(0)
            fstp  c
            fistp dword ptr c1
             invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;������� �������� c
     .case 317 ;c+plus
            fld c
            fadd plus
            fld st(0)
            fstp  c
            fistp dword ptr c1
             invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;������� �������� c
            
     .case 318 ;d-plus
            fld d
            fsub plus
            fld st(0)
            fstp  d
            fistp dword ptr d1
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;������� �������� d
     .case 319 ;d+plus
            fld d
            fadd plus
            fld st(0)
            fstp  d
            fistp dword ptr d1
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;������� �������� d

     .case 320 ;plus-1
            fld plus
            fsub one
            fld st(0)
            fstp  plus
            fistp dword ptr plus1
            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;������� �������� plus
     .case 321 ;plus+1
            fld plus
            fadd one
            fld st(0)
            fstp  plus
            fistp dword ptr plus1
            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;������� �������� plus
     .case 322
             
     invoke MsgboxI,hWin,"���������� '+' ��� �������� ���������� ��������� ��� '-' ��� ���� ��������","���������� ���������",MB_OK,10 ;plus-info

      .case 305
 
             rcall EndDialog,hWin, 1 
         .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
Conditions endp
;//////////////////////////////////////////////////////////////////
formulas proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; ;; ����������� �������
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        ;invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
          .case 401 ; ������ ���� �������� ������ �������� �� ������ 
          mov j,3
          mov k,3
          .case 402
          mov hBmp, rv(ResImageLoad,20)
          invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon
 
           
          .case 403 ; ������ ���� �������� ������ �������� �� ������ 
           mov j,3
           mov k,4
          .case 408
           mov hBmp, rv(ResImageLoad,30)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; ����� ������� �������
           
          .case 409 ; ������ ���� �������� ������ �������� �� ������ 
           mov hBmp, rv(ResImageLoad,40)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; ����� ������� �������
          .case 410
                       mov hBmp, rv(ResImageLoad,50)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; ����� ������� �������
          .case 411  

         
          .case 405 ; ������ ���� �������� ������ �������� �� ������ 
           mov j,4
           mov k,4
          .case 406
                        mov hBmp, rv(ResImageLoad,50)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; ����� ������� �������
                  
          .case 407
             invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND;�������� �������� ����
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;  
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
formulas endp

;//////////////////////////////////////////////////////////////////
formulas2 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; ;; ���� ����������� �������� �������
    .switch uMsg

      .case WM_INITDIALOG ; ��������� � �������� ����. ����
         invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
           mov hStatic, rv(GetDlgItem,hWin,501) 
         invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
          
          .case 507
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;  
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
formulas2 endp

;//////////////////////////////////////////////////////////////////
ChangeSettings proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD;������������ ������ ���� �� ������
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
     
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1 ;������� �������� divk

       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;������� �������� ������ ����

        invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;������� �������� ������ ����


        .return TRUE

     invoke SetWindowText,rv(GetDlgItem,hWin,608),"������ ����� ������� �����" 
      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 

      .case 610 ;����� ������ - 5
            fld  divK
            fsub minus
            fld st(0)
            fstp  divK
            fistp dword ptr divK2
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1 ;������� �������� ������ ������
     .case 611 ;����� ������ + 5
            fld  divK
            fadd minus
            fld st(0)
            fstp  divK
            fistp dword ptr divK2
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1  ;������� �������� ������ ������
            
     .case 612 ;����� ���� - 10
      sub xdiv,10
       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;������� �������� ����������
     .case 613 ;����� ���� + 10
      add xdiv,10 
       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;������� �������� ����������
     .case 614 ;����� ���� - 10
      sub ydiv,10
       invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;������� �������� ����������
     .case 615 ;����� ���� + 10
      add ydiv,10
        invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;������� �������� ����������

 .case 607
 ;����� ���� �������� ����
   mov rax ,xdiv
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� �
  mov xdiv2,rax
  mov rax ,ydiv
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� Y
  mov ydiv2,rax
   rcall EndDialog,hWin, 1
   
         .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
ChangeSettings endp

;//////////////////////////////////////////////////////////////////


Paint proc ; ��������� ����
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
   mrm wc.hbrBackground,5 ; ���� ����
    mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; ��� ������
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
 mov rax ,xdiv
   mov wid, rax ; ������ ����������������� ���� � ��������
    mov rax ,ydiv
   mov hgt, rax ; ������ ����������������� ���� � ��������
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
Paint endp

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
;//////////////////////////////////////////////////////////////////
WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD ;�������� ������
LOCAL hdc:HDC   	; �������������� ����� ��� ����������� ����
LOCAL ps:PAINTSTRUCT ; ��� ��������� PAINTSTRUCT
LOCAL rect:RECT      ; ��� ��������� ��������� RECT
.switch uMsg
 .case WM_DESTROY ; ���� ���� ��������� ��� ����������� ����
        invoke PostQuitMessage,NULL
 .case WM_LBUTTONDOWN    ; ��������� �� ����� ������� 
mov rax,lParam  ; 32-��������� ���������� ������� �����
and rax,0ffffh  ; ��������� ������� ����� - ���������� �
mov myXY.x,eax	; ���������� ���������� X
mov rax,lParam  ; 32-��������� ���������� ������� �����
shr rax,16 		; ����� ������ �� 4 ����� ��� ���������  Y 
mov myXY.y,eax  ; ���������� ���������� Y
 ;mov MouseClick,TRUE 	; ������������� ��������� ���������
invoke InvalidateRect,hWnd,0,TRUE ; ��� ������������� ����
; .case WM_PAINT      ; ���� ���� ��������� � ������������� 
invoke BeginPaint,hWnd,ADDR ps ; ���������� ���������
mov  hdc,rax 		  ; ���������� ���������
      		; �������� ������������ ������
   mov r10d,mas ; ���������� ���������� ������
 mov temp1,r10d
 invoke InvalidateRect,hWnd,0,TRUE ; ����� ������� � WM_PAINT
finit
    invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
 
l1:   
                      
invoke wsprintf,ADDR buf1,ADDR text01,xr,yr                        
   invoke TextOut,hdc, 10,30,ADDR buf1,12 ;����� ��������� �����(��� ������ �� ���� �������������)
 
  fld a    ; a
fmul t     ; m*alpha
fcos       ;cos(a*t)
fld b      ; b
Fmul t     ; b*t
fcos       ; cos (b*t)
cmp j,4    ; ���������� ��������� �� ������ 3 ��� 4
je s1
 
fld st(0)
fld st(0)
FMUL       ; sin^2(d*t)
FMUL       ; sin^3(d*t)
jmp s2
s1:
fld st(0)
fld st(0)
fld st(0)
FMUL       ; cos^2(d*t)
FMUL       ; cos^3(d*t)
FMUL       ; cos^3(d*t)
s2:
 
FSUB       ; cos(a*t)-cos^3(m*t)
FMUL divK  ; �����* cos(a*t)-cos^3(m*t)
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 
 
fld c   ; c
fmul t     ; m*alpha
fsin       ;cos(c*t)
fld d      ; d
Fmul t     ; d*t
fsin       ; sin (d*t)

cmp k,4    ; ���������� ��������� �� ������ 3 ��� 4
je s4
s3:
fld st(0)
fld st(0)
FMUL       ; sin^2(d*t)
FMUL       ; sin^3(d*t)
jmp s5
s4:
fld st(0)
fld st(0)
fld st(0)
FMUL       ; cos^2(d*t)
FMUL       ; cos^3(d*t)
FMUL       ; cos^3(d*t)
s5:

FSUB       ; sin(a*t)-sin^k(m*t)
FMUL divK  ; �����* sin(a*t)-sin^k(m*t)
fstp tmp
fild ydiv2      
fsub tmp  

fistp dword ptr yr ; ���������� X ��� ��������� �� �����
 
invoke SetPixel, hdc, xr, yr, colorBlack ; ��������� ����� � ���.
 
;invoke SetCursorPos,xr,yr ; ������������ ������� �� xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3
 
dec temp1   ; ���������� ��������
jz l2       ; ����������� ���������
jmp l1	; ����� �� �����
l2: 
 
invoke EndPaint,hWnd, ADDR ps			; ���������� ������ ������
      .endif

    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end