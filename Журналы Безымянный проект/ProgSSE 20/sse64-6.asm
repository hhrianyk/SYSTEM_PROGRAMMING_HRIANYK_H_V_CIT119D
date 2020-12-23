include \masm64\include64\masm64rt.inc ;
.data
mas1 dd  2.4,  7.1, 6.8, 2.6,21.9, 6.12,7.54, 8.1,  9.0,  10.65
mas2 dd -1.34,-5.0,-3.54,1.5,-5.8,-6.53,7.5, -8.34,-9.54,-10.1
len1 equ ($-mas2)/ type mas2	; ������� ����� ������ mas2
res dd len1 DUP(0),0   ; �������������� ������ ��� ����������
titl1 db "��������� ������������� ��������. SSE. masm64",0
buf1 dd len1 DUP(0),0  ; ����� ������ ���������
ifmt db "��������� �������� ��������:", len1 dup(" %I64d "), 10,10,
"��� ������ ����� wsprintf �������������� ������� ����������: cvtps2dq, cvtss2si",10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0 
.code          			       ; 
entry_point proc
mov rax,len1 ; ���������� ����� � �������
mov rbx,4 ; ���������� ������������ ���������� ����� � XMM
xor rdx,rdx ; �������� �� ������� 2 (���������)
div rbx 	; eax := 4 � ���������� ������ edx := 1
mov rcx,rax ; �������� ��������
lea rsi,mas1 ; esi := addr mas1
lea rdi,mas2 ; edi := addr mas2
lea rbx,res  ; ��������� ������ �������
m1: movups XMM0,[rsi] ;mas1  ; 
movups XMM1,[rdi] ;mas2  ; 
addps xmm0,xmm1
cvtps2dq xmm2,xmm0
movups xmmword ptr [rbx],xmm2
add rsi,16;type mas2 ; ���������� ������ mas1 � ������ ����������
add rdi,16 ; ���������� ������ mas2 � ������ ����������
add rbx,16 ; ���������� ������ � ������ ����������
loop m1    ; ecx := ecx � 1 � �������, ���� ecx /= 0
 cmp rdx,0 ; ����������� ������� �������������� ��������� ��������
 jz  exit    ; ���� �������� �����������, �� ������� �� exit
 mov rcx,rdx ; ��������� � ������� ���������� �������������� �����
m2:  movss xmm3,dword ptr [rsi] ; ��������� ��������������� �������� �� mas1
 addss xmm3,dword ptr [rdi] ; �������� ��������� ���� ��������
 cvtss2si eax,xmm3 ;  float-����� � ����� 32-��������� �����
 mov dword ptr [rbx],eax ; ���������� ����������
 add rsi,4 ; ���������� � ������� �������� �� mas1
 add rdi,4 ; ���������� � ������� �������� �� mas2
 add rbx,4 ; ���������� � ������ ���������� � ������
 loop m2   ; ecx := ecx � 1 � �������, ���� ecx /= 0
 exit: 
movs  rsi,res
movs  rdi,res[4]
movs  r10,res[8]
movs  r11,res[12]
movs  r12,res[16]
movs  r13,res[20]
movs  r14,res[24]
movs  r15,res[28]
movs  rax,res[32]
movs  rbx,res[36]

invoke wsprintf,ADDR buf1,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15,rax,rbx
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end