.686 	           ; ��������� ���������� ���� �������������
.model flat,stdcall ; �������� ������ ����� ����� �� ����� �� Windows
option casemap:none          ; ��������� ����� �� ������� ����
include \masm32\include\windows.inc   ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib kernel32, user32,shell32,advapi32;
.data
P        dd ? ; ����� ���������� ��� �������������� ��������
lpClassName db 'Progman',0
explname  db 'explorer.exe',0
.code
start:
; ���������� ��������
invoke FindWindow,offset lpClassName,0 ;��������� ���������� ���� �������� ������
invoke GetWindowThreadProcessId,eax,offset P ; ���������� ������� ������������� ������
invoke OpenProcess,PROCESS_TERMINATE,\;��������� �������
   0,P ; �������� ����������� ����������� �� ������������� �������
invoke TerminateProcess,eax,1
; ��������� ��������
invoke ShellExecute,0,0,addr explname,0,0,SW_SHOWNORMAL
invoke ExitProcess,0
end start
