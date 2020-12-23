title Рысованый А.Н.
; masm64. Числа а є{a1,a2,a3} заданы массивом 
; и имеют размерность Real8. Вычислить уравнение d/b sqrt(a) + a
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data
arr1 real8 16.,25.,36.,1244. ; массив чисел А
len1 equ LENGTHOF arr1       ; ($-arr1)/type arr1
arr2 real8 2.,4.,16.         ; b, c, d
tit1 db "masm64. AVX. Результат вычисления уравнения d/b sqrt(a) + a.",0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения
ifmt db "masm64.  Массив ai = 16., 25., 36., 1244.",10,
9,"Числа: b, c, d  := 2., 4., 16.",10,
"Результаты вычисления: ", 4 dup(" %d "),10,10,
"Автор: Рысованый А.Н., каф. ВТП, фак. КИТ, НТУ ХПИ",10,
9,"Сайт:  http://blogs.kpi.kharkov.ua/v2/asm/",0
tit2 db "masm64.Проверка микропроцессора на поддержку команд AVX",0
szInf2 db "Команды AVX микропроцессором НЕ поддерживаются",0;
.code               ; уравнение d/b sqrt(a) + a
entry_point proc
; проверка на поддержку AVX команд
mov EAX,1          ; при использования 64-разрядной ОС   
cpuid ; по eax производится идентификация МП
and  ecx,10000000h ; eсx:= eсx v 1000 0000h  (28 разряд)
jnz @1             ; перейти, если не нуль
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION
jmp exit1
@1:
mov rcx,len1
lea rdx,res
lea rbx,arr1
vmovsd xmm1,arr2[0]  ; xmm1 - b - переслать двойное слово
vmovsd xmm2,arr2[8]  ; xmm2 - c
vmovsd xmm3,arr2[16] ; xmm3 - d
vdivsd xmm3,xmm3,xmm1  ; d/b
@@:
vmovsd xmm0,qword ptr[rbx] ; xmm0 - a
vsqrtsd xmm4,xmm4,xmm0     ;sqrt(a)
vmulsd xmm4,xmm4,xmm3      ; d/b x sqrt(a)
vaddsd xmm4,xmm4,xmm0      ; d/b x sqrt(a) + a 
vcvttsd2si r15d,xmm4	 ; 
movsxd r15,r15d 
mov [rdx],r15d ; сохранение результата
add rbx,8
add rdx,8
dec rcx
jnz @b ; ссылка на предыдущую метку @@ (наверх)
mov r10,res
mov r11,res[8]
mov r12,res[16]
mov r13,res[24]

invoke wsprintf,addr buf1,addr ifmt,r10,r11,r12,r13
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
exit1: 
invoke ExitProcess,0
entry_point endp
end