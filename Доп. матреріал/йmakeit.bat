:: ����� ������������� ����� �� �����
@echo off
:: ��������� ����������
set appname=%1

\masm64\bin64\ml64.exe /c %appname%.asm

\masm64\bin64\link.exe /SUBSYSTEM:WINDOWS /MACHINE:X64 /ENTRY:entry_point /nologo /LARGEADDRESSAWARE %appname%.obj

:: ����� ������ ������ 
dir %appname%.*

:: �������� ����� *.obj
del %appname%.obj
pause