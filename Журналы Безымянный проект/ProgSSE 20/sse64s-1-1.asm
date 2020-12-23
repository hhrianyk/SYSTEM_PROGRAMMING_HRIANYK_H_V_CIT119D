include \masm64\include64\masm64rt.inc ;
.data 
mas1 DD 167.13
mas2 DD 23.13
titl1 db "��������� ������� �����",0
buf1 dq 2 dup(0.),0	; �����
res1 dq 0,0
tFpu dq 0
tSse dq 0
ifmt db "����� FPU =  %d ",10, "����� ����� FPU =  %d ",10,10,
"����� SSE =  %d ",10,"����� ����� SSE =  %d ",10,
"��������� ���������� FISTTP � �������������� ������������� ����� � ����� � �����������",
" �������������� �������� � ����������� � ��������.",10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
.code 
entry_point proc
rdtsc
xchg r14,rax 
finit
fld mas1
fld mas2
fadd
fisttp res1
rdtsc
sub rax,r14
mov tFpu,rax

rdtsc
xchg r14,rax 
movss XMM0,mas1
addss XMM0,mas2
cvtss2si eax,XMM0 ; �������� ������������ ������ ���. �����
movsxd r10,eax
rdtsc
sub rax,r14
mov tSse,rax
invoke wsprintf,addr buf1,ADDR ifmt,res1,tFpu,r10,tSse;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end