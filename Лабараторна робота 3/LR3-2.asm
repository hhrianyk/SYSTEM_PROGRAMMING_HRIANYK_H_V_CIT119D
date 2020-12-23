include \masm64\include64\masm64rt.inc ; библиотеки
.data ;

_x    dq 3.0 ; початок відліку
_op1  dq 125.0 ; перше число у формулі
_op2  dq 3.0 ; друге число у формулі
_op3  dq 1.1 ; трете число у формулі
_step dq 1.5 ; крок для виконання завдання

res1 dd 0 ;  збереження результату1
res2 dd 0;  збереження результату2
res3 dd 0;  збереження результату3
res4 dd 0;  збереження результату4

;Текст для MessageBox
title1 db "Лаб.3-2 Виконання рівняння на сопроцесорі. masm64",0
txt1 db"Обчислити 4 значення функції: Yn = 125 / (3*х^2 - 1,1) (х змінюється від 3 з кроком 1,5).",10," Результат округлити в меншу сторону.",10,10,
"Результат: %d, %d, %d, %d ",10,10,
"Адрес результату1: %ph",10,
"Адрес результату2: %ph",10,
"Адрес результату3: %ph",10,
"Адрес результату4: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0

buf dq 4 dup(0) ;буфер
.code;cекция кода
entry_point proc

finit  ;
mov rcx, 4  ; счетчик;  количество циклов
m1:fld _x    ;загрузка аргумента х
fmul _x      ; x^2
fmul _op2  ; (3*x^2 )
fsub _op3  ;(3*x^2-1.1)
FDIVR  _op1;125 / (3*х^2 - 1,1) 

fld _x 
fadd _step  ; увеличение шага инерации
fstp _x ; сохранение в ячейке с освобождением вершины стека
 loop m1   ; уменьшение на 1 rcx и переход на метку, если не ноль

fisttp res4 ; сохранение в 64-разрядных ячейках памяти с округлением
fisttp res3 ;
fisttp res2 ;
fisttp res1 ;

invoke wsprintf,ADDR buf,ADDR txt1,res1,res2,res3,res4,addr res1,ADDR res2,ADDR res3,ADDR res4
invoke MessageBox,0,ADDR buf,ADDR title1,MB_ICONINFORMATION ;Створення MessageBoxinvoke ExitProcess,0
entry_point endp; кінець роботи програм
end