.686 	           ; ��������� ����������� ���� ���������������
.model flat,stdcall ; ������� �������� ������ ������ � ���������� �� Windows
option casemap:none  ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, ��������
include \masm32\macros\macros.asm
uselib kernel32,user32 
.data
st1 db "��������! ������� ��������",0         ; ����� ������ ���������
titl db "������ MessageBoxTimeout",0
 .code 	          	
 start:
  invoke MessageBoxTimeout,0,addr st1,addr titl,MB_ICONINFORMATION,0,9000           
invoke ExitProcess, 0 ; ����������� ���������� �� Windows � ������������ ��������
end start 	        ; ��������� ��������� ��������� � ������ start


