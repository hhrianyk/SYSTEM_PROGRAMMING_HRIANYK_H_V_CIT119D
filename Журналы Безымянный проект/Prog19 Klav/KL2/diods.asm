.686 	             ; директива определения типа микропроцессора
.model flat,stdcall  ;задание линейной модели памяти и соглашения ОС Windows
option casemap:none  ; отличие малых и больших букв
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
.data
    flag DWORD 0;
.code
 _st:
;.WHILE(flag==0)
	invoke keybd_event, VK_RETURN, 45, KEYEVENTF_EXTENDEDKEY , 0	;нажатие клавиши Enter
	invoke keybd_event, VK_RETURN, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;отжатие клавиши Утеук

	invoke keybd_event, VK_NUMLOCK, 45, KEYEVENTF_EXTENDEDKEY , 0	;нажатие клавиши NUMLOCK
	invoke keybd_event, VK_NUMLOCK, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;отжатие клавиши NUMLOCK

	invoke keybd_event, VK_SCROLL, 45, KEYEVENTF_EXTENDEDKEY , 0	;нажатие клавиши SCROLLLOCK
	invoke keybd_event, VK_SCROLL, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;отжатие клавиши SCROLLLOCK

	invoke keybd_event, VK_CAPITAL, 45, KEYEVENTF_EXTENDEDKEY , 0	;нажатие клавиши CAPSLOCK
	invoke keybd_event, VK_CAPITAL, 45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0	;отжатие клавиши CAPSLOCK
	;wait, 2000
	;inc flag
;.ENDW

  end _st	