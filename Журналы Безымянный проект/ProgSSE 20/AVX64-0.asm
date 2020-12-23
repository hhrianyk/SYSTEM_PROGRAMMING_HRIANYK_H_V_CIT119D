OPTION DOTNAME       ; ��������� � ���������� ������� ����������
option casemap:none ; ���������, ��������� ������� ����, �������� �������������
include \masm64\include64\win64.inc   ; �������� ���� ��������
include \masm64\macros64\macros64.inc ; ��������������� �������
    STACKFRAME                        ; ������� ������ ����� �� ���������
include \masm64\include64\kernel32.inc
include \masm64\include64\user32.inc
includelib \masm64\lib64\kernel32.lib
includelib \masm64\lib64\user32.lib
;include \masm64\include64\masm64rt.inc; ������������ ����������
.data 
titl db "�������� ��������������� �� ��������� ������ AVX",0 ; �������� ���� 
szInf db "������� AVX ��������������!!!",0  ; 
inf db "������� AVX ���������������� �� ��������������",0
.code
entry_point proc
mov   rax,1	
cpuid ; �� ����������� rax ������������ ������������� ���������������
and  rcx,10000000h ; r�x:= r�x v 1000 0000h  (28 ������)
jnz  exit1       ; ������� �� exit, ���� �� ����
invoke MessageBox,0,addr inf,addr titl,MB_OK  
jmp exit2
exit1: 
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION
exit2:
invoke ExitProcess,0
entry_point endp
end
