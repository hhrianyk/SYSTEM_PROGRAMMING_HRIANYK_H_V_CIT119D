title ��������� �.�.
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data 
titl db "�������� ��������������� �� ��������� ������ AVX2",0 ; �������� ���� 
szInf db "������� AVX2 ��������������!!!",0  ; 
inf db "������� AVX2 ���������������� �� ��������������",0
.code 
entry_point proc
mov eax,7
mov ecx,0
cpuid ; �� ����������� rax ������������ ������������� ���������������
and  rbx,20h ;   (5 ������)
jnz  exit1       ; ������� �� exit, ���� �� ����
invoke MessageBox,0,addr inf,addr titl,MB_OK  
jmp exit2
exit1: 
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION
exit2:
invoke ExitProcess,0
entry_point endp
end	
