include \masm64\include64\masm64rt.inc
.data	
 mas dd 360 ; 
 alpha dd 0.0 ; ������� ���������� 
 delta dd 0.0175 ; ���� ������
 xdiv2 dq ?    ; �������� �� X 
 ydiv2 dq ?    ; �������� �� Y
 tmp dd 0       ; ��������� ����������
 divK dd 10.0 ; ���������� �����������
 xr dd 0. 	; ���������� �������
 yr dd 0
temp1 dd 0

titl1 db "����� ���.",0 
buf dq 2 dup(?)
fmt db "fpu = %d,","sse = %d",0    ; ������������ �����

.code
entry_point proc
 invoke GetSystemMetrics,SM_CXSCREEN ; ��������� ������ ������ � ��������
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� �
  mov xdiv2,rax
 invoke GetSystemMetrics,SM_CYSCREEN ; ��������� ������ ������ � ��������
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� Y
  mov ydiv2,rax
 mov r10d,mas ; ���������� ���������� ������
 mov temp1,r10d
finit
l1:                        ; x = x0 + �fcosf
rdtsc   ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
mov r14,rdx ;

fld alpha   ; st(0) := alpha
fcos        ; st(0) := cos(alpha)
 fld alpha 	; st(0) := alpha
 fmul divK 	; st(0) := alpha * divK, st(1) := cos(alpha)
 fmul     ; st(0) := st(0) * st(1)  := alpha * divK * cos(alpha)
 fild xdiv2      
 fadd       ; xr := xdiv2 + alpha * divK * cos(alpha)
 fistp dword ptr xr ; ���������� X
rdtsc ; edx,eax
shl rdx,32 ; �������� � ��������� ��. �����
add rdx,rax ; ��. � ��. ����� � ����� ��������
sub rdx,r14 ;
mov r14,rdx ;

rdtsc ; edx,eax
 shl rdx,32  ; �������� � ��������� ��. �����
 add rdx,rax ; ��. � ��. ����� � ����� ��������
 mov r15,rdx ;

fstp xr ; ���������� � ������
 movss XMM0,xr   ; cos(alpha)  
 mulss XMM0,alpha
 mulss XMM0,divK  ;
 cvtss2si eax,XMM0 ;
add rax,xdiv2 ;
mov xr,eax

rdtsc ; edx,eax
 shl rdx,32 ; �������� � ��������� ��. �����
 add rdx,rax ; ��. � ��. ����� � ����� ��������
 sub rdx,r15 ;
 mov r15,rdx ;
invoke wsprintf,addr buf,addr fmt,r14,r15
invoke MessageBox,0,addr buf,addr titl1,MB_OK; 

; fld alpha     ; st(0) := alpha
; fsin            ; st(0) := sin(alpha)
; fld alpha     ; st(0) := alpha
; fmul divK   ; st(0) := alpha * divK, st(1) := sin(alpha)
; fmul          ; st(0) := st(0) * st(1) := alpha * divK * cos(alpha)
; fstp tmp
; fild ydiv2      
; fsub tmp       ; yr:= ydiv2 - alpha * divK * cos(alpha)
; fistp dword ptr yr ; ���������� X ��� ��������� �� �����

; invoke Sleep,1             ; ��������
; invoke SetCursorPos,xr,yr ; ������������ ������� �� xr, yr 
; movss XMM3,delta
; addss XMM3,alpha
; movss alpha,XMM3
; pop ecx   ; ����������� �� ����� ���������� ������
; dec ecx   ; ���������� ��������
; push ecx
;jz l2       ; ����������� ���������
;jmp l1	    ; ����� �� �����
l2: dec temp1   ; ���������� ��������
invoke  ExitProcess,0 ; 
entry_point endp
end
