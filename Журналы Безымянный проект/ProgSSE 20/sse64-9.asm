; masm64. ��������� ������������ ��������� � ������� SSE-������ 2-� ��������. 
; ���� ��� �������� ������� ������� ������, ��� ����������� �������� ������� �������, 
;�� ��������� �������� (a � c)b � d/b, ��� � = 3.0; b = 0.2; � = 1,0; d = 2.2
; ����� - ��������� �������� d/b.
include \masm64\include64\masm64rt.inc ; ������������ ����������
.data     	         				
mas1  dd -1.3, 2.1, 3.8, 1.0, 5.4, 6.12,7.54, 8.1,  9.0,  10.65
mas2  dd -1., -5.0,-3.54,1.5,-5.8,-6.53,7.5, -8.34,-9.54,-10.1
len1 equ ($-mas2)/ type mas2 ; ���������� ����� ������� mas2
a1  dd  3.0 ; 
b1  dd  0.2 ; 
c1  dd  1.0 ; 
d1  dd  2.2 ; 
fmt db "IF mas1>mas2, �� (a � c)b � d/b",10,"����� d/b, ��� d = 2.2, b = 0.2",10,
"��������� = %d",10,10,"�����:  ��������� �.�., ���. ���, ��� ���",0
buf dq 0,0 ; ������ ������
titl1 db "masm64. ������������ ��������� � ������� SSE-������",0; �������� ������
buf1 dq 0,0 
.code
entry_point proc				
mov eax,len1   ; 
mov ebx,4      ; ���������� 32-��������� ����� � 128 ��������� ��������
xor edx,edx    ; 
div ebx  ; ����������� ���������� ������ ��� ������������� ���������� � �������
mov ecx,eax       ; ������� ������ ��� ������������� ����������
lea rsi,mas1  	; 
lea rdi,mas2  	; 
next:  movups XMM0,xmmword ptr [rsi]; 4- 32 ����� �� mas1
movups XMM1,[rdi]     ; 4-  32 ����� �� mas2
cmpltps XMM0,XMM1 ; ��������� �� ������: ���� ������, �� ����
movmskps ebx,XMM0 ; ����������� �������� �����
add rsi,16 ; ���������� ������ ��� ������ ���������� mas1
add rdi,16 ; ���������� ������ ��� ������ ���������� mas2
dec ecx    ; ���������� �������� ������
jnz m1     ; �������� �������� �� ��������� ��������
jmp m2     ;
m1: mov r10,rbx 
shl r10,4 ; ����� ������ �� 4 ����
jmp next       ; �� ����� ����
m2:  cmp edx,0  ; �������� �������
jz _end         ; 
mov ecx,edx   ; ���� � ������� �� ����, �� ��������� ��������
m4:   
movss XMM0,dword ptr[rsi]    ; 
movss XMM1,dword ptr[rdi]    ; 
comiss XMM0,XMM1 ; ��������� ������� ����� ��������
jg @f  	  ; ���� ������
shl r10,1 ; ����� ������ �� 1 ������
inc r10   ; ������������ 1, ��������� XMM0[0] < XMM1[0]
jmp m3
@@:
shl r10,1 ; ����� ������ �� 1 ������
m3: 
add rsi,4  ; ������ ��� ������ ����� mas1
add rdi,4  ; ������ ��� ������ ����� mas2
loop m4
_end:
cmp r10,0 	; �������� �������� �����
jz mb  		; ���� ebx = 0, �� ������� �� ����� mb
movss xmm2,dword ptr d1
movss xmm3,dword ptr b1
divss xmm2,xmm3         ; d/b
jmp m5
mb:  
movss xmm2,dword ptr a1
subss xmm4,dword ptr c1 ; a - c
mulss xmm2,b1           ;(a - c)b
movss xmm5,dword ptr d1
movss xmm6,dword ptr b1 ; 
divss xmm5,xmm6         ; d/b
subss xmm2,xmm5         ;(a - c)b - d/b
m5:
cvttss2si eax,xmm2 
movsxd r15,eax 
invoke wsprintf,addr buf1,addr fmt,r15  
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION        
invoke ExitProcess,0
entry_point endp
end	