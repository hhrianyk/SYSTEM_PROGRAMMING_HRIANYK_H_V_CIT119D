.686 	           ; директива определения типа микропроцессора
.model flat,stdcall ; задание линейной модели памяти и соглашения ОС Windows
option casemap:none  ; отличие малых и больших букв
include \masm32\include\windows.inc ; файлы структур, констант
include \masm32\macros\macros.asm
uselib kernel32,user32 
.data
st1 db "Внимание! Процесс активный",0         ; буфер вывода сообщения
titl db "Просто MessageBoxTimeout",0
 .code 	          	
 start:
  invoke MessageBoxTimeout,0,addr st1,addr titl,MB_ICONINFORMATION,0,9000           
invoke ExitProcess, 0 ; возвращение управления ОС Windows и освобождение ресурсов
end start 	        ; директива окончания программы с именем start


