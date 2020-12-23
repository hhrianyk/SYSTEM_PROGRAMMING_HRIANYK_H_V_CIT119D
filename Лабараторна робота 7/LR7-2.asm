    include \masm64\include64\masm64rt.inc
    .data
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
title1 db "Лаб.7 SetKeyboardStatemasm64",0      
classname db "template_class",0
caption db "Mouse",0
Hello db "Натисніть на символ. ",0
txt01 db "Переміщення миші в некліентсой області дочірнього вікна призводить до його згортання. Натискання на клавішу «пробіл» при установці фокусу введення на батьківське вікно призводить також до його згортання.",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0
 


.code
entry_point proc

mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
      ;  mov hStatic, rv(GetDlgItem,hWin,101)
       ; invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 103 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 106
            mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
call main
           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
 
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
call main

    .case 117    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     .case 115    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
.case WM_DESTROY ; если есть сообщение про уничтожение окна 
        invoke PostQuitMessage,NULL
 .case 107    ; если есть сообщение от клавиатуры
         invoke  keybd_event,VK_LWIN,0,0,NULL
         invoke  Sleep,1
         invoke  keybd_event,'M',0,0,NULL
         invoke  Sleep,1
         invoke  keybd_event,VK_LWIN,0,KEYEVENTF_KEYUP,NULL                     



        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
         WS_OVERLAPPED or WS_VISIBLE or WS_OVERLAPPEDWINDOW,\
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
 
  
 .case WM_MOUSEMOVE ;сообщение на перевод окна
 
         invoke  keybd_event,VK_LWIN,0,0,NULL
        invoke  Sleep,1
        invoke  keybd_event,'M',0,0,NULL
        invoke  Sleep,1
        invoke  keybd_event,VK_LWIN,0,KEYEVENTF_KEYUP,NULL                     
 
      
.endif
 
invoke EndPaint,hWnd, ADDR ps
 
 
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end


















