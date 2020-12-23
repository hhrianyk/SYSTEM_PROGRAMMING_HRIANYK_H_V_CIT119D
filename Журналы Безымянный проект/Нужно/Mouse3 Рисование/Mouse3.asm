.686   ; директива определения типа микропроцессора
.model flat,stdcall ; задание линейной модели памяти и соглашения OC Windows
option casemap:none ; отличие малых и больших букв
include \masm32\include\windows.inc ; файлы структур, констант …
include \masm32\macros\macros.asm
 uselib user32,kernel32,gdi32
IDM_EXIT 	equ 1
IDM_ABOUT 	equ 2
IDM_CLEAN 	equ 3
IDM_BLACK 	equ 4
IDM_RED 	equ 5
IDM_BLUE	equ 6
IDM_GREEN	equ 7
IDI_ICON	equ 8
.data 	
ClassName 	db "SimpleWinClass",0
AppName  	db " Рисование мышкой",0
MenuName 	db "FirstMenu",0
About_string db "Программа для рисования мышкой", 0
wc  WNDCLASSEX <>
msg	MSG <>
hwnd HWND ?
hInstance HINSTANCE ?
x dd ? 
y dd ?
bTracking BOOL FALSE ;может принимать одно из двух значений: true и false
hdc	 	HDC ?
color 	RGBQUAD<255,255,255>
hPen 	dd 0
col_black 	RGBQUAD<0,0,0>
col_red 	RGBQUAD<255,0,0>
col_green 	RGBQUAD<0,255,0>
col_blue 	RGBQUAD<0,0,255>
.code ; 
start: 
invoke  GetModuleHandle,0 ; 
mov     hInstance,eax
mov     wc.cbSize,SIZEOF WNDCLASSEX
mov     wc.style, CS_HREDRAW or CS_VREDRAW
mov     wc.lpfnWndProc, OFFSET WndProc
mov     wc.cbClsExtra,NULL
mov     wc.cbWndExtra,NULL
push    hInstance
pop     wc.hInstance
invoke  LoadIcon, hInstance,IDI_ICON ; ресурс 
mov      wc.hIcon, eax	
mov     wc.hIconSm,0
mov     wc.hbrBackground,COLOR_WINDOW+1
invoke  GetStockObject, WHITE_BRUSH   
mov     wc.lpszMenuName,OFFSET MenuName
mov     wc.lpszClassName,OFFSET ClassName
invoke  LoadCursor,NULL,IDC_ARROW        ; ресурс курсора
mov     wc.hCursor,eax
invoke  RegisterClassEx,addr wc   ; 
invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW, \ 
  CW_USEDEFAULT,CW_USEDEFAULT,600,400,;  координаты окна
     0,0, hInstance,0 ; дескрипторы родительского окна и меню и дескриптор программы
	mov     hwnd,eax
invoke ShowWindow,hwnd,SW_SHOWNORMAL ; видимость окна
.WHILE TRUE
    invoke  GetMessage,ADDR msg,0,0,0 ; чтение сообщений
    or eax, eax
    jz Quit
    invoke DispatchMessage,ADDR msg ; передача сообщений
.ENDW
Quit:
mov     eax,msg.wParam
invoke  ExitProcess, eax

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM,\ 
   lParam:LPARAM
LOCAL ps:PAINTSTRUCT
LOCAL rect:RECT
.IF uMsg==WM_CREATE
	invoke GetDC,hWnd ; получить дескриптор контекста устройства
	mov hdc, eax
invoke CreatePen,PS_SOLID,1,dword ptr col_black ; создание пера 
; черного цвета (по умолчанию) 
mov hPen, eax
.ELSEIF uMsg==WM_LBUTTONDOWN; сигнал нажатия левой кнопки мыши
  mov bTracking,TRUE  ; установление признака в TRUE
  push word ptr lParam ; координататы х и у при нажатии кнопки
	pop word ptr x
	push word ptr lParam+2
	pop word ptr y
invoke MoveToEx,hdc,x,y,0 ; перемещение текущего указателя в точку x,y
.ELSEIF uMsg==WM_LBUTTONUP ; при выборе левой кнопки мыши
	mov bTracking, FALSE   ; установление признака в FALSE
.ELSEIF uMsg==WM_MOUSEMOVE ;сообщение при перемещении курсора 
; для рисования цветной линии от текущего положения курсора 
.IF bTracking
	push word ptr lParam
	pop word ptr x
	push word ptr lParam+2
	pop word ptr y
invoke SelectObject,hdc,hPen
invoke LineTo,hdc,x,y ; рисование линии
.ENDIF
.ELSEIF uMsg==WM_COMMAND
    mov eax,wParam
   	.IF ax==IDM_ABOUT
invoke  MessageBox,0,ADDR About_string,OFFSET AppName,MB_OK 
	.ELSEIF ax==IDM_CLEAN  ; очистить
invoke  GetClientRect,hWnd,ADDR rect ; возвращение координат окна
	invoke FillRect,hdc,ADDR rect, 0; заполнение окна
	.ELSEIF ax==IDM_BLACK
invoke CreatePen,PS_SOLID,1,dword ptr col_black ; создание черного пера
	mov hPen, eax
	.ELSEIF ax==IDM_RED
invoke CreatePen,PS_SOLID,1,dword ptr col_red ; создание красного пера		
	mov hPen, eax
	.ELSEIF ax==IDM_BLUE
invoke CreatePen,PS_SOLID,1,dword ptr col_blue ; создание синего пера
	mov hPen, eax
	.ELSEIF ax==IDM_GREEN
invoke CreatePen,PS_SOLID,1,dword ptr col_green ; создание зеленого пера
	mov hPen,eax
   	.ELSE
       	invoke DestroyWindow,hWnd
   	.ENDIF
.ELSEIF uMsg==WM_DESTROY      ; уничтожение окна 
	invoke ReleaseDC,hWnd,hdc
	invoke PostQuitMessage,0
.ELSE WM_MOUSEMOVE
   	invoke DefWindowProc,hWnd,uMsg,wParam,lParam
	ret
.ENDIF
xor    eax,eax
ret
WndProc endp 
end start   

