.686 	           ; ��������� ���������� ���� �������������
.model flat,stdcall ; �������� ����� ����� ����� �� ����� �� Windows
option casemap:none          ; �������� ����� �� ������� ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib kernel32,user32,shell32,winmm;
.data ;	���������	�������	��������	�����
_cmd_eject db 'set cdaudio door open',0 
_cmd_close db 'set cdaudio door closed',0 
_name db "- ����������� �������;",0ah,0dh,\
         "- �������� � �������� CD; ", 0ah,0dh,\
		 "- �������� ������� ��������; ", 0ah,0dh,\
         "- ������� ����������� �� ���������� ", 0
titl db '��������',0 ; ����� ���������� ����
IDI_ICON1 equ 1 ; ������
hlnstance dd ? ;����� ��������
X DWORD ?	; ����������	�������
Y DWORD ?	; ����������	�������
h0 dd	?	; ������������� ������
h1 dd	?	; ������������� ������
h2 dd	?	; ������������� ������
h3 dd	?	; ������������� ������
hEventStart HANDLE ? ;����� ��䳿
note NOTIFYICONDATA <>; ���������, ��������� ��� ������ � ����
.code	
_st:
invoke MessageBox,NULL,ADDR _name, ADDR titl,MB_ICONINFORMATION 
invoke GetModuleHandle,0 ; 
mov hlnstance,eax	;
mov note.cbSize,sizeof NOTIFYICONDATA ; ����� ��������� 
mov note.hwnd,eax		; ����� ����
mov note.uID,IDI_ICON1 	;
mov note.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP ; �������� ���������
mov note.uCallbackMessage,0 
invoke LoadIcon,hlnstance,IDI_ICON1 ; ������������ ������
mov note.hIcon,eax			;
invoke Shell_NotifyIcon,NIM_ADD,addr note ; ��������� ������ � ����
lea EAX, _procCD 		    ; ������������ ������ ��������� 
invoke CreateThread,0,0,eax,0,0,addr h0	; �������� ������
lea EAX, _procMOUSE 		;������������ ������ ��������� 
invoke CreateThread,0,0,eax,0,0,addr h1	; �������� ������
lea EAX, _procSPEAKER 	    ;������������ ������ ��������� 
invoke CreateThread,0,0,eax,0,0,addr h2	; �������� ������
lea EAX, _procKEYBOARD 	    ; ������������ ������ ���������
invoke CreateThread,0,0,eax,0,0,addr h3	; �������� ������
invoke CreateEvent,0,FALSE,FALSE,0	; ��������� ��䳿
mov hEventStart,eax		     ; ���������� ������ ��䳿
invoke WaitForSingleObject,\ ; ���������� ���������� ������� 
   hEventStart,5000	;
invoke ExitProcess,0	

_procCD proc	; ��������� ��������� CD-np������
_CD: 
invoke mciSendString,addr _cmd_eject,0,0,0 ; ������� CD
invoke Sleep, 1000	; ������ 1 ce�����
invoke mciSendString,addr _cmd_close,0,0,0 ; ������� CD
jmp _CD 		;
_procCD endp	;

_procSPEAKER proc		;npo�e�ypa ��������� ��������� ��������
_SPK: 
invoke Beep, 1000,1000; ������� 1 M�� �� ��������� 1 �������
invoke Sleep, 10	; ������ 0.01 ce�����
jmp _SPK ;
_procSPEAKER endp	;

_procMOUSE proc ;  ��������� ��������� ������
_MOUSE: 
invoke Sleep, 1	; 0.001 c
invoke SetCursorPos,X,Y ; ������������ ������� �� ������������
inc X	;
inc Y	;
jmp _MOUSE ; 
_procMOUSE endp ;

_procKEYBOARD proc ; ��������� ��������� �����������
_KEYB:	
invoke keybd_event,VK_NUMLOCK, 1,0,0 ; ���������� ������ NUMLOCK
invoke keybd_event,VK_SCROLL, 1,0,0  ; ���������� ������ SCROLL LOCK
invoke keybd_event,VK_CAPITAL, 1,0,0 ; ���������� ������ CAPSLOCK
invoke keybd_event,VK_NUMLOCK,1,KEYEVENTF_KEYUP,0 ; ��������� NUMLOCK
invoke keybd_event,VK_SCROLL, 1,KEYEVENTF_KEYUP,0 ; ��������� CROLL LOCK 
invoke keybd_event,VK_CAPITAL,1,KEYEVENTF_KEYUP,0 ; ��������� CAPSLOCK
invoke Sleep,500 ; ������� 0.5 ce�����
jmp _KEYB ;
_procKEYBOARD endp ;
end _st