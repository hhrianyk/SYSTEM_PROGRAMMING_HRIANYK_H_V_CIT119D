 
include \masm64\include64\masm64rt.inc ; ����������

 
mDIV macro x, y ;; ������ � ������ mSub
fld x ;; �������� x
fld y ;; �������� y
fdiv ;; x/y
endm ;; ��������� �������

.data ; 
a real4 1.7   ; ������� �1 ������������ 64 ������� ��������� 2
b real4 7.2   ; ������� b1 ������������ 64 ������� ;�������  d 
const1 real4 16.16
const2 real4 3.0

tick1 dq 0;
tick2 dq 0;

res1 dd 0,0; ������� res1 ������������ 64 �������; ����� �������

;����� ��� MessageBox
title1 db " M������. masm64",0
 
;����� ��� window
txt01 db "ϳ��������� ������� ��� ��������� ������������ ������: (16.16/a-b/16.16)/ab  �� �������� �� ��� �������.",10,10,
"����: a=1.7, b=7.2",0
txt02 db"���������: %d",10,"����� ����� � ������: %ph",0
txt03 db "��������� ��� � ��������: %d",10,"��������� ��� ��� �������: %d",0
autor db"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 25 dup(0),0
buf2 dq 25 dup(0),0
 

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0


fName  BYTE "PR6.txt",0;���� ��� ���������
fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 50 ;����� ����� 
.code;c����� ����
entry_point proc



 fisttp res1
 ;movsxd  rax,res1

rdtsc 
xchg rdi,rax
finit ; ������������� FPU
;mov ecx,4;
mDIV [const1],[a]
mDIV [b],[const1]
fsub 
fdiv a
fmul b
 fisttp res1
 ;movsxd  rax,res1
 
 rdtsc ; ��������� ����� ������
sub rax,rdi ; ��������� �� ���������� ����� ������ ����������� �����
mov tick1,rax

rdtsc 
xchg rdi,rax
 finit ; ������������� FPU
;mov ecx,4;
fld const1
fld a
FDIV 
fld b
fld const1
fDIV  
fsub 
fdiv a
fmul b
 fisttp res1
 ;movsxd  rax,res1
 
  rdtsc ; ��������� ����� ������
sub rax,rdi ; ��������� �� ���������� ����� ������ ����������� �����
mov tick2,rax
        
     invoke wsprintf,ADDR buf1,ADDR txt02,res1,ADDR res1
     invoke wsprintf,ADDR buf2,ADDR txt03,tick1,tick2
      
 
    
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
          invoke MsgboxI,hWin,ADDR buf1,"��������� ������:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf2,"��������� ���:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
   invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10

           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf1,"��������� ������:",MB_OK,10
          .case 116
          invoke MsgboxI,hWin,ADDR buf2,"��������� ���:",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
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