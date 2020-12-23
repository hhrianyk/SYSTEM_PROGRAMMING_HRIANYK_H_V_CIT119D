; masm64. ����� � �{a1,a2,a3} �������� �������� 
; � ����� ����������� Real8.  ��������� ��������� d/b sqrt(a) + a
include \masm64\include64\masm64rt.inc
IDI_ICON  EQU 1001    ; ������������� ������
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
.data
 params MSGBOXPARAMSA <>
 
arr1 real8 16.,25.,36.,1244. ; ������ ����� �
len1 equ ($-arr1)/type arr1
arr2 real8 2.,4.,16.       ; b, c, d
tit1 db "masm64. ��������� ������������ ���������� ���������. SSE2. ",0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������
ifmt db "masm64. d/b sqrt(a) + a",10,10, "������ ai: 16., 25., 36., 1244.",10,
9,"�����: b, c, d  := 2., 4., 16.",10,
"���������� ����������: %d ,%d ,%d ,%d ",10,10,
"�����: ��������� �.�., ���. ���, ���. ���, ��� ���",10,
9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0

.code               ; ��������� d/b sqrt(a) + a
entry_point proc
mov rcx,len1
lea rdx,res
lea rbx,arr1
movsd xmm1,arr2[0]   ; xmm1 - b - ��������� ������� �����
movsd xmm2,arr2[8]   ; xmm2 - c
movsd xmm3,arr2[16]  ; xmm3 - d
divsd xmm3,xmm1      ; d/b
@@:
movsd xmm0,qword ptr[rbx] ; xmm0 - a
sqrtsd xmm4,xmm0     ;sqrt(a)
mulsd xmm4,xmm3      ; d/b x sqrt(a)
addsd xmm4,xmm0      ; d/b x sqrt(a) + a 
cvttsd2si eax,xmm4	 ; 
movsxd r15,eax 
mov [rdx],eax ; ���������� ����������
add rbx,8
add rdx,8

dec rcx
jnz @b

mov r10,res
mov r11,res[8]
mov r12,res[16]
mov r13,res[24]

invoke wsprintf,addr buf1,addr ifmt,r10,r11,r12,r13
;invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION

   mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
    mov params.hwndOwner,0    ; ���������� ���� ���������
   invoke GetModuleHandle,0   ; ��������� ����������� ���������
    mov params.hInstance,rax  ; ���������� ����������� ���������
        lea rax, buf1       ; !!! ����� ���������
    mov params.lpszText,rax   
        lea rax,tit1        ;!!!Caption ; ����� �������� ����
    mov params.lpszCaption,rax     
    mov params.dwStyle,MB_USERICON ; ����� ����
    mov params.lpszIcon,IDI_ICON   ; ������ ������
    mov params.dwContextHelpId,0  ; �������� �������
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ���� ���������
        lea rcx,params
   invoke MessageBoxIndirect
invoke ExitProcess,0
entry_point endp
end	