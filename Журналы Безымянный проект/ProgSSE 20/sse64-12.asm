; ����� �������� ��������� ������� ��� ����� ������������ DD � DQ
include \masm64\include64\masm64rt.inc
.data
arr1 dq 1,2,3,6    ; ����� � ���: 1.,2.,3.,6.
len1 equ ($-arr1)/type arr1
res1 dq 2 dup(0.)
titl1 db "��������� ��������. SSE. masm64",0
buf1 dq 50 DUP(0),0 ; ����� ������ ���������
ifmt db "����� �������� ��������� ������� ��� ����� ������������ dq",10,
" �����:  %d, ����� %d �����.",10,10,
"����� �������� ��������� ������� ��� ����� ������������ dd",10,
" �����:  %d, ����� %d �����.",10,10,
"����� ���������: ��������� �.�., �.�������, ��� ���",0
.code ;
entry_point proc
rdtsc ; ��������� ����� ������ � �������e rax
mov r10,rax ; ����� ���������� ���������
mov rcx,len1/2
lea rdi,arr1
lea rsi,res1
movups XMM0,[rsi];
@@:
movups XMM1,[rdi]; �������� ������� arr1
addpd XMM0,XMM1
add rdi,8*2
loop @b
shufpd XMM0,XMM0,0101b ;
cvttsd2si r12,xmm0
rdtsc ; ��������� ����� ������
mov r11,rax
sub r11,r10 ; ��������� �� ���������� ����� ������ ����������� �����
.data
res2 dd 4 dup(0.)
arr2 dd 1.,2.,3.,6.
len2 equ ($-arr2)/type arr2
.code
rdtsc ; ��������� ����� ������ � �������e rax
mov r10,rax ; ����� ���������� ���������
mov rcx,len1/4
lea rdi,arr2
lea rsi,res2
movups XMM2,[rsi];
m2:
movups XMM3,[rdi];
addpd XMM2,XMM3
add rdi,8*4
loop m2
movups xmm3,xmm2
shufps XMM3,XMM3,11100101b ;
cvttss2si eax,xmm3 
shufps XMM2,XMM2,11100111b ;
cvttss2si eax,xmm2 
addss xmm3,xmm2
cvttss2si eax,xmm3 
 movsxd r15,eax
rdtsc ; ��������� ����� ������
mov r14,rax
sub r14,r10 ; ��������� �� ���������� ����� ������ ����������� �����
invoke wsprintf,addr buf1,addr ifmt,r12,r11, r15,r14
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end	
