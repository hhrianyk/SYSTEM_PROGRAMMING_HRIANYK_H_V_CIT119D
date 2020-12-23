;����� ������ ��������� masA:={a,b,c,d} � masE :={�1,�2,�3,�4}.
;���������  ������� � �������� ���.
;��������� ��������� ��� 4-� ����� ��
include \masm64\include64\masm64rt.inc
.data
mas1 db 1,2,3,4  ; a,b,c,d
masE dq 7,10,3,8 ;
len1 EQU (LENGTHOF masE) ; ���. ��������� 
mas3 dq 4 dup(?)
res0 dq ? ; �������� 1-�� ����������
res1 dq ? ; �������� 2-�� ����������

tit1 db "�������:  ae/b � ad;",0
txt1 db "���������� : ", len1 dup(" %d "),0
buf1 dq ?,0

.code
entry_point proc
lea rsi,mas1 ; ����� mas1
lea rdi,masE
lea r8,mas3
mov rcx,len1
xor rdx,rdx

movq mm0,[rsi]  ; �������� mas1
movq mm1,mm0    ; ������������ mas1
pextrw r10d,MM1,0 ; ���������� 0-�� �����
and r10d,0ffh   ; ����� - ��������� ��. �����
pextrw r11d,MM1,0 ; ���������� 0-�� �����
and r11d,0ff00h  ; ��������� ��. �����
sar r11d,8   ; ����� �� ����� ��. �����

pextrw r12d,MM1,1 ; ���������� 1-�� �����
and r12d,0ffh
pextrw r13d, MM1,1
and r13d,0ff00h
sar r13d,8

cycle:
xor rbx,rbx
mov bl,byte ptr [rdi]
mov eax,r10d  ; a
mul rbx       ; ae
div r11d
mov r9,rax    ; ae/b
mov eax,r10d  ; a
mul r13d
sub r9,rax     ;
mov [r8],r9
add r8,8
add rdi,8
loop cycle

mov rax,mas3[0]
mov res0,rax    ; 1-� ���������
mov rax,mas3[8]
mov res1,rax    ; 2-� ���������
mov r14,mas3[16] ; 3-� ���������
mov r15,mas3[24] ; 4-� ���������
invoke wsprintf,ADDR buf1,ADDR txt1,res0,res1,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end