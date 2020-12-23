include \masm64\include64\masm64rt.inc 

.data
 mas1 db 'pneumonoultramicroscopicsilicovolcanoconiosis' ; массив байтов с символами кода ASCII
 len1 equ $-mas1     ; определение количества байтов в массиве mas1
 simvol db 's'
 count dq 0; кількість повторень
 poz dq 0; індекс елементу

;Текст для MessageBox
title1 db "PR4. masm64",0
txt1 db " 'Pneumonoultramicroscopicsilicovolcanoconiosis'",10,
"  Виконати наступні завдання повязані із словом наведеним вище",10,
"*Визначити повторення літери 's'  ",10,
"*Визначити довжину слова" ,10,
"*Визначити першу позицію літери 's'",10,10, 
"-Кількість літер s: %d",10,
"-Довжина слова: %d", 10,
"-Перша позиція літери 'm': %d",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq ?,0            ; буфер вывода сообщения

.code;cекция кода
entry_point proc

 enter 16,0 ; создает кадр стека: кол. байт и уровень вложенности
 mov r10,0;
lea rdi,mas1    ; загрузка адреса массива mas1
mov al, 'm'      ; загрузка символа ‘m’
mov rcx,len1 ; установить в счетчик max значение букв
cld		     ; направление -  вверх
repne scasb	     ; повторять, пока не будет равняться

dec rdi   	  ; найден: декрементировать DI
mov rax,len1
sub rax,rcx
mov poz,rax

inc R10
lea rdi,mas1

m1: 
enter 16,0 ; создает кадр стека: кол. байт и уровень вложенности
mov rax, 's' 
repne scasb	     ; повторять, пока не будет равняться

inc R10
cmp rcx,0
jnz m1

mov count,r10 		

        ;Створення MessageBox
    invoke wsprintf,ADDR buf1,ADDR txt1,count,len1,poz  
    invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    invoke ExitProcess,0

entry_point endp; кінець роботи програми
   end