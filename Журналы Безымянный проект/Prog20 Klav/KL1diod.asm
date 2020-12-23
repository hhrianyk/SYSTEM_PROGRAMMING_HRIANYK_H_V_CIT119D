include \masm64\include64\masm64rt.inc ; библиотеки
.code
entry_point proc
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши Enter
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши Enter
  invoke Sleep,200
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши NUMLOCK
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0
;отжатие клавиши NUMLOCK
invoke Sleep,200
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши CAPSLOCK
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши CAPSLOCK
invoke Sleep,200
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши SCROLLLOCK
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши SCROLLLOCK

invoke Sleep,500
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши Enter
invoke keybd_event,VK_RETURN,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши Enter
  invoke Sleep,200
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши NUMLOCK
invoke keybd_event,VK_NUMLOCK,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0
;отжатие клавиши NUMLOCK
invoke Sleep,200
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши CAPSLOCK
	invoke keybd_event,VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши CAPSLOCK
invoke Sleep,200
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY,0;нажатие клавиши SCROLLLOCK
	invoke keybd_event,VK_SCROLL,45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0;отжатие клавиши SCROLLLOCK
invoke ExitProcess,0
entry_point endp
end	