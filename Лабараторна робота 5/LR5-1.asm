 
include \masm64\include64\masm64rt.inc ; ����������
.data ; 
 mas1 db  'Do not bite the hand that feeds you ' ; ������ ������ � ��������� ���� ASCII
 len1 equ $-mas1     ; ����������� ���������� ������ � ������� mas1
 poz dq 0; ������ ��������
 

;����� ��� MessageBox
title1 db "���.5-1 ������ ������� masm64",0

buf1 dq 35 dup(0),0
buf2 dq 25 dup(0),0


;����� ��� window
txt01  db "������� ����� � 8 ��� � ����� ������� �������.",10," � ������ � ������ ������� ������ ������� ���� �� ���������.",10,10,
"�����: Do not bite the hand that feeds you",10,10,
"� ������ � ������ ������� ������ ������� ���� �� ���������.",0
txt02 db "���������: %s",10,"����� ����� � ������: %ph",0
txt04 db "���������: %s  ",0
txt05 db "����� ����� � ������: %ph",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0

;params MSGBOXPARAMSA <>

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;�������� ����
fName  BYTE "Res_LR5-1.txt",0;���� ��� ���������
fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 47;����� ����� 


.code;c����� ����
entry_point proc
mov poz,0; 
lea rdi,mas1
mov rcx,len1 ; ���������� � ������� max �������� ����
mov esi,0
mov edx,0

jnz m1 
m2:
mov rax,len1
sub rax,rcx
;sub rax,poz
 dec rax   ;������� ����a

mov rbx,poz
dec rbx
 m3:
 mov  dl, mas1[rax] 
 mov  dh, mas1[rbx]
 mov mas1[rax],dh
 mov mas1[rbx],dl

inc rbx
cmp rbx,rax
jz m4
dec rax
cmp rbx,rax
jz m4

jnz m3
m1: 
enter 38,0 ; ������� ���� �����: ���. ���� � ������� �����������
mov rax, ' ' 
repne scasb	     ; ���������, ���� �� ����� ���������

inc r10

   TEST r10, 1
    JZ  m2   	;������, ������� �� ����� m2
 m4:  
 
mov poz,len1
sub poz,rcx

cmp rcx,0
jnz m1 

        ;��������� MessageBox
      invoke wsprintf,ADDR buf1,ADDR txt02, ADDR mas1,ADDR mas1
     ;invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION

      invoke wsprintf,ADDR buf2,ADDR txt04,ADDR mas1
      invoke wsprintf,ADDR txt04,ADDR txt05,ADDR mas1  

    mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     mov hBmp, rv(ResImageLoad,20)
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
           ; 102 - jpg
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
          invoke MsgboxI,hWin,ADDR buf1,"���������:",MB_OK,10
          .case 107
               invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
               mov fHandle, rax;������� �� ������ ���� �����
               invoke WriteFile,fHandle,ADDR buf2,BSIZE ,ADDR cWritten,0
               invoke CloseHandle,fHandle
                         .case 110 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 111
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 113
          invoke MsgboxI,hWin,ADDR buf1,"���������:",MB_OK,10
          .case 115
               invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
               mov fHandle, rax;������� �� ������ ���� �����
               invoke WriteFile,fHandle,ADDR buf2,BSIZE ,ADDR cWritten,0
               invoke CloseHandle,fHandle
              rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
              
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end
