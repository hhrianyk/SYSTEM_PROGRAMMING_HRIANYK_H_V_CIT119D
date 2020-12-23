.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc   ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32, user32;
.data
buff   db 100 dup(?)
;programname db  "c:\windows\system32\calc.exe",0
programname db  "Proc1.exe",0
titl   db   'Level 0',0
mask1  db   'My ProcID = %i (decimal)',0
startInfo dd ?
processInfo PROCESS_INFORMATION <> ; інформація про процес і його первинну нитку
.code
start:
invoke CreateProcess,ADDR programname,0,0,0,FALSE,\
  NORMAL_PRIORITY_CLASS, 0,0,ADDR startInfo,ADDR processInfo
     invoke  GetCurrentProcessId ; извлекает псевдодескриптор для текущего процесса
     invoke  wsprintf,addr buff,addr mask1,eax
     invoke  MessageBox,NULL,addr buff, addr titl,MB_ICONINFORMATION+180000h
     invoke  ExitProcess,0
end start 			; закінчення програми з ім’ям start