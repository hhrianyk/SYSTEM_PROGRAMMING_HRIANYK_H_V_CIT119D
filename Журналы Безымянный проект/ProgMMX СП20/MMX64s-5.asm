; Параллельное сложение с помощью ММХ-команд над массивами целых чисел.
; Если второе слово больше 55, то выполнить операцию
; a-c/b-dc  (-4,83), где a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; иначе - выполнить операцию a-c/b   (2,43)
include \masm64\include64\masm64rt.inc
fpuDiv macro _a,_c,_b ; макрос fpuDiv
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
    arr1_2 BYTE (len1+len2) dup(0) ; размер буфера
    tit1 db "FPU-MMX Result",0  ; название окошка
    sms1 dd 0 ; длЯ вывода сообщениЯ
  ifmt db "Oтвет =  %I64d ",0
  buf1 dd 0,0
.code 				
entry_point proc
  movq MM1,QWORD PTR arr1 ; загрузка массива чисел arr1
  movq MM2,QWORD PTR arr2 ; загрузка массива чисел arr2
  paddb MM1,MM2     ; параллельное циклическое сложение
  movq QWORD PTR arr1_2,MM1 ; сохранение результата
pextrw eax,MM1,1 ; копирование из ћћ0 слова в eax
emms   		; последняя MMX-команда
 cmp eax,55
 jg @1 ; if >
 jmp @2
@1:  fpuDiv [_a],[_c],[_b] ; a-c/b
 fld _d
 fmul _c
 fsub
 fisttp sms1 ; сохранение целочисленного значениЯ и округление в сторону нулЯ
    jmp @3
@2: fpuDiv [_a],[_c],[_b]
 fisttp sms1 ; сохранение целочисленного значениЯ и округление в сторону нулЯ
@3:
invoke wsprintf,ADDR buf1,ADDR ifmt,sms1
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONQUESTION
invoke ExitProcess,0
entry_point endp
end	