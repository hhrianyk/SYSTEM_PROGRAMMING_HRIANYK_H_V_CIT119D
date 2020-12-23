include \masm64\include64\masm64rt.inc ;
.data
mas1 dd  2.4,  7.1, 6.8, 2.6,21.9, 6.12,7.54, 8.1,  9.0,  10.65
mas2 dd -1.34,-5.0,-3.54,1.5,-5.8,-6.53,7.5, -8.34,-9.54,-10.1
len1 equ ($-mas2)/ type mas2	; кількість чисел масиву mas2
res dd len1 DUP(0),0   ; резервирование байтов под переменную
titl1 db "Результат параллельного сложения. SSE. masm64",0
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения
ifmt db "Результат сложения массивов:", len1 dup(" %I64d "), 10,10,
"Для вывода через wsprintf использовались команды округления: cvtps2dq, cvtss2si",10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0 
.code          			       ; 
entry_point proc
mov rax,len1 ; количество чисел в массиве
mov rbx,4 ; количество одновременно занесенных чисел в XMM
xor rdx,rdx ; сложение по модулем 2 (обнуление)
div rbx 	; eax := 4 – количество циклов edx := 1
mov rcx,rax ; нагрузка счетчика
lea rsi,mas1 ; esi := addr mas1
lea rdi,mas2 ; edi := addr mas2
lea rbx,res  ; занесение начала массива
m1: movups XMM0,[rsi] ;mas1  ; 
movups XMM1,[rdi] ;mas2  ; 
addps xmm0,xmm1
cvtps2dq xmm2,xmm0
movups xmmword ptr [rbx],xmm2
add rsi,16;type mas2 ; подготовка адреса mas1 к новому считыванию
add rdi,16 ; подготовка адреса mas2 к новому считыванию
add rbx,16 ; подготовка адреса к новому считыванию
loop m1    ; ecx := ecx – 1 и переход, если ecx /= 0
 cmp rdx,0 ; определение остатка необработанных элементов массивов
 jz  exit    ; если элементы закончились, то перейти на exit
 mov rcx,rdx ; занесение в счетчик количества необработанных чисел
m2:  movss xmm3,dword ptr [rsi] ; занесение необработанного элемента из mas1
 addss xmm3,dword ptr [rdi] ; сложение элементов двух массивов
 cvtss2si eax,xmm3 ;  float-число в целое 32-разрядное число
 mov dword ptr [rbx],eax ; сохранение результата
 add rsi,4 ; подготовка к выборке элемента из mas1
 add rdi,4 ; подготовка к выборке элемента из mas2
 add rbx,4 ; подготовка к записи результата в память
 loop m2   ; ecx := ecx – 1 и переход, если ecx /= 0
 exit: 
movs  rsi,res
movs  rdi,res[4]
movs  r10,res[8]
movs  r11,res[12]
movs  r12,res[16]
movs  r13,res[20]
movs  r14,res[24]
movs  r15,res[28]
movs  rax,res[32]
movs  rbx,res[36]

invoke wsprintf,ADDR buf1,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15,rax,rbx
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end