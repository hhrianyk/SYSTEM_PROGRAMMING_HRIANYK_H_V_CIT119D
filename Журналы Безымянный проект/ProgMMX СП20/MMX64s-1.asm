include \masm64\include64\masm64rt.inc ; библиотеки
.data  		     ; директива определения данных
mas1  DB " STUDENTS OF THE UNIVERSITY"
len1  EQU $-mas1 ; вычисление количества байтов 
mas2 DB len1 DUP (20h) ; резервирование со значением 20h
mas3 db len1 DUP(' '),10,10, ; массив сохранения 
 "Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
titl1 db "Параллельное сложениe массивов с помощью команд ММХ",0
.code 			   ; директива начала кода программы
entry_point proc
mov EAX, len1 ; загрузка количества байтов
mov EBX, 8 	; максимальное количество слов
xor EDX, EDX; инициализация перед делением
div EBX     ; определение количества циклов по 8 байтов
mov ECX, EAX ; количество циклов для параллельной обработки
lea rsi, mas1 ; загрузка адреса массива mas1
lea rbx, mas2 ; загрузка адреса массива mas2
lea rdi, mas3 ; загрузка адреса массива mas3
m1:
movq MM0,qword ptr [rsi] ; занесение 8 байтов массива mas1 в ММ0
paddb MM0,qword ptr [rbx] ; mas1 + mas2
movq qword ptr [rdi], MM0 ; сохранение результата
add rsi,8 ; смещение на 64 розряда адреса данных массива
add rdi,8 ; смещение на 64 розряда адреса данных массива
add rbx,8 ; подготовление нового адреса данных массива
loop m1   ; перейти на m1, если ecx /= 0
cmp EDX,0 ; сравнение остатка
jz  exit  ; перейти на exit, если EDX = 0 (z = 1)
mov ECX,EDX ; количество циклов для последовательной обработки
m2: mov AL,byte ptr [rsi]
add AL,20h
mov byte ptr [rdi], AL
inc rsi ; rsi := rsi + 1
inc rdi ; rdi := rdi + 1
dec ECX ; ecx := ecx – 1
jnz m2  ; перейти на m2, если не нуль (есх /= 0) 
exit:
invoke MessageBox,0,addr mas3,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
