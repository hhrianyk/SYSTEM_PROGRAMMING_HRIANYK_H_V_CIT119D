:: ����� ������������� ����� �� �����
@echo off
:: ��������� ����������
set appname=%1
\masm64\bin64\ml64.exe /c %appname%.asm
\masm64\bin64\rc.exe %appname%.rc
\masm64\bin64\link.exe /SUBSYSTEM:WINDOWS /ENTRY:entry_point ^
/nologo /LARGEADDRESSAWARE:NO %appname%.obj %appname%.res
:: ����� ������ ������
dir %appname%.*
:: �������� ����� *.obj
del %appname%.obj
del %appname%.res
pause