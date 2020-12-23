include \masm64\include64\masm64rt.inc; ���������� ��� �����������

 
DATE2 STRUCT              ; ��� ������ ���������
  _Monitor   db 22 dup(?) ; �����
  _marka     db 15 dup(?) ; �����
  _modem     db 15 dup(?) ; ������
  _Diagonal  dq   ?       ; ��������
  _Update    dq   ?       ;  
DATE2 ENDS        ; ��������� ������ ���������

.data             
Samsung DATE2 <"������ 24",   "Samsung " , "S24R350",24,75>      ; ��������� � ������ ASUS
AOS     DATE2 <"������ 23", "���",      "24G2U/BK",23,144>      ; ��������� � ������ HP
LG      DATE2 <"������ 27",   "LG",       "27GL83A-B",27,144>      ; ��������� � ������ ACER 
ACER    DATE2 <"������ 36.6", "ACER",   "UM.UE2EE.A01",36.6,144>      ; ���������� ������ MSI

  a   dq 24;
_res1 dq  0;

title1 db "  ���������. masm64", 0 
txt01  db"������ ����������� ��������.",10,
" ϳ��������� ������� ������� �������� ���� ����� 24.",0
txt02 db "+-------------+----------+-------------+-----+------+",10,
"| ������       | �����      | ������       |ĳ��.|Update|",10, 
"+-------------+----------+-------------+-----+------+",10,
"|������ 24   | Samsung | S24R350       | 24  | 75�� |",10, 
"|������ 23.8| ���         | 24G2U/BK    | 23  | 144��|",10, 
"|������ 27   | LG             |27GL83A-B| 27  | 144��|",10, 
"|������ 36.6| ACER        | UM.UE2EE.A0Z| 36.6| 144��|",10,\
"+-------------+----------+-------------+-----+------+",0


txt03 db "ʳ������ �������:  %d  ",0;�������� �����
autor db"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 10 dup(?),0

       hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
   


  fName  BYTE "PR5.txt",0;���� ��� ���������
fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 50 ;����� ����� 

.code 				
entry_point proc

mov rax, Samsung._Diagonal ; �������� ������ ������ ������ ���������
cmp rax, a
JNLE m1
inc _res1
m1:
mov rax, AOS._Diagonal ; �������� ������ ������ ������ ���������
cmp rax, a
JNLE m2
m2: 
inc _res1
mov rax, LG._Diagonal ; �������� ������ ������ ������ ���������
cmp rax, a
JNLE m3
inc _res1
m3:
mov rax, ACER._Diagonal ; �������� ������ ������ ������ ���������
cmp rax, a
JNLE m4
inc _res1
m4:
invoke wsprintf,ADDR buf1,ADDR txt03,_res1

      mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,1000,0,ADDR main,hIcon
    invoke ExitProcess,0
    ret
entry_point endp

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 101 - jpg
        mov hStatic, rv(GetDlgItem,hWin,101)
        invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
          .case 103 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR txt02,"���������",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf1,"���������  ���������",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
 
   invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10

           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf1,"���������  ���������",MB_OK,10
          .case 116
          invoke MsgboxI,hWin,ADDR txt02,"���������",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
               rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     .case 117    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end

