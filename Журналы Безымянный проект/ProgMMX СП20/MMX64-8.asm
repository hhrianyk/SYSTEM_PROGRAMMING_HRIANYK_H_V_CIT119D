;Числа заданы массивами masA:={a,b,c,d} и masE :={е1,е2,е3,е4}.
;Загрузить  массивы в регистры ММХ.
;Посчитать уравнение для 4-х чисел «е»
include \masm64\include64\masm64rt.inc
.data
mas1 db 1,2,3,4  ; a,b,c,d
masE dq 7,10,3,8 ;
len1 EQU (LENGTHOF masE) ; кол. элементов 
mas3 dq 4 dup(?)
res0 dq ? ; хранение 1-го результата
res1 dq ? ; хранение 2-го результата

tit1 db "Задание:  ae/b – ad;",0
txt1 db "Результаты : ", len1 dup(" %d "),0
buf1 dq ?,0

.code
entry_point proc
lea rsi,mas1 ; адрес mas1
lea rdi,masE
lea r8,mas3
mov rcx,len1
xor rdx,rdx

movq mm0,[rsi]  ; загрузка mas1
movq mm1,mm0    ; дублирование mas1
pextrw r10d,MM1,0 ; извлечение 0-го слова
and r10d,0ffh   ; маска - выделение мл. байта
pextrw r11d,MM1,0 ; извлечение 0-го слова
and r11d,0ff00h  ; выделение ст. байта
sar r11d,8   ; сдвиг на место мл. байта

pextrw r12d,MM1,1 ; извлечение 1-го слова
and r12d,0ffh
pextrw r13d, MM1,1
and r13d,0ff00h
sar r13d,8

cycle:
xor rbx,rbx
mov bl,byte ptr [rdi]
mov eax,r10d  ; a
mul rbx       ; ae
div r11d
mov r9,rax    ; ae/b
mov eax,r10d  ; a
mul r13d
sub r9,rax     ;
mov [r8],r9
add r8,8
add rdi,8
loop cycle

mov rax,mas3[0]
mov res0,rax    ; 1-й результат
mov rax,mas3[8]
mov res1,rax    ; 2-й результат
mov r14,mas3[16] ; 3-й результат
mov r15,mas3[24] ; 4-й результат
invoke wsprintf,ADDR buf1,ADDR txt1,res0,res1,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end