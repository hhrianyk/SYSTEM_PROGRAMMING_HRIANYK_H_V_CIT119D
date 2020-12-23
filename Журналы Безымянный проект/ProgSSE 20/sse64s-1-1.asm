include \masm64\include64\masm64rt.inc ;
.data 
mas1 DD 167.13
mas2 DD 23.13
titl1 db "Обработка дробных чисел",0
buf1 dq 2 dup(0.),0	; буфер
res1 dq 0,0
tFpu dq 0
tSse dq 0
ifmt db "Через FPU =  %d ",10, "Число тиков FPU =  %d ",10,10,
"Через SSE =  %d ",10,"Число тиков SSE =  %d ",10,
"Применена инструкция FISTTP — преобразование вещественного числа в целое с сохранением",
" целочисленного значения и округлением к меньшему.",10,10,
"Автор программы:  Рысованый А.Н., каф. ВТП, НТУ ХПИ",0
.code 
entry_point proc
rdtsc
xchg r14,rax 
finit
fld mas1
fld mas2
fadd
fisttp res1
rdtsc
sub rax,r14
mov tFpu,rax

rdtsc
xchg r14,rax 
movss XMM0,mas1
addss XMM0,mas2
cvtss2si eax,XMM0 ; скалярне перетворення одного мол. числа
movsxd r10,eax
rdtsc
sub rax,r14
mov tSse,rax
invoke wsprintf,addr buf1,ADDR ifmt,res1,tFpu,r10,tSse;
invoke MessageBox,0,addr buf1,addr titl1,MB_ICONINFORMATION
invoke ExitProcess,0
entry_point endp
end