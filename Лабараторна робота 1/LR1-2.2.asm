
include \masm64\include64\masm64rt.inc ; библиотеки

.data ; 
mas1 dq  88, 3, 21, 5, 19, 4, 5,4
;       a, b, c,  d, e,  f ,g 
mas2 dq  88, 4, 1,  5, 18, 7, 1,8
;       a1,b1,c1, d1,e1, f1,g1 
len1 equ $-mas1


res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
;Текст для MessageBox
title1 db "Лаб.1-2.2 Рішення рівяння. masm64",0
txt1 db "Завдання: Написать программу определения количества пар элементов, которые удовлетворяют условие Аi <= Ві.",10,
"Результат: %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0


.code;cекция кода
entry_point proc
mov rcx ,8;; загрузка счетчика количеством чисел массива
lea rsi,byte ptr mas1 ; занесение адреса начала элементов массива mas1
lea rdi,byte ptr mas2 ; занесение адреса массива результата массива mas2

jnz @1 ;визов цикла

 minus: inc res1;+1 к результату
    add rsi,8;звиг указателя
    add  rdi,8;звиг указателя
    dec rcx;счётчик -1
    cmp rcx,0; проверка не конец
    je en

 @1:
  movzx rax, word ptr [rsi] ;занесениеелемента в rax
  movzx  rdx, word ptr [rdi] ;занесениеелемента в rdx
  sub rax,rdx; доп. дейсвия для проверки
   cmp rax,0; проверка rax <0;
  JLE  minus; перейти, если a <= b

     add rsi,8;звиг указателя
     add rdi,8;звиг указателя


    dec rcx;счётчик -1
    cmp rcx,0; проверка не конец
    jnz @1 

en: mov rax, 0;;конец
   ;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; кінець роботи програми
   end