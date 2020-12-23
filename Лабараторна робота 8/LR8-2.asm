 
  include \masm64\include64\masm64rt.inc
  include \masm64\macros64\macros64.inc
  
    .data
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      hImg1     dq ? ; хэндл рисунка
      tEdit     dq ? ; хэндл окна ввода
 buffer BYTE 260 dup(?) ;;; для хранения текста
title1 db "Лаб.8.2",0      
txt01 db "Запуск однієї програми, створеної особисто, і програми калькулятора (calc.exe). Особисто створена програма виконується 5 секунд, а програма calc.exe виконується 8 секунд.",0
 
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0


  pbuf dq buffer ;;; для MessageBox,т.к.не используется ADDR
  rus db  'Russian_Russia.866',0      ; 
 
programname1 db  "c:\windows\system32\calc.exe",0
programname2 db  "LR8-2_1.exe",0
 

buf1 dd 0   ;
buf2 dq 3 dup(0),0; буфер
P        dd ? ; адрес переменной для идентификатора процесса

startInfo dd ?
startInfo2 dd ?
processInfo PROCESS_INFORMATION <> ; информация о процессе и его первичной нити
processInfo2 PROCESS_INFORMATION <> ; информация о процессе и его первичной нити
 

.code
entry_point proc

 

     mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     ;mov hBmp, rv(ResImageLoad,10,,128,128,LR_DEFAULTCOLOR)
     invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
     
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
       ; mov hStatic, rv(GetDlgItem,hWin,101)
       ; invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
 
          .case 103 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
          .case 102
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 104
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
;/////////////////////////////////////////
           .case 105 ; кнопка
 mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,3000,0,ADDR GetUserText,hIcon
        test rax, rax  ; нажата ли кнопка отмены
       jz notext
       invoke wsprintf,addr buf2 ,ADDR pbuf
notext:
;/////////////////////////////////////////
    .case 106 ; кнопка
     rcall MessageBox, hWin,buf2,"  Текст", MB_ICONQUESTION
   

;/////////////////////////////////////////
   .case 107 ; кнопка
    invoke  MsgboxI,hWin,"Відкрити програми","Повідомлення",MB_OK,10 
   invoke GetStartupInfo,ADDR startInfo ; Возобновляет структуру STARTUPINFO
 invoke CreateProcess,ADDR programname2,NULL,NULL,NULL,FALSE,\
        NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo2
  ; invoke CloseHandle,processInfo2.hThread ; закрытие хендла потока

   invoke CreateProcess,ADDR programname1,NULL,NULL,NULL,FALSE,\
         NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo

    invoke  Sleep, 5000
         invoke TerminateProcess,processInfo2.hProcess,0 ; закінчує процес 
   invoke  Sleep, 3000
invoke FindWindow, 0,"Калькулятор"
   invoke GetWindowThreadProcessId,rax, addr P ;
    invoke  OpenProcess,PROCESS_TERMINATE,FALSE,P 
    or      rax,rax
    invoke  TerminateProcess,rax,0

   invoke TerminateProcess,processInfo.hProcess,0
invoke TerminateProcess,processInfo.hProcess,0 ; закінчує процес 
; rcall SendMessage,processInfo.hThread,WM_SYSCOMMAND,SC_CLOSE,0;
   
  invoke  MsgboxI,hWin,"Закрито всі вікна","Повідомлення",MB_OK,10 
           

  ;/////////////////////////////////////////
   
 .case 200    
           invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10;
           
 .case 203
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
 .case 205
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;        
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp

;/////////////////////////////////////////
GetUserText proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG ; SendMessage отправляет заданное сообщение окну
invoke SendMessage,hWin,WM_SETICON,1,lParam ; иконка в строке заголовка 
  mov hImg1, rvcall(GetDlgItem,hWin,304); извлекает дескриптор
invoke SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области
  mov tEdit, rvcall(GetDlgItem,hWin,301)
invoke SetFocus, tEdit ; установка курсора в поле ввода 

.case WM_COMMAND
.switch wParam
   .case 302
rcall GetWindowText,tEdit,pbuf,sizeof buffer; записать текст по адресу буфера
            .if rax == 0
rcall MessageBox,hWin,"Введіть текст ","Текст відсутній", MB_ICONWARNING
 rcall SetFocus,tEdit ; установка фокуса на окно Edit
            .else
             rcall EndDialog,hWin, 1 
            .endif
 .case 309
            jmp exit_dialog
   .endsw
      .case WM_CLOSE
exit_dialog:
       rcall EndDialog,hWin,0 
.endsw
    xor rax, rax
    ret
GetUserText endp
    end