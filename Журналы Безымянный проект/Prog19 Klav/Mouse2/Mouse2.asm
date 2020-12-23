.686 	            ; директива определения типа микропроцессора
.model flat,stdcall ;задание линейной модели памяти и соглашения ОС Windows
option casemap:none ; отличие малых и больших букв
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32,gdi32
IDI_ICON equ 22
   WinMain proto :DWORD,:DWORD
.data 
    ClassName db 'SimpleWinClass',0 ; имя класса меню
    AppName db 'Обработка сообщений от левой клавиши мышки',0
	hInstance HINSTANCE ?
MouseClick db 0 ; флажок нажатия левой клавиши
myXY POINT <>   ; структура определения х- и у-координат
.code
start:
invoke  GetModuleHandle,0 ; отримання дескриптора програми
mov   hInstance,eax       ; збереження дескриптора програми
invoke WinMain,hInstance, SW_SHOWDEFAULT
invoke ExitProcess,eax ; возврат управления Windows и высвобождение ресурсов
WinMain proc hInst:HINSTANCE,CmdShow:DWORD
       LOCAL wc:WNDCLASSEX
       LOCAL msg:MSG
       LOCAL hwnd:HWND
     push  hInst
     pop   wc.hInstance
mov  wc.cbSize,SIZEOF WNDCLASSEX       ; количество байтов структуры
mov wc.style, CS_HREDRAW or CS_VREDRAW ; стиль и поведение окна
mov  wc.lpfnWndProc, OFFSET WndProc    ; адрес процедуры WndProc
mov  wc.hbrBackground,COLOR_WINDOW+1   ; цвет окна
mov     wc.lpszMenuName,0              ; имя ресурса меню
mov     wc.lpszClassName,OFFSET ClassName ; имя класса
invoke  LoadIcon,hInstance,IDI_ICON       ; ресурс пиктограммы
mov     wc.hIcon,eax                  ; дескриптор «большой» пиктограммы
mov     wc.hIconSm,eax                ; дескриптор маленького окошка
invoke  LoadCursor,NULL,IDC_ARROW     ; ресурс курсора
mov     wc.hCursor,eax
mov     wc.cbClsExtra,0  ; количество байтов для структуры
mov  wc.cbWndExtra,NULL  ; количество байтов для дополнительных структур
invoke  RegisterClassEx, ADDR wc    ; функция регистрации класса окна

invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,\
  CW_USEDEFAULT,CW_USEDEFAULT,450,350,0,0,hInst,0
     mov hwnd,eax
invoke ShowWindow,hwnd,SW_SHOWNORMAL ; видимость окна
invoke UpdateWindow,hwnd ; обновление клиентской области окна сообщением WM_PAINT
.WHILE TRUE                        ; пока истинно, то
invoke  GetMessage, ADDR msg,0,0,0 ; чтение сообщения
         .BREAK .IF (!eax)        ; окончание цикла при выполнении условия
 invoke TranslateMessage,ADDR msg ; трансляция к очереди
 invoke DispatchMessage,ADDR msg ; отправка сообщения проц. окна
.ENDW                       ; окончание цикла обрабатывания сообщений
    mov eax,msg.wParam
ret  		 ; возвращение из процедуры
WinMain endp ; окончание процедуры с именем WinMain 

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
LOCAL hdc:HDC   	 ; резервирование стека под хендл окна
LOCAL ps:PAINTSTRUCT ; резервирование стека под структуру PAINTSTRUCT
.IF uMsg==WM_DESTROY ; если есть сообщение об уничтожении окна
       invoke PostQuitMessage,0 ; передача сообщения об уничтожении
.ELSEIF uMsg==WM_LBUTTONDOWN    ; сообщение от левой клавиши 
mov eax,lParam  ; 32-разрядные координаты курсора мышки
and eax,0ffffh  ; выделение младшей части - координаты Х
mov myXY.x,eax	; сохранение координаты X
mov eax,lParam  ; 32-разрядные координаты курсора мышки
shr eax,16 		; сдвиг вправо на 4 байта для выделения  Y
mov myXY.y,eax  ; сохранение координаты Y
mov MouseClick,TRUE 	; подтверждение получения координат
    invoke InvalidateRect,hWnd,NULL,TRUE ; для перерисования окна
.ELSEIF uMsg==WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd, ADDR ps ; заполнение структуры
mov  hdc,eax 		  ; сохранение контекста
     .IF MouseClick  		; проверка установления флажка
invoke lstrlen,ADDR AppName ; определение длины строки 
invoke TextOut,hdc,myXY.x,myXY.y,\ ; координаты начала текста
  ADDR AppName,\ 		; адрес хранения текста
   eax 			; количество байтов текста
	 .ENDIF
invoke EndPaint,hWnd, ADDR ps
.ELSE 		; иначе
   invoke DefWindowProc,hWnd,uMsg,wParam,lParam ; обработка и отправка сообщения к WndProc
   ret 	  ; возвращение из процедуры
.ENDIF    ; окончание структуры .IF – .ELSEIF
xor eax,eax ; подготовление к окончанию
ret         ; возвращение из процедуры
WndProc endp ; окончание процедуры WndProc
end start    ; окончание программы с именем start