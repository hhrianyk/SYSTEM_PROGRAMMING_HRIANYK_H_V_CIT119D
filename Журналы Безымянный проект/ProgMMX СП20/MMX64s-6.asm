include \masm64\include64\masm64rt.inc ; 
.data  		     
mas1 dw 1,2,3,4,5,6,7,8
res2 dq 0
tit1 db "masm64. ������������ ������� ",0
fmt1 db "������� MMX psrlw.",10,"���������: %016I64xh",10,10,
"������� MMX psllq.",10,"���������: %016I64xh",0
buf1 dq 4 dup(0),0
.code  				   
entry_point proc
movq mm0,qword ptr[mas1] ; ��� ��������� 
movq mm1,qword ptr[mas1] ;
psrlw mm1,1 ; ����� ������ �� 1 ������ ������� �����
movq res2,mm1
mov r10,res2 ; 

movq mm3,qword ptr[mas1] ; ��� ���������
movq mm4,qword ptr[mas1] ;
psllq mm4,1  ;
movq res2,mm4
mov r11,res2 ; 

movd eax, mm4 ; ��� ��������� 
invoke wsprintf,ADDR buf1,ADDR fmt1,r10,r11;
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
