; ��������� ����������� ����������� ������� � ������������� ������� 
include \masm64\include64\masm64rt.inc
.data  
myXY POINT <>  ; ��������� ����������� �- � �-���������
cursor_rect RECT <>
titl db "���������� �������",0
buf db 50 dup(?),0
ifmt db "������� ���������� �������: X=  %d,  Y=  %d",0dh,0ah,0ah,
"����� ������� �� ������ <OK> �������������� ����������� ������� �� 10 �",0dh,0ah,
 "����� ���������:        �������, ��� ���",0
temp dd 0
.code 
entry_point proc
invoke GetCursorPos,addr myXY
invoke wsprintf,addr buf,addr ifmt,myXY.x,myXY.y ;
invoke MessageBox,0,addr buf,addr titl,MB_ICONINFORMATION
 mov cursor_rect.left,450
 mov cursor_rect.top,450
 mov cursor_rect.right,650
 mov cursor_rect.bottom,650
invoke ClipCursor,addr cursor_rect

fn Sleep,10000
 mov cursor_rect.left,0
 mov cursor_rect.top,0
invoke GetSystemMetrics,SM_CXSCREEN ; ��������� ������ ������ � ��������
 mov cursor_rect.right,eax
invoke GetSystemMetrics,SM_CYSCREEN ; ��������� ������ ������ � ��������
 mov cursor_rect.bottom,eax
invoke ClipCursor, addr cursor_rect
fn MessageBeep,MB_ICONHAND ; ���� "����������� ������" 
invoke ExitProcess, NULL  ; ������� ���������� Windows 
entry_point endp
   end