.686 	           ; ��������� ���������� ���� �������������
.model flat,stdcall ; �������� ������ ����� ����� �� ����� �� Windows
option casemap:none          ; ��������� ����� �� ������� ����
include \masm32\include\windows.inc   ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib kernel32, user32,shell32,advapi32;
.data
Pr        dd ? ; ����� ���������� ��� �������������� ��������
lpClassName db 'Progman',0
explname  db 'c:\Windows\explorer.exe',0
shell db "Shell_TrayWnd",0 ; ��� ��� ������ ������ �����
startInfo dd ?
processInfo PROCESS_INFORMATION <> ; ���. ��� ������ � ���� �������� �����

.code
start:
; ���������� ��������
invoke FindWindow,offset lpClassName,0 ;��������� ���������� ���� �������� ������
invoke GetWindowThreadProcessId,eax,offset Pr ; ���������� ������� ������������� ������
invoke OpenProcess,PROCESS_TERMINATE,\;��������� �������
   0,Pr ; �������� ����������� ����������� �� ������������� �������
invoke TerminateProcess,eax,1
invoke Sleep,5000
; ��������� ��������
;invoke ShellExecute,eax,0,addr explname,0,0,SW_SHOWNORMAL
invoke CreateProcess,ADDR explname,0,0,0,FALSE,\
     NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo

 
invoke ExitProcess,0
end start
