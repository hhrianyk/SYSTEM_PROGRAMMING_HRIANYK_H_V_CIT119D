include \masm64\include64\masm64rt.inc ; ����������
err1 PROTO arg_a:QWORD
.data ;

mas1 dq 85,85,4,85,3,5,5,32,5,13,54,12,64,5   ;�����
a dq 55h                                       ;������ �����
_res dq 0;                                     ;��������
len1 dq 14 ; ���������� ���������� ���� � mas

;����� ��� MessageBox
title1 db "���.3-1.1 ������ � �������. masm64",0
txt1 db"K������� ��������, �������� ���� ������� 55h: %d",10,
"����� ����������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0
msg1 db "STOP!",10," � ����� ���� �������� ����� �� 3 �������� ������ �� ������, ���� �������� ����������.",10,"����������� ���������� � ����  ",0;�������
msg3 db "STOP!",10," � ����� ���� �������� ����� �� 3 �������� ������ �� ������, ���� �������� ����������.",10,"����������� ���������� � ����  ",0;�������


fName  BYTE "Res_LR3-1.1.txt",0;���� ��� ���������
fHandle dq ? ;        ��� ����� �����         
cWritten dq ? ;
BSIZE equ 120;����� ����� 
;��� ���������� �� ������
_file1 db "Res_LR3-1.1A.txt",0 ; ���� �� 
hFile01 HANDLE ?
from_file db 4096 dup(?)
read_by_file dq ?
write_by_file dq ?
file01_size dq ?
;���������� �� ������
title2 db "���������� �� ������",0
msg2 db "�������! ���� 'Res_LR3-1.1A' �� ��������!",0
buf dq 0

.code;c����� ����
entry_point proc

invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;������� �� ������ ���� �����

invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
mov hFile01,rax ; ���������� ����������� �����
.if hFile01 == INVALID_HANDLE_VALUE ; ���� CreateFile ���������� ������
  invoke MessageBox,0,addr msg2,addr title1,0 ; ��������� �� ������
   ret
.endif ; ���� ������������� ��������� �����  �� ���������� ��
   invoke GetFileSize,hFile01,0 ; ��������� ������� ����� 01
   mov file01_size,rax; 
   invoke ReadFile,hFile01,addr from_file,file01_size,addr read_by_file,0;��������� �����
  invoke MessageBox,0,addr from_file,addr title2,0 ; ������ MessageBox
  invoke err1,len1 ; ������ ���������


entry_point endp; ����� ������ ��������


err1 proc arg_a:QWORD; arg_a ���������� � rcx
lea rsi,mas1 	 ; ���������� ����� ������� marc 
mov r11,a

m1:  
movzx rax, word ptr [rsi] 
cmp rax,r11	; �������� ��������
jne m2 	; ���� �� ��� ,�� ������� �� m2

inc _res;+1 �� ����������
mov r14,_res

m2:  add rsi,8 ; �������� ������ ��� ������ ������ ��������
dec rcx 	   ; �������� �������� ������� ����� mas1

 cmp _res,3   ; ��������� ���������
 jle m3       ;������� ��  m3, ���� <=3
 
 ;����� ��������������������� ��� ������� �� ���������� ����� � ����
     invoke wsprintf,ADDR buf1,ADDR msg1
     invoke WriteFile,fHandle,ADDR buf1,BSIZE ,ADDR cWritten,0
     invoke CloseHandle,fHandle
     invoke MessageBox,0,addr msg3,addr title1,0 ; ��������� �� ������

 ret           ; ����� � ��������

m3:cmp rcx,0      ;
jnz m1 		; ������� ��  m1, ���� �� ����
;����� ���������� ����������� ��� ������ ���������� ������ �������� �� ���������� ����� � ����
  invoke wsprintf,ADDR buf1,ADDR txt1,_res,ADDR _res
  invoke WriteFile,fHandle,ADDR buf1,BSIZE ,ADDR cWritten,0
  invoke CloseHandle,fHandle

  invoke wsprintf,ADDR buf1,ADDR txt1,_res,ADDR _res
  invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION ;��������� MessageBox


ret
err1 endp ;����� ������ ��������
   end