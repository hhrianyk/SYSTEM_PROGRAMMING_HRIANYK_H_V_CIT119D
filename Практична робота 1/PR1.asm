
include \masm64\include64\masm64rt.inc ; ����������
count PROTO arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD, arg_e:QWORD,arg_f:QWORD,arg_g:QWORD
.data ; 
a1 dq 10   ; ������� �1 ������������ 64 ������� ��������� 2
b1 dq 2   ; ������� b1 ������������ 64 ������� ;�������  d 
c1 dq 5   ; ������� c1 ������������ 64 �������;�������  c
d1 dq 23   ; ������� d1 ������������ 64 ������� ;�������  d
e1 dq 6   ; ������� e1 ������������ 64 ������� ;�������  e
f1 dq 1  ; ������� f1 ������������ 64 ������� ;�������  f
res1 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
;����� ��� MessageBox
title1 db "��������� ������ 1. masm64",0
txt1 db "г������ a+b+c - d/e + a*f",10,
"����: a=%d, b=%d, c=%d, d=%d, e=%d, f=%d",10,
"���������: %d",10,
"����� ���������� � ������: %p",0ah,0ah,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0

.code;c����� ����
entry_point proc
        mov  rax,a1    ; ��������� �1 � rax
        add  rax,b1    ;
        add  rax,c1    ; 
       
        mov  rsi,rax   ; ���������� �������������� ����������
        mov  rax,d1    ; ��������� (���������) d1 � rax
        xor  rdx,rdx   ; ������������� - ���������� � ������� (�������� �� ������ 2)
        div  e1        ;  �������  rax/d1


        sub  rsi,rax   ;  a+b+c - d/e  
        mov  rax,f1    ;  ��������� f1 � rax
        mul  a1        ;
        add  rsi ,rax  ;
        mov  res1,rsi  ; ����������
        ;��������� MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,a1,b1,c1,d1,e1,f1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; ����� ������ ��������
   end