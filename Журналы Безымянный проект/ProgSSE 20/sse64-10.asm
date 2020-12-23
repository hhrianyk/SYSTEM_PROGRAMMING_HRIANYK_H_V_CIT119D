include \masm64\include64\masm64rt.inc; ������������ ����������
.data     	         				
mas1 dq 1.,2.     ; ������ 1
mas2 dq 3.,4.     ; ������ 2
mas3 dq 5.,6.     ; ������ 3
mas4 dq 7.,8.1     ; ������ 4 
titl1 db "SSE2-�������. ������������ ����� max �������� � ��������",0 ; �������� ����
fmt db "������������ ����� max ��������",0Ah,0Dh,\ 
 "� ����� ����������� 64-��������� ����� � ��������� ���-���.",0Ah,0Dh,0Dh,
  "�������:",0Ah,0Dh,"mas1:   1.,  2.",0Ah,0Dh,"mas2:   3.,  4.",0Ah,0Dh,0Dh,
   "mas3:   5.,  6.",0Ah,0Dh,"mas4:   7.,  8.",0Ah,0Dh,0Dh,\
    "����� ������������ �������� ��������= %d",10,
    "�����:  ��������� �.�., ���. ���, ��� ���",0
buf1 dq 0 ; �����
.code
entry_point proc 				

movupd Xmm0,mas1	; ��������� masl � ����
movupd Xmm1,mas2  ; ��������� mas2 � ���1
movupd Xmm2,mas3	; ��������� mas3 � ���2
movupd Xmm3,mas4	; ��������� mas4 � ����
maxpd Xmm0,xmm1     ; ���������� ���������� � mas1 � mas2
maxpd Xmm2,xmm3     ; ���������� ���������� � mas3 � mas4
addpd Xmm0,xmm2	  ; ����� ����������
unpckhpd xmm4,xmm0 ; ���������� ��. �. xmm0 � ��. �. xmm4 � ����� ��. �. xmm4
unpckhpd xmm4,xmm5 ; ����������� ��. ����� xmm4 � ��. �. xmm4
unpcklpd xmm5,xmm0 ; ���������� ��. �. xmm0 � ��. �. xmm5 � ����� ��. �. xmm5
unpckhpd xmm5,xmm6 ; ����������� ��. ����� xmm5 � ��. ����� xmm5
addpd xmm4,xmm5         ; ����� xmm4 � xmm5
cvtpd2pi MM0,xmm4       ; ����������� � 32-��������� �����
movd dword ptr ebx,mm0  ; ��������� ����������� ��0 � ebx
invoke wsprintf,addr buf1,addr fmt,ebx  ; ��������������
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION+90000h
invoke ExitProcess,0
entry_point endp
end
