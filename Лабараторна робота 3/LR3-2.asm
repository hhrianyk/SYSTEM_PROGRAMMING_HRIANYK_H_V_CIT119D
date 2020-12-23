include \masm64\include64\masm64rt.inc ; ����������
.data ;

_x    dq 3.0 ; ������� �����
_op1  dq 125.0 ; ����� ����� � ������
_op2  dq 3.0 ; ����� ����� � ������
_op3  dq 1.1 ; ����� ����� � ������
_step dq 1.5 ; ���� ��� ��������� ��������

res1 dd 0 ;  ���������� ����������1
res2 dd 0;  ���������� ����������2
res3 dd 0;  ���������� ����������3
res4 dd 0;  ���������� ����������4

;����� ��� MessageBox
title1 db "���.3-2 ��������� ������� �� ����������. masm64",0
txt1 db"��������� 4 �������� �������: Yn = 125 / (3*�^2 - 1,1) (� ��������� �� 3 � ������ 1,5).",10," ��������� ��������� � ����� �������.",10,10,
"���������: %d, %d, %d, %d ",10,10,
"����� ����������1: %ph",10,
"����� ����������2: %ph",10,
"����� ����������3: %ph",10,
"����� ����������4: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0

buf dq 4 dup(0) ;�����
.code;c����� ����
entry_point proc

finit  ;
mov rcx, 4  ; �������;  ���������� ������
m1:fld _x    ;�������� ��������� �
fmul _x      ; x^2
fmul _op2  ; (3*x^2 )
fsub _op3  ;(3*x^2-1.1)
FDIVR  _op1;125 / (3*�^2 - 1,1) 

fld _x 
fadd _step  ; ���������� ���� ��������
fstp _x ; ���������� � ������ � ������������� ������� �����
 loop m1   ; ���������� �� 1 rcx � ������� �� �����, ���� �� ����

fisttp res4 ; ���������� � 64-��������� ������� ������ � �����������
fisttp res3 ;
fisttp res2 ;
fisttp res1 ;

invoke wsprintf,ADDR buf,ADDR txt1,res1,res2,res3,res4,addr res1,ADDR res2,ADDR res3,ADDR res4
invoke MessageBox,0,ADDR buf,ADDR title1,MB_ICONINFORMATION ;��������� MessageBoxinvoke ExitProcess,0
entry_point endp; ����� ������ �������
end