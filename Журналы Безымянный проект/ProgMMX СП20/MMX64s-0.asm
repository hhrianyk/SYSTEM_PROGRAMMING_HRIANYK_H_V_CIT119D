include \masm64\include64\masm64rt.inc ; ����������
.data 	
mas1 db 1,2,3,4,5,6,7,8
mas2 DB 9,8,7,6,5,4,3,2
len1 equ ($-mas2) ; ����������� ���. ���� ������� mas2
mas3 db len1 dup(?) ;
mas4 db len1 dup(255) ; ��� �������� ��������� ���.������.

tit1 db "��������� ������� ��������� �������. masm64 ",0
ifmt db "����� ��������� ��������� ���. ����������: %d",10,10,
"����� ��������� MMX: %d",10,10,"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
buf1 dq 0
.code  		
entry_point proc
lea rsi,mas1 ; �������� ������ ������� mas1
  lea r10,mas1 ; ���������� ������ ��� ������������� ��������� MMX
lea rdi,mas2 ; �������� ������ ������� mas2
  lea rbx,mas2 ; ���������� ������ ��� ������������� ��������� MMX
lea r11,mas3 ; �������� ������ ������� mas3
  lea r12,mas4 ; ���������� ������ ��� ������������� ��������� MMX
rdtsc   ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
mov r14,rdx ;
mov rcx,len1 ;
@@: mov al,[rsi]
    add al,byte ptr [rdi]
    mov byte ptr [r11],al
    inc rsi ; 
    inc rdi ;
    inc r11 ;
loop @b
rdtsc ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
sub rdx,r14 ;
mov r14,rdx ;

rdtsc ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
mov r15,rdx ;

movq mm0,qword ptr [r10] ; ��������� 8 ������ mas1 � ��0
paddb MM0,qword ptr [rbx] ; mas1 + mas2
movq qword ptr [r12],MM0 ; ���������

rdtsc ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
sub rdx,r15 ;
mov r15,rdx ;

invoke wsprintf,ADDR buf1,ADDR ifmt,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION;
invoke ExitProcess,0
entry_point endp
end
