include \masm64\include64\masm64rt.inc ; ����������
.data  		     ; ��������� ����������� ������
mas1 dw 1, 20000, 30000, 40000, 100, 40000, 3, 50000, 6000
mas2 dw 2, 40000, 50000, 25538, 200, 40000, 1, 0, 60000
len1 EQU ($-mas2)/ type mas2 ; ���������� ���������� ������� ���� mas2
sum dw len1 DUP(0),0  ; �������������� ������ ��� ���������� sum
sum2 dq len1 DUP(0),0  ; �������������� ������ ��� ���������� sum
_title db "��������� ������������� �������� ��������. ���. masm64",0
buf dd len1 DUP(0),0  ; ����� ������ ���������
ifmt db "����� =", len1 dup("  %I64d "),10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",0 
.code  				   
entry_point proc
mov rax,len1 ; ������� ����� � �������
mov rbx,4 ; ���������� ������������ ���������� ����� � ���
xor rdx,rdx ; �������� �� ������ 2 (���������)
div rbx 	; eax := 4 � ���������� ������ edx := 1
mov rcx,rax ; �������� ��������
lea rsi,mas1 ; esi := addr mas1
lea rdi,mas2 ; edi := addr mas2
lea rbx,sum  ; ��������� ������ ������� sum;
m1: movq MM0,qword ptr [rsi] ;
paddw MM0,qword ptr [rdi]  ; ������������ ����������� ��������
movq qword ptr [rbx],MM0
add rsi,8 ; ���������� ������ mas1 � ������ ����������
add rdi,8 ; ���������� ������ mas2 � ������ ����������
add rbx,8 ; ���������� ������ sum  � ������ ����������
loop m1   ; ecx := ecx � 1 �� �������, ���� ecx /= 0
 cmp rdx,0 ; ����������� ������� �������������� ��������� ��������
 jz  exit  ; ���� �������� �����������, �� ������� �� exit
 mov rcx,rdx ; ��������� � ������� ���������� �������������� �����
m2:  mov eax,dword ptr [rsi] ; ��������� ��������������� �������� �� mas1
 add  eax,dword ptr [rdi] ; �������� ��������� ���� ��������
 mov  dword ptr [rbx],eax ; ���������� ����������
 add rsi,2 ; ���������� � ������� �������� �� mas1
 add rdi,2 ; ���������� � ������� �������� �� mas2
 add rbx,2 ; ���������� � ������ ���������� � ������
 loop m2   ; ecx := ecx � 1 �� �������, ���� ecx /= 0
 exit:
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]
movzx rax,sum[16]
invoke wsprintf,ADDR buf,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15,rax
invoke MessageBox,0,addr buf,addr _title,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
