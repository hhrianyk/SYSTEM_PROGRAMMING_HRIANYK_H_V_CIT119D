include \masm64\include64\masm64rt.inc ; ����������
;count PROTO arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD,arg_e:QWORD, arg_f:QWORD

.data ; 
a1 dq 4   ; ������� �1 ������������ 64 ������� ��������� 2
b1 dq 16   ; ������� b1 ������������ 64 ������� ;�������  d 
c1 dq 32  ; ������� c1 ������������ 64 �������;�������  c
d1 dq 64  ; ������� d1 ������������ 64 ������� ;�������  d
e1 dq 128  ; ������� e1 ������������ 64 ������� ;�������  e
f1 dq 256  ; ������� f1 ������������ 64 ������� ;�������  f

res1 dq -2097144 ; ������� res1 ������������ 64 �������; ����� �������
_res dq 0
_res1 dq 0
_res2 dq 0
_res3 dq 0

;����� ��� MessageBox
title1 db "���.2-1 ������� �����. masm64",0
txt1 db "г������  e/b + a/c � d*e*f",10,
"����: a=%d, b=%d, c=%d, d=%i, e=%d, f=%d",10,10,
"��������� ��������� �����. ������: %d",0ah,"����� �����: %d",0ah,"����� ����� � ������: %ph",10,10,
"��������� ��������� ������ �����: %d",0ah,"����� �����: %d",0ah,"����� ����� � ������: %ph",10,10,
"���������(����������): %d",10,"����� ����� � ������: %ph",10,10,
"�����: ������ �.�., ��.ʲ�-119�",0
buf1 dq 3 dup(0),0

.code;c����� ����
 
count proc arga:QWORD,argb:QWORD,argc:QWORD,argd:QWORD,arge:QWORD,argf:QWORD
rdtsc 
xchg rdi,rax
mov rax,[rbp]  ; ������������ ; ������� � x64dbg ���������� [rbp]
mov rax,[rbp+10h]  ; a1; 
mov rax,[rbp+18h]  ; b1 
mov rax,[rbp+20h]  ; c1
mov rax,[rbp+28h]  ; d1
mov rax,[rbp+30h]  ; e1
mov rax,[rbp+38h]  ; f1

mov r10,[rbp+18h]   ;������� � r10 b1
mov rax,[rbp+30h]  ; e1
mov rdx,0          ; �������� ���� rdx
div  r10           ; e/d
mov _res,rax;      ; save result

mov rax, rcx       ; ������� � � rax
div r8             ; ������� �� �
add _res,rax       ; e/b + a/c 

mov rax,r9        ; ������� � v rax
mov r8,[rbp+30h]  ; e1
mov r9,[rbp+38h]  ; f1
mul r8            ; d*e
mul r9            ; d*e*f
sub _res,rax      ; e/b + a/c � d*e*f


rdtsc ; ��������� ����� ������
sub rax,rdi ; ��������� �� ���������� ����� ������ ����������� �����
mov _res1,rax

ret
count endp;;;�������� 1 �����


count2 proc arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD,arg_e:QWORD,arg_f:QWORD;;;�������� 2
rdtsc
xchg rdi,rax

mov rax ,[rbp+30h] ; ������� � r10 rax
sar rax,4 ;        ; e/d
mov _res2,rax      ; ���������� ����������


sar rcx,5          ;a/c
add _res2,rcx      ;e/d+a/c

shl r9,7          ;d*e
shl r9,8          ;d*e*f
sub _res2,r9      ;e/d+a/c-d*e*f


rdtsc
sub rax, rdi   ;��������� ����� ������
mov _res3,rax ; ����� �����
ret
count2 endp;;�������� 2 �����

entry_point proc
 
mov rax,e1
 invoke count,a1,b1,c1,d1,e1,f1 ;��������� �����. ������
 invoke count2,a1,b1,c1,d1,e1,f1;��������� ������ �����

       ;��������� MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,a1,b1,c1,d1,e1,f1,_res, _res1,ADDR _res,_res2,_res3,ADDR _res2,res1,ADDR res1
   invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
   invoke ExitProcess,0

entry_point endp; ����� ������ ��������
   end