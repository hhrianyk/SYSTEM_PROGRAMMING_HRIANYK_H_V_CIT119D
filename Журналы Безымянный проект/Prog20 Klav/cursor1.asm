include \masm64\include64\masm64rt.inc
.data  
myXY POINT <>  ; ��������� ����������� �- � �-��������� �����
titl db "���������� �������",0
buf db 50 dup(?),0
ifmt db "������� ���������� �������: X=  %d,  Y=  %d",0dh,0ah,0ah,
 "����� ���������:        �������, ��� ���",0
temp dd 0
.code 
entry_point proc
 invoke GetCursorPos, addr myXY ; ��������� ��������� �������
 invoke  wsprintf, ADDR buf, \ ; ����� ������, ���� ����� �������� ������������������ ��������
  ADDR ifmt, myXY.x,myXY.y ; ����� ������ �������������� ������� 
 invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
 invoke GetSystemMetrics,SM_CXSCREEN ; ��������� ������ ������ � ��������
mov temp,eax
xor esi,esi
m1:
invoke SetCursorPos,esi,0 ; ��������� ������� �� ������������
invoke Sleep,50 ; ��������
add esi,20          ; ���������� ����������
cmp temp,esi     ; ��������� � ������������ �����������
jge  m1  ; ���� temp > esi
invoke GetSystemMetrics,SM_CYSCREEN ; ��������� ������ ������ � ��������
invoke SetCursorPos,0,eax ; ��������� �������  �� ������������
fn MessageBeep,MB_ICONEXCLAMATION ; ���� "�����������"
invoke ExitProcess, NULL ; ����������� ���������� Windows  
entry_point endp
   end

