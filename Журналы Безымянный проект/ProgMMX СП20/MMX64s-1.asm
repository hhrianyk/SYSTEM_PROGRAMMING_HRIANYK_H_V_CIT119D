include \masm64\include64\masm64rt.inc ; ����������
.data  		     ; ��������� ����������� ������
mas1  DB " STUDENTS OF THE UNIVERSITY"
len1  EQU $-mas1 ; ���������� ���������� ������ 
mas2 DB len1 DUP (20h) ; �������������� �� ��������� 20h
mas3 db len1 DUP(' '),10,10, ; ������ ���������� 
 "����� ���������:  ��������� �.�., ���. ���, ��� ���",0
titl1 db "������������ �������e �������� � ������� ������ ���",0
.code 			   ; ��������� ������ ���� ���������
entry_point proc
mov EAX, len1 ; �������� ���������� ������
mov EBX, 8 	; ������������ ���������� ����
xor EDX, EDX; ������������� ����� ��������
div EBX     ; ����������� ���������� ������ �� 8 ������
mov ECX, EAX ; ���������� ������ ��� ������������ ���������
lea rsi, mas1 ; �������� ������ ������� mas1
lea rbx, mas2 ; �������� ������ ������� mas2
lea rdi, mas3 ; �������� ������ ������� mas3
m1:
movq MM0,qword ptr [rsi] ; ��������� 8 ������ ������� mas1 � ��0
paddb MM0,qword ptr [rbx] ; mas1 + mas2
movq qword ptr [rdi], MM0 ; ���������� ����������
add rsi,8 ; �������� �� 64 ������� ������ ������ �������
add rdi,8 ; �������� �� 64 ������� ������ ������ �������
add rbx,8 ; ������������� ������ ������ ������ �������
loop m1   ; ������� �� m1, ���� ecx /= 0
cmp EDX,0 ; ��������� �������
jz  exit  ; ������� �� exit, ���� EDX = 0 (z = 1)
mov ECX,EDX ; ���������� ������ ��� ���������������� ���������
m2: mov AL,byte ptr [rsi]
add AL,20h
mov byte ptr [rdi], AL
inc rsi ; rsi := rsi + 1
inc rdi ; rdi := rdi + 1
dec ECX ; ecx := ecx � 1
jnz m2  ; ������� �� m2, ���� �� ���� (��� /= 0) 
exit:
invoke MessageBox,0,addr mas3,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
