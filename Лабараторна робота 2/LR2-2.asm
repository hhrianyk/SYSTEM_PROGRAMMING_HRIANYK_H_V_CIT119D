include \masm64\include64\masm64rt.inc ; ����������
err1 PROTO arg_a:QWORD
.data ;

mas1 dq 12,4,5,3,8   
     dq 10 dup(1)
     dq 25 dup(5)      ; ������ mas1 
mas2 dq 10,12,10,34,17   
     dq 20 dup(1)
     dq 15 dup(2)      ; ������ mas2
buf dq ?,0      ; 
len1 equ ($-mas1)/type mas2 ; ���������� ���������� ���� � mas1

_res dq 1 ; ������� res1 ������������ 64 �������; ����� �������
_res1 dq 0 ; ������� res1 ������������ 64 �������; ����� �������


;����� ��� MessageBox
title1 db "���.2-2 ���� �����. masm64",0
txt1 db "��������:����� ������ � � � � N = 50 ��������.",10," �������� �������� ���������� ������� �������� ������ B ,",10," ��� ���� ��� 0 � 1 ���������.", 10,10,
"ʳ������ �������� : %d",10,"����� ����� � ������: %ph",10,10,
"������� �������� : %d",10,"����� ����� � ������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0

.code;c����� ����
entry_point proc

  invoke err1,len1
  invoke wsprintf,ADDR buf1,ADDR txt1,_res1,ADDR _res1,_res,ADDR _res
  invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION ;��������� MessageBox
  invoke ExitProcess,0

entry_point endp; ����� ������ ��������
mov r14,_res

err1 proc arg_a:QWORD; arg_a ���������� � rcx
lea rsi,mas2 	 ; ��������� ����� ������� mas1 
m1:   
mov ax,[rsi] ; � �� ��������� ������� �������
bt  rax,0		; ����� �������� ����
setc bh		; ���� cf=1, �� ������������ 1 � bh
bt  rax,1		; ����� ������� ����
setc bl	; ���� pf = 1, �� ������������ 1 � bl
cmp bh,bl 	; ��������� �����
jne m2 	; ���� �� ���������, �� ������� �� m2

mov _res,rax;���������� ����������
add _res1,1;������� ��������
mov r14,_res
m2:  add rsi,8 ; ���������� ������ mas2 ��� ������� ������ �����
dec rcx 	   ; ���������� �������� ����� � ������� mas1
cmp rcx,0
jnz m1 		; ������� �� ����� m1, ���� �� ����

ret
err1 endp

   end