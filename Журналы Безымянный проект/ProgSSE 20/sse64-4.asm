include \masm64\include64\masm64rt.inc
.data 
mas1 DD 0, 2.,4.,6. ; �������������� ����� ������ ��� ������� mas1
mas2 DD 1.,3.,5.,7. ; �������������� ����� ������ ��� ������� mas2
res dq 2 dup (0)

titl1 db "masm64. ��������� ������� �����",0
buf1 dq 2 dup(0.),0	; �����
ifmt db "  %d, ","  %d, ","  %d, ","  %d ",10,10,
"CVTPS2DQ - �������������� 4-� ����������� ����� ��������� �������� � ",
"4-� 32-��������� �����",10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
.code 
entry_point proc
movups XMM0,mas1 ; ��������� 4-� 32-��������� ����� ������� mas1
movups XMM1,mas2 ; ��������� 4-� 32-��������� ����� ������� mas2
movhlps XMM0,XMM1 ; ��������� � ������� �������������� 64 ������
cvtps2dq xmm3,xmm0
movupd res,xmm3

movsxd r10,dword ptr res[0]
movsxd r11,dword ptr res[4]
movsxd r12,dword ptr res[8]
movsxd r13,dword ptr res[12]
invoke wsprintf,addr buf1,ADDR ifmt,r10,r11,r12,r13
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0	
entry_point endp
end
