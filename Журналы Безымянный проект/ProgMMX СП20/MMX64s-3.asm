include \masm64\include64\masm64rt.inc ; библиотеки
.data                                             
mas1 dw 10, 20,30,40     ; 
mas2 dw 100,200,300,400  ; 
res dd 2 dup(0),0
info1 db " Использование команды ММХ - pextrw.",10,10,
"Задание: распаковать из чисел первого массива первое слово,",0Ah,0Dh,
"а из второго массива второе слово, результат записать в новый массив.",10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",10,10,
"Результирующий массив:"
buf1 dd 128 dup (?),0
fmt1  db " %d,  %d",0 ; %X - hex, %d - dec
.code
entry_point proc
lea rsi,mas1 ; адрес mas1
lea rdi,mas2 ; адрес mas2
lea rbx,res  ; адрес результатов
 movq MM0,qword ptr [rsi] ; занесение в ММ0 элемента mas1
 movq MM1,qword ptr [rdi] ; занесение в ММ1 елемента mas2
    pextrw eax,MM0,0 ; из ММ0 первое слово в eax
    movsxd r14,eax    ; результат. Можно mov r14,rax
    pextrw eax,MM1,1 ; из ММ1 в eax
movsxd r15,eax            ; результат
invoke wsprintf,ADDR buf1,ADDR fmt1,r14,r15
fn MessageBox,0,ADDR info1,"ММХ-команда pextrw. masm64",0
invoke ExitProcess,0
entry_point endp
end
	
