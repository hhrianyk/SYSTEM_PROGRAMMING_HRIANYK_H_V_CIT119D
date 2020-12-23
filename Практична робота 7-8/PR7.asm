 
include \masm64\include64\masm64rt.inc ; ����������


.data ; 

 mas1 dw 3  ,1 ,11 ,1 ,0 ,5 ,15 ,1    ;  
 
 mas2 dw 5  , 3 ,0 ,4 ,83 ,0 ,2 ,3    ; 
 len1 EQU (LENGTHOF mas2) ; ���������� ��������� � ������� 
 sum dw len1 DUP(0),0
 sum2 dw len1 DUP(0),0 
 
 mas3 dd   3.0  ,1.0 ,11.0 ,1.0 ,5. ,5. ,15. ,1.    ;  
 mas4 real8 12.0, 4.0, 6.0, 37.0  



;����� ��� MessageBox
title1 db "PR 7",0

buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0
buf4 dq 25 dup(0),0

;����� ��� window
txt01 db "�������� ������� ���������� ���������� � ������� �������������� ����������",0
txt01_1 db "������ ��� ������, ��������� ������ MMX  ������� �� ����� ���� ����� ��������",0
txt01_2 db "���������� ���� ����� ������",0
txt01_3 db "������ �����  ",0

txt02_1 db "���������: ",len1 dup("%d "),0
txt02_2 db "���� ��x �����: %d",0
txt02_3 db "���������: -2",0


txt03_1 db "������: ",10, "3, 1, 11, 1, 0, 5, 15, 1",10,  "5, 3, 0, 4, 83, 0, 2, 3",0
txt03_2 db "�����:  3  ,1  ,11  ,1  ,5  ,5 ,15 ,1 ,0",0
txt03_3 db "�����:  SQRT(a+b)-d/c",0

autor db "�����: ������ �.�., ��.ʲ�-119�",0
 
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;�������� ����
fNameM  BYTE "PR7_M.txt",0;���� ��� ���������
fNameS  BYTE "PR7_S.txt",0;���� ��� ���������
fNameA  BYTE "PR7_A.txt",0;���� ��� ���������

fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 27;����� ����� 

.code;c����� ����
entry_point proc
 mov rax,len1 ; ������� ����� 
mov rbx,4    ; ���. ����� � 64 ��������
xor rdx,rdx ; ���������� � �������
div rbx     ; ����������� ���. ������ � �������
mov rcx,rax  ; ���. ������ � ��������
lea rsi,mas1 ; 
lea rdi,mas2 ;
lea rbx,sum  ; ����� �������� ����������
@@:
movq MM0,qword ptr[rsi] ; �������� ����� mas1
movq MM1,qword ptr[rdi] ; �������� ����� mas2
pmaxsw   MM0,MM1         ; 
movq qword ptr[rbx],MM0 ;
add rsi,8 ; ���. ������ ���������� �����
add rdi,8 ; 
add rbx,8 ;
  loop @b 

 cmp rdx,0  ; ����������� ������� �������������� ��������� ��������
 jz  exit   ; ���� �������� �����������, �� ������� �� exit
 mov rcx,rdx ; ��������� � ������� ���������� �������������� �����
m2:  mov ax,word ptr [rsi] ; ��������� ��������������� �������� �� mas1
 add  ax,word ptr [rdi]        ; �������� ��������� ���� ��������
 mov  word ptr [rbx],ax      ; ���������
 add rsi,2     ; ���������� � ������� �������� �� mas1
 add rdi,2     ; ���������� � ������� �������� �� mas2
 add rbx,2     ; ���������� � ������ ���������� � ������
 loop m2       ; ecx := ecx � 1 � �������, ���� ecx /= 0
 exit:
  
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]

invoke wsprintf,ADDR buf1,ADDR txt02_1,rsi,rdi,r10,r11,r12,r13,r14,r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lea rsi, mas3 ; ��������� ������ ������ mas1 � rsi
movups XMM0,[rsi] ;
movups XMM1,[rsi+16] ;
addps xmm0,xmm1
 movaps XMM1,XMM0          ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
cvttss2si eax,xmm0 
movsxd r15,eax 
invoke wsprintf,ADDR buf2,ADDR txt02_2,r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov rcx,4
 
lea rbx,mas4
 
	vmovsd xmm1,real8 ptr [rbx]  ; xmm1 - b - ��������� ������� �����
      vmovsd xmm2,real8 ptr [rbx+8];
      vaddsd xmm1,xmm2,xmm1 
      SQRTSD xmm1,xmm1
      vmovsd xmm3, real8 ptr [rbx+16]
      vmovsd xmm4,real8 ptr [rbx+24]
      vdivsd xmm3, xmm3,xmm4
      vsubsd xmm1,xmm1,xmm3
      cvttss2si eax,xmm2 
      movsxd r15,eax 

     invoke wsprintf,ADDR buf3,ADDR txt02_3,r15
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
          invoke MsgboxI,hWin,ADDR txt01_2,"��������",MB_OK,10
          invoke MsgboxI,hWin,ADDR txt03_2,"�����",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 106
          
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
 
          .case 107
      invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
 
  invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10
           .case 1001
           invoke MsgboxI,hWin,ADDR txt01_1,"��������",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_1,"�����",MB_OK,10
           .case 1002
            invoke MsgboxI,hWin,ADDR buf1,"���������",MB_OK,10
           .case 1003
             invoke CreateFile,ADDR fNameM,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
             mov fHandle, rax;������� �� ������ ���� �����
            invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
            invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10
          .case 1005
           invoke MsgboxI,hWin,ADDR txt01_3,"��������",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_3,"�����",MB_OK,10
             .case 1006 
            invoke MsgboxI,hWin,ADDR buf3,"���������",MB_OK,10

            .case 1005 
            invoke MsgboxI,hWin,ADDR txt01_3,"��������",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_3,"г������",MB_OK,10
         .case 1008
   
         invoke MsgboxI,hWin,ADDR txt01 ,"��������",MB_OK,10

            .case 1007
              invoke CreateFile,ADDR fNameA,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
             mov fHandle, rax;������� �� ������ ���� �����
            invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
            invoke MsgboxI,hWin,"������ ���������","SAVE",MB_OK,10
           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR buf1,"��������",MB_OK,10
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
          .case 116
           invoke MsgboxI,hWin,ADDR buf4,"�����:",MB_OK,10
        .case 221
   
         invoke MsgboxI,hWin,ADDR txt01 ,"��������",MB_OK,10
        .case 216
         invoke MsgboxI,hWin,ADDR txt01_1,"��������",MB_OK,10
        .case 219
         invoke MsgboxI,hWin,ADDR txt01_2,"��������",MB_OK,10
         .case 220
         invoke MsgboxI,hWin,ADDR txt01_3,"��������",MB_OK,10

 
        .case 222
         invoke MsgboxI,hWin,ADDR txt03_1,"�����",MB_OK,10
        .case 223
         invoke MsgboxI,hWin,ADDR txt03_2,"�����",MB_OK,10
         .case 224
         invoke MsgboxI,hWin,ADDR txt03_3,"�����",MB_OK,10

        .case 212
         invoke MsgboxI,hWin,ADDR buf1,"���������",MB_OK,10
        .case 217
         invoke MsgboxI,hWin,ADDR buf2,"���������",MB_OK,10
         .case 218
         invoke MsgboxI,hWin,ADDR buf3,"���������",MB_OK,10


      .case 115
     invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
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