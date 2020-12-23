@echo off

set appname=23

del %appname%.obj
del %appname%.exe

\masm32\bin64\ml64.exe /c /nologo %appname%.asm
\masm32\bin64\link.exe /SUBSYSTEM:WINDOWS /ENTRY:entry_point /nologo /LARGEADDRESSAWARE %appname%.obj 

dir %appname%.*
pause