title ��������� �.�.
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data
mas1 dd 1, 10, 3, 8
mas2 dd 5,  6, 7, 8
tit1 db "masm64. AVX. ������������ ������� vpcmpgtb",0
ifmt db "������ ������ ������� AVX vpcmpgtb",10,
  "(��������� �� ������).",10,10,
  "��������� ������ (255 - ������, 0 - ������ ��� �����): ",10,10,
   4 dup(" %d "),10,
   "�����: ��������� �.�., ���. ���, ���. ���, ��� ���",10,
   9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0
buf1 dd 4 DUP(0),0
.code               
entry_point proc
vmovups xmm1,mas1 ; ymm1,mas1 ��� AVX2
vmovups xmm2,mas2
vpcmpgtb xmm3,xmm1,xmm2 ;https://support.amd.com/TechDocs/26568.pdf
vpextrd r10d,xmm3,0   ; ���������� 0-�� ����� � xmm 
vpextrd r11d,xmm3,1   ; ���������� 1-�� ����� � xmm 
vpextrd r12d,xmm3,2   ; ���������� 2-�� ����� � xmm
vpextrd r13d,xmm3,3   ; ���������� 3-�� ����� � xmm 

invoke wsprintf,ADDR buf1,ADDR ifmt,r10d,r11d,r12d,r13d
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
exit1: invoke ExitProcess,0
entry_point endp
end	