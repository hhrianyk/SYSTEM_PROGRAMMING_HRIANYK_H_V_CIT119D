.686 	           ; директива определения типа микропроцессора
.model flat,stdcall ; задание линейной модели памяти и соглашения ОС Windows
option casemap:none          ; отличие малых и больших букв
include \masm32\include\windows.inc ; файлы структур, констант …
include \masm32\macros\macros.asm
uselib kernel32,user32 
.data
st1 db "Процесс активный",0  ; буфер для вывода сообщения
titl db "Просто MessageBox",0
 .code 			          	;
 start:
  invoke MessageBox,0,addr st1,addr titl, MB_ICONINFORMATION+180000h;
invoke ExitProcess, 0 ; 
end start 	        ; 

