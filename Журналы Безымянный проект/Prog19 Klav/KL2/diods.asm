.686 	             ; ��������� ����������� ���� ���������������
.model flat,stdcall  ;������� �������� ������ ������ � ���������� �� Windows
option casemap:none  ; ������� ����� � ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
.data
    flag DWORD 0;
.code
 _st:
;.WHILE(flag==0)
	invoke keybd_event, VK_RETURN, 45, KEYEVENTF_EXTENDEDKEY , 0	;������� ������� Enter
	invoke keybd_event, VK_RETURN, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;������� ������� �����

	invoke keybd_event, VK_NUMLOCK, 45, KEYEVENTF_EXTENDEDKEY , 0	;������� ������� NUMLOCK
	invoke keybd_event, VK_NUMLOCK, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;������� ������� NUMLOCK

	invoke keybd_event, VK_SCROLL, 45, KEYEVENTF_EXTENDEDKEY , 0	;������� ������� SCROLLLOCK
	invoke keybd_event, VK_SCROLL, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;������� ������� SCROLLLOCK

	invoke keybd_event, VK_CAPITAL, 45, KEYEVENTF_EXTENDEDKEY , 0	;������� ������� CAPSLOCK
	invoke keybd_event, VK_CAPITAL, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;������� ������� CAPSLOCK
	;wait, 2000
	;inc flag
;.ENDW

  end _st	