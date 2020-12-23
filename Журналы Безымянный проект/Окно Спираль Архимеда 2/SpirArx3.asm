include \masm64\include64\masm64rt.inc
.data	
 mas dd 360 ; 
 alpha dd 0.0 ; угловая координата 
 delta dd 0.0175 ; один градус
 xdiv2 dq ?    ; середина по X 
 ydiv2 dq ?    ; середина по Y
 tmp dd 0       ; временная переменная
 divK dd 10.0 ; масштабный коэффициент
 xr dd 0. 	; координаты функции
 yr dd 0
temp1 dd 0

titl1 db "Время вып.",0 
buf dq 2 dup(?)
fmt db "fpu = %d,","sse = %d",0    ; форматування чисел

.code
entry_point proc
 invoke GetSystemMetrics,SM_CXSCREEN ; получение ширины экрана в пикселях
  shr rax,1 ; деление на 2 – определение середины экрана по Х
  mov xdiv2,rax
 invoke GetSystemMetrics,SM_CYSCREEN ; получение высоты экрана в пикселях
  shr rax,1 ; деление на 2 – определение середины экрана по Y
  mov ydiv2,rax
 mov r10d,mas ; сохранение количества циклов
 mov temp1,r10d
finit
l1:                        ; x = x0 + Кfcosf
rdtsc   ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
mov r14,rdx ;

fld alpha   ; st(0) := alpha
fcos        ; st(0) := cos(alpha)
 fld alpha 	; st(0) := alpha
 fmul divK 	; st(0) := alpha * divK, st(1) := cos(alpha)
 fmul     ; st(0) := st(0) * st(1)  := alpha * divK * cos(alpha)
 fild xdiv2      
 fadd       ; xr := xdiv2 + alpha * divK * cos(alpha)
 fistp dword ptr xr ; сохранение X
rdtsc ; edx,eax
shl rdx,32 ; смещение в свободную ст. часть
add rdx,rax ; ст. и мл. части в одном регистре
sub rdx,r14 ;
mov r14,rdx ;

rdtsc ; edx,eax
 shl rdx,32  ; смещение в свободную ст. часть
 add rdx,rax ; ст. и мл. части в одном регистре
 mov r15,rdx ;

fstp xr ; сохранение в памяти
 movss XMM0,xr   ; cos(alpha)  
 mulss XMM0,alpha
 mulss XMM0,divK  ;
 cvtss2si eax,XMM0 ;
add rax,xdiv2 ;
mov xr,eax

rdtsc ; edx,eax
 shl rdx,32 ; смещение в свободную ст. часть
 add rdx,rax ; ст. и мл. части в одном регистре
 sub rdx,r15 ;
 mov r15,rdx ;
invoke wsprintf,addr buf,addr fmt,r14,r15
invoke MessageBox,0,addr buf,addr titl1,MB_OK; 

; fld alpha     ; st(0) := alpha
; fsin            ; st(0) := sin(alpha)
; fld alpha     ; st(0) := alpha
; fmul divK   ; st(0) := alpha * divK, st(1) := sin(alpha)
; fmul          ; st(0) := st(0) * st(1) := alpha * divK * cos(alpha)
; fstp tmp
; fild ydiv2      
; fsub tmp       ; yr:= ydiv2 - alpha * divK * cos(alpha)
; fistp dword ptr yr ; сохранение X для выведения на экран

; invoke Sleep,1             ; задержка
; invoke SetCursorPos,xr,yr ; установление курсора по xr, yr 
; movss XMM3,delta
; addss XMM3,alpha
; movss alpha,XMM3
; pop ecx   ; возвращение из стека количества циклов
; dec ecx   ; уменьшение счетчика
; push ecx
;jz l2       ; продолжение рисування
;jmp l1	    ; выход из цикла
l2: dec temp1   ; уменьшение счетчика
invoke  ExitProcess,0 ; 
entry_point endp
end
