include \masm64\include64\masm64rt.inc
.data  
mas1 dw 1,5,7,98,52,12,36,45
mas2 dw 2,3,89,5,14,23,6,58
len1 EQU (LENGTHOF mas2) ; количество элементов в массиве 

sum dw len1 DUP(0),0
sum2 dw len1 DUP(0),0 
tit1 db "Использование команды pminsw", 0
buf1 dq len1 DUP(0),0 
ifmt db "Команда находит минимальный элемент",10,10,
" Ответ=", len1 dup(" %d "),0

.code
entry_point proc
mov rax,len1 ; счетчик чисел 
mov rbx,4    ; кол. чисел в 64 разрядах
xor rdx,rdx ; подготовка к делению
div rbx     ; определение уол. циклов и остатка
mov rcx,rax  ; кол. циклов в счетчике
lea rsi,mas1 ; 
lea rdi,mas2 ;
lea rbx,sum  ; адрес хранения результата
@@:
movq MM0,qword ptr[rsi] ; загрузка чисел mas1
movq MM1,qword ptr[rdi] ; загрузка чисел mas2
pminsw MM0,MM1         ; 
movq qword ptr[rbx],MM0 ;
add rsi,8 ; адр. начала следующего цикла
add rdi,8 ; 
add rbx,8 ;
  loop @b 

 cmp rdx,0  ; определение остатка необработанных элементов массивов
 jz  exit   ; если элементы закончились, то перейти на exit
 mov rcx,rdx ; занесение в счетчик количества необработанных чисел
m2:  mov ax,word ptr [rsi] ; занесение необработанного элемента из mas1
 add  ax,word ptr [rdi]        ; сложение элементов двух массивов
 mov  word ptr [rbx],ax      ; результат
 add rsi,2     ; подготовка к выборке элемента из mas1
 add rdi,2     ; подготовка к выборке элемента из mas2
 add rbx,2     ; подготовка к записи результата в память
 loop m2       ; ecx := ecx – 1 и переход, если ecx /= 0
 exit:
  
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]

invoke wsprintf,ADDR buf1,ADDR ifmt,rsi,rdi,r10,r11,r12,r13,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end
