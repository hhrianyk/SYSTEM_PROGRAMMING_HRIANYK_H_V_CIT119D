title ��������� �.�.
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data 
titl db "�������� ��������������� �� ��������� ������ AVX",0 ; �������� ���� 
szInf db "������� AVX ��������������!!!",0  ; 
inf db "������� AVX ���������������� �� ��������������",0
.code 
entry_point proc
mov   rax,1	
cpuid ; �� ����������� rax ������������ ������������� ���������������
and  rcx,10000000h ; r�x:= r�x v 1000 0000h  (28 ������)
jnz  exit1       ; ������� �� exit, ���� �� ����
invoke MessageBox,0,addr inf,addr titl,MB_OK  
jmp exit2
exit1: 
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION
exit2:

.data 
b1 dd 10, 8, 9, 6
titl1 db "������������ ������� vpextrd",0
buf db ?
frmt db "2-� ����� �� XMM = %d",0
.code 
vmovups xmm2, b1 
vpextrd eax,xmm2,2   ; ���������� 2-�� ����� � xmm 
invoke wsprintf, addr buf, addr frmt, eax
invoke MessageBox,0,addr buf,addr titl1,MB_OK
invoke ExitProcess,0
entry_point endp
end	
