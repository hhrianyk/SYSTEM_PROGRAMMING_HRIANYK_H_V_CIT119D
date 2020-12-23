; »зменение текста заголовка окна 
; ќбработка нажати€ правой и левой кл. мыши в клиентской области окна.
; ќбработка нажати€ кл. F1
include \masm64\include64\masm64rt.inc
.data
hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
  classname db "template_class",0
.code
entry_point proc
  mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadIcon,hInstance,10) ; загрузка и сохранение дескрипторa иконки
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора 
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
  call main ; вызов процедуры main
    invoke ExitProcess,0
    ret
entry_point endp

main proc
    LOCAL wc  :WNDCLASSEX ; объ€вление локальных переменных
    LOCAL lft :QWORD ;  Ћок. переменные содержатс€ в стеке 
    LOCAL top :QWORD  ; и существуют только во врем€ вып. проц.
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
   mrm wc.hbrBackground,0 ; цвет окна
    mov wc.lpszMenuName,0 ; заполнение пол€ в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; им€ класса
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; регистраци€ класса окна
   mov wid, 720 ; ширина пользовательского окна в пиксел€х
   mov hgt, 250 ; высота пользовательского окна в пиксел€х
    mov rax,sWid ; колич. пикселей монитора по x
    sub rax,wid ; дельта ’ = ’(монитора) - х(окна пользовател€)
    shr rax,1   ; получение середины ’
    mov lft,rax ;

    mov rax, sHgt ; колич. пикселей монитора по y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
             ADDR classname,ADDR classname, \
               WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
                lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd, rax ; сохранение дескриптора окна
    call msgloop
    ret
main endp

msgloop proc
    LOCAL msg    :MSG
    LOCAL pmsg   :QWORD
    mov pmsg, ptr$(msg) ; получить адрес структуры сообщени§
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
LOCAL hdc:HDC   	; резервирование стека дл€ дескриптора окна
LOCAL ps:PAINTSTRUCT ; дл€ структуры PAINTSTRUCT
LOCAL rect:RECT      ; дл€ структуры координат RECT
.switch uMsg
 .case WM_DESTROY
        invoke PostQuitMessage,NULL
 .case WM_LBUTTONDOWN ;
invoke SetWindowText,hWin,"Ќажата лева€ клавиша мышки" ; замен€ем текст заголовка
 .case WM_RBUTTONDOWN ;
invoke SetWindowText,hWin,"ѕрава€ клавиша мышки" ; замен€ем текст заголовка
 .case WM_KEYDOWN
          .if wParam == VK_F1
   invoke SetWindowText,hWnd,"ќбработка VK_F1" ; новый заголовок
          .endif
 .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end