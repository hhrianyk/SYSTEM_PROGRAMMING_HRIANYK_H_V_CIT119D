.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32,user32,shell32,winmm;
.data ;	Директива	початку	сегменту	даних
_cmd_eject db 'set cdaudio door open',0 
_cmd_close db 'set cdaudio door closed',0 
_name db "- перемещение курсора;",0ah,0dh,\
         "- открытие и закрытие CD; ", 0ah,0dh,\
		 "- звуковые сигналы динамика; ", 0ah,0dh,\
         "- мигание светодиодов на клавиатуре ", 0
titl db 'Процессы',0 ; назва спрощеного вікна
IDI_ICON1 equ 1 ; іконка
hlnstance dd ? ;хендл програми
X DWORD ?	; координата	курсора
Y DWORD ?	; координата	курсора
h0 dd	?	; ідентифікатор потоку
h1 dd	?	; ідентифікатор потоку
h2 dd	?	; ідентифікатор потоку
h3 dd	?	; ідентифікатор потоку
hEventStart HANDLE ? ;хендл події
note NOTIFYICONDATA <>; структура, необхідна для іконки в трею
.code	
_st:
invoke MessageBox,NULL,ADDR _name, ADDR titl,MB_ICONINFORMATION 
invoke GetModuleHandle,0 ; 
mov hlnstance,eax	;
mov note.cbSize,sizeof NOTIFYICONDATA ; розмір структури 
mov note.hwnd,eax		; хендл вікна
mov note.uID,IDI_ICON1 	;
mov note.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP ; признаки структури
mov note.uCallbackMessage,0 
invoke LoadIcon,hlnstance,IDI_ICON1 ; завантаження іконки
mov note.hIcon,eax			;
invoke Shell_NotifyIcon,NIM_ADD,addr note ; додавання іконки в трей
lea EAX, _procCD 		    ; завантаження адреси процедури 
invoke CreateThread,0,0,eax,0,0,addr h0	; створити процес
lea EAX, _procMOUSE 		;завантаження адреси процедури 
invoke CreateThread,0,0,eax,0,0,addr h1	; створити процес
lea EAX, _procSPEAKER 	    ;завантаження адреси процедури 
invoke CreateThread,0,0,eax,0,0,addr h2	; створити процес
lea EAX, _procKEYBOARD 	    ; завантаження адреси процедури
invoke CreateThread,0,0,eax,0,0,addr h3	; створити процес
invoke CreateEvent,0,FALSE,FALSE,0	; створення події
mov hEventStart,eax		     ; збереження хендлу події
invoke WaitForSingleObject,\ ; очикування завершення процеса 
   hEventStart,5000	;
invoke ExitProcess,0	

_procCD proc	; процедура управління CD-npиводом
_CD: 
invoke mciSendString,addr _cmd_eject,0,0,0 ; відкрити CD
invoke Sleep, 1000	; чекати 1 ceкунду
invoke mciSendString,addr _cmd_close,0,0,0 ; закрити CD
jmp _CD 		;
_procCD endp	;

_procSPEAKER proc		;npoцeдypa управління системним динаміком
_SPK: 
invoke Beep, 1000,1000; частота 1 MГц та тривалість 1 секунда
invoke Sleep, 10	; чекати 0.01 ceкунду
jmp _SPK ;
_procSPEAKER endp	;

_procMOUSE proc ;  процедура управління мишкою
_MOUSE: 
invoke Sleep, 1	; 0.001 c
invoke SetCursorPos,X,Y ; встановлення курсора за координатами
inc X	;
inc Y	;
jmp _MOUSE ; 
_procMOUSE endp ;

_procKEYBOARD proc ; процедура управління світлодіодами
_KEYB:	
invoke keybd_event,VK_NUMLOCK, 1,0,0 ; натиснення клавіші NUMLOCK
invoke keybd_event,VK_SCROLL, 1,0,0  ; натиснення клавіші SCROLL LOCK
invoke keybd_event,VK_CAPITAL, 1,0,0 ; натиснення клавіші CAPSLOCK
invoke keybd_event,VK_NUMLOCK,1,KEYEVENTF_KEYUP,0 ; віджимання NUMLOCK
invoke keybd_event,VK_SCROLL, 1,KEYEVENTF_KEYUP,0 ; віджимання CROLL LOCK 
invoke keybd_event,VK_CAPITAL,1,KEYEVENTF_KEYUP,0 ; віджимання CAPSLOCK
invoke Sleep,500 ; чекання 0.5 ceкунди
jmp _KEYB ;
_procKEYBOARD endp ;
end _st