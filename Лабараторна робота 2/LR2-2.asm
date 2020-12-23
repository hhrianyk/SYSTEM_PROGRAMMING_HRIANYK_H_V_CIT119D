include \masm64\include64\masm64rt.inc ; библиотеки
err1 PROTO arg_a:QWORD
.data ;

mas1 dq 12,4,5,3,8   
     dq 10 dup(1)
     dq 25 dup(5)      ; массив mas1 
mas2 dq 10,12,10,34,17   
     dq 20 dup(1)
     dq 15 dup(2)      ; массив mas2
buf dq ?,0      ; 
len1 equ ($-mas1)/type mas2 ; вычисление количества слов в mas1

_res dq 1 ; операнд res1 размерностью 64 разряда; змінна результ
_res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ


;Текст для MessageBox
title1 db "Лаб.2-2 Тест битов. masm64",0
txt1 db "Завдання:Задані масиви А і В з N = 50 елементів.",10," Привести програму визначення добутку елементів масиву B ,",10," для яких біти 0 і 1 збігаються.", 10,10,
"Кількість елементів : %d",10,"Адрес змінної в памяти: %ph",10,10,
"Добуток елементів : %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0

.code;cекция кода
entry_point proc

  invoke err1,len1
  invoke wsprintf,ADDR buf1,ADDR txt1,_res1,ADDR _res1,_res,ADDR _res
  invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION ;Створення MessageBox
  invoke ExitProcess,0

entry_point endp; кінець роботи програми
mov r14,_res

err1 proc arg_a:QWORD; arg_a передается в rcx
lea rsi,mas2 	 ; начальный адрес массива mas1 
m1:   
mov ax,[rsi] ; в ах заносится элемент массива
bt  rax,0		; выбор нулевого бита
setc bh		; если cf=1, то установление 1 в bh
bt  rax,1		; выбор первого бита
setc bl	; если pf = 1, то установление 1 в bl
cmp bh,bl 	; сравнение битов
jne m2 	; если не равняется, то перейти на m2

mov _res,rax;збереження результату
add _res1,1;кількість елементів
mov r14,_res
m2:  add rsi,8 ; увеличение адреса mas2 для выборки нового числа
dec rcx 	   ; уменьшение счетчика чисел в массиве mas1
cmp rcx,0
jnz m1 		; перейти на метку m1, если не нуль

ret
err1 endp

   end