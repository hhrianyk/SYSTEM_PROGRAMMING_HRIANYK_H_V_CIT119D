include \masm64\include64\masm64rt.inc
.data  
mas1 dw 1,5,7,98,52,12,36,45
mas2 dw 2,3,89,5,14,23,6,58
len1 EQU (LENGTHOF mas2) ; ���������� ��������� � ������� 

sum dw len1 DUP(0),0
sum2 dw len1 DUP(0),0 
tit1 db "������������� ������� pminsw", 0
buf1 dq len1 DUP(0),0 
ifmt db "������� ������� ����������� �������",10,10,
" �����=", len1 dup(" %d "),0

.code
entry_point proc
mov rax,len1 ; ������� ����� 
mov rbx,4    ; ���. ����� � 64 ��������
xor rdx,rdx ; ���������� � �������
div rbx     ; ����������� ���. ������ � �������
mov rcx,rax  ; ���. ������ � ��������
lea rsi,mas1 ; 
lea rdi,mas2 ;
lea rbx,sum  ; ����� �������� ����������
@@:
movq MM0,qword ptr[rsi] ; �������� ����� mas1
movq MM1,qword ptr[rdi] ; �������� ����� mas2
pminsw MM0,MM1         ; 
movq qword ptr[rbx],MM0 ;
add rsi,8 ; ���. ������ ���������� �����
add rdi,8 ; 
add rbx,8 ;
  loop @b 

 cmp rdx,0  ; ����������� ������� �������������� ��������� ��������
 jz  exit   ; ���� �������� �����������, �� ������� �� exit
 mov rcx,rdx ; ��������� � ������� ���������� �������������� �����
m2:  mov ax,word ptr [rsi] ; ��������� ��������������� �������� �� mas1
 add  ax,word ptr [rdi]        ; �������� ��������� ���� ��������
 mov  word ptr [rbx],ax      ; ���������
 add rsi,2     ; ���������� � ������� �������� �� mas1
 add rdi,2     ; ���������� � ������� �������� �� mas2
 add rbx,2     ; ���������� � ������ ���������� � ������
 loop m2       ; ecx := ecx � 1 � �������, ���� ecx /= 0
 exit:
  
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]

invoke wsprintf,ADDR buf1,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
