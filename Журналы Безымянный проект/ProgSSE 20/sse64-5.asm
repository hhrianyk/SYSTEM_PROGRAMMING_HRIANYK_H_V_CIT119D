include \masm64\include64\masm64rt.inc
DATE1 STRUCT ; ��������� � ������ Date1
a1 dd ?	; ��� ������� ���� ���������  
a2 dd ?	; ��� ������� ���� ���������  
a3 dd ? ; ��� �������� ���� ���������  
a4 dd ?	; ��� ���������� ���� ���������  
DATE1 ENDS ; ��������� ���������

.data
  Car1  DATE1 <1.1,2.2,3.3,4.4> ; ��������� � ������ Car1
  titl1 db '�������� 1-�� � 4-�� ��������� ������� <1.1,2.2,3.3,4.4>',0
fmt db "��������� -   %d",10,10,
"��������� ������� cvtss2si - ������������ ������ �������� � �� ��������� �������� ", 
"� 32-��������� ����� �����", 10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
buf1 db 0
.code          			       ; 
entry_point proc
movss XMM0,Car1.a1
addss XMM0,Car1.a4
;movss res,XMM0
cvttss2si eax,xmm0
;fld res
;fisttp res1
invoke wsprintf,addr buf1,addr fmt,eax;res1  
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0	
entry_point endp
end	