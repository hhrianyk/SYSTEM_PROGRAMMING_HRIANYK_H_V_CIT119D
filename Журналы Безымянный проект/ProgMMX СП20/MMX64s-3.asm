include \masm64\include64\masm64rt.inc ; ����������
.data                                             
mas1 dw 10, 20,30,40     ; 
mas2 dw 100,200,300,400  ; 
res dd 2 dup(0),0
info1 db " ������������� ������� ��� - pextrw.",10,10,
"�������: ����������� �� ����� ������� ������� ������ �����,",0Ah,0Dh,
"� �� ������� ������� ������ �����, ��������� �������� � ����� ������.",10,10,
"����� ���������:  ��������� �.�., ���. ���, ��� ���",10,10,
"�������������� ������:"
buf1 dd 128 dup (?),0
fmt1  db " %d,  %d",0 ; %X - hex, %d - dec
.code
entry_point proc
lea rsi,mas1 ; ����� mas1
lea rdi,mas2 ; ����� mas2
lea rbx,res  ; ����� �����������
 movq MM0,qword ptr [rsi] ; ��������� � ��0 �������� mas1
 movq MM1,qword ptr [rdi] ; ��������� � ��1 �������� mas2
    pextrw eax,MM0,0 ; �� ��0 ������ ����� � eax
    movsxd r14,eax    ; ���������. ����� mov r14,rax
    pextrw eax,MM1,1 ; �� ��1 � eax
movsxd r15,eax            ; ���������
invoke wsprintf,ADDR buf1,ADDR fmt1,r14,r15
fn MessageBox,0,ADDR info1,"���-������� pextrw. masm64",0
invoke ExitProcess,0
entry_point endp
end
	
