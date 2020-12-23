title Рысованый А.Н.
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
mas1 dd 10, 5, 2, 1
mas2 dd 16,10, 9, 8
res dd 4 dup(0),0
buf dd 4 DUP(0),0
_info db "Пример работы команды AVX vpaddd",0Ah,0Dh,
 "(циклическое сложение).",10,10,"Результат работы: ", 4 dup(" %d "),10,10,
 "Автор: Рысованый А.Н., каф. ВТП, фак. КИТ, НТУ ХПИ",10,
9,"Сайт:  http://blogs.kpi.kharkov.ua/v2/asm/",0
_title db "Вывод чисел через распаковку и преобразование",0
.code 
entry_point proc
mov eax,4 ;
vmovups xmm1, mas1 ; переслать невыровненные упакованные значения
vmovups xmm2, mas2 ; переслать невыровненные упакованные значения
vpaddd xmm3, xmm1, xmm2 ; операция циклического сложения
vpextrd r10d,xmm3,0   ; извлечение 0-го числа з xmm 
vpextrd r11d,xmm3,1   ; извлечение 1-го числа з xmm 
vpextrd r12d,xmm3,2   ; извлечение 2-го числа з xmm
vpextrd r13d,xmm3,3   ; извлечение 3-го числа з xmm 
movsxd r10,r10d
movsxd r11,r11d
movsxd r12,r12d
movsxd r13,r13d
invoke wsprintf,ADDR buf,ADDR _info,r10,r11,r12,r13 ; 
invoke MessageBox,0,addr buf,addr _title, 0 ; 
invoke ExitProcess,0
entry_point endp
end	
