include \masm64\include64\masm64rt.inc ;
.data 
a1 DD 167.13
a2 DD 23.13
b1 qword 167.13
b2 dq 23.13
titl1 db "��������� ������� �����",0
buf1 dq 3 dup(0.),0; �����
res1 dd 0,0
ifmt db "����� FPU =  %d ",10, "����� SSE =  %d ",10,"����� SSE2 =  %08I64x ",10,10,
"��������� ���������� FISTTP � �������������� ������������� ����� � ����� � �����������",
" �������������� �������� � ����������� � ��������.",10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
.code 
entry_point proc
 
finit
fld a1
fld a2
fadd
fisttp res1

movss XMM0,a1
addss XMM0,a2
cvtss2si r10d,XMM0 ; ��������. ������������� � ��������� ��. ����o

movsd XMM1,qword ptr b1
addsd XMM1,qword ptr b2
cvtsd2si r11d,XMM1 ;
invoke wsprintf,addr buf1,ADDR ifmt,res1,r10d,r11d;
invoke MessageBox,0,addr buf1,addr titl1,MB_OK
invoke ExitProcess,0
entry_point endp
end	