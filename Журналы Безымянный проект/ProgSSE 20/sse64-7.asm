; Скалярное сложение массивов вещественных чисел
include \masm64\include64\masm64rt.inc
.data
mas1 DD  12.13,-15.01, -3.1, 77.1  ; резервирование памяти
mas2 DD  25.13, 35.01,-34.5, 23.01 ; резервирование памяти
len1 EQU ($-mas2)/ type mas2 ; кол. двойных слов mas2
res dd 4 dup(?),0	;
titl1 db "СКАЛЯРНОЕ сложение двух массивов чисел командами SSE",0
buf dd 4 dup(?)
fmt db "mas1  12.13,-15.01, -3.1, 77.1",10,
       "mas2  25.13, 35.01,-34.5, 23.01",10,10, 
   "addss:", len1 dup("   %I64d "),10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0 
.code 
entry_point proc
 lea rsi,mas1 ; esi := addr mas1
 lea rdi,mas2 ; edi := addr mas2
 lea rbx,res
 mov rcx,len1 ; счетчик
@m1:
movups XMM0,[rsi] ;mas1  ; 
movups XMM1,[rdi] ;mas2  ; 
addss xmm0,xmm1
cvtss2si eax,XMM0 ;  float-число в целое 32-разрядное число со знаком
mov dword ptr [rbx],eax
add rsi,4 ; 
add rdi,4 ; 
add rbx,4 ; 
loop @m1;

movsxd r10,res
movsxd r11,res[4]
movsxd r12,res[8]
movsxd r13,res[12]
invoke wsprintf,ADDR buf,ADDR fmt,r10,r11,r12,r13
invoke MessageBox,0,ADDR buf,ADDR titl1, MB_ICONINFORMATION 
invoke ExitProcess,0
entry_point endp
end	