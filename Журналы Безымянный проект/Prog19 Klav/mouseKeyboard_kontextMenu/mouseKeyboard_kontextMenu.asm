  .686
  .model flat,stdcall
  option casemap:none
include    \masm32\include\windows.inc
include    \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
include    \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
.CONST
IDPM_CUT    equ 1   ; идентификаторы пунктов меню
IDPM_COPY   equ 2
IDPM_PASTE  equ 3
IDPM_POPUP  equ 4
.DATA
s_classname db "ioWindowClass",0
szTitl db "Управление мышкой и клавиатурой",0
s_pov  db "Нажмите левую и правую кнопки мыши, сделайте двойной клик, щелкните по клавиатуре.",0
szMsg2 db "Нажмите внутри окна, которое появится, левой и правой кнопками мыши, сделайте двойной клик, щелкните по клавиатуре.",0Ah,0Dh,
 "Проверьте сообщения от нажатия кнопок: <F1>, <Ctrl>, <SHIFT>.",0
s_left  db "Клик левой кнопкой мышки.",0
s_leftd db "Двойной левый.",0
szShift db "Нажата клавиша <SHIFT>.",0
szCtrl  db "Нажата клавиша <Ctrl>.",0
szF1    db "Нажата клавиша <F1>.",0 
s_zaholMsgbx db "ВЫ ИЗБРАЛИ ПУНКТ КОНТЕКСТНОГО МЕНЮ",0
s_cut        db "Cut io",0
s_copy       db "Copy io",0
s_paste      db "Paste io",0
s_popup      db "Popup io",0
st_point POINT <>  ; структура для хранения точки положения курсора
s_char   db 0,0   ; строка-символ (второй 0-байт не изменяется)
  .DATA?
hInstance     dd ?
hwnd         dd ?
h_popupMenu   dd ?  ; хендл основного контекстного меню
h_popupMenu2  dd ?  ; хендл выпадающий из основного меню
.CODE
start:
invoke GetModuleHandle, 0 ; получение дескриптора программы
	mov  hInstance,eax  ; сохранение дескриптора программы
invoke MessageBox,NULL,addr szMsg2,addr szTitl,MB_OK
call WinMain;
	invoke ExitProcess,eax  
  
WinMain proc
LOCAL wc:WNDCLASSEX
LOCAL msg:MSG
  mov wc.cbSize,sizeof WNDCLASSEX
  mov wc.style,CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS  ; последний - окно воспримет двойной клик
  mov wc.lpfnWndProc,offset WndProc
  mov wc.cbClsExtra,NULL
  mov wc.cbWndExtra,NULL
  push hInstance
  pop wc.hInstance
  mov wc.hbrBackground,COLOR_WINDOW
  mov wc.lpszMenuName,NULL
  mov wc.lpszClassName,offset s_classname
  invoke LoadIcon,NULL,IDI_APPLICATION
  mov wc.hIcon,eax
  mov wc.hIconSm,eax
  invoke LoadCursor,NULL,IDC_ARROW
  mov wc.hCursor,eax
  invoke RegisterClassEx,addr wc
  invoke CreateWindowEx,0,addr s_classname,addr s_pov,WS_OVERLAPPEDWINDOW,10,10,600,400,0,0,hInstance,0
  mov hwnd,eax
  invoke ShowWindow,hwnd,SW_SHOWDEFAULT
  invoke UpdateWindow,hwnd
  .WHILE TRUE
    invoke GetMessage,addr msg,0,0,0
    cmp eax,0
    je out_while
    invoke TranslateMessage,addr msg
    invoke DispatchMessage,addr msg
  .ENDW
out_while:
  mov eax,msg.wParam
  ret
       WinMain endp

WndProc proc h_wnd0:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
  .IF uMsg==WM_DESTROY
    invoke PostQuitMessage,NULL
  .ELSEIF uMsg==WM_CREATE                 
    invoke CreatePopupMenu                ; создает контекстное меню
    mov h_popupMenu,eax
    invoke CreatePopupMenu                ; выпадающее меню из основного
    mov h_popupMenu2,eax
    invoke AppendMenu,\                   ; добавляем в контекстное меню пункты
           h_popupMenu,\                  ; добавляем пункт в основной пункт меню
           MF_STRING,\                    ; тип пункта меню (строка)
           IDPM_CUT,\                     ; идентификатор пункта меню
           addr s_cut                     ; пункт меню
    invoke AppendMenu,h_popupMenu,MF_STRING,IDPM_COPY,addr s_copy
    invoke AppendMenu,h_popupMenu,MF_STRING,IDPM_PASTE,addr s_paste
    invoke AppendMenu,h_popupMenu,MF_POPUP,h_popupMenu2,addr s_popup  ; добавляем выпадающее меню

    invoke AppendMenu,h_popupMenu2,MF_STRING,IDPM_CUT, addr s_cut     ; дведаем в выпадающее меню
    invoke AppendMenu,h_popupMenu2,MF_STRING,IDPM_COPY, addr s_copy   ; 
    invoke AppendMenu,h_popupMenu2,MF_STRING,IDPM_PASTE,addr s_paste
  .ELSEIF uMsg==WM_RBUTTONUP              ; при отпуске правой кнопки мышки выводим меню
    invoke GetCursorPos,addr st_point     ; заполняет структуру абсолютными координатами курсору
    invoke TrackPopupMenu,\               ; показывает меню
           h_popupMenu,TPM_RIGHTALIGN,st_point.x,st_point.y,0,h_wnd0,0
    invoke PostMessage,h_wnd0,0,0,0 ; передать логику программы на основное окно, а не остаться в конменю
  .ELSEIF uMsg==WM_COMMAND                
    mov eax,wParam                        ;  wParam содержит идентификатор элемента
    .IF ax==IDPM_CUT
      invoke MessageBox,NULL,addr s_cut,addr s_zaholMsgbx,MB_OK
    .ELSEIF ax==IDPM_COPY
      invoke MessageBox,NULL,addr s_copy,addr s_zaholMsgbx,MB_OK
    .ELSEIF ax==IDPM_PASTE
      invoke MessageBox,NULL,addr s_paste,addr s_zaholMsgbx,MB_OK
    .ENDIF
  .ELSEIF uMsg==WM_LBUTTONDOWN            ;  если нажата левуая кнопка мышки
    invoke MessageBox,0,addr s_left,addr szTitl,0
  .ELSEIF uMsg==WM_LBUTTONDBLCLK          ; если двойной клик левой кнопкой
    invoke MessageBox,hwnd,addr s_leftd,addr szTitl,0
  .ELSEIF uMsg==WM_KEYDOWN       ; нажата клавиша на клавиатуре
    .IF wParam==VK_SHIFT          ; wParam (при WM_KEY...) содержит код клавиши
      invoke MessageBox,hwnd,addr szShift,addr szTitl,0  ; отслеживание клавишы <Alt>
    .ELSEIF wParam==VK_CONTROL   ; wParam (при WM_KEY...) содержит код клавиши
      invoke MessageBox,hwnd,addr szCtrl,addr szTitl,0  ; отслеживание клавишы <Ctrl>
    .ELSEIF wParam==VK_F1        ; wParam (при WM_KEY...) содержит код клавиши
      invoke MessageBox,hwnd,addr szF1,addr szTitl,0  ; отслеживание клавишы <F1>
    .ENDIF
  .ELSEIF uMsg==WM_CHAR                   ; завдяки TranslateMessage отримуємо зразу символ
    mov eax,wParam
    mov s_char,al
    invoke MessageBox,0,addr s_char,addr s_char,0
  .ELSE
    invoke DefWindowProc,h_wnd0,uMsg,wParam,lParam
    ret
  .ENDIF
  xor eax,eax
  ret
WndProc endp
end start