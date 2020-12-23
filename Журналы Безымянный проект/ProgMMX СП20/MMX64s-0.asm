include \masm64\include64\masm64rt.inc ; библиотеки
.data 	
mas1 db 1,2,3,4,5,6,7,8
mas2 DB 9,8,7,6,5,4,3,2
len1 equ ($-mas2) ; определение кол. байт массива mas2
mas3 db len1 dup(?) ;
mas4 db len1 dup(255) ; для сложения командами общ.назнач.

tit1 db "Сравнение времени обработки массива. masm64 ",0
ifmt db "Время обработки командами общ. назначения: %d",10,10,
"Время обработки MMX: %d",10,10,"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
buf1 dq 0
.code  		
entry_point proc
lea rsi,mas1 ; загрузка адреса массива mas1
  lea r10,mas1 ; сохранение адреса для использования командами MMX
lea rdi,mas2 ; загрузка адреса массива mas2
  lea rbx,mas2 ; сохранение адреса для использования командами MMX
lea r11,mas3 ; загрузка адреса массива mas3
  lea r12,mas4 ; сохранение адреса для использования командами MMX
rdtsc   ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
mov r14,rdx ;
mov rcx,len1 ;
@@: mov al,[rsi]
    add al,byte ptr [rdi]
    mov byte ptr [r11],al
    inc rsi ; 
    inc rdi ;
    inc r11 ;
loop @b
rdtsc ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
sub rdx,r14 ;
mov r14,rdx ;

rdtsc ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
mov r15,rdx ;

movq mm0,qword ptr [r10] ; занесение 8 байтов mas1 в ММ0
paddb MM0,qword ptr [rbx] ; mas1 + mas2
movq qword ptr [r12],MM0 ; результат

rdtsc ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
sub rdx,r15 ;
mov r15,rdx ;

invoke wsprintf,ADDR buf1,ADDR ifmt,r14,r15
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION;
invoke ExitProcess,0
entry_point endp
end
