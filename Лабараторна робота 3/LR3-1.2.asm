include \masm64\include64\masm64rt.inc ; ����������

.data ;
;����� ��� MessageBox
title1 db "���.3-1.2 ������ � �������. masm64",0
txt1 db"����� �����: %hS",10,
"��� �����: %hS",10,
"������������ �����:C:\masm64\bin64\%hS",10,
"����� �����: %d byte",10,
"������� � �����: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0

_file1 db "Res_LR3-1.1A.txt",0; ���� ��� ������
hFile01 HANDLE ?   ; ��� ���������� �����
;������� ��� ��� ������
file01_pype db 'txt',0
file01_size dq ?
; ����������� ��� �������
title2 db "���������� �� ������",0
msg1 db "�������! ����  %hS  �� ��������!",0
buf dq 0

.code;c����� ����
entry_point proc

invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
mov hFile01,rax ; ���������� ����������� �����
.if hFile01 == INVALID_HANDLE_VALUE ; ���� CreateFile ���������� ������
invoke wsprintf,ADDR buf,ADDR msg1,addr _file1
  invoke MessageBox,0,addr buf,addr title2,0 ; ��������� �� ������
   ret
.endif
   invoke GetFileSize,hFile01,0 ; ��������� ������� ����� 01
   mov file01_size,rax; ����� ������
   
  invoke wsprintf,ADDR buf,ADDR txt1,addr _file1,ADDR file01_pype,ADDR _file1,file01_size,addr hFile01; ��������� ����� ��� MessageBox
  invoke MessageBox,0,ADDR buf,ADDR title1,MB_ICONINFORMATION ;��������� MessageBox

entry_point endp; ����� ������ �������
end