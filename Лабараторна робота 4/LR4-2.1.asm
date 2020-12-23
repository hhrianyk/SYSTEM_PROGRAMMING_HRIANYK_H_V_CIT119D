 
include \masm64\include64\masm64rt.inc ; библиотеки

IDI_ICON  EQU 1001
MSGBOXPARAMSA STRUCT
   cbSize          DWORD ?,?
   hwndOwner       QWORD ?
   hInstance       QWORD ?
   lpszText        QWORD ?
   lpszCaption     QWORD ?
   dwStyle         DWORD ?,?
   lpszIcon        QWORD ?
   dwContextHelpId QWORD ?
   lpfnMsgBoxCallback QWORD ?
   dwLanguageId       DWORD ?,?
MSGBOXPARAMSA ENDS

mMul macro x, y ;; макрос с именем mSub
fld x ;; загрузка x
fld y ;; загрузка y
fmul ;; x*y
endm ;; окончание макроса

.data ; 
a real4 2.7   ; операнд а1 размерностью 64 разряда константа 2
b real4 5.2   ; операнд b1 размерностью 64 разряда ;змзмінна  d 
const1 real4 1.1
const2 real4 3.0
 
res1 dd 0,0; операнд res1 размерностью 64 разряда; змінна результ

;Текст для MessageBox
title1 db "Лаб.4-2.1 макроси. masm64",0
txt1 db "Вираз:  (1,1ab – 3)/ab",10,
"Змінні: a=2.7, b=5.2",10,10,
"Результат: %d",10,"Адрес змінної в памяти: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 25 dup(0),0
buf2 dq 25 dup(0),0
;Текст для window
txt01 db "Вираз:  (1,1ab – 3)/ab",0
txt02 db"Змінні: a=2.7, b=5.2",0
txt03 db"Результат: %d  " 
txt04 db"Адрес змінної в памяти: %ph",0
autor db"Автор: Гряник Г.В., гр.КІТ-119Д",0

params MSGBOXPARAMSA <>

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
    classname db "template_class",0
    caption db "“екст в Windows-окне",0
    Hello db "ѕервое сообщение пользовател¤ в windows окне!!!",10,
	" masm64",0

.code;cекция кода
entry_point proc

finit ; инициализация FPU
;mov ecx,4;
mMul [a],[b]
fmul const1
fsub const2
fdiv a
fmul b

 fisttp res1
 ;movsxd  rax,res1

        ;Створення MessageBox
     invoke wsprintf,ADDR buf1,ADDR txt1,res1,ADDR res1
     invoke wsprintf,ADDR buf2,ADDR txt03,res1
    invoke wsprintf,ADDR txt03,ADDR txt04,ADDR res1

     invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION
    
    mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
    mov params.hwndOwner,0    ; дескриптор окна владельца
    invoke GetModuleHandle,0   ; получение дескриптора программы
    mov params.hInstance,rax  ; сохранение дескриптора программы
         lea rax,buf1
    mov params.lpszText,rax   ; адрес сообщения
         lea rax,title1
    mov params.lpszCaption,rax     ; адрес заглавия окна
    mov params.dwStyle,MB_USERICON ; стиль окна
    mov params.lpszIcon,IDI_ICON    ; ресурс значка
    mov params.dwContextHelpId,0  ;контекст справки
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; язык сообщения
         lea rcx,params
    invoke MessageBoxIndirect
    
  mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadIcon,IDI_ICON,IDI_ICON) ; загрузка и сохранение дескрипторa иконки
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
    mov wc.cbClsExtra,0 ; количество байтов дл¤ структуры класса
    mov wc.cbWndExtra,0 ; количество байтов дл¤ структуры окна
    mrm wc.hInstance,hInstance ; заполнение поля дескриптора в структуре
    mrm wc.hIcon,  hIcon ; хэндл иконки
    mrm wc.hCursor,hCursor ; хэндл курсора
    mrm wc.hbrBackground,4 ; цвет окна
    mov wc.lpszMenuName,0 ; заполнение пол¤ в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; им¤ класса
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; регистрация класса окна
   mov wid, 450 ; ширина пользовательского окна в пиксел¤х
   mov hgt, 190 ; высота пользовательского окна в пиксел¤х
    mov rax,sWid ; колич. пикселей монитора по x
    sub rax,wid ; дельта Х = Х(монитора) - х(окна пользовател¤)
    shr rax,1   ; получение середины Х
    mov lft,rax ;

    mov rax, sHgt ; колич. пикселей монитора по y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
  ; ---------------------------------
  ; centre window at calculated sizes
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
            ADDR classname,ADDR title1  , \
            WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
            lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; сохранение дескриптора окна
  call msgloop
    ret
main endp

msgloop proc
    LOCAL msg  :MSG
    LOCAL pmsg :QWORD
    mov pmsg,ptr$(msg) ; получение адреса структуры сообщения
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
LOCAL hdc:HDC   	; резервирование стека дл¤ дескриптора окна
LOCAL ps:PAINTSTRUCT ; дл¤ структуры PAINTSTRUCT
LOCAL rect:RECT      ; дл¤ структуры координат RECT

.switch uMsg
 .case WM_DESTROY ; если есть сообщение про уничтожение окна
        invoke PostQuitMessage,NULL
 .case WM_PAINT   ; если есть смс о перерисовании 
  invoke BeginPaint,hWnd, ADDR ps ; вызов подготовительной процедуры
  mov hdc,rax            ; сохранение контекста
  invoke GetClientRect,hWnd,ADDR rect ; занесение в структуру rect 
                             ; характеристик окна
  invoke  DrawText, hdc,ADDR txt1,0, ADDR rect, \ ; рисование текста
   DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke TextOut,hdc,10,10,ADDR txt01,22
    invoke TextOut,hdc,50,40,ADDR txt02,21
    invoke TextOut,hdc,50,70,ADDR buf2,13
    invoke TextOut,hdc,50,90,ADDR txt03,41
   invoke TextOut,hdc,80,130,ADDR autor,31
 

  invoke EndPaint,hWnd, ADDR ps                ; завершение рисования
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end