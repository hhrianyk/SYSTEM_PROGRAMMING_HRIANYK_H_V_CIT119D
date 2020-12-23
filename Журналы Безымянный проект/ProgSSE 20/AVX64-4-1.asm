title Рысованый А.Н.
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
mas1 dd 10, 5, 2, 1
mas2 dd 16,10, 9, 8
res dd 4 dup(0),0
buf1 dq 4 DUP(0),0
_info db "Пример работы команды AVX vpaddd",0Ah,0Dh,
    "(циклическое сложение).", 0Ah, 0Dh,
    "Результат работы: ", 4 dup(" %d "),0
_title db "Вывод чисел через распаковку и преобразование",0
.code 
entry_point proc
vmovups xmm1, mas1 ; переслать невыровненные упакованные значения
vmovups xmm2, mas2 ; переслать невыровненные упакованные значения
vpaddd xmm0, xmm1, xmm2 ; операция циклического сложения
vunpcklpd xmm4, xmm4, xmm0 ; распаковка младших половин
vunpckhpd xmm4, xmm4, xmm5 ; распаковка старших половин 
vunpckhpd xmm5, xmm5, xmm0 ; распаковка старших половин
vunpckhpd xmm5, xmm5, xmm6 ; распаковка старших половин
vcvtdq2pd xmm0, xmm4 ; преобразование на числа с двойной точностью
vcvtdq2pd xmm1, xmm5 ; преобразование на числа с двойной точностью 

vunpcklpd xmm4, xmm4, xmm0 ; распаковка младших половин
vunpckhpd xmm4, xmm4, xmm6 ; распаковка старших половин
vunpckhpd xmm5, xmm5, xmm0 ; распаковка старших половин
vunpckhpd xmm5, xmm5, xmm4 ; распаковка старших половин
vcvttsd2si eax, xmm4 ; преобразование числа двойной точности
vcvttsd2si ebx, xmm5 ; преобразование числа двойной точности 
;mov dword ptr res, eax ; 
;mov dword ptr res[4], ebx ;
movsxd r10,eax
movsxd r11,ebx 

vunpcklpd xmm4, xmm4, xmm1 ; распаковка младших половин
vunpckhpd xmm4, xmm4, xmm6 ; распаковка старших половин
vunpckhpd xmm5, xmm5, xmm1 ; распаковка старших половин
vunpckhpd xmm5, xmm5, xmm4 ; распаковка старших половин
vcvttsd2si eax, xmm4 ; преобразование числа двойной точности
vcvttsd2si ebx, xmm5 ; преобразование числа двойной точности 
;mov dword ptr res[8],eax ; 
;mov dword ptr res[12],ebx ;
movsxd r12,eax
movsxd r13,ebx
 
invoke wsprintf,ADDR buf1,ADDR _info,r10,r11,r12,r13 ; 
invoke MessageBox,0,addr buf1,addr _title,0 ; 
invoke ExitProcess,0
entry_point endp
end	
