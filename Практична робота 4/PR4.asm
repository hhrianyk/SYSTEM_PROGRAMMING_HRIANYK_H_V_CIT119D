include \masm64\include64\masm64rt.inc 

.data
 mas1 db 'pneumonoultramicroscopicsilicovolcanoconiosis' ; ������ ������ � ��������� ���� ASCII
 len1 equ $-mas1     ; ����������� ���������� ������ � ������� mas1
 simvol db 's'
 count dq 0; ������� ���������
 poz dq 0; ������ ��������

;����� ��� MessageBox
title1 db "PR4. masm64",0
txt1 db " 'Pneumonoultramicroscopicsilicovolcanoconiosis'",10,
"  �������� ������� �������� ������� �� ������ ��������� ����",10,
"*��������� ���������� ����� 's'  ",10,
"*��������� ������� �����" ,10,
"*��������� ����� ������� ����� 's'",10,10, 
"-ʳ������ ���� s: %d",10,
"-������� �����: %d", 10,
"-����� ������� ����� 'm': %d",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq ?,0            ; ����� ������ ���������

.code;c����� ����
entry_point proc

 enter 16,0 ; ������� ���� �����: ���. ���� � ������� �����������
 mov r10,0;
lea rdi,mas1    ; �������� ������ ������� mas1
mov al, 'm'      ; �������� ������� �m�
mov rcx,len1 ; ���������� � ������� max �������� ����
cld		     ; ����������� -  �����
repne scasb	     ; ���������, ���� �� ����� ���������

dec rdi   	  ; ������: ���������������� DI
mov rax,len1
sub rax,rcx
mov poz,rax

inc R10
lea rdi,mas1

m1: 
enter 16,0 ; ������� ���� �����: ���. ���� � ������� �����������
mov rax, 's' 
repne scasb	     ; ���������, ���� �� ����� ���������

inc R10
cmp rcx,0
jnz m1

mov count,r10 		

        ;��������� MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,count,len1,poz  
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; ����� ������ ��������
   end