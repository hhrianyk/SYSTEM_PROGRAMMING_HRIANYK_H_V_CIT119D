include \masm64\include64\masm64rt.inc ; библиотеки
;count PROTO arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD,arg_e:QWORD, arg_f:QWORD

.data ; 
a1 dq 4   ; операнд а1 размерностью 64 разряда константа 2
b1 dq 16   ; операнд b1 размерностью 64 разряда ;змзмінна  d 
c1 dq 32  ; операнд c1 размерностью 64 разряда;змзмінна  c
d1 dq 64  ; операнд d1 размерностью 64 разряда ;змзмінна  d
e1 dq 128  ; операнд e1 размерностью 64 разряда ;змзмінна  e
f1 dq 256  ; операнд f1 размерностью 64 разряда ;змзмінна  f

res1 dq -2097144 ; операнд res1 размерностью 64 разряда; змінна результ
_res dq 0
_res1 dq 0
_res2 dq 0
_res3 dq 0

;Текст для MessageBox
title1 db "Лаб.2-1 Команди зсуву. masm64",0
txt1 db "Рівняння  e/b + a/c – d*e*f",10,
"Змінні: a=%d, b=%d, c=%d, d=%i, e=%d, f=%d",10,10,
"Результат виконання арифм. команд: %d",0ah,"Число тактів: %d",0ah,"Адрес змінної в памяти: %ph",10,10,
"Результат виконання команд зсуву: %d",0ah,"Число тактів: %d",0ah,"Адрес змінної в памяти: %ph",10,10,
"Результат(Очікуваний): %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0

.code;cекция кода
 
count proc arga:QWORD,argb:QWORD,argc:QWORD,argd:QWORD,arge:QWORD,argf:QWORD
rdtsc 
xchg rdi,rax
mov rax,[rbp]  ; исследование ; смотрим в x64dbg содержимое [rbp]
mov rax,[rbp+10h]  ; a1; 
mov rax,[rbp+18h]  ; b1 
mov rax,[rbp+20h]  ; c1
mov rax,[rbp+28h]  ; d1
mov rax,[rbp+30h]  ; e1
mov rax,[rbp+38h]  ; f1

mov r10,[rbp+18h]   ;занести в r10 b1
mov rax,[rbp+30h]  ; e1
mov rdx,0          ; обнулить рігіст rdx
div  r10           ; e/d
mov _res,rax;      ; save result

mov rax, rcx       ; занести а в rax
div r8             ; поділити на с
add _res,rax       ; e/b + a/c 

mov rax,r9        ; занести с v rax
mov r8,[rbp+30h]  ; e1
mov r9,[rbp+38h]  ; f1
mul r8            ; d*e
mul r9            ; d*e*f
sub _res,rax      ; e/b + a/c – d*e*f


rdtsc ; получение числа тактов
sub rax,rdi ; вычитание из последнего числа тактов предыдущего числа
mov _res1,rax

ret
count endp;;;програма 1 кінець


count2 proc arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD,arg_e:QWORD,arg_f:QWORD;;;програма 2
rdtsc
xchg rdi,rax

mov rax ,[rbp+30h] ; занести в r10 rax
sar rax,4 ;        ; e/d
mov _res2,rax      ; збереження результатів


sar rcx,5          ;a/c
add _res2,rcx      ;e/d+a/c

shl r9,7          ;d*e
shl r9,8          ;d*e*f
sub _res2,r9      ;e/d+a/c-d*e*f


rdtsc
sub rax, rdi   ;получение числа тактов
mov _res3,rax ; число тактів
ret
count2 endp;;програма 2 кінець

entry_point proc
 
mov rax,e1
 invoke count,a1,b1,c1,d1,e1,f1 ;виконання арифм. команд
 invoke count2,a1,b1,c1,d1,e1,f1;виконання команд зсуву

       ;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,a1,b1,c1,d1,e1,f1,_res, _res1,ADDR _res,_res2,_res3,ADDR _res2,res1,ADDR res1
   invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
   invoke ExitProcess,0

entry_point endp; кінець роботи програми
   end