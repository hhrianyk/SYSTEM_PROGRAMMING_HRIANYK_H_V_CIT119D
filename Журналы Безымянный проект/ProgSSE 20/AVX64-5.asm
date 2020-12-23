title Рысованый А.Н.
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data
mas1 dd 1, 10, 3, 8
mas2 dd 5,  6, 7, 8
tit1 db "masm64. AVX. Исследование команды vpcmpgtb",0
ifmt db "Пример работы команды AVX vpcmpgtb",10,
  "(сравнение на больше).",10,10,
  "Результат работы (255 - больше, 0 - меньше или равно): ",10,10,
   4 dup(" %d "),10,
   "Автор: Рысованый А.Н., каф. ВТП, фак. КИТ, НТУ ХПИ",10,
   9,"Сайт:  http://blogs.kpi.kharkov.ua/v2/asm/",0
buf1 dd 4 DUP(0),0
.code               
entry_point proc
vmovups xmm1,mas1 ; ymm1,mas1 для AVX2
vmovups xmm2,mas2
vpcmpgtb xmm3,xmm1,xmm2 ;https://support.amd.com/TechDocs/26568.pdf
vpextrd r10d,xmm3,0   ; извлечение 0-го числа з xmm 
vpextrd r11d,xmm3,1   ; извлечение 1-го числа з xmm 
vpextrd r12d,xmm3,2   ; извлечение 2-го числа з xmm
vpextrd r13d,xmm3,3   ; извлечение 3-го числа з xmm 

invoke wsprintf,ADDR buf1,ADDR ifmt,r10d,r11d,r12d,r13d
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
exit1: invoke ExitProcess,0
entry_point endp
end	