include \masm64\include64\masm64rt.inc
.data
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
classname db "template_class",0
caption db "Вывод  символов в Windows-окно",0
AppName db 'Обработка сообщений от левой клавиши мышки',0
MouseClick db 0  ; флаг нажатия 
myXY POINT <>  ; структура для х- та у-координат

.code
entry_point proc
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
   mrm wc.hbrBackground,0 ; цвет окна
    mov wc.lpszMenuName,0 ; заполнение поля в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; имя класса
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; регистрациЯ класса окна
   mov wid, 720 ; ширина пользовательского окна в пикселях
   mov hgt, 320 ; высота пользовательского окна в пикселях
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
mov MouseClick,TRUE 	; подтверждение получения координат
invoke InvalidateRect,hWnd,0,TRUE ; для перерисования окна
 .case WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd,ADDR ps ; заполнение структуры
mov  hdc,rax 		  ; сохранение контекста
     .if MouseClick == 1 		; проверка установления флажка
invoke lstrlen,ADDR AppName ; определение длины строки 
invoke TextOut,hdc,\ 		; выведение текста
 myXY.x,myXY.y,\ 		; координаты начала текста
  ADDR AppName,\ 		; адрес хранения текста
   rax 			; количество байтов текста
      .endif
invoke EndPaint,hWnd, ADDR ps
.endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end
