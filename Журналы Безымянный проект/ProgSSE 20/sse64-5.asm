include \masm64\include64\masm64rt.inc
DATE1 STRUCT ; СТРУКТУРА с именем Date1
a1 dd ?	; имя первого поля структуры  
a2 dd ?	; имя второго поля структуры  
a3 dd ? ; имя третьего поля структуры  
a4 dd ?	; имя четвертого поля структуры  
DATE1 ENDS ; окончание структуры

.data
  Car1  DATE1 <1.1,2.2,3.3,4.4> ; структура с именем Car1
  titl1 db 'Сложение 1-го и 4-го элементов массива <1.1,2.2,3.3,4.4>',0
fmt db "Результат -   %d",10,10,
"Применена команда cvtss2si - конвертирует сжатое значение с ПТ одинарной точности ", 
"в 32-разрядное целое число", 10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
buf1 db 0
.code          			       ; 
entry_point proc
movss XMM0,Car1.a1
addss XMM0,Car1.a4
;movss res,XMM0
cvttss2si eax,xmm0
;fld res
;fisttp res1
invoke wsprintf,addr buf1,addr fmt,eax;res1  
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0	
entry_point endp
end	