; ����� ���� �������
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
invoke GetCursorPos,addr myXY
invoke wsprintf,ADDR buf,ADDR ifmt,myXY.x,myXY.y 
invoke MessageBox,0,addr buf,addr titl,MB_ICONINFORMATION
   invoke LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; ������� ������-�������
  invoke  Sleep,5000
  fn MessageBeep,MB_ICONEXCLAMATION ; ���� "�����������"
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; ������� ������-�������
invoke ExitProcess, NULL ; ������� ���������� Windows 
entry_point endp
   end
