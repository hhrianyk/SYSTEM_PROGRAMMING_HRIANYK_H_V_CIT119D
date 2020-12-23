    include \masm64\include64\masm64rt.inc
    .data?
    hInstance dq ? ; дескриптор програми
    hWnd      dq ? ; дескриптор окна
    hIcon     dq ? ; дескриптор иконки
    hCursor   dq ? ; дескриптор курсора
    sWid      dq ? ; ширина монитора (колич. пикселей по x)
    sHgt      dq ? ; высота монитора (колич. пикселей по y)
   hImage  dq ?
   hStatic dq ?
.data
      classname db "template_class",0
      caption db "НТУ ХПИ КИТ",0
.code
entry_point proc
 GdiPlusBegin        ; initialise GDIPlus
 mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
 mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
 mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
 mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора 
 mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
  mov hImage,rv(ResImageLoad,20) ; макрос загрузки Bitmap
    call main
 GdiPlusEnd         ; GdiPlus cleanup
    invoke ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; объявление локальных переменных
    LOCAL lft :QWORD    ;  Лок. переменные содержатся в стеке 
    LOCAL top :QWORD     ; и существуют только во время вып. проц.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; колич. байтов структуры
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; стиль окна
    mov wc.lpfnWndProc,ptr$(WndProc) ; адрес процедуры WndProc
    mov wc.cbClsExtra,0       ; количество байтов для структуры класса
    mov wc.cbWndExtra,0       ; количество байтов для структуры окна
   mrm wc.hInstance,hInstance ; заполнение поля дескриптора в структуре
   mrm wc.hIcon,  hIcon       ; хэндл иконки
   mrm wc.hCursor,hCursor     ; хэндл курсора
    mrm wc.hbrBackground,0    ; hBrush цвет окна
    mov wc.lpszMenuName,0 ; заполнение поля в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; имя класса
   mrm wc.hIconSm,hIcon
invoke RegisterClassEx,ADDR wc ; регистрация класса окна
    mov wid,512   ; ширина пользовательского окна в пикселях
    mov hgt,380   ; высота пользовательского окна в пикселях
    mov rax,sWid  ; колич. пикселей монитора по x
    sub rax,wid   ; дельта Х = Х(монитора) - х(окна пользователя)
    shr rax,1     ; получение середины Х
    mov lft,rax   ;

    mov rax, sHgt ; колич. пикселей монитора по y
    sub rax, hgt
    shr rax, 1
    mov top, rax
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
       ADDR classname,ADDR caption, \
       WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
         lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; сохранение дескриптора окна
    call msgloop
    ret
main endp

msgloop proc
    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD
 mov pmsg, ptr$(msg) ; получение адреса структуры сообщения
 jmp gmsg            ; jump directly to GetMessage()
mloop:
 invoke TranslateMessage,pmsg
 invoke DispatchMessage,pmsg
gmsg:
 test rax, rv(GetMessage,pmsg,0,0,0) ; пока GetMessage не вернет ноль
 jnz mloop
 ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
.switch uMsg
    .case WM_COMMAND   ; если выбрано меню
       .switch wParam
          .case 10002    ; если выбрана кнопка Exit
invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0
          .case 10004    ; если выбрана кнопка About
            .data
              msgtxt db "masm64",10
                     db "Вывод BMP (JPG) файла",0
            .code
invoke MsgboxI,hWin,ptr$(msgtxt),"Выбрана кнопка About In Window",MB_OK,10
rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0 ; уничтожить окно
       .endsw
    .case WM_CREATE
invoke CreateWindowEx,WS_EX_LEFT,"STATIC",0,WS_CHILD or WS_VISIBLE or SS_BITMAP,\
        0,0,0,0,hWin,hInstance,0,0    
mov hStatic,rax
;mov hStatic,rv(bitmap_image,hInstance,hWin,0,0)
invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hImage; сообщение окну

invoke LoadMenu,hInstance,100 ; загружает меню из exe-файла
invoke SetMenu,hWin,rax ; связывает меню с окном
        .return 0
    .case WM_CLOSE ;
        invoke SendMessage,hWin,WM_DESTROY,0,0
    .case WM_DESTROY ; 
        invoke PostQuitMessage,NULL
.endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp
    end




















