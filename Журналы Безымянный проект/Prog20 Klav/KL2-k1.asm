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
Hello db "Выберите символ на клавиатуре. Нажмите на кнопку символа. masm64",0
char1 dq 20h; символ пропуска, который программа получает от клавиатуры
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
  ; ---------------------------------
  ; centre window at calculated sizes
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
  .case WM_CHAR    ; если есть сообщение от клавиатуры
push wParam    ; то временно сохранить введенный символ
pop  char1   ; и перезаписать в ячейку для выведа в окно
invoke InvalidateRect,hWnd,0,TRUE ; вызов функции и WM_PAINT

 .case WM_PAINT   ; если есть смс о перерисовании 
  invoke BeginPaint,hWnd, ADDR ps ; вызов подготовительной процедуры
  mov hdc,rax            ; сохранение контекста
invoke TextOut,hdc,20,20,\ ; координаты начала текста
      addr char1,1; адрес хранения текста и кол. байтов текста
invoke GetClientRect,hWnd,ADDR rect ; занесение в структуру rect 
                           ; характеристик окна
invoke  DrawText, hdc,ADDR Hello,-1, ADDR rect, \ ; рисование текста
DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke EndPaint,hWnd, ADDR ps            ; завершение рисования
.endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end




















