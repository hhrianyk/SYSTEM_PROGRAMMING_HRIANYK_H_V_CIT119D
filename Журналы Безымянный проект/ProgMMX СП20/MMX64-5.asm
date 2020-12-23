; Параллельное сложение с помощью ММХ-команд над массивами целых чисел.
; Если второе слово больше 55, то выполнить операцию
; a-c/b-dc  (-4,83), где a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; иначе - выполнить операцию a-c/b   (2,43)
title Рысованый АН.
include win64a.inc
fpuDiv macro _a,_c,_b ; макрос с именем fpuDiv
    fld _c
    fdiv _b
    fld _a
    fsubr
endm  			;; окончание макроса
.data  	         			
    _a REAL4 2.8
    _b REAL4 8.05
    _c REAL4 2.2
    _d REAL4 3.3
    arr1 dw 1,2,3,4          ; массив чисел arr1 размером в слово
    len1 equ ($-arr1)/type arr1  ; количество чисел массива
    arr2 dw 5,6,7,5 	       ; массив чисел arr2 размером в слово
    len2 equ ($-arr2)/type arr2    ; количество чисел массива
    arr1_2 BYTE (len1+len2) dup(0) ; размер буфера дл€ чисел массивов
    st1 db "FPU-MMX Result",0  ; название окошка
    st2 dd 0	        ; буфер чисел дл€ вывода сообщени€
  ifmt db "ќтвет =  %d ",0
  buf dd 0,0
.code 				
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 - возврат
mov rbp,rsp					
  movq MM1,QWORD PTR arr1 ; загрузка массива чисел arr1
  movq MM2,QWORD PTR arr2 ; загрузка массива чисел arr2
  paddb MM1,MM2     ; параллельное циклическое сложение
  movq QWORD PTR arr1_2,MM1 ; сохранение результата
pextrw eax,MM1,1 ; копирование из ћћ0 слова в eax
emms   		; последн€€ ћћ’-команда
 cmp eax,55
 jg @1 ; if >
 jmp @2
@1:  fpuDiv [_a],[_c],[_b]
 fld _d
  fmul _c
  fsub
  fisttp st2; сохранение целочисленного значени€ и округление в сторону нул€
    jmp @3
@2: fpuDiv [_a],[_c],[_b]
 fisttp st2 ; сохранение целочисленного значени€ и округление в сторону нул€
@3: invoke wsprintf,ADDR buf,ADDR ifmt,st2
   invoke MessageBox,0,addr buf,addr st1,MB_ICONQUESTION
invoke RtlExitUserProcess,0
WinMain endp
end	
