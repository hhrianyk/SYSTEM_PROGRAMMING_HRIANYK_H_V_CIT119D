include \masm64\include64\masm64rt.inc
.data ; 
a1 dq 2   ; ������� �1 ������������ 64 ������� ��������� 2
 
c1 dq 3   ; ������� c1 ������������ 64 �������;�������  c
d1 dq 6   ; ������� d1 ������������ 64 ������� ;�������  d
res1 dq 0 ; ������� res1 ������������ 64 �������; ����� �������

;����� ��� MessageBox
title1 db "���.1-1.г����� ������. masm64",0
txt1 db "г������   2d/�  � �d �� ��������� MessageBox: ",10,
"����: c=%d", ",d=%d",10,
"���������: %d",10,"����� ����� � ������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0
.code            ;c����� ����
entry_point proc
        mov  rax, d1 ; ��������� d1 � rax
        mul  a1     ; ��������  rax � 2
        div  c1      ; ������   rax � c1
        mov  res1,rax ; ���������� �������������� ����������
        mov  rax, d1 ;��������� d1 � rax
        mul  c1      ;�������� rax �� �1
        sub  res1,rax;2d/�  � �d
        
        
;��������� MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,c1,d1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0
entry_point endp; ����� ������ ��������
   end