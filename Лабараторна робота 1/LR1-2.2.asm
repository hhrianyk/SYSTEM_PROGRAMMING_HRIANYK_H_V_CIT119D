
include \masm64\include64\masm64rt.inc ; ����������

.data ; 
mas1 dq  88, 3, 21, 5, 19, 4, 5,4
;       a, b, c,  d, e,  f ,g 
mas2 dq  88, 4, 1,  5, 18, 7, 1,8
;       a1,b1,c1, d1,e1, f1,g1 
len1 equ $-mas1


res1 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
;����� ��� MessageBox
title1 db "���.1-2.2 г����� ������. masm64",0
txt1 db "��������: �������� ��������� ����������� ���������� ��� ���������, ������� ������������� ������� �i <= ³.",10,
"���������: %d",10,"����� ����� � ������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0


.code;c����� ����
entry_point proc
mov rcx ,8;; �������� �������� ����������� ����� �������
lea rsi,byte ptr mas1 ; ��������� ������ ������ ��������� ������� mas1
lea rdi,byte ptr mas2 ; ��������� ������ ������� ���������� ������� mas2

jnz @1 ;����� �����

 minus: inc res1;+1 � ����������
    add rsi,8;���� ���������
    add  rdi,8;���� ���������
    dec rcx;������� -1
    cmp rcx,0; �������� �� �����
    je en

 @1:
  movzx rax, word ptr [rsi] ;����������������� � rax
  movzx  rdx, word ptr [rdi] ;����������������� � rdx
  sub rax,rdx; ���. ������� ��� ��������
   cmp rax,0; �������� rax <0;
  JLE  minus; �������, ���� a <= b

     add rsi,8;���� ���������
     add rdi,8;���� ���������


    dec rcx;������� -1
    cmp rcx,0; �������� �� �����
    jnz @1 

en: mov rax, 0;;�����
   ;��������� MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; ����� ������ ��������
   end