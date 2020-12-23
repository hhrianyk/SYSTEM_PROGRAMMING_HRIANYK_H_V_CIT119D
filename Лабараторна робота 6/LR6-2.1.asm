include \masm64\include64\masm64rt.inc
.data	

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
classname db "template_class",0
caption db "Гряафічна фігура",0
MouseClick db 0  ; флаг нажатия 
myXY POINT <>  ; структура для х- та у-координат

 mas dd 500 ; 
 m dd  0.25 
 R dd 1.0
 r dd 1.0
 t dd 0.0 ; угловая координата 

 delta dd 0.1175 ; один градус
 xdiv2 dq ?    ; середина по X 
 ydiv2 dq ?    ; середина по Y
 tmp dd 0       ; временная переменная
 divK dd 100.0 ; масштабный коэффициент
 xr dd 0. 	; координаты функции
 yr dd 0
 temp1 dd 0


 text01 db "x=%d y=%d",0
 AppName db "Rina",0
buf1 dq 3 dup(0),0

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
l1:                         ; x = x0 + Кfcosf

fld m   ; m
fmul t ; m*alpha
fcos       ;cos(m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)cos(m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FCOS       ;cos(t-r*t)
FMUL m     ;m*cos(t-rt)
FADD       ;(R-RM)cos(m*t)+m*cos(t-rt)
FMUL divK  ; розмір*((R-RM)cos(m*t)+m*cos(t-rt))
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 




fld m
fmul t ; m*alpha
fsin       ;sin (m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)sin (m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FSIN       ;sin (t-r*t)
FMUL m     ;m*cos(t-rt)
FSUB      ;(R-RM)sin (m*t)-m*sin (t-rt)
FMUL divK  ; розмір*((R-RM)sin (m*t)+m*sin (t-rt))FMUL divK
fstp tmp
fild ydiv2      
fsub tmp  
 
fistp dword ptr yr ; сохранение X для выведения на экран


 
invoke Sleep,1             ; задержка
invoke SetCursorPos,xr,yr ; установление курсора по xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3
dec temp1   ; уменьшение счетчика
jz l2       ; продолжение рисование
jmp l1	; выход из цикла
l2: 
  mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
call main
    invoke ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; объявление локальных переменных
    LOCAL lft :QWORD ;  Лок. переменные содержатся в стеке 
    LOCAL top :QWORD  ; и существуют только во время вып. проц.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; колич. байтов структуры
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; стиль окна
    mov wc.lpfnWndProc,ptr$(WndProc) ; адрес процедуры WndProc
    mov wc.cbClsExtra,0 ; количество байтов для структуры класса
    mov wc.cbWndExtra,0 ; количество байтов для структуры окна
   mrm wc.hInstance,hInstance ; заполнение полЯ дескриптора в структуре
   mrm wc.hIcon,  hIcon ; хэндл иконки
   mrm wc.hCursor,hCursor ; хэндл курсора
   mrm wc.hbrBackground,5 ; цвет окна
    mov wc.lpszMenuName,0 ; заполнение поля в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; имя класса
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; регистрациЯ класса окна
   mov wid, 420 ; ширина пользовательского окна в пикселях
   mov hgt, 420 ; высота пользовательского окна в пикселях
    mov rax,sWid ; колич. пикселей монитора по x
    sub rax,wid ; дельта • = •(монитора) - х(окна пользователя)
    shr rax,1   ; получение середины •
    mov lft,rax ;

    mov rax, sHgt ; колич. пикселей монитора по y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
         ADDR classname,ADDR caption, \
         WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
         lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; сохранение дескриптора окна
  call msgloop
    ret
main endp

msgloop proc
    LOCAL msg  :MSG
    LOCAL pmsg :QWORD
    mov pmsg,ptr$(msg) ; получение адреса структуры сообщениЯ
    jmp gmsg           ; jump directly to GetMessage()
  mloop:
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg ; отправка на обслуживание к WndProc
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0) ; пока GetMessage не вернет ноль
    jnz mloop
    ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
LOCAL hdc:HDC   	; резервирование стека для дескриптора окна
LOCAL ps:PAINTSTRUCT ; для структуры PAINTSTRUCT
LOCAL rect:RECT      ; для структуры координат RECT
.switch uMsg
 .case WM_DESTROY ; если есть сообщение про уничтожение окна
        invoke PostQuitMessage,NULL
 .case WM_LBUTTONDOWN    ; сообщение от левой клавиши 
mov rax,lParam  ; 32-разрядные координаты курсора мышки
and rax,0ffffh  ; выделение младшей части - координаты Х
mov myXY.x,eax	; сохранение координаты X
mov rax,lParam  ; 32-разрядные координаты курсора мышки
shr rax,16 		; сдвиг вправо на 4 байта для выделения  Y 
mov myXY.y,eax  ; сохранение координаты Y
;mov MouseClick,TRUE 	; подтверждение получения координат
invoke InvalidateRect,hWnd,0,TRUE ; для перерисования окна
 .case WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd,ADDR ps ; заполнение структуры
mov  hdc,rax 		  ; сохранение контекста
      		; проверка установления флажка
   mov r10d,mas ; сохранение количества циклов
 mov temp1,r10d
 invoke InvalidateRect,hWnd,0,TRUE ; вызов функции и WM_PAINT
finit
    invoke BeginPaint,hWnd, ADDR ps ; вызов подготовительной процедуры
  mov hdc,rax            ; сохранение контекста
 
l1:   
                      
invoke wsprintf,ADDR buf1,ADDR text01,xr,yr                        
   invoke TextOut,hdc, 10,30,ADDR buf1,15 

 sub xr, 480
 sub yr, 200

 invoke TextOut,hdc,xr,yr,\ ; координаты начала текста
      addr AppName ,4; адрес хранения текста и кол. байтов текста

 

  fld m   ; m
fmul t ; m*alpha
fcos       ;cos(m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)cos(m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FCOS       ;cos(t-r*t)
FMUL m     ;m*cos(t-rt)
FADD       ;(R-RM)cos(m*t)+m*cos(t-rt)
FMUL divK  ; розмір*((R-RM)cos(m*t)+m*cos(t-rt))
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 
 

fld m
fmul t ; m*alpha
fsin       ;sin (m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)sin (m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FSIN       ;sin (t-r*t)
FMUL m     ;m*cos(t-rt)
FSUB      ;(R-RM)sin (m*t)-m*sin (t-rt)
FMUL divK  ; розмір*((R-RM)sin (m*t)+m*sin (t-rt))FMUL divK
fstp tmp
fild ydiv2      
fsub tmp  
 
fistp dword ptr yr ; сохранение X для выведения на экран
 
 
invoke Sleep,4             ; задержка
invoke SetCursorPos,xr,yr ; установление курсора по xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3

dec temp1   ; уменьшение счетчика
jz l2       ; продолжение рисование
jmp l1	; выход из цикла
l2: 
 
invoke EndPaint,hWnd, ADDR ps			; количество байтов текста
      .endif
 
 
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end