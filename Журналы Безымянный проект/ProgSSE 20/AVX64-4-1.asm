title ��������� �.�.
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data 
mas1 dd 10, 5, 2, 1
mas2 dd 16,10, 9, 8
res dd 4 dup(0),0
buf1 dq 4 DUP(0),0
_info db "������ ������ ������� AVX vpaddd",0Ah,0Dh,
    "(����������� ��������).", 0Ah, 0Dh,
    "��������� ������: ", 4 dup(" %d "),0
_title db "����� ����� ����� ���������� � ��������������",0
.code 
entry_point proc
vmovups xmm1, mas1 ; ��������� ������������� ����������� ��������
vmovups xmm2, mas2 ; ��������� ������������� ����������� ��������
vpaddd xmm0, xmm1, xmm2 ; �������� ������������ ��������
vunpcklpd xmm4, xmm4, xmm0 ; ���������� ������� �������
vunpckhpd xmm4, xmm4, xmm5 ; ���������� ������� ������� 
vunpckhpd xmm5, xmm5, xmm0 ; ���������� ������� �������
vunpckhpd xmm5, xmm5, xmm6 ; ���������� ������� �������
vcvtdq2pd xmm0, xmm4 ; �������������� �� ����� � ������� ���������
vcvtdq2pd xmm1, xmm5 ; �������������� �� ����� � ������� ��������� 

vunpcklpd xmm4, xmm4, xmm0 ; ���������� ������� �������
vunpckhpd xmm4, xmm4, xmm6 ; ���������� ������� �������
vunpckhpd xmm5, xmm5, xmm0 ; ���������� ������� �������
vunpckhpd xmm5, xmm5, xmm4 ; ���������� ������� �������
vcvttsd2si eax, xmm4 ; �������������� ����� ������� ��������
vcvttsd2si ebx, xmm5 ; �������������� ����� ������� �������� 
;mov dword ptr res, eax ; 
;mov dword ptr res[4], ebx ;
movsxd r10,eax
movsxd r11,ebx 

vunpcklpd xmm4, xmm4, xmm1 ; ���������� ������� �������
vunpckhpd xmm4, xmm4, xmm6 ; ���������� ������� �������
vunpckhpd xmm5, xmm5, xmm1 ; ���������� ������� �������
vunpckhpd xmm5, xmm5, xmm4 ; ���������� ������� �������
vcvttsd2si eax, xmm4 ; �������������� ����� ������� ��������
vcvttsd2si ebx, xmm5 ; �������������� ����� ������� �������� 
;mov dword ptr res[8],eax ; 
;mov dword ptr res[12],ebx ;
movsxd r12,eax
movsxd r13,ebx
 
invoke wsprintf,ADDR buf1,ADDR _info,r10,r11,r12,r13 ; 
invoke MessageBox,0,addr buf1,addr _title,0 ; 
invoke ExitProcess,0
entry_point endp
end	
