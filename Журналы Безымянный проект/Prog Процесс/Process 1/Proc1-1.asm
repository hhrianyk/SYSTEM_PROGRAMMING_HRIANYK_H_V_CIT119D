.686  ; директива определения типа микропроцессора
.model flat,stdcall ; задание линейной модели памяти и соглашения ОС Windows
option casemap:none ; отличие малых и больших букв
include \masm32\include\windows.inc ; файлы структур, констант
include \masm32\macros\macros.asm
uselib kernel32, user32;
.data
buff dd 0   ;
;programname db  "c:\windows\system32\calc.exe",0
programname db  "1-1.exe",0
titl   db   'Level 0',0
mask1  db   'My ProcID = %i (decimal)',0
startInfo dd ?
processInfo PROCESS_INFORMATION <> ; информация о процессе и его первичной нити
.code
start:
invoke CreateProcess,ADDR programname,0,0,0,FALSE,\
  NORMAL_PRIORITY_CLASS, 0,0,ADDR startInfo,ADDR processInfo
     invoke  GetCurrentProcessId ; извлекает псевдодескриптор для текущего процесса
     invoke  wsprintf,addr buff,addr mask1,eax
     invoke  MessageBox,0,addr buff,addr titl,MB_ICONINFORMATION+180000h
     invoke  ExitProcess,0
end start ; окончание программы с именем start