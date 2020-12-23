include \masm64\include64\masm64rt.inc ; подключаемые библиотеки
.data     	         				
mas1 dd 1.,2.,3.,6.
titl1 db "Сложение чисел массива ",0 ;
fmt db "Сложение 32-разрядных дробных чисел одного массива",10,
"с использованием команд SSE",10,
"mas1:  1., 2., 3., 4.", 10,10, "Сумма: %d",10,
"Автор:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
 buf1 dq 0,0 ; буфер 
.code
entry_point proc
;movups - пересылка невыровненных упакованных коротких вещественных значений
;movaps - пересылка выровненных упакованных коротких вещественных значений
movups XMM0,mas1          ; XMM0:= 4. 3. 2. 1. 
movaps XMM1,XMM0          ; XMM1:= 4. 3. 2. 1.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 3. 2.
addss XMM0,XMM1            ; XMM0:= 4. 3. 2. 3.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 4. 3.
addss XMM0,XMM1            ; XMM0:= 4. 3. 2. 6.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 4. 4.
addss XMM0,XMM1            ; XMM0:= 4. 3. 2. 10.
cvttss2si eax,xmm0 
movsxd r15,eax 

invoke wsprintf,addr buf1,addr fmt,r15  
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION        
invoke ExitProcess,0
entry_point endp
end	