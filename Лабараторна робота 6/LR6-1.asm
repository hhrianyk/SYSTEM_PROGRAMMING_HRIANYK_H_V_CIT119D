 
include \masm64\include64\masm64rt.inc ; ����������


.data ; 

 mas1 dd 3.,1.,11.,1.,0.,5.,15.,1.,0.,9.,0.,0.  ; ������ ����� arr1 �������� � �����
 len1 equ ($-mas1)/type mas1 ; ���������� ����� �������
 mas2 dd 5., 3.,0.,4.,83.,0.,2.,3.,4.,3.,0.,0.  ; ������ ����� arr2 �������� � �����
 mas1_2 dd  len1 dup(0) ; ���������� ����� ������� ����������
 _res dd 0. ; ������� res1 ������������ 64 �������; ����� �������
 a  DD  100.0 ;
;����� ��� MessageBox
title1 db "���.6-1 SSE and AVX masm64",0

buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0
buf4 dq 25 dup(0),0

;����� ��� window
txt01 db "�������� �������� ������������ �������� �������� 2-� ������ �� 10-�� 64-��������� ������ �����. ������� ��i ����������. ���� ���� ��� ��������� ����� ����� 100, �� �������� ���������� ����������� ������, � ���� ������� - �� ����������.",0
txt02 db "���� ��x �����: %s",0
txt03 db "��������� ���������� ����������� ������: %d",0
txt04 db "�� ������ ����� �������� �������",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0
txt05 db "������ 100 ",0
txt06 db "����� 100",0
txt07 db "�����: %d",0
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;�������� ����
fNameS  BYTE "Res_LR6-1S.txt",0;���� ��� ���������
fNameA  BYTE "Res_LR6-1A.txt",0;���� ��� ���������

fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 27;����� ����� 

.code;c����� ����
entry_point proc
 
  
 lea rsi, mas1 ; ��������� ������ ������ mas1 � rsi
 lea rdi, mas2 ; ��������� ������ ������ mas2 � rdi
 lea rbx, mas1_2
 
movups XMM0,[rsi] ;mas1  ; 
movups XMM1,[rdi] ;mas2  ; 
 
mulps xmm1,xmm0 
;movupd xmmword ptr mas1_2,xmm1

 movups XMM2,[rsi+16] ;mas1  ; 
movups XMM3,[rdi+16] ;mas2  ; 
mulps xmm3,xmm2

movups XMM4,[rsi+32] ;mas1  ; 
movups XMM5,[rdi+32] ;mas2  ; 
mulps xmm5,xmm4 

addps xmm1,xmm3
addps xmm1,xmm5

movupd xmmword ptr mas1_2,xmm1

movups XMM0,mas1_2 
 movaps XMM1,XMM0          ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
movupd xmmword ptr a,xmm0
 cvttss2si eax,xmm0 
 movsxd r15,eax 
invoke wsprintf,ADDR buf2,ADDR txt02,ADDR txt06
invoke wsprintf,ADDR buf4,ADDR txt04

    cmp r15,100
    JNGE EXIT
   
     lea r15,a
    
    MOVUPS XMM5, a   
    SQRTSS xmm6, xmm5 
   cvttss2si rdi,xmm6 
 
 

 invoke wsprintf,ADDR buf2,ADDR txt02, ADDR txt05
 invoke wsprintf,ADDR buf4,ADDR txt07, rdi
EXIT:
        ;��������� Message
       invoke wsprintf,ADDR buf1,ADDR txt01 
       invoke wsprintf,ADDR buf3,ADDR txt03,r15 

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
           ; 102 - jpg
        mov hStatic, rv(GetDlgItem,hWin,101)
        invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
          .case 103 ; ������
          invoke MsgboxI,hWin,ADDR buf1,"��������",MB_OK,10
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
             invoke MsgboxI,hWin,ADDR buf4,"�����:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ����� �����
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
  invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10
 
           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR buf1,"��������",MB_OK,10
                   .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
          .case 116
           invoke MsgboxI,hWin,ADDR buf4,"�����:",MB_OK,10

      .case 115
     invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ����� �����
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