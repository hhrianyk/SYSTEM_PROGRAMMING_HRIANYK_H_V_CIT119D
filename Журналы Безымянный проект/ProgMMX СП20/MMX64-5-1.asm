; ������������ �������� � ������� ���-������ ��� ��������� ����� �����.
; ���� ������ ����� ������ 55, �� ��������� ��������
; a - c/b - dc  (-4,83), �� a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; ����� - ��������� �������� a-c/b   (2,43)
include \masm64\include64\masm64rt.inc
IDI_ICON  EQU 1001
MSGBOXPARAMSA STRUCT
   cbSize          DWORD ?,?
   hwndOwner       QWORD ?
   hInstance       QWORD ?
   lpszText        QWORD ?
   lpszCaption     QWORD ?
   dwStyle         DWORD ?,?
   lpszIcon        QWORD ?
   dwContextHelpId QWORD ?
   lpfnMsgBoxCallback QWORD ?
   dwLanguageId       DWORD ?,?
MSGBOXPARAMSA ENDS

fpuDiv macro _a,_c,_b ; ������ � ������ fpuDiv
    fld _c
    fdiv _b
    fld _a
    fsubr
endm 	;; ��������� �������
.data

params MSGBOXPARAMSA <>         			
    _a REAL4 2.8
    _b REAL4 8.05
    _c REAL4 2.2
    _d REAL4 3.3
    arr1 dw 1,2,3,4          ; ������ ����� arr1 �������� � �����
    len1 equ ($-arr1)/type arr1  ; ���������� ����� �������
    arr2 dw 5,6,7,5 	       ; ������ ����� arr2 �������� � �����
    len2 equ ($-arr2)/type arr2    ; ���������� ����� �������
    arr1_2 dw len1 dup(0) ; ������ ������ ��� ����� ��������
    tit1 db "masm64. O������� MMX-FPU",0  ; �������� ������
    st2 dd 0 	        ; ����� ����� ��� ������ ���������
    buf1 db 0,0
ifmt db "������������ �������� � ������� ���-������ ��� ��������� ����� �����.",10,
"���� ������ ����� ������ 55, �� ��������� ��������:",10,
"a - c/b - dc  (-4,83), ��� a = 2,7; b = 8,05; c = 2,2; d = 3,3;",10,
"����� - ��������� �������� a - c/b   (2,43)",10,10,"����� =  %d ",10,10,
"�����: ��������� �.�., ���. ���, ���. ���, ��� ���",10,
9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0
len11 equ ($-ifmt)/type ifmt

.code 
entry_point proc
  movq MM1,QWORD PTR arr1 ; �������� ������� ����� arr1
  movq MM2,QWORD PTR arr2 ; �������� ������� ����� arr2
  paddw MM1,MM2     ; ������������ ����������� ��������
  movq QWORD PTR arr1_2,MM1 ; ���������� ����������
pextrw eax,MM1,1 ; ����������� ������� ����� �������� ����� � eax
 cmp eax,55
 jg @1 ; if >
 jmp @2
@1: emms ; ��������� ���-������� - ������������ ������������
 fpuDiv [_a],[_c],[_b]
 fld _d
 fmul _c
 fsub
 fisttp st2; ���������� �������������� �������� � ���������� � ������� ����
 invoke wsprintf,ADDR buf1,ADDR ifmt,st2
 
   mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
    mov params.hwndOwner,0    ; ���������� ���� ���������
   invoke GetModuleHandle,0   ; ��������� ����������� ���������
    mov params.hInstance,rax  ; ���������� ����������� ���������
        lea rax, buf1       ; ����� ���������
    mov params.lpszText,rax   
        lea rax,tit1 ;Caption ; ����� �������� ����
    mov params.lpszCaption,rax     
    mov params.dwStyle,MB_USERICON ; ����� ����
    mov params.lpszIcon,IDI_ICON   ; ������ ������
    mov params.dwContextHelpId,0  ; �������� �������
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ���� ���������
        lea rcx,params
   invoke MessageBoxIndirect
    ;  invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
jmp @3
@2: emms
    fpuDiv [_a],[_c],[_b]
	fisttp st2 ; ���������� �������������� �������� � ���������� � ������� ����
   invoke wsprintf,ADDR buf1,ADDR ifmt,st2
  
   mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
    mov params.hwndOwner,0    ; ���������� ���� ���������
   invoke GetModuleHandle,0   ; ��������� ����������� ���������
    mov params.hInstance,rax  ; ���������� ����������� ���������
        lea rax, buf1       ; ����� ���������
    mov params.lpszText,rax   
        lea rax,tit1 ;Caption ; ����� �������� ����
    mov params.lpszCaption,rax     
    mov params.dwStyle,MB_USERICON ; ����� ����
    mov params.lpszIcon,IDI_ICON   ; ������ ������
    mov params.dwContextHelpId,0  ; �������� �������
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ���� ���������
        lea rcx,params
   invoke MessageBoxIndirect
     ;invoke MessageBox,0,addr buf1,addr tit1,MB_ICONQUESTION
@3:
.data
fmt2 db 3 dup("%x "),0    ; ������ ��������������
fName db "MMX64-5-1.txt",0
hFile dq ?
buf2 db 3 dup(0); 
fHandle dq ? ;
cWritten dq ? ;
BSIZE equ 338
fName2 BYTE "notepad C:\masm64\bin64\MMX64-5-1.txt",0 ; ��� �����
  
.code
invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE,0
mov hFile,rax

invoke WriteFile,hFile,ADDR buf1,BSIZE,ADDR cWritten,0
invoke CloseHandle,hFile

invoke WinExec,addr fName2,SW_SHOW
invoke ExitProcess,0
entry_point endp
end	
