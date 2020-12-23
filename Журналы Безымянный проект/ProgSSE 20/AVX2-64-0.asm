title Рысованый А.Н.
include  \masm64\include64\masm64rt.inc; подключаемые библиотеки
.data 
titl db "Проверка микропроцессора на поддержку команд AVX2",0 ; название окна 
szInf db "Команды AVX2 ПОДДЕРЖИВАЮТСЯ!!!",0  ; 
inf db "Команды AVX2 микропроцессором НЕ поддерживаются",0
.code 
entry_point proc
mov eax,7
mov ecx,0
cpuid ; по содержимому rax производится идентификация микропроцессора
and  rbx,20h ;   (5 разряд)
jnz  exit1       ; перейти на exit, если не нуль
invoke MessageBox,0,addr inf,addr titl,MB_OK  
jmp exit2
exit1: 
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION
exit2:
invoke ExitProcess,0
entry_point endp
end	
