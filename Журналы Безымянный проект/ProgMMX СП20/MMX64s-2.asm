include \masm64\include64\masm64rt.inc ; библиотеки
.data  		     ; директива определения данные
mas1 dw 1, 20000, 30000, 40000, 100, 40000, 3, 50000, 6000
mas2 dw 2, 40000, 50000, 25538, 200, 40000, 1, 0, 60000
len1 EQU ($-mas2)/ type mas2 ; вычисление количества двойных слов mas2
sum dw len1 DUP(0),0  ; резервирование байтов под переменную sum
sum2 dq len1 DUP(0),0  ; резервирование байтов под переменную sum
_title db "Результат параллельного сложения массивов. ММХ. masm64",0
buf dd len1 DUP(0),0  ; буфер вывода сообщения
ifmt db "Ответ =", len1 dup("  %I64d "),10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0 
.code  				   
entry_point proc
mov rax,len1 ; счетчик чисел в массиве
mov rbx,4 ; количество одновременно занесенных чисел в ММХ
xor rdx,rdx ; сложение по модулю 2 (обнуление)
div rbx 	; eax := 4 – количество циклов edx := 1
mov rcx,rax ; загрузка счетчика
lea rsi,mas1 ; esi := addr mas1
lea rdi,mas2 ; edi := addr mas2
lea rbx,sum  ; занесение начала массива sum;
m1: movq MM0,qword ptr [rsi] ;
paddw MM0,qword ptr [rdi]  ; параллельное циклическое сложение
movq qword ptr [rbx],MM0
add rsi,8 ; подготовка адреса mas1 к новому считыванию
add rdi,8 ; подготовка адреса mas2 к новому считыванию
add rbx,8 ; подготовка адреса sum  к новому считыванию
loop m1   ; ecx := ecx – 1 но переход, если ecx /= 0
 cmp rdx,0 ; определение остатка необработанных элементов массивов
 jz  exit  ; если элементы закончились, то перейти на exit
 mov rcx,rdx ; занесение в счетчик количества необработанных чисел
m2:  mov eax,dword ptr [rsi] ; занесение необработанного элемента из mas1
 add  eax,dword ptr [rdi] ; сложение элементов двух массивов
 mov  dword ptr [rbx],eax ; збереження результату
 add rsi,2 ; подготовка к выборке элемента из mas1
 add rdi,2 ; подготовка к выборке элемента из mas2
 add rbx,2 ; подготовка к записи результата в пам’ять
 loop m2   ; ecx := ecx – 1 но переход, если ecx /= 0
 exit:
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]
movzx rax,sum[16]
invoke wsprintf,ADDR buf,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15,rax
invoke MessageBox,0,addr buf,addr _title,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
