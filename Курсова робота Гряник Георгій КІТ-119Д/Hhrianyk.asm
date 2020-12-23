include \masm64\include64\masm64rt.inc
.data	
colorBlack dd 196920
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y)
      tEdit     dq ? ; хэндл окна ввода 
       buffer BYTE 260 dup(?) ;;; для хранения текста
         pbuf dq buffer ;;; для MessageBox,т.к.не используется ADDR
         
classname db "template_class",0
caption db "Графічна фігура",0
MouseClick db 0  ; флаг нажатия 
myXY POINT <>  ; структура для х- та у-координат

 mas dd 25000 ; кількість точок
 j dq 3       ;степінь cos
 k dq 3       ;степінь sin
 t dd 0.0     ; угловая коор дината 

 a dq 1.    ;a
 b dq 80.0  ;b
 c dq 1.0   ;c
 d dq 80.0 ; d 

;резерв для вивода
 a1 dd 0  
 b1 dd 0
 c1 dd 0
 d1 dd 0 ; 
 divK2 dd 100
 
;коефіціенти зміни параметрів налаштування
 plus dd 1.
 plus1 dd 1  
 minus dd 5.
 one dd 1.

 delta dd  0.0175 ; один градус  

 xdiv2 dq ?    ; середина по X 
 ydiv2 dq ?    ; середина по Y
 xdiv  dq 620  ; ширина вікна
 ydiv  dq 520  ; висота вікна
 tmp dd 0       ; временная переменная
 divK dd 100. ; масштабный коэффициент
 xr dd 0. 	; координаты функции
 yr dd 0    ;; координаты функции
 temp1 dd 0; на всяк випадок

;текст для виводу
text01 db "x=%d y=%d",0

txt02 db "     Встановлені параметри     ",10,10,
"        Встановлені параметри    ",10,10, 
"Розмір фігури: %d",10,
"Розмір вікна: %dx%d",10,10,
"Дані:",10,
"A=%d",10,
"B=%d	",10,
"C=%d",10,
"D=%d",10,10,
"Формула: ",10,
"x=сos(at)-cos^%d(bt)",10,
"y=sin(ct)-sin^%d(dt)",10,10,
"Кількість точок: %d",0 
txt03 db "%d",0
 

buf1 dq 3 dup(0),0
buf2 dq 100 dup(0),0
 
;для інформації від автора
_file1 db "Help.txt",0 ; файл від 
hFile01 HANDLE ?
from_file db 4096 dup(?)
read_by_file dq ?
write_by_file dq ?
file01_size dq ?
;Інформація від автора
title2 db "Інформація від автора",0
msg2 db "Помилка! Файл 'Про програму' не доступен!",0
buf dq 0

.code
entry_point proc
 

    GdiPlusBegin        ; initialise GDIPlus
    ;Пошук середе вікна
  mov rax ,xdiv
  shr rax,1 ; деление на 2 – определение середины экрана по Х
  mov xdiv2,rax
  mov rax ,ydiv
  shr rax,1 ; деление на 2 – определение середины экрана по Y
  mov ydiv2,rax

 

 mov hBmp, rv(ResImageLoad,20); завантаження фото

  mov hInstance,rv(GetModuleHandle,0) ; получение и сохранение дескрипторa програми
  mov hIcon,  rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR) ; загрузка и сохранение дескрипторa иконки
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; загрузка курсора и сохранение
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; получение кол. пикселей по х монитора
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; получение кол. пикселей по y монитора
 ;Paint main
  invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon;головного меню
 
    

    invoke ExitProcess,0
    ret
entry_point endp


mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну

invoke SendMessage,rv(GetDlgItem,hWin,106),\ ; сообщение окну по дескриптору органа управления
              STM_SETIMAGE,IMAGE_ICON,lParam
                         ; 102 - jpg
        .return TRUE
  mov tEdit, rvcall(GetDlgItem,hWin,301)
invoke SetFocus, tEdit ; установка курсора в поле ввода 

      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 101 ; кнопка налаштування кількості точок
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,2000,0,ADDR Rrecision,hIcon
        
 
          .case 102 ;налаштування вхідних даних
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,3000,0,ADDR Conditions,hIcon
     
 
          .case 103 ; налаштування фугкції
          mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
        invoke DialogBoxParam,hInstance,4000,0,ADDR formulas,hIcon
    
 
          .case 104;зоразити фігуру
          call Paint
                    
          .case  105;закрити програму
            ; invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
           
          .case 10004; відкриття інформації про програму
          invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
          mov hFile01,rax ; сохранение дескриптора файла
           .if hFile01 == INVALID_HANDLE_VALUE ; если CreateFile возвращает ошибку
           invoke MsgboxI,0,addr msg2,"Інфа від автора",MB_OK,0 ; сообщение об ошибке
          ret
         .endif ; якщо невиконуєтьсяя попередня умова  то виконується це
         invoke GetFileSize,hFile01,0 ; получение размера файла 01
         mov file01_size,rax; 
         invoke ReadFile,hFile01,addr from_file,file01_size,addr read_by_file,0;підготовка даних
         invoke MessageBox,0,addr from_file,addr title2,MB_OK,10 ; виклик MessageBox
         invoke CloseHandle,hFile01
 

         .case  10005;;вивод встановлених налаштувань
            fld a
            fld b
            fld c
            fld d
            fld divK
            fistp dword ptr divK2
            fistp dword ptr d1
            fistp dword ptr c1
            fistp dword ptr b1
            fistp dword ptr a1
          invoke wsprintf,ADDR buf1,ADDR txt02, divK2, xdiv, ydiv, a1, b1,c1, d1,j,k,mas
          invoke MsgboxI,hWin,ADDR buf2,"Info",MB_OK,10
          
          .case 10002;хто автор
          invoke MsgboxI,hWin,"Автор: Гряник Г.В., гр.КІТ-119Д","Автор",MB_OK,10
          
          .case 10003;закрить програму
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
          
          .case 10007;додатекові налаштування
           invoke DialogBoxParam,hInstance,600,0,ADDR ChangeSettings,hIcon

        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp
;//////////////////////////////////////////////////////////////////////////
Rrecision proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; процедура налаштування точності(кількості точок
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg

        .return TRUE 
      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 201 ; кнопка встановити 1000
      mov mas ,1000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ;закрити вікно
          .case 202 ; кнопка встановити 2000
      mov mas ,2000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; ;закрити вікно

         .case 203 ; кнопка встановити 5000
      mov mas ,5000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;;закрити вікно
         .case 204 ; кнопка встановити 10 000
      mov mas ,10000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;закрити вікно
          .case 205 ; кнопка встановити 25000
      mov mas ,25000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрити вікно
           .case 206 ; кнопка встановити 50 000
      mov mas ,50000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрити вікно
           .case 212 ; кнопка встановити 75 000
      mov mas ,75000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрити вікно
            .case 207 ; кнопка встановити 100 000
      mov mas ,100000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;закрити вікно
          .case 208 ; кнопка встановити 1 000 000
      mov mas ,1000000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрити вікно
            .case 209 ; кнопка встановити 1 000 000
      mov mas ,1000000000
     rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;   закрити вікно       
 
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
Rrecision endp
;////////////////////////////////////////
Conditions proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD;зміна вхідних даних для розрахунку формули
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        ;invoke SetWindowText,301,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
 
       
            invoke wsprintf,ADDR buf1,ADDR txt03, a1 
            invoke SetDlgItemText,hWin,301,addr buf1 ;вивести значення a
            
            invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;вивести значення b
            
            invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;вивести значення c
            
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;вивести значення d

            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;вивести значення plus
 .return TRUE

      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
     .case 312  ;a-plus
     
            fld a
            fsub plus
            fld st(0)
            fstp  a
            fistp dword ptr a1
              invoke wsprintf,ADDR buf1,ADDR txt03, a1
            invoke SetDlgItemText,hWin,301,addr buf1 ;вивести значення a
     .case 313 ;a+plus
            fld a
            fadd plus
            fld st(0)
            fstp  a
            fistp dword ptr a1
             invoke wsprintf,ADDR buf1,ADDR txt03, a1
            invoke SetDlgItemText,hWin,301,addr buf1 ;вивести значення a
            
     .case 314 ;b-plus
            fld  b
            fsub plus
            fld st(0)
            fstp  b
            fistp dword ptr b1
             invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;вивести значення b
     .case 315 ;b+plus
            fld b
            fadd plus
            fld st(0)
            fstp  b
            fistp dword ptr b1
             invoke wsprintf,ADDR buf1,ADDR txt03, b1
            invoke SetDlgItemText,hWin,302,addr buf1 ;вивести значення b
            
     .case 316 ;c-plus
            fld c
            fsub plus
            fld st(0)
            fstp  c
            fistp dword ptr c1
             invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;вивести значення c
     .case 317 ;c+plus
            fld c
            fadd plus
            fld st(0)
            fstp  c
            fistp dword ptr c1
             invoke wsprintf,ADDR buf1,ADDR txt03, c1
            invoke SetDlgItemText,hWin,303,addr buf1 ;вивести значення c
            
     .case 318 ;d-plus
            fld d
            fsub plus
            fld st(0)
            fstp  d
            fistp dword ptr d1
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;вивести значення d
     .case 319 ;d+plus
            fld d
            fadd plus
            fld st(0)
            fstp  d
            fistp dword ptr d1
            invoke wsprintf,ADDR buf1,ADDR txt03, d1
            invoke SetDlgItemText,hWin,304,addr buf1 ;вивести значення d

     .case 320 ;plus-1
            fld plus
            fsub one
            fld st(0)
            fstp  plus
            fistp dword ptr plus1
            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;вивести значення plus
     .case 321 ;plus+1
            fld plus
            fadd one
            fld st(0)
            fstp  plus
            fistp dword ptr plus1
            invoke wsprintf,ADDR buf1,ADDR txt03, plus1
            invoke SetDlgItemText,hWin,306,addr buf1 ;вивести значення plus
     .case 322
             
     invoke MsgboxI,hWin,"Натискайте '+' аби збільшити коефіціент додавання або '-' щоб його зменшити","Коефіціент додавання",MB_OK,10 ;plus-info

      .case 305
 
             rcall EndDialog,hWin, 1 
         .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
Conditions endp
;//////////////////////////////////////////////////////////////////
formulas proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; ;; редагування функції
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        ;invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 401 ; кнопка зміни значення степіня косинусв та синуса 
          mov j,3
          mov k,3
          .case 402
          mov hBmp, rv(ResImageLoad,20)
          invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon
 
           
          .case 403 ; кнопка зміни значення степіня косинусв та синуса 
           mov j,3
           mov k,4
          .case 408
           mov hBmp, rv(ResImageLoad,30)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; вивод приклад графіка
           
          .case 409 ; кнопка зміни значення степіня косинусв та синуса 
           mov hBmp, rv(ResImageLoad,40)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; вивод приклад графіка
          .case 410
                       mov hBmp, rv(ResImageLoad,50)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; вивод приклад графіка
          .case 411  

         
          .case 405 ; кнопка зміни значення степіня косинусв та синуса 
           mov j,4
           mov k,4
          .case 406
                        mov hBmp, rv(ResImageLoad,50)
           invoke DialogBoxParam,hInstance,5000,0,ADDR formulas2,hIcon; вивод приклад графіка
                  
          .case 407
             invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND;анімоване закриття вікна
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;  
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
formulas endp

;//////////////////////////////////////////////////////////////////
formulas2 proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD; ;; вікно відображення прикладу графіка
    .switch uMsg

      .case WM_INITDIALOG ; сообщение о создании диал. окна
         invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
           mov hStatic, rv(GetDlgItem,hWin,501) 
         invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          
          .case 507
           rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;  
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
formulas2 endp

;//////////////////////////////////////////////////////////////////
ChangeSettings proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD;налаштування розміру вікна та фігури
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
     
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1 ;вивести значення divk

       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;вивести значення розміру вікна

        invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;вивести значення розміру вікна


        .return TRUE

     invoke SetWindowText,rv(GetDlgItem,hWin,608),"Нажата левая клавиша мышки" 
      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 

      .case 610 ;розмір фігури - 5
            fld  divK
            fsub minus
            fld st(0)
            fstp  divK
            fistp dword ptr divK2
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1 ;вивести значення розміру фігури
     .case 611 ;розмір фігури + 5
            fld  divK
            fadd minus
            fld st(0)
            fstp  divK
            fistp dword ptr divK2
            invoke wsprintf,ADDR buf1,ADDR txt03, divK2
            invoke SetDlgItemText,hWin,603,addr buf1  ;вивести значення розміру фігури
            
     .case 612 ;розмір вікна - 10
      sub xdiv,10
       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;вивести значення розмірувікна
     .case 613 ;розмір вікна + 10
      add xdiv,10 
       invoke wsprintf,ADDR buf1,ADDR txt03, xdiv
       invoke SetDlgItemText,hWin,604,addr buf1 ;вивести значення розмірувікна
     .case 614 ;розмір вікна - 10
      sub ydiv,10
       invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;вивести значення розмірувікна
     .case 615 ;розмір вікна + 10
      add ydiv,10
        invoke wsprintf,ADDR buf1,ADDR txt03, ydiv
       invoke SetDlgItemText,hWin,605,addr buf1 ;вивести значення розмірувікна

 .case 607
 ;пошук нової середини вікна
   mov rax ,xdiv
  shr rax,1 ; деление на 2 – определение середины экрана по Х
  mov xdiv2,rax
  mov rax ,ydiv
  shr rax,1 ; деление на 2 – определение середины экрана по Y
  mov ydiv2,rax
   rcall EndDialog,hWin, 1
   
         .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
ChangeSettings endp

;//////////////////////////////////////////////////////////////////


Paint proc ; створення вікна
    LOCAL wc  :WNDCLASSEX ; объявление локальных переменных
    LOCAL lft :QWORD ;  Лок. переменные содержатся в стеке 
    LOCAL top :QWORD  ; и существуют только во время вып. проц.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; колич. байтов структуры
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; стиль окна
    mov wc.lpfnWndProc,ptr$(WndProc) ; адрес процедуры WndProc
    mov wc.cbClsExtra,0 ; количество байтов для структуры класса
    mov wc.cbWndExtra,0 ; количество байтов для структуры окна
   mrm wc.hInstance,hInstance ; заполнение полЯ дескриптора в структуре
   mrm wc.hIcon,  hIcon ; хэндл иконки
   mrm wc.hCursor,hCursor ; хэндл курсора
   mrm wc.hbrBackground,5 ; цвет окна
    mov wc.lpszMenuName,0 ; заполнение поля в структуре с именем ресурса меню
    mov wc.lpszClassName,ptr$(classname) ; имя класса
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; регистрациЯ класса окна
 mov rax ,xdiv
   mov wid, rax ; ширина пользовательского окна в пикселях
    mov rax ,ydiv
   mov hgt, rax ; высота пользовательского окна в пикселях
    mov rax,sWid ; колич. пикселей монитора по x
    sub rax,wid ; дельта • = •(монитора) - х(окна пользователя)
    shr rax,1   ; получение середины •
    mov lft,rax ;

    mov rax, sHgt ; колич. пикселей монитора по y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
         ADDR classname,ADDR caption, \
         WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
         lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; сохранение дескриптора окна
  call msgloop
    ret
Paint endp

msgloop proc
    LOCAL msg  :MSG
    LOCAL pmsg :QWORD
    mov pmsg,ptr$(msg) ; получение адреса структуры сообщениЯ
    jmp gmsg           ; jump directly to GetMessage()
  mloop:
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg ; отправка на обслуживание к WndProc
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0) ; пока GetMessage не вернет ноль
    jnz mloop
    ret
msgloop endp
;//////////////////////////////////////////////////////////////////
WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD ;побудова фігури
LOCAL hdc:HDC   	; резервирование стека для дескриптора окна
LOCAL ps:PAINTSTRUCT ; для структуры PAINTSTRUCT
LOCAL rect:RECT      ; для структуры координат RECT
.switch uMsg
 .case WM_DESTROY ; если есть сообщение про уничтожение окна
        invoke PostQuitMessage,NULL
 .case WM_LBUTTONDOWN    ; сообщение от левой клавиши 
mov rax,lParam  ; 32-разрядные координаты курсора мышки
and rax,0ffffh  ; выделение младшей части - координаты Х
mov myXY.x,eax	; сохранение координаты X
mov rax,lParam  ; 32-разрядные координаты курсора мышки
shr rax,16 		; сдвиг вправо на 4 байта для выделения  Y 
mov myXY.y,eax  ; сохранение координаты Y
 ;mov MouseClick,TRUE 	; подтверждение получения координат
invoke InvalidateRect,hWnd,0,TRUE ; для перерисования окна
; .case WM_PAINT      ; если есть сообщение о перерисовании 
invoke BeginPaint,hWnd,ADDR ps ; заполнение структуры
mov  hdc,rax 		  ; сохранение контекста
      		; проверка установления флажка
   mov r10d,mas ; сохранение количества циклов
 mov temp1,r10d
 invoke InvalidateRect,hWnd,0,TRUE ; вызов функции и WM_PAINT
finit
    invoke BeginPaint,hWnd, ADDR ps ; вызов подготовительной процедуры
  mov hdc,rax            ; сохранение контекста
 
l1:   
                      
invoke wsprintf,ADDR buf1,ADDR text01,xr,yr                        
   invoke TextOut,hdc, 10,30,ADDR buf1,12 ;вивод координат точок(аби бачити що щось розраховується)
 
  fld a    ; a
fmul t     ; m*alpha
fcos       ;cos(a*t)
fld b      ; b
Fmul t     ; b*t
fcos       ; cos (b*t)
cmp j,4    ; оптимізація алгоритму під степінь 3 або 4
je s1
 
fld st(0)
fld st(0)
FMUL       ; sin^2(d*t)
FMUL       ; sin^3(d*t)
jmp s2
s1:
fld st(0)
fld st(0)
fld st(0)
FMUL       ; cos^2(d*t)
FMUL       ; cos^3(d*t)
FMUL       ; cos^3(d*t)
s2:
 
FSUB       ; cos(a*t)-cos^3(m*t)
FMUL divK  ; розмір* cos(a*t)-cos^3(m*t)
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 
 
fld c   ; c
fmul t     ; m*alpha
fsin       ;cos(c*t)
fld d      ; d
Fmul t     ; d*t
fsin       ; sin (d*t)

cmp k,4    ; оптимізація алгоритму під степінь 3 або 4
je s4
s3:
fld st(0)
fld st(0)
FMUL       ; sin^2(d*t)
FMUL       ; sin^3(d*t)
jmp s5
s4:
fld st(0)
fld st(0)
fld st(0)
FMUL       ; cos^2(d*t)
FMUL       ; cos^3(d*t)
FMUL       ; cos^3(d*t)
s5:

FSUB       ; sin(a*t)-sin^k(m*t)
FMUL divK  ; розмір* sin(a*t)-sin^k(m*t)
fstp tmp
fild ydiv2      
fsub tmp  

fistp dword ptr yr ; сохранение X для выведения на экран
 
invoke SetPixel, hdc, xr, yr, colorBlack ; поставити точку у вікні.
 
;invoke SetCursorPos,xr,yr ; установление курсора по xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3
 
dec temp1   ; уменьшение счетчика
jz l2       ; продолжение рисование
jmp l1	; выход из цикла
l2: 
 
invoke EndPaint,hWnd, ADDR ps			; количество байтов текста
      .endif

    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end