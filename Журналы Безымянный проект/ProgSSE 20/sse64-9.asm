; masm64. Выполнить параллельное сравнение с помощью SSE-команд 2-х массивов. 
; Если все элементы первого массива больше, чем одноименные элементы второго массива, 
;то выполнить операцию (a – c)b – d/b, где а = 3.0; b = 0.2; с = 1,0; d = 2.2
; иначе - выполнить операцию d/b.
include \masm64\include64\masm64rt.inc ; подключаемые библиотеки
.data     	         				
mas1  dd -1.3, 2.1, 3.8, 1.0, 5.4, 6.12,7.54, 8.1,  9.0,  10.65
mas2  dd -1., -5.0,-3.54,1.5,-5.8,-6.53,7.5, -8.34,-9.54,-10.1
len1 equ ($-mas2)/ type mas2 ; количество чисел массива mas2
a1  dd  3.0 ; 
b1  dd  0.2 ; 
c1  dd  1.0 ; 
d1  dd  2.2 ; 
fmt db "IF mas1>mas2, то (a – c)b – d/b",10,"иначе d/b, где d = 2.2, b = 0.2",10,
"Результат = %d",10,10,"Автор:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
buf dq 0,0 ; размер буфера
titl1 db "masm64. Параллельное сравнение с помощью SSE-команд",0; название окошка
buf1 dq 0,0 
.code
entry_point proc				
mov eax,len1   ; 
mov ebx,4      ; количество 32-разрядных чисел в 128 разрядном регистре
xor edx,edx    ; 
div ebx  ; определение количества циклов для параллельного считывания и остатка
mov ecx,eax       ; счетчик циклов для параллельного считывания
lea rsi,mas1  	; 
lea rdi,mas2  	; 
next:  movups XMM0,xmmword ptr [rsi]; 4- 32 числа из mas1
movups XMM1,[rdi]     ; 4-  32 числа из mas2
cmpltps XMM0,XMM1 ; сравнение на меньше: если меньше, то нули
movmskps ebx,XMM0 ; перенесение знаковых битов
add rsi,16 ; подготовка адреса для нового считывания mas1
add rdi,16 ; подготовка адреса для нового считывания mas2
dec ecx    ; уменьшение счетчика циклов
jnz m1     ; проверка счетчика на ненулевое значение
jmp m2     ;
m1: mov r10,rbx 
shl r10,4 ; сдвиг налево на 4 бита
jmp next       ; на новый цикл
m2:  cmp edx,0  ; проверка остатка
jz _end         ; 
mov ecx,edx   ; если в остатке не нуль, то установка счетчика
m4:   
movss XMM0,dword ptr[rsi]    ; 
movss XMM1,dword ptr[rdi]    ; 
comiss XMM0,XMM1 ; сравнение младших чисел массивов
jg @f  	  ; если больше
shl r10,1 ; сдвиг налево на 1 разряд
inc r10   ; встановление 1, поскольку XMM0[0] < XMM1[0]
jmp m3
@@:
shl r10,1 ; сдвиг налево на 1 разряд
m3: 
add rsi,4  ; адреса для нового числа mas1
add rdi,4  ; адреса для нового числа mas2
loop m4
_end:
cmp r10,0 	; проверка знаковых битов
jz mb  		; если ebx = 0, то перейти на метку mb
movss xmm2,dword ptr d1
movss xmm3,dword ptr b1
divss xmm2,xmm3         ; d/b
jmp m5
mb:  
movss xmm2,dword ptr a1
subss xmm4,dword ptr c1 ; a - c
mulss xmm2,b1           ;(a - c)b
movss xmm5,dword ptr d1
movss xmm6,dword ptr b1 ; 
divss xmm5,xmm6         ; d/b
subss xmm2,xmm5         ;(a - c)b - d/b
m5:
cvttss2si eax,xmm2 
movsxd r15,eax 
invoke wsprintf,addr buf1,addr fmt,r15  
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION        
invoke ExitProcess,0
entry_point endp
end	