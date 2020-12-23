title  ; masm64
include \masm64\include64\masm64rt.inc
include LR8-3.inc

.data ;

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 

title1 db "Лаб.8",0   

txt01 db "Написати програму вичислення порівнянь на FPU, SSE, AVX у різних процесах із вивідним часом їх виконання.",0
txt02 db "ab/sqrt(c) – d/e   ",0
txt03 db "13,3,16,41,10",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0
txt04 db "Число тиков FPU =  %d ",10,10,"Число тиков SSE =  %d ",10,10,
"Число тиков AVX =  %d ",0 

txt041 db "Число тиков FPU =  %d ",0
txt042 db "Число тиков SSE =  %d ",0
txt043 db "Число тиков AVX =  %d ",0

txt051 db "Результат FPU =  %d ",0
txt052 db "Результат SSE =  %d ",0
txt053 db "Результат AVX =  %d ",0
 

buf1 dq 9 dup(0),0; буфер
buf2 dq 3 dup(0),0
buf3 dq 3 dup(0),0
buf4 dq 3 dup(0),0

buf5 dq 3 dup(0),0
buf6 dq 3 dup(0),0
buf7 dq 3 dup(0),0


tFpu dq 0
tSse dq 0
tAvx dq 0

rFpu dd 145.75
rSse dd 0.0
rAvx dd 0
 
h1 dq	?	; идентификатор потока
h2 dq	?	; идентификатор потока
h3 dq	?	; идентификатор потока
hEventStart HANDLE ? ;хэндл события
temp dd 0
.code
	
proc1 proc ;  процедура 
 rdtsc
xchg r14,rax 
finit
lea rsi,mas1  ; адрес начала массива mas1

 fild dword ptr  [rsi]  ; загрузка целого числа
FIMUL dword ptr  [rsi+4]
fild dword ptr [rsi+8]
FSQRT
FDIVP
fild dword ptr [rsi+12]
FIDIV dword ptr [rsi+16]
FSUB
fistp dword ptr rFpu 

rdtsc
sub rax,r14
mov tFpu,rax

ret
proc1 endp ;

proc2 proc	; процедура 
rdtsc
xchg r14,rax 
 lea rsi,a1   ; адрес начала массива mas1
 
	 movups xmm1, [rsi]  ;  
      lea rsi,b1
	 movups xmm2, [rsi]  ; 
       mulps xmm1,xmm2;
             lea rsi,c1
      movups  xmm2, [rsi];
      SQRTps xmm2,xmm2
      DIVps xmm1,xmm2
                  lea rsi,d1
      movups xmm2,[rsi]
      lea rsi,e1
      movups xmm3,[rsi]
      DIVps xmm2, xmm3
      SUBps xmm1,xmm2
      cvttss2si eax,xmm1 
       movsxd r10,eax 
         mov   rSse,eax


rdtsc
sub rax,r14
mov tSse,rax
ret
proc2 endp	;


proc3 proc	; процедура 
rdtsc
xchg r14,rax 
 
 lea rsi,a1   ; адрес начала массива mas1
 
	 vmovups ymm1, [rsi]  ; 
       lea rsi,b1   ; адрес начала массива  

       vmulps  ymm1,ymm1, [rsi];
       lea rsi,c1   ; адрес начала массива 

       vmovups  ymm2, [rsi];
      vsqrtps  ymm2,ymm2
      vdivps ymm1,ymm1,ymm2
      lea rsi,d1   ; адрес начала массива 
      vmovups xmm2, [rsi]
      lea rsi,e1   ; адрес начала массива 
      VDIVPS ymm2,ymm2,   [rsi]
      VSUBPS ymm1,ymm1,ymm2
      ; VCVTTSD2SI  eax,ymm1 
      vmovups rAvx,ymm1 



rdtsc
sub rax,r14
mov tAvx,rax
ret
proc3 endp	;

entry_point proc
lea rax, proc1   ; загрузка адреса процедуры 
invoke CreateThread,0,0,rax,0,0,addr h1 ; создать процесс
lea rax, proc2 ; загрузка адреса процедуры 
invoke CreateThread,0,0,rax,0,0,addr h2; создать процесс
lea rax, proc3 ; загрузка адреса процедуры 
invoke CreateThread,0,0,rax,0,0,addr h3; создать процес
invoke CreateEvent,0,FALSE,FALSE,0; создание события
mov hEventStart,rax    ; сохранение хендла события
invoke WaitForSingleObject,hEventStart,1000

invoke wsprintf,addr buf1,ADDR txt04,tFpu,tSse,tAvx;
invoke wsprintf,addr buf2,  ADDR txt041,tFpu;
invoke wsprintf,addr buf3,ADDR txt042,tSse;
invoke wsprintf,addr buf4,ADDR txt043,tAvx;

invoke wsprintf,addr buf5,ADDR txt051,rFpu;
invoke wsprintf,addr buf6,ADDR txt052,rSse ;
invoke wsprintf,addr buf7,ADDR txt053,rSse;
 ;  

 mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,0,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp


mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
     
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
       ; mov hStatic, rv(GetDlgItem,hWin,101)
       ; invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 103 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
          .case 102
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 104
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
;/////////////////////////////////////////
           .case 105 ; кнопка
         invoke MsgboxI,hWin,ADDR buf5,"Результат FPU",MB_OK,10;  
;/////////////////////////////////////////

    .case 106 ; кнопка
         invoke MsgboxI,hWin,ADDR buf6,"Результат SSE",MB_OK,10;  
;/////////////////////////////////////////
    .case 107 ; кнопка
          invoke MsgboxI,hWin,ADDR buf7,"Результат AVX",MB_OK,10;  
 ;/////////////////////////////////////////
 
 .case 120 ; кнопка
        invoke MsgboxI,hWin,ADDR buf2,"TiCK FPU",MB_OK,10;  
 
;/////////////////////////////////////////
 .case 108 ; кнопка
       invoke MsgboxI,hWin,ADDR buf3,"TiCK SSE",MB_OK,10;  
 
;/////////////////////////////////////////
 .case 109 ; кнопка
    invoke MsgboxI,hWin,ADDR buf4,"TiCK AVX",MB_OK,10;  
 
;/////////////////////////////////////////
   
 .case 201    
           invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10;
           
 .case 202     
           invoke MsgboxI,hWin,ADDR txt02,"Вираз",MB_OK,10;
 .case 206     
           invoke MsgboxI,hWin,ADDR txt03,"Масив",MB_OK,10;
                      
 .case 203
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
 .case 205
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;        
 .case 207
             invoke MsgboxI,hWin,ADDR buf1,"TiCK",MB_OK,10;    


        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp
    end

end