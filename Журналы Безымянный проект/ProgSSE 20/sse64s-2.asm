include \masm64\include64\masm64rt.inc
.data 
mas1 DD 20 dup(1,2,4,6) ; резервирование ячеек памяти для mas1
     dd 16 dup(1)      ; 80+16=96
len1 equ ($-mas1)/type mas1
mas2 DD len1 dup(0) ; резервирование ячеек памяти для mas2

titl1 db "Пересылка целых чисел",0
buf1 dq 0,0	; буфер
tFpu dq 0
tSse dq 0
ifmt db "Число тиков FPU =  %d ",10,10,"Число тиков SSE =  %d ",10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
.code 
entry_point proc	
rdtsc
xchg r14,rax 
finit
 mov rcx,len1   ; количество чисел массива mas1
 lea rsi,mas1   ; адрес начала массива mas1
 lea rdi,mas2   ; адрес начала массива mas2
@@: fild dword ptr [rsi] ; загрузка на вершину стека целого числа
fistp dword ptr [rdi]
add rsi,type mas1; 
add rdi,type mas1; 
loop @b
rdtsc
sub rax,r14
mov tFpu,rax

rdtsc
xchg r14,rax 
 mov rcx,len1   ; количество чисел массива mas1
 lea rsi,mas1   ; адрес начала массива mas1
 lea rdi,mas2   ; адрес начала массива mas2
@@: movups XMM0,mas1 ; пересылка 4-x 32-разрядных целых чисел
movups mas2,xmm0
add rsi,type mas1; 
add rdi,type mas1;
loop @b
rdtsc
sub rax,r14
mov tSse,rax
invoke wsprintf,addr buf1,ADDR ifmt,tFpu,tSse;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end	