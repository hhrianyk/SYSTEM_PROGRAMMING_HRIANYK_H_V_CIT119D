include \masm64\include64\masm64rt.inc ; ����������
.code
entry_point proc
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� Enter
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� Enter
  invoke Sleep,200
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� NUMLOCK
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0
;������� ������� NUMLOCK
invoke Sleep,200
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� CAPSLOCK
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� CAPSLOCK
invoke Sleep,200
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� SCROLLLOCK
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� SCROLLLOCK

invoke Sleep,500
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� Enter
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� Enter
  invoke Sleep,200
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� NUMLOCK
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0
;������� ������� NUMLOCK
invoke Sleep,200
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� CAPSLOCK
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� CAPSLOCK
invoke Sleep,200
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY,0;������� ������� SCROLLLOCK
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;������� ������� SCROLLLOCK
invoke ExitProcess,0
entry_point endp
end	