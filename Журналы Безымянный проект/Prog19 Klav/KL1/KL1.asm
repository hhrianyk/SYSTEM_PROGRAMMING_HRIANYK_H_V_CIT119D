.686 	             ; директива определения типа микропроцессора
.model flat,stdcall  ;задание линейной модели памяти и соглашения ОС Windows
option casemap:none  ; отличие малых и больших букв
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
   WinMain proto :DWORD,:DWORD
.data 			                    ; директива определения данные
   ClassName db "SimpleWinClass",0
AppName  db "Обработка сообщений от КЛАВИАТУРЫ",0 ; название окна
char WPARAM 20h ; символ пропуска, который программа получает от клавиатуры
   hInstance HINSTANCE ?
.code ; директива начала сегмента команд
start: ; метка начала программы с именем start
invoke  GetModuleHandle, NULL      ; получение дескриптора программы
mov   hInstance,eax 	           ; сохранение дескриптора программы
invoke WinMain, hInstance,  SW_SHOWDEFAULT
       invoke ExitProcess,eax ; повернення управление ОС Windows и освобождение ресурсов
   WinMain proc hInst:HINSTANCE, CmdShow:DWORD
LOCAL wc:WNDCLASSEX ; резервирование стека под структуру
LOCAL   msg:MSG             ; резервирование стека под структуру MSG 
LOCAL   hwnd:HWND        ;  резервирование стека под хендл программы
push  hInst  		         ; сохранение в стеке дескриптора программы
pop     wc.hInstance                 ; возвращение дескриптора в поле структуры
mov  wc.cbSize,SIZEOF WNDCLASSEX               ; количество байтов структуры
mov wc.style, CS_HREDRAW or CS_VREDRAW   ; стиль и поведение окна
mov  wc.lpfnWndProc, OFFSET WndProc         ; адрес процедуры WndProc
mov  wc.hbrBackground,COLOR_WINDOW+1                               ; цвет окна
mov     wc.lpszMenuName,NULL                                        ; ім’я ресурсу меню
mov     wc.lpszClassName,OFFSET ClassName                             ; имя класса
invoke  LoadIcon,NULL,IDI_APPLICATION                       ; ресурс пиктограммы
mov     wc.hIcon,eax                                  ; дескриптор «большой» пиктограммы
mov     wc.hIconSm,eax                                ; дескриптор маленького окошка
invoke  LoadCursor,NULL,IDC_ARROW                                 ; ресурс курсора
mov     wc.hCursor,eax
mov     wc.cbClsExtra,NULL                            ; количество байтов для структуры
mov  wc.cbWndExtra,NULL           ; количество байтов для дополнительных структур
invoke  RegisterClassEx, ADDR wc              ; функция регистрации класса окна
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,\
  CW_USEDEFAULT,CW_USEDEFAULT,500,400,\ ; ширина та висота вікна
      0,0,hInst,0 			           ; дескрипторы
       mov   hwnd,eax
invoke  ShowWindow, hwnd,SW_SHOWNORMAL    ; видимость окна
invoke UpdateWindow, hwnd ; обновление клиентской области окна сообщением WM_PAINT
.WHILE TRUE                           ; пока истинное, то
invoke  GetMessage, ADDR msg,0,0,0    ; чтение сообщения
         .BREAK .IF (!eax)       ; окончание цикла при выполнении условия
 invoke TranslateMessage, ADDR msg  ; трансляция к очереди
 invoke DispatchMessage, ADDR msg ; отправка сообщения проц. окна
.ENDW                       ; окончание цикла обрабатывания сообщений
       mov     eax,msg.wParam
ret  				         ; возвращение из процедуры
WinMain endp 		  ; окончание процедуры с именем WinMain 
WndProc proc hWnd:HWND, uMsg:UINT,\
 wParam:WPARAM, lParam:LPARAM
LOCAL hdc:HDC   	 ; резервирование стека под хендл окна
LOCAL ps:PAINTSTRUCT ; резервирование стека под структуру PAINTSTRUCT
.IF uMsg==WM_DESTROY         ; если есть сообщение об уничтожении окна
      invoke PostQuitMessage, NULL ; передача сообщение об уничтожении
.ELSEIF  uMsg==WM_CHAR    ; если есть сообщение от клавиатуры
           push wParam    ; то временно сохранить введенный символ
           pop  char   ; и перезаписать в ячейку для выведа в окно
invoke InvalidateRect, hWnd, NULL, TRUE ; вызов функции и WM_PAINT
.ELSEIF uMsg==WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd,ADDR ps ; вызов процедуры и заполнение структуры 
mov     hdc,eax 		  ; сохранение контекста
invoke TextOut,hdc,20,20,\ ; координаты начала текста
      addr char,\          ; адрес хранения текста
          1                ; количество байтов текста
invoke EndPaint,hWnd, ADDR ps          
.ELSE 		; інакше
   invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; обработка и отправка сообщения к WndProc
   ret 	  ; возвращение из процедуры
.ENDIF    ; окончание структуры .IF – .ELSEIF
xor     eax,eax      ; подготовление к окончанию
ret                  ; возвращение из процедуры
WndProc endp ; окончание процедуры WndProc
end start    ; окончание программы с именем start
