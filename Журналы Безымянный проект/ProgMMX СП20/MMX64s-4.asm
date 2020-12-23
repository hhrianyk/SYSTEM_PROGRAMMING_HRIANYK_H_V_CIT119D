include \masm64\include64\masm64rt.inc 
.data 	
mas1  DB -1, -2, 3, 4, 0, 0, 12, -8
mas2  DB -1, -2, 3, 4, 0, 1, 12, -8
res  DB 16 DUP (5)
titl1 db "ММХ-команды сравнения. masm64",0
fmt1  db "r12=%016I64xh сравнение на равенство",10,
"r14=%016I64xh сравнение на больше",0 
       
buf1 dq 0,0
.code  		
entry_point proc

movq MM0,qword ptr mas1; 
pcmpeqb MM0,qword ptr mas2 ; попарное сравнение на равенство
movq qword ptr res,MM0     ; сохранение результата в памяти 
mov r12,qword ptr res

movq MM1,qword ptr mas1
pcmpgtb MM1,qword ptr mas2 ; попарное сравнение на больше
movq qword ptr res+8,MM1
mov r14,qword ptr res+8

invoke wsprintf,ADDR buf1,ADDR fmt1,r12,r14
invoke MessageBox,0,ADDR buf1,ADDR titl1,0            
invoke ExitProcess,0
entry_point endp
end
	
