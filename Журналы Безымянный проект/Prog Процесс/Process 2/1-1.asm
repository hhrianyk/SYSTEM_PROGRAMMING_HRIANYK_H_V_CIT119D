.686 	           ; ��������� ���������� ���� �������������
.model flat,stdcall ; �������� ����� ����� ����� �� ����� �� Windows
option casemap:none          ; �������� ����� �� ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib kernel32,user32 
.data
st1 db "������� ��������",0         ; ����� ��������� �����������
titl db "������ MessageBox",0
 .code 			          	; ��������� ���������� �����
 start:
  invoke MessageBox, \ 	         ; �в-������� ��������� ���� ������
 NULL, \ 			              ; hwnd � ������������� ����
  addr st1, \ 	      ; ������ �����, ��� ������  ����� �����������
   addr titl, \            ; ������ �����, ��� ������  ��������� �����������
     MB_ICONINFORMATION+180000h           ; ������ ����
invoke ExitProcess, 0 ; ���������� ��������� �� Windows �� ���������� �������
end start 	        ; ��������� ��������� �������� � ������ start

