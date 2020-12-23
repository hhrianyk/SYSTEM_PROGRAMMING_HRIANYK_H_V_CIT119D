include \masm64\include64\masm64rt.inc
.data 
mas1 DD 0, 2.,4.,6. ; резервирование ячеек памяти для массива mas1
mas2 DD 1.,3.,5.,7. ; резервирование ячеек памяти для массива mas2
res dq 2 dup (0)

titl1 db "masm64. Обработка дробных чисел",0
buf1 dq 2 dup(0.),0	; буфер
ifmt db "  %d, ","  %d, ","  %d, ","  %d ",10,10,
"CVTPS2DQ - преобразование 4-х упакованных чисел одинарной точности в ",
"4-е 32-разрядных числа",10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
.code 
entry_point proc
movups XMM0,mas1 ; пересылка 4-х 32-разрядных чисел массива mas1
movups XMM1,mas2 ; пересылка 4-х 32-разрядных чисел массива mas2
movhlps XMM0,XMM1 ; пересылка с обменом невыровненными 64 битами
cvtps2dq xmm3,xmm0
movupd res,xmm3

movsxd r10,dword ptr res[0]
movsxd r11,dword ptr res[4]
movsxd r12,dword ptr res[8]
movsxd r13,dword ptr res[12]
invoke wsprintf,addr buf1,ADDR ifmt,r10,r11,r12,r13
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0	
entry_point endp
end
