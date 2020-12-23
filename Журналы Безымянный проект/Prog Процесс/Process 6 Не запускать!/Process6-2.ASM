.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc   ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32, user32,shell32,advapi32;
.data
Pr        dd ? ; адрес переменной для идентификатора процесса
lpClassName db 'Progman',0
explname  db 'c:\Windows\explorer.exe',0
shell db "Shell_TrayWnd",0 ; это имя класса панели задач
startInfo dd ?
processInfo PROCESS_INFORMATION <> ; інф. про процес і його первинну нитку

.code
start:
; отключение оболочки
invoke FindWindow,offset lpClassName,0 ;извлекает дескриптор окна верхнего уровня
invoke GetWindowThreadProcessId,eax,offset Pr ; возвращает обратно идентификатор потока
invoke OpenProcess,PROCESS_TERMINATE,\;прапорець доступу
   0,Pr ; параметр дескриптора спадкоємства та ідентифікатор процесу
invoke TerminateProcess,eax,1
invoke Sleep,5000
; включение оболочки
;invoke ShellExecute,eax,0,addr explname,0,0,SW_SHOWNORMAL
invoke CreateProcess,ADDR explname,0,0,0,FALSE,\
     NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo

 
invoke ExitProcess,0
end start
