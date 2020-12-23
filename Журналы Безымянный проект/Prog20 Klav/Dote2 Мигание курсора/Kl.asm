.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib user32,kernel32
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
EditId equ 1010
IDM_INC equ 1001
IDM_RESET equ 1002
IDM_CHANGE equ 1003
IDM_SHOW equ 1004
IDM_ABOUT equ 1005
IDM_EXIT equ 1006
.data
ClassName db "WinClass",0
AppName  db "LAB 13",0
EditClassName db "edit",0
MenuName db "FirstMenu",0     
_str db "Программа с мерцанием курсора",0
_head db "Информация",0
cFreq dd ?
nFreq dd ?
curShow db 0
curPic dd 1
hCursor HCURSOR 0
.data?
hInstance dd ?
CommandLine dd ?
hWndEdit HWND ?
hMenu HMENU ?
.code                                  	    ; директива початку сегмента команд
 start:                                		    ; мітка початку програми
invoke GetModuleHandle, NULL    ; отримання дескриптора програми
mov    hInstance,eax                     ; збереження дескриптора програми
invoke GetCommandLine               ; повернення командного рядка процесу
mov    CommandLine,eax
invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
invoke SetCaretBlinkTime,nFreq ; встановлює час мерехтіння символу
invoke LoadCursor, NULL, IDC_ARROW
invoke ExitProcess, eax
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR,\
  CmdShow:DWORD
LOCAL wc:WNDCLASSEX 	; резервування стека  під структуру
LOCAL msg:MSG 		; резервування стека під структуру MSG 
LOCAL hwnd:HWND  ; резервування стека під хендл програми
mov wc.cbSize,SIZEOF WNDCLASSEX       ; кількість байтів структури
mov wc.style, CS_HREDRAW or CS_VREDRAW ; стиль та поведінка вікна
mov wc.lpfnWndProc, OFFSET WndProc      ; адреса процедури WndProc
mov wc.cbClsExtra,NULL               ; кількість байтів для структури
mov wc.cbWndExtra,NULL  ; кількість байтів для додаткових структур
push  hInstance              ; збереження в стеку дескриптора програми
pop  wc.hInstance          ; повернення дескриптора в поле структури
mov  wc.hbrBackground, COLOR_WINDOW+1  ; колір вікна
mov  wc.lpszMenuName, NULL             ; ім’я ресурсу меню
mov  wc.lpszClassName, OFFSET ClassName  ; ім’я класу
invoke LoadIcon, NULL, IDI_APPLICATION    ; ресурс піктограми
mov     wc.hIcon,eax                ; дескриптор «великої» піктограми
mov     wc.hIconSm,eax              ; дескриптор маленького віконця
invoke  LoadCursor,NULL,IDC_ARROW         ; ресурс курсора
mov   wc.hCursor, eax
invoke RegisterClassEx, addr wc  ; функція реєстрації класу вікна
invoke LoadMenu, hInst, OFFSET MenuName ; завантажує ресурс меню
mov hMenu,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,\
 ADDR AppName, WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
   CW_USEDEFAULT,350,130,NULL,hMenu,\
     hInst,NULL
	mov   hwnd, eax
invoke ShowWindow, hwnd, SW_SHOWNORMAL       ; видимість вікна
	invoke UpdateWindow, hwnd
.WHILE TRUE                                 ; поки істинне, то
invoke  GetMessage, ADDR msg,NULL,0,0       ; читання повідомлення
	.BREAK .IF (!eax)           ; закінчення циклу при виконанні умови
invoke TranslateMessage, ADDR msg   ; трансляція до черги
invoke DispatchMessage, ADDR msg    ; відправка на обслуговування
				; до WndProc proc
.ENDW
	mov     eax,msg.wParam
	ret           ; повернення з процедури
WinMain endp     ; закінчення процедури з ім’ям WinMain 


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.IF uMsg==WM_DESTROY       ; якщо є повідомлення про знищення вікна
    invoke PostQuitMessage, NULL ; передача повідомлення про знищення
.elseif uMsg==WM_CREATE    ; якщо є повідомлення про створення вікна
invoke LoadCursor, NULL, IDC_ARROW
mov hCursor,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR EditClassName,0,\
   WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT,30,\
    20,230,25,hWnd,EditId,\
      hInstance,NULL
           mov hWndEdit,eax
           invoke SetFocus,hWndEdit
invoke GetCaretBlinkTime ; визначає частоту мерехтіння вставки
           mov nFreq,eax
           mov cFreq,eax
.elseif uMsg==WM_SETCURSOR
            invoke SetCursor,hCursor; встановлює форму курсора
.elseif uMsg==WM_COMMAND      ; обробка повідомлень від меню
            mov eax,wParam
			    .IF ax==EditId ; дескриптор батьківського вікна
                shr eax,16
                .if ax==EN_CHANGE
                    jmp m1
                .endif
            .elseif ax==IDM_ABOUT ; якщо є повідомлення "Об авторе"
     invoke MessageBox,NULL,addr _str,addr _head,MB_ICONERROR
    .elseif ax==IDM_RESET ; якщо є повідомлення "Сбросить частоту мигания"
invoke SetCaretBlinkTime,nFreq ; встановлює частоту мерехтіння 
                push nFreq
                pop cFreq
    .elseif ax==IDM_INC ; якщо є повідомлення "Уменьшить частоту мигания”
m1:             mov eax,cFreq
                add eax,200
                mov cFreq,eax
invoke SetCaretBlinkTime,cFreq  ; встановлює частоту мерехтіння 
                invoke SetFocus,hWndEdit
    .elseif ax==IDM_SHOW ; якщо є повідомлення "Спрятать\Показать курсор"
invoke ShowCursor,curShow          ; відображає або приховує курсор
                .if curShow==1
                    mov al,0
                    mov curShow,al
                .else
                    mov al,1
                    mov curShow,al
                .endif
    .elseif ax==IDM_CHANGE ; якщо є повідомлення "Изменить вид курсора"
         .if curPic==1
          invoke LoadCursor, NULL, IDC_CROSS
          mov hCursor,eax
         xor ecx,ecx
         mov curPic,ecx
    .else
         invoke LoadCursor, NULL, IDC_ARROW
         mov hCursor,eax
         mov ecx,1
         mov curPic,ecx
    .endif
        invoke SetCursor,hCursor 	; встановлює форму курсора
.elseif
invoke DestroyWindow,hWnd  ; знищення вікна 
.endif
.else
invoke DefWindowProc, hWnd, uMsg, wParam, lParam ; знищення вікна 
	ret
.endif
	xor    eax,eax                                         ; підготування до закінчення
	ret                                                              ; повернення з процедури
WndProc endp                                      ; закінчення процедури WndProc
end start                                              ; закінчення програми з ім’ям start

