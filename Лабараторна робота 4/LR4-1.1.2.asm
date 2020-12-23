include \masm64\include64\masm64rt.inc ; библиотеки для подключения
 IDI_ICON  EQU 1001

DATE1 STRUCT               ; определения данные СТРУКТУРА с именем DATE1
Name1   dW ? 			; имя 1 поля структуры  
Name2   dw ? 			; имя 2 поля структуры  
Name3   dw ? 			; имя 3 поля структуры  
Name4   dw ? 			; имя 4 поля структуры  
Name5   dw ? 			; имя 5 поля структуры  
Name6   dW ? 			; имя 6 поля структуры  

DATE1 ENDS 	 	  ; окончания данные СТРУКТУРА с именем Date1

.data 			          	; директива определения данные
  Car1  DATE1 <1,10,2,3,1,1> 		      ; структура с именем Car1
  Car2  DATE1 <2,-11,6,7,2,1> 		; структура с именем Car2
  Car3  DATE1 <3,12,10,11,3,1> 		; структура с именем Car3
  Car4  DATE1 <4,13,14,15,31,1> 		; структура с именем Car4

_res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res2 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res3 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res4 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res5 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res6 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ

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


;Текст для Window
titl1 db "Лаб.4-1.1 СТРУКТУРИ. masm64",0
txt1 db "Завдання: Дана матриця 4 х 6. Визначити суму елементів кожного стовпця.", 10,10,0
txt2 db "Вхідний массив - вид матриці:",10,0
txt3 db "          |01|10|02|03|01|01|",10,0
txt4 db "          |01|10|02|03|01|01|",10,0
txt5 db "          |03|12|10|11|03|01|",10,0
txt6 db "          |04|13|14|15|31|01|",10,0
txt7 db "--------------------------------------",10,0
txt8 db "сума: |%d|%d|%d|%d|%d|%d| ",10,0


autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0

st2 db 32 dup(?),0 ; 
.code
entry_point proc
xor ebx,ebx
movzx  ebx,Car1.Name1	; заполнение нулями старшей части 
  add   bx,Car2.Name1     	; bx := Car1.Name1  +  Car2.Name1
  add   bx,Car3.Name1 	; 
  add   bx,Car4.Name1 	; 
movsxd  r15,ebx 
mov _res1,r15 ; 
movzx  ebx,Car1.Name2	; заполнение нулями старшей части 
  add   bx,Car2.Name2     	; bx := Car1.Name2  +  Car2.Name2
  add   bx,Car3.Name2 	; 
  add   bx,Car4.Name2 	; 
movsxd  r15,ebx 
mov _res2,r15 ; 
movzx  ebx,Car1.Name3	; заполнение нулями старшей части 
  add   bx,Car2.Name3     	; bx := Car1.Name3  +  Car2.Name3
  add   bx,Car3.Name3 	; 
  add   bx,Car4.Name3 	; 
movsxd  r15,ebx 
mov _res3,r15 ; 
movzx  ebx,Car1.Name4	; заполнение нулями старшей части 
  add   bx,Car2.Name4     	; bx := Car1.Name4  +  Car2.Name4
  add   bx,Car3.Name4 	; 
  add   bx,Car4.Name4 	; 
movsxd  r15,ebx 
mov _res4,r15 ; 
movzx  ebx,Car1.Name5	; заполнение нулями старшей части 
  add   bx,Car2.Name5     	; bx := Car1.Name5  +  Car2.Name5
  add   bx,Car3.Name5 	; 
  add   bx,Car4.Name5 	; 
movsxd  r15,ebx 
mov _res5,r15 ;  
movzx  ebx,Car1.Name6	; заполнение нулями старшей части 
  add   bx,Car2.Name6     	; bx := Car1.Name6  +  Car2.Name6
  add   bx,Car3.Name6 	; 
  add   bx,Car4.Name6 	; 
movsxd  r15,ebx 
mov _res6,r15 ; 
invoke wsprintf,ADDR st2,ADDR txt8,_res1,_res2,_res3,_res4,_res5,_res6   ; функция преобразования

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
   mov wid, 600 ; ширина пользовательского окна в пиксел¤х
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
            ADDR classname,ADDR titl1, \
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
  invoke  DrawText, hdc,ADDR autor,0, ADDR rect, \ ; рисование текста
   DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke TextOut,hdc,10,10,ADDR txt1,74
   invoke TextOut,hdc,50,40,ADDR txt2,32
   invoke TextOut,hdc,50,70,ADDR txt3,32
   invoke TextOut,hdc,50,100,ADDR txt4,32
   invoke TextOut,hdc,50,130,ADDR txt5,32
   invoke TextOut,hdc,50,160,ADDR txt6,31
   invoke TextOut,hdc,50,180,ADDR txt7,40
   invoke TextOut,hdc,50,200,ADDR st2,32
   invoke TextOut,hdc,80,250,ADDR autor,32

  invoke EndPaint,hWnd, ADDR ps                ; завершение рисования
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end
