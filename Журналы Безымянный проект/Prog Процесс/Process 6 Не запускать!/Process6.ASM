.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc   ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32, user32,shell32,advapi32;
.data
P        dd ? ; адрес переменной для идентификатора процесса
lpClassName db 'Progman',0
explname  db 'explorer.exe',0
.code
start:
; отключение оболочки
invoke FindWindow,offset lpClassName,0 ;извлекает дескриптор окна верхнего уровня
invoke GetWindowThreadProcessId,eax,offset P ; возвращает обратно идентификатор потока
invoke OpenProcess,PROCESS_TERMINATE,\;прапорець доступу
   0,P ; параметр дескриптора спадкоємства та ідентифікатор процесу
invoke TerminateProcess,eax,1
; включение оболочки
invoke ShellExecute,0,0,addr explname,0,0,SW_SHOWNORMAL
invoke ExitProcess,0
end start
