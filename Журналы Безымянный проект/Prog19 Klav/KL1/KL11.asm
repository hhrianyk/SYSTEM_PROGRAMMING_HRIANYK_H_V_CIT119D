.686 	             ; директива определения типа микропроцессора
.model flat,stdcall  ;задание линейной модели памяти и соглашения ОС Windows
option casemap:none  ; отличие малых и больших букв
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
   WinMain proto :DWORD,:DWORD
.data 
char WPARAM 20h ; символ пропуска, который программа получает от клавиатуры
.const
wcex label WNDCLASSEX
    cbSize dd sizeof WNDCLASSEX  ; количество байтов структуры
    style dd 0                    ; стиль
    lpfnWndProc dd offset WndProc ; адрес процедуры WndProc
    cbClsExtra dd 0               ; количество байтов для структуры
    cbWndExtra dd 0         ; количество байтов для дополнительных структур
    hInstance dd 004000000h ; дескриптор
    hIcon dd 4F00h          ; дескриптор иконки
    hCursor dd 4F00h        ; дескриптор курсора
    hbrBackground dd COLOR_WINDOW+1 ; цвет окна
    lpszMenuName dd 0               ; имя ресурса меню
    lpszClassName dd offset ClassName ; ресурс для имени класса меню
    hIconSm dd 4F00h                ; дескриптор маленькой иконки
    ClassName db 'SimpleWinClass',0 ; имя класса меню
    AppName db 'Обработка сообщений от КЛАВИАТУРЫ',0
.code 
start: 
;invoke  GetModuleHandle,0 ; получение дескриптора программы
;mov   hInstance,eax       ; сохранение дескриптора программы
invoke WinMain,hInstance,SW_SHOWDEFAULT
       invoke ExitProcess,eax ; повернення управление ОС Windows и освобождение ресурсов
   WinMain proc hInst:HINSTANCE, CmdShow:DWORD
LOCAL msg:MSG       ; резервирование стека под структуру MSG 
LOCAL hwnd:HWND     ; резервирование стека под хендл программы

invoke  RegisterClassEx, ADDR wcex      ; функция регистрации класса окна
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,\
  CW_USEDEFAULT,CW_USEDEFAULT,400,250,0,0,hInst,0
     mov hwnd,eax
invoke ShowWindow,hwnd,SW_SHOWNORMAL ; видимость окна
invoke UpdateWindow,hwnd ; обновление клиентской области окна сообщением WM_PAINT
.WHILE TRUE                           ; пока истинно, то
invoke  GetMessage, ADDR msg,0,0,0    ; чтение сообщения
         .BREAK .IF (!eax)         ; окончание цикла при выполнении условия
 invoke TranslateMessage, ADDR msg  ; трансляция к очереди
 invoke DispatchMessage, ADDR msg ; отправка сообщения проц. окна
.ENDW                       ; окончание цикла обрабатывания сообщений
       mov eax,msg.wParam
ret  				  ; возвращение из процедуры
WinMain endp 		  ; окончание процедуры с именем WinMain 
WndProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM, lParam:LPARAM
LOCAL hdc:HDC   	 ; резервирование стека под хендл окна
LOCAL ps:PAINTSTRUCT ; резервирование стека под структуру PAINTSTRUCT
.IF uMsg==WM_DESTROY         ; если есть сообщение об уничтожении окна
      invoke PostQuitMessage, NULL ; передача сообщение об уничтожении
.ELSEIF  uMsg==WM_CHAR    ; если есть сообщение от клавиатуры
           push wParam    ; то временно сохранить введенный символ
           pop  char   ; и перезаписать в ячейку для выведа в окно
invoke InvalidateRect,hWnd,0,TRUE ; вызов функции и WM_PAINT
.ELSEIF uMsg==WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd,ADDR ps ; вызов процедуры и заполнение структуры 
mov   hdc,eax 		  ; сохранение контекста
invoke TextOut,hdc,20,20,\ ; координаты начала текста
      addr char,\          ; адрес хранения текста
          1                ; количество байтов текста
invoke EndPaint,hWnd,ADDR ps          
.ELSE 		; инаше
   invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; обработка и отправка сообщения к WndProc
   ret 	  ; возвращение из процедуры
.ENDIF    ; окончание структуры .IF – .ELSEIF
xor     eax,eax      ; подготовление к окончанию
ret                  ; возвращение из процедуры
WndProc endp ; окончание процедуры WndProc
end start    ; окончание программы с именем start
