title Рысованый А.Н.
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
titl db "Проверка микропроцессора на поддержку команд AVX",0 ; название окна 
szInf db "Команды AVX ПОДДЕРЖИВАЮТСЯ!!!",0  ; 
inf db "Команды AVX микропроцессором НЕ поддерживаются",0
.code 
entry_point proc
mov   rax,1	
cpuid ; по содержимому rax производится идентификация микропроцессора
and  rcx,10000000h ; rсx:= rсx v 1000 0000h  (28 разряд)
jnz  exit1       ; перейти на exit, если не нуль
invoke MessageBox,0,addr inf,addr titl,MB_OK  
jmp exit2
exit1: 
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION
exit2:

.data 
b1 dd 10, 8, 9, 6
titl1 db "Исследование команды vpextrd",0
buf db ?
frmt db "2-е число из XMM = %d",0
.code 
vmovups xmm2, b1 
vpextrd eax,xmm2,2   ; извлечение 2-го числа з xmm 
invoke wsprintf, addr buf, addr frmt, eax
invoke MessageBox,0,addr buf,addr titl1,MB_OK
invoke ExitProcess,0
entry_point endp
end	
