 
include \masm64\include64\masm64rt.inc ; ����������


fpuDiv macro _a,_b,_c ; ������ � ������ fpuDiv
mov rax,_b
mul _c
mov rbx,_a
sub rbx ,rax
mov rax,rbx

endm ;; ��������� �������

.data ; 
 a1 dq 2 
 b1 dq 8 
 c1 dq 5 
 d1 dq 3 

 arr1 dw 1,2,3,44,4,32,53,21,14,51,51,13,13,14,15,13,5,23,13,23,14,53,52,23,64,63,63,23,52,64 ; ������ ����� arr1 �������� � �����
 len1 equ ($-arr1)/type arr1 ; ���������� ����� �������
 arr2 dw 5,6,7,2,3,31,12,21,4,1,5,3,43,54,3,83,15,53,73,83,54,13,42,63,74,13,3,2,2,4  ; ������ ����� arr2 �������� � �����
 arr1_2 dq len1 dup(0) ; ���������� ����� ������� ����������
 _res dq 1 ; ������� res1 ������������ 64 �������; ����� �������
 
 

;����� ��� MessageBox
title1 db "���.5-2 MMX ������� masm64",0


textM db "���� ����� ����� 15",0
textB db "���� ����� ����� 15",0
buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0



;����� ��� window
txt01 db "�������� �������� ���r (xor) �� ������ ��� ����� ����� 2-� ������.",10,"���� ����� ����� ����� 15, �� �������� ��������",10,
"(b � d�)/a � �, �� a, b, c, d � ���� �����;",10,
"������ - �������� �������� b - d�.",10,10,
"����: a=%d, b=%d, c=%d, d=%d",0
txt02 db "%s",0
txt03 db "���������: %d",10,"����� ����� � ������: %ph",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0


      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;�������� ����
fName  BYTE "Res_LR5-2.txt",0;���� ��� ���������
fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 27;����� ����� 

.code;c����� ����
entry_point proc
 mov rbp,rsp
 movq MM1,QWORD PTR arr1 ; �������� ������� ����� arr1
 movq MM2,QWORD PTR arr2 ; �������� ������� ����� arr2
 pxor  MM1,MM2 ; ������������ ����������� ��������
 movq QWORD PTR arr1_2,MM1 ; ���������� ����������
pextrw eax,MM1,3 ; 

cmp eax,15 ; ���������
jg m1 ; if >
jmp m2
m1:
fpuDiv [b1],[c1],[d1]
 mov rdx,0
 div  a1
 sub rax,c1
mov _res,rax ; ���������� �������������� ��������  


invoke wsprintf,ADDR buf2,ADDR txt02, ADDR textB
jmp m3
m2: emms
 fpuDiv [b1],[c1],[d1]
mov _res,rax ; ���������� �������������� �������� 


invoke wsprintf,ADDR buf2,ADDR txt02, ADDR textM
m3:

        ;��������� Message
     invoke wsprintf,ADDR buf1,ADDR txt01,a1,b1,c1,d1
       invoke wsprintf,ADDR buf3,ADDR txt03,_res,ADDR _res

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
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf3,"���������:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0

           .case 110 ; ������
          invoke MsgboxI,hWin,ADDR buf1,"��������",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; �������� ����
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"���������:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf3,"���������:",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
              rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
              
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end