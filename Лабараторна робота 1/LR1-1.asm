include \masm64\include64\masm64rt.inc
.data ; 
a1 dq 2   ; операнд а1 размерностью 64 разряда константа 2
 
c1 dq 3   ; операнд c1 размерностью 64 разряда;змзмінна  c
d1 dq 6   ; операнд d1 размерностью 64 разряда ;змзмінна  d
res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна резудьт

;Текст для MessageBox
title1 db "Лаб.1-1.Рішення рівяння. masm64",0
txt1 db "Рівняння   2d/с  – сd за допомогою MessageBox: ",10,
"Змінні: c=%d", ",d=%d",10,
"Результат: %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0
.code            ;cекция кода
entry_point proc
        mov  rax, d1 ; пересылка d1 в rax
        mul  a1     ; множення  rax х 2
        div  c1      ; ділення   rax х c1
        mov  res1,rax ; сохранение промежуточного результата
        mov  rax, d1 ;пересылка d1 в rax
        mul  c1      ;множення rax на с1
        sub  res1,rax;2d/с  – сd
        
        
;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,c1,d1,res1,ADDR res1
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0
entry_point endp; кінець роботи програми
   end