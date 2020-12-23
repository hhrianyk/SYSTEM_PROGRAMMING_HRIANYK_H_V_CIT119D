title Рысованый А.Н.
; masm64. Сложение 32-разрядных чисел 2-х массивов с числом элементов,
; которые нацело не вмещаются в регистр YMM
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
a1 dd 1,2,3,20,9,15,36,25,68,12,54,36,10,12,74,52,1,2 ;18 чисел
b1 dd 2,3,4, 5,3, 5, 6, 5,14,12,85,65,12,30,42,72,2,3     ;18 чисел
len1 EQU ($-b1)/type b1
r1 dq len1 dup(0),0
.code 
entry_point proc
mov rax,len1    ; количество чисел
mov rbx,8       ; чисел в цикле
xor rdx,rdx     ; подготовка к делению
div rbx         ; количество циклов
mov rcx,rax  ; сохранение количества циклов
lea rsi,a1   ; загрузка адреса массива a1
lea rdi,b1   ; загрузка адреса массива b1
lea rbx,r1 ; загрузка адреса массива r1 (res1)
m1:  vmovups ymm0,[rsi] ; перемещение упакованных чисел одинарной точности
vmovups ymm1,[rdi]   ;
vaddpd ymm2,ymm0,ymm1;
vmovups [rbx],ymm2   ; перемещение в память по адресу регистра rbx
add rdi,32    ; 32 х 8 = 256
add rsi,32    ; смещение на 256
add rbx,32    ; смещение на 32 байта = 256
loop m1
mov rcx,rdx ; занесение остатка в счетчик
cmp rdx,0h  ; выработка признаков
jz @F    ; перейти, если ноль
m2:  
 vmovss xmm3,dword ptr [rsi]   ; занесение элемента mas1
 vaddss XMM3,XMM3,dword ptr [rdi] ; сложение с элементом mas2
 vmovss dword ptr [rbx],XMM3 ; сохранение в r1
 add rsi,4   ; смещение указателя на a1
 add rdi,4   ; смещение указателя на b1 
 add rbx,4   ; смещение указателя на r1 
  loop m2
.data
titl1 db "Результат параллельного сложения. AVX. masm64",0
ifmt db "Результат сложения: ", 10 dup(" %d "),10, 
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0 
buf1 dq len1 DUP(0),0  ; буфер вывода сообщения
.code
movsxd rsi,dword ptr r1[0]
movsxd rdi,dword ptr r1[4]
movsxd r10,dword ptr r1[8]
movsxd r11,dword ptr r1[12]
movsxd r12,dword ptr r1[16]
movsxd r13,dword ptr r1[20]
movsxd r14,dword ptr r1[24]
movsxd r15,dword ptr r1[28]
movsxd rax,dword ptr r1[32]
movsxd rbx,dword ptr r1[36]
invoke wsprintf,addr buf1,addr ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15,rax,rbx;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
.data
;titl1 db "Результат параллельного сложения. AVX. masm64",0
ifmt2 db "Результат сложения: ", 8 dup(" %d "),10, 
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0 
.code
movsxd r10,dword ptr r1[40]
movsxd r11,dword ptr r1[44]
movsxd r12,dword ptr r1[48]
movsxd r13,dword ptr r1[52]
movsxd r14,dword ptr r1[56]
movsxd r15,dword ptr r1[60]
movsxd rax,dword ptr r1[64]
movsxd rbx,dword ptr r1[68]
invoke wsprintf,addr buf1,addr ifmt2,r10,r11,r12,r13,r14,r15,rax,rbx;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
@@:  
invoke ExitProcess,0
entry_point endp
end
