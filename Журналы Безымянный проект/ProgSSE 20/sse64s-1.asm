include \masm64\include64\masm64rt.inc ;
.data 
a1 DD 167.13
a2 DD 23.13
b1 qword 167.13
b2 dq 23.13
titl1 db "Обработка дробных чисел",0
buf1 dq 3 dup(0.),0; буфер
res1 dd 0,0
ifmt db "Через FPU =  %d ",10, "Через SSE =  %d ",10,"Через SSE2 =  %08I64x ",10,10,
"Применена инструкция FISTTP — преобразование вещественного числа в целое с сохранением",
" целочисленного значения и округлением к меньшему.",10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
.code 
entry_point proc
 
finit
fld a1
fld a2
fadd
fisttp res1

movss XMM0,a1
addss XMM0,a2
cvtss2si r10d,XMM0 ; преобраз. вещественного в скалярное мл. числo

movsd XMM1,qword ptr b1
addsd XMM1,qword ptr b2
cvtsd2si r11d,XMM1 ;
invoke wsprintf,addr buf1,ADDR ifmt,res1,r10d,r11d;
invoke MessageBox,0,addr buf1,addr titl1,MB_OK
invoke ExitProcess,0
entry_point endp
end	