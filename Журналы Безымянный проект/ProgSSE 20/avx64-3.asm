title ��������� �.�.
; masm64. ����� � �{a1,a2,a3} ������ �������� 
; � ����� ����������� Real8. ��������� ��������� d/b sqrt(a) + a
include  \masm64\include64\masm64rt.inc; ������������ ����������
.data
arr1 real8 16.,25.,36.,1244. ; ������ ����� �
len1 equ LENGTHOF arr1       ; ($-arr1)/type arr1
arr2 real8 2.,4.,16.         ; b, c, d
tit1 db "masm64. AVX. ��������� ���������� ��������� d/b sqrt(a) + a.",0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������
ifmt db "masm64.  ������ ai = 16., 25., 36., 1244.",10,
9,"�����: b, c, d  := 2., 4., 16.",10,
"���������� ����������: ", 4 dup(" %d "),10,10,
"�����: ��������� �.�., ���. ���, ���. ���, ��� ���",10,
9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0
tit2 db "masm64.�������� ��������������� �� ��������� ������ AVX",0
szInf2 db "������� AVX ���������������� �� ��������������",0;
.code               ; ��������� d/b sqrt(a) + a
entry_point proc
; �������� �� ��������� AVX ������
mov EAX,1          ; ��� ������������� 64-��������� ��   
cpuid ; �� eax ������������ ������������� ��
and  ecx,10000000h ; e�x:= e�x v 1000 0000h  (28 ������)
jnz @1             ; �������, ���� �� ����
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION
jmp exit1
@1:
mov rcx,len1
lea rdx,res
lea rbx,arr1
vmovsd xmm1,arr2[0]  ; xmm1 - b - ��������� ������� �����
vmovsd xmm2,arr2[8]  ; xmm2 - c
vmovsd xmm3,arr2[16] ; xmm3 - d
vdivsd xmm3,xmm3,xmm1  ; d/b
@@:
vmovsd xmm0,qword ptr[rbx] ; xmm0 - a
vsqrtsd xmm4,xmm4,xmm0     ;sqrt(a)
vmulsd xmm4,xmm4,xmm3      ; d/b x sqrt(a)
vaddsd xmm4,xmm4,xmm0      ; d/b x sqrt(a) + a 
vcvttsd2si r15d,xmm4	 ; 
movsxd r15,r15d 
mov [rdx],r15d ; ���������� ����������
add rbx,8
add rdx,8
dec rcx
jnz @b ; ������ �� ���������� ����� @@ (������)
mov r10,res
mov r11,res[8]
mov r12,res[16]
mov r13,res[24]

invoke wsprintf,addr buf1,addr ifmt,r10,r11,r12,r13
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
exit1: 
invoke ExitProcess,0
entry_point endp
end