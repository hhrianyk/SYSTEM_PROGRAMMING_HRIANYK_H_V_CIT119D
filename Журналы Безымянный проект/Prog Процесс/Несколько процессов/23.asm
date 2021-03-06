title  ; masm64
include \masm32\include64\masm64rt.inc
.data ;	
mas1 DD 20 dup(0,2,4,6) ; �������������� ����� ������ ��� mas1
     dd 16 dup(1)      ; 80+16=96
len1 equ ($-mas1)/type mas1
mas2 DD len1 dup(0) ; �������������� ����� ������ ��� mas2
titl1 db "��������� ����� �����",0
buf1 dq 0,0	; �����
tFpu dq 0
tSse dq 0
ifmt db "����� ����� FPU =  %d ",10,10,"����� ����� SSE =  %d ",10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0
h1 dq	?	; ������������� ������
h2 dq	?	; ������������� ������
hEventStart HANDLE ? ;����� �������
.code
	
proc1 proc ;  ��������� 
 rdtsc
xchg r14,rax 
finit
mov rcx,len1   ; ���������� ����� ������� mas1
 lea rsi,mas1  ; ����� ������ ������� mas1
 lea rdi,mas2  ; ����� ������ ������� mas2
@@: fild dword ptr [rsi] ; �������� ������ �����
fistp dword ptr [rdi]
add rsi,type mas1; 
add rdi,type mas1; 
loop @b
rdtsc
sub rax,r14
mov tFpu,rax
ret
proc1 endp ;

proc2 proc	; ��������� 
rdtsc
xchg r14,rax 
 mov rcx,len1   ; ���������� ����� ������� mas1
 lea rsi,mas1   ; ����� ������ ������� mas1
 lea rdi,mas2   ; ����� ������ ������� mas2
@@: movups XMM0,mas1 ; ��������� 4-x ����� �����
movups mas2,xmm0
add rsi,type mas1; 
add rdi,type mas1;
loop @b
rdtsc
sub rax,r14
mov tSse,rax
ret
proc2 endp	;

entry_point proc
lea rax, proc1   ; �������� ������ ��������� 
invoke CreateThread,0,0,rax,0,0,addr h1 ; ������� �������
;invoke proc1
lea rax, proc2 ; �������� ������ ��������� 
invoke CreateThread,0,0,rax,0,0,addr h2; ������� �������
;invoke proc2
invoke CreateEvent,0,FALSE,FALSE,0; �������� �������
mov hEventStart,rax    ; ���������� ������ �������
invoke WaitForSingleObject,hEventStart,1000
invoke wsprintf,addr buf1,ADDR ifmt,tFpu,tSse;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION  
invoke ExitProcess,0	
entry_point endp

end