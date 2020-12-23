include \masm64\include64\masm64rt.inc
 IDM_Functions equ 10002
 IDM_EXIT  equ 10003  ;  выход с программы
 IDM_ABOUT equ 10005  ;  выход с программы
.data
    hInstance dq ? ; дескриптор програми
    hWnd      dq ? ; дескриптор окна
    hIcon     dq ? ; дескриптор иконки
    hCursor   dq ? ; дескриптор курсора
    sWid      dq ? ; ширина монитора (колич. пикселей по x)
    sHgt      dq ? ; высота монитора (колич. пикселей по y) 
  classname db "template_class",0
  caption db "ќкно с Menu. masm64",0
.code
entry_point proc
 mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
 mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
 mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
 mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора 
 mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
;mov hBrush,rvcall(CreateSolidBrush,00C4C4C4h)
    call main ; вызов процедуры main
  rcall ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; объявление локальных переменных
    LOCAL lft :QWORD    ;  Лок. переменные содержатс€ в стеке 
    LOCAL top :QWORD      ; и существуют только во время вып. проц.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; колич. байтов структуры
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; стиль окна
    mov wc.lpfnWndProc,ptr$(WndProc) ; адрес процедуры WndProc
    mov wc.cbClsExtra,0 ; количество байтов дл€ структуры класса
    mov wc.cbWndExtra,0 ; количество байтов дл€ структуры окна
   mrm wc.hInstance,hInstance ; заполнение пол€ дескриптора в структуре
   mrm wc.hIcon,  hIcon ; хэндл иконки
   mrm wc.hCursor,hCursor ; хэндл курсора
    mrm wc.hbrBackground,0;hBrush цвет окна
    mov wc.lpszMenuName,0 ; заполнение пол€ в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; имя класса
   mrm wc.hIconSm,hIcon
invoke RegisterClassEx,ADDR wc ; регистраци€ класса окна
    mov wid, 500 ; ширина пользовательского окна в пикселях
   mov hgt, 250 ; высота пользовательского окна в пикселях
    mov rax,sWid ; колич. пикселей монитора по x
    sub rax,wid ; дельта Х = Х(монитора) - х(окна пользователя)
    shr rax,1   ; получение середины Х
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
    mov pmsg, ptr$(msg)      ; получение адреса структуры сообщения
    jmp gmsg                 ; jump directly to GetMessage()
mloop:
    rcall TranslateMessage,pmsg
    rcall DispatchMessage,pmsg
gmsg:
    test rax, rvcall(GetMessage,pmsg,0,0,0) ; пока GetMessage не вернет ноль
    jnz mloop
    ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    LOCAL dfbuff[260]:BYTE
    LOCAL pbuff :QWORD
    .switch uMsg
      .case WM_COMMAND
        .switch wParam
          .case IDM_Functions ; 10002
            rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
          .case IDM_EXIT  ; 10003
invoke MsgboxI,hWin,"masm64","»спользование rcall и rvcall",MB_OK,10
          .case IDM_ABOUT ; 10005
invoke MessageBox,hWin,"¬ыбрана кнопка меню ABOUT","Button1",MB_ICONINFORMATION
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

         .endsw

      .case WM_CREATE
        rcall LoadMenu,hInstance,10000
        rcall SetMenu,hWin,rax
        .return 0

      .case WM_CLOSE
rcall SendMessage,hWin,WM_DESTROY,0,0
      .case WM_DESTROY
        rcall PostQuitMessage,NULL
    .endsw
    rcall DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp
   end
