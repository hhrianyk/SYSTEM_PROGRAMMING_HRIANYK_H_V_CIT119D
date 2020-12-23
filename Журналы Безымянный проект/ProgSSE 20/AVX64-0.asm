OPTION DOTNAME       ; включение и отключение функций ассемблера
option casemap:none ; директива, сохраняет регистр имен, заданных пользователем
include \masm64\include64\win64.inc   ; основной файл макросов
include \masm64\macros64\macros64.inc ; вспомогательные макросы
    STACKFRAME                        ; создать размер стека по умолчанию
include \masm64\include64\kernel32.inc
include \masm64\include64\user32.inc
includelib \masm64\lib64\kernel32.lib
includelib \masm64\lib64\user32.lib
;include \masm64\include64\masm64rt.inc; подключаемые библиотеки
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
invoke ExitProcess,0
entry_point endp
end
