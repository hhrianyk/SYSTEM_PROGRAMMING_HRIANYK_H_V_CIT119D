title ��������� �.�.
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data 
mas1 dd 10, 5, 2, 1
mas2 dd 16,10, 9, 8
res dd 4 dup(0),0
buf dd 4 DUP(0),0
_info db "������ ������ ������� AVX vpaddd",0Ah,0Dh,
 "(����������� ��������).",10,10,"��������� ������: ", 4 dup(" %d "),10,10,
 "�����: ��������� �.�., ���. ���, ���. ���, ��� ���",10,
9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0
_title db "����� ����� ����� ���������� � ��������������",0
.code 
entry_point proc
mov eax,4 ;
vmovups xmm1, mas1 ; ��������� ������������� ����������� ��������
vmovups xmm2, mas2 ; ��������� ������������� ����������� ��������
vpaddd xmm3, xmm1, xmm2 ; �������� ������������ ��������
vpextrd r10d,xmm3,0   ; ���������� 0-�� ����� � xmm 
vpextrd r11d,xmm3,1   ; ���������� 1-�� ����� � xmm 
vpextrd r12d,xmm3,2   ; ���������� 2-�� ����� � xmm
vpextrd r13d,xmm3,3   ; ���������� 3-�� ����� � xmm 
movsxd r10,r10d
movsxd r11,r11d
movsxd r12,r12d
movsxd r13,r13d
invoke wsprintf,ADDR buf,ADDR _info,r10,r11,r12,r13 ; 
invoke MessageBox,0,addr buf,addr _title, 0 ; 
invoke ExitProcess,0
entry_point endp
end	
