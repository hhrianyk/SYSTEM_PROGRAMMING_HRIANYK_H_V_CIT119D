.686    ; ��������� ����������� ���� ���������������
.model  flat, stdcall  ; ������� �������� ������ ������ � ���������� �� Windows
option casemap:none       ; ������� ����� � �������  ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32
.data  
myXY POINT <>  ; ��������� ����������� �- � �-��������� �����
ccc CURSORINFO <>
titl db "���������� �������",0
buf db 50 dup(?),0
ifmt db "������� ���������� �������: X=  %d,  Y=  %d",0dh,0ah,0ah,
 "����� ���������:        �������, ��� ���",0
temp dd 0
.code 
_st: 
invoke GetCursorPos, addr myXY
invoke  wsprintf, ADDR buf, ADDR ifmt, myXY.x,myXY.y 
invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; ������� ������-�������
  invoke  Sleep,10000
  fn MessageBeep,MB_ICONEXCLAMATION ; ���� "�����������"
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; ������� ������-�������

            invoke GetCursorInfo,addr ccc;  ������
            mov ccc.flags, 0 
			invoke  Sleep,10000
           
invoke ExitProcess, NULL ; ������� ���������� Windows 
end _st ; ��������� ��������� ���������
