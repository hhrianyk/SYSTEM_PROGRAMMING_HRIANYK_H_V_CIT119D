
include \masm64\include64\masm64rt.inc ; библиотеки
count PROTO arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD, arg_e:QWORD,arg_f:QWORD,arg_g:QWORD
.data ; 
a1 dq 10   ; операнд а1 размерностью 64 разряда константа 2
b1 dq 2   ; операнд b1 размерностью 64 разряда ;змзмінна  d 
c1 dq 5   ; операнд c1 размерностью 64 разряда;змзмінна  c
d1 dq 23   ; операнд d1 размерностью 64 разряда ;змзмінна  d
e1 dq 6   ; операнд e1 размерностью 64 разряда ;змзмінна  e
f1 dq 1  ; операнд f1 размерностью 64 разряда ;змзмінна  f
res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
;Текст для MessageBox
title1 db "Практична робота 1. masm64",0
txt1 db "Рівняння a+b+c - d/e + a*f",10,
"Змінні: a=%d, b=%d, c=%d, d=%d, e=%d, f=%d",10,
"Результат: %d",10,
"Адрес переменной в памяти: %p",0ah,0ah,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0

.code;cекция кода
entry_point proc
        mov  rax,a1    ; пересылка а1 в rax
        add  rax,b1    ;
        add  rax,c1    ; 
       
        mov  rsi,rax   ; сохранение промежуточного результата
        mov  rax,d1    ; пересылка (занесение) d1 в rax
        xor  rdx,rdx   ; инициализация - подготовка к делению (сложение по модулю 2)
        div  e1        ;  деление  rax/d1


        sub  rsi,rax   ;  a+b+c - d/e  
        mov  rax,f1    ;  пересылка f1 в rax
        mul  a1        ;
        add  rsi ,rax  ;
        mov  res1,rsi  ; сохранение
        ;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,a1,b1,c1,d1,e1,f1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; кінець роботи програми
   end