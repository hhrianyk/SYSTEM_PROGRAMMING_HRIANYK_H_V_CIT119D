title Рысованый А.Н., каф. ВТП, НТУ ХПИ
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
mas1 DD 20 dup(1,2,4,6) ; резервирование ячеек памяти для mas1
     dd 16 dup(1)      ; 80+16=96
len1 equ ($-mas1)/type mas1
mas2 DD len1 dup(0) ; резервирование ячеек памяти для mas2
buf1 dq 0,0	; буфер

ifmt db "Число тиков FPU =  %d ",10,10,"Число тиков SSE =  %d ",10,
"Число тиков AVX =  %d ",10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
titl1 db "Пересылка целых чисел",0
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
mov r10,rax
        ; обнуление ячеек памяти
mov rcx,len1; 
lea rdi,mas2   ;
mm: mov dword ptr [rdi],0
add rdi,type mas1
loop mm

rdtsc
xchg r14,rax 
 mov rcx,len1/4 ; количество чисел массива mas1
 lea rsi,mas1   ; адрес начала массива mas1
 lea rdi,mas2   ; адрес начала массива mas2
@@: movups xmm0,dword ptr [rsi] ; пересылка 4-x 32-разрядных целых чисел
movups dword ptr [rdi],xmm0
add rsi,16; 
add rdi,16;
 loop @b
rdtsc
sub rax,r14
mov r11,rax
          ; обнуление ячеек памяти
mov rcx,len1/8
lea rdi,mas2   ;
mm33: mov dword ptr [rdi],0
add rdi,type mas1
loop mm33

rdtsc
xchg r14,rax 
 mov rcx,len1/8   ; количество чисел массива mas1
 lea rsi,mas1   ; адрес начала массива mas1
 lea rdi,mas2   ; адрес начала массива mas2
@@: vmovups ymm0,dword ptr [rsi] ; пересылка 8-и 32-разрядных целых чисел
vmovups dword ptr [rdi],ymm0
add rsi,32; 
add rdi,32;
loop @b
rdtsc
sub rax,r14
mov r12,rax

invoke wsprintf,addr buf1,ADDR ifmt,r10,r11,r12;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end		