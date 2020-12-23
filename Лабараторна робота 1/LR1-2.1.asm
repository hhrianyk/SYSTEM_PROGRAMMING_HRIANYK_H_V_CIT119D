
include \masm64\include64\masm64rt.inc ; библиотеки
count PROTO arg_a:QWORD,arg_b:QWORD,arg_c:QWORD,arg_d:QWORD, arg_e:QWORD,arg_f:QWORD
.data ; 
a1 dq 2   ; операнд а1 размерностью 64 разряда константа 2
b1 dq 5   ; операнд b1 размерностью 64 разряда ;змзмінна  d 
c1 dq 3   ; операнд c1 размерностью 64 разряда;змзмінна  c
d1 dq 16   ; операнд d1 размерностью 64 разряда ;змзмінна  d
e1 dq 8   ; операнд e1 размерностью 64 разряда ;змзмінна  e
f1 dq 13  ; операнд f1 размерностью 64 разряда ;змзмінна  f
tmp1 dq 0;
res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
;Текст для MessageBox
title1 db "Лаб.1-2.1 Рішення рівяння. masm64",0
txt1 db "Рівняння  a+b + c*d - e-f",10,
"Змінні: a=%d, b=%d, c=%d, d=%d, e=%d, f=%d",10,
"Результат: %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0

.code;cекция кода
count proc arga:QWORD, argb:QWORD, argc:QWORD,argd:QWORD, arge:QWORD,argf:QWORD
mov rax,[rbp]  ; исследование ; смотрим в x64dbg содержимое [rbp]
mov rax,[rbp+10h]  ; a1; 
mov rax,[rbp+18h]  ; b1
mov rax,[rbp+20h]  ; c1
mov rax,[rbp+28h]  ; d1
mov rax,[rbp+30h]  ; e1
mov rax,[rbp+38h]  ; f1

 
 mov rax,rcx ; arg a
 add rax ,[rbp+18h]         ; arg b ;      rdx:rax
 mov rsi,rax
 mov rax, [rbp+20h]     ; arg c
 mov r11, [rbp+28h]
 mul r11           ; arg d
 add rax,rsi
 add rax,[rbp+30h]  ; arg e
 sub rax,[rbp+38h]  ; arg f
 mov res1,rax

  ret
count endp
entry_point proc
invoke count,a1,b1,c1,d1,e1,f1
        ;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,a1,b1,c1,d1,e1,f1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; кінець роботи програми
   end