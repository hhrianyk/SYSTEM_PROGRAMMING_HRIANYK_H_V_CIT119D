include \masm64\include64\masm64rt.inc; библиотеки для подключения


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


DATE2 STRUCT              ; тип данных структура
  _firm      db 22 dup(?) ; поле торговельнa діяльності комп'ютерної фірми
  _computer  db 10 dup(?) ; поле Комп'ютер
  _modem     db 10 dup(?) ; поле винт
  _price     dq   ?       ; ціна (в доларах)
  _quantity  dq   ?       ; кількість проданих одиниць
DATE2 ENDS        ; окончания данных СТРУКТУРА

.data             
ASUS DATE2 <"Комп'ютерна техніка", "ASUS" , "512 ГБ SSD",940,5>      ; структура с именем ASUS
HP   DATE2 <"Комп'ютерна техніка", "HP",    "256 ГБ SSD",761,5>      ; структура с именем HP
Acer DATE2 <"Комп'ютерна техніка", "Acer",  "512 ГБ SSD",673,8>      ; структура с именем ACER 
MSI  DATE2 <"Комп'ютерна техніка", "MSI",   "256 ГБ SSD",672,7>      ; структурас именем MSI

txt1  db"Задана послідовність структур.",10,
" Обчислити прибуток фірми (підсумовування 'кількості проданих одиниць помножену на ціну').",10,10,
"| торг. діяльності      |Комп'ютер|винт      |ціна|кількіс|",10,\
"|Комп'ютерна техніка| ASUS  |512 ГБ SSD|940$|      5|",10,\
"|Комп'ютерна техніка| HP      |256 ГБ SSD|761$|      5|",10,\
"|Комп'ютерна техніка| Acer   |512 ГБ SSD|673$|      8|",10,\
"|Комп'ютерна техніка| MSI     |256 ГБ SSD|672$|      7|",10,10,\
"Автор: Гряник Г.В., гр.КІТ-119Д",0


txt01 db"Задана послідовність структур.",10,0
txt2  db" Обчислити прибуток фірми (підсумовування 'кількості проданих одиниць помножену на ціну').",10,10,0
txt3  db"| торг. діяльності____|Комп'ютер|винт______|ціна|кількіс|",0
txt4  db"|Комп'ютерна техніка| ASUS____|512 ГБ SSD|940$|      5|",0
txt5  db"|Комп'ютерна техніка| HP______|256 ГБ SSD|761$|      5|",0
txt6  db"|Комп'ютерна техніка| Acer_____|512 ГБ SSD|673$|      8|",0
txt7  db"|Комп'ютерна техніка| MSI_____|256 ГБ SSD|672$|      7|",0
autor db"Автор: Гряник Г.В., гр.КІТ-119Д",0

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
    classname db "template_class",0
   

buf1 dq 5 dup(?),0
st1 db "Лаб.4-1.2 СТРУКТУРИ. masm64", 0 
ifmt db "Прибуток фірми:  %d$ ",0;Прибуток фірми
_res1 dq 0  
 params MSGBOXPARAMSA <>    
.code 				
entry_point proc

mov rax, ASUS._price ; загрузка адреса первой строки структуры
mul  ASUS._quantity  ; ASUS._price*ASUS._quantity
mov _res1,rax;       ; збереження даних

mov rax, HP._price ; загрузка адреса первой строки структуры
mul  HP._quantity  ; HP._price*HP._quantity
add _res1,rax;       ; збереження даних

mov rax, Acer._price ; загрузка адреса первой строки структуры
mul  Acer._quantity  ; Acer._price*Acer._quantity
add _res1,rax;       ; збереження даних

mov rax, MSI._price ; загрузка адреса первой строки структуры
mul  MSI._quantity  ; MSI._price*MSI._quantity
add _res1,rax;       ; збереження даних

invoke wsprintf,ADDR buf1,ADDR ifmt,_res1

     mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
     mov params.hwndOwner,0     ; дескриптор окна владельца
     invoke GetModuleHandle,0   ; получение дескриптора программы
     mov params.hInstance,rax   ; сохранение дескриптора программы
         lea rax,txt1
     mov params.lpszText,rax   ; адрес сообщени¤
         lea rax,st1
     mov params.lpszCaption,rax     ; адрес заглави¤ окна
     mov params.dwStyle,MB_USERICON ; стиль окна
     mov params.lpszIcon,IDI_ICON    ; ресурс значка
     mov params.dwContextHelpId,0  ;контекст справки
     mov params.lpfnMsgBoxCallback,0 ;
     mov params.dwLanguageId,LANG_NEUTRAL ; ¤зык сообщени¤
         lea rcx,params
    invoke MessageBoxIndirect

    lea rax,buf1
     mov params.lpszText,rax   ; адрес сообщени¤
         lea rax,st1
     mov params.lpszCaption,rax     ; адрес заглави¤ окна
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
   mov wid, 750 ; ширина пользовательского окна в пиксел¤х
   mov hgt, 340 ; высота пользовательского окна в пиксел¤х
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
            ADDR classname,ADDR st1  , \
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
   invoke TextOut,hdc,10,10,ADDR txt01,32
    invoke TextOut,hdc,50,40,ADDR txt2,92
   invoke TextOut,hdc,50,70,ADDR txt3,57
    invoke TextOut,hdc,50,90,ADDR txt4,55
    invoke TextOut,hdc,50,110,ADDR txt5,55
   invoke TextOut,hdc,50,130,ADDR txt6,56
   invoke TextOut,hdc,50,150,ADDR txt7,55
   invoke TextOut,hdc,80,250,ADDR autor,31
   invoke TextOut,hdc,80,200,ADDR buf1,25

  invoke EndPaint,hWnd, ADDR ps                ; завершение рисования
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end
