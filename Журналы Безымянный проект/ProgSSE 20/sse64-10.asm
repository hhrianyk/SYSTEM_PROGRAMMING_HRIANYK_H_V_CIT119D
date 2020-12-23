include \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data     	         				
mas1 dq 1.,2.     ; массив 1
mas2 dq 3.,4.     ; массив 2
mas3 dq 5.,6.     ; массив 3
mas4 dq 7.,8.1     ; массив 4 
titl1 db "SSE2-команды. Параллельный поиск max значений в массивах",0 ; название окна
fmt db "Параллельный поиск max значений",0Ah,0Dh,\ 
 "в парах упакованных 64-разрядных чисел с плавающей точ-кой.",0Ah,0Dh,0Dh,
  "Массивы:",0Ah,0Dh,"mas1:   1.,  2.",0Ah,0Dh,"mas2:   3.,  4.",0Ah,0Dh,0Dh,
   "mas3:   5.,  6.",0Ah,0Dh,"mas4:   7.,  8.",0Ah,0Dh,0Dh,\
    "Сумма максимальных значений массивов= %d",10,
    "Автор:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
buf1 dq 0 ; буфер
.code
entry_point proc 				

movupd Xmm0,mas1	; занесение masl к ХММО
movupd Xmm1,mas2  ; занесение mas2 к Хмм1
movupd Xmm2,mas3	; занесение mas3 к Хмм2
movupd Xmm3,mas4	; занесение mas4 к ХММЗ
maxpd Xmm0,xmm1     ; нахождение максимумов в mas1 и mas2
maxpd Xmm2,xmm3     ; нахождение максимумов в mas3 и mas4
addpd Xmm0,xmm2	  ; сумма максимумов
unpckhpd xmm4,xmm0 ; распаковка ст. ч. xmm0 в ст. ч. xmm4 и сдвиг мл. ч. xmm4
unpckhpd xmm4,xmm5 ; перемещение ст. части xmm4 в мл. ч. xmm4
unpcklpd xmm5,xmm0 ; распаковка мл. ч. xmm0 в ст. ч. xmm5 и сдвиг мл. ч. xmm5
unpckhpd xmm5,xmm6 ; перемещение ст. части xmm5 в мл. часть xmm5
addpd xmm4,xmm5         ; сумма xmm4 и xmm5
cvtpd2pi MM0,xmm4       ; превращение в 32-разрядное число
movd dword ptr ebx,mm0  ; занесение содержимого ММ0 в ebx
invoke wsprintf,addr buf1,addr fmt,ebx  ; преобразование
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION+90000h
invoke ExitProcess,0
entry_point endp
end
