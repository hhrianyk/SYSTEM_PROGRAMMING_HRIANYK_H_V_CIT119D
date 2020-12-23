 
  include \masm64\include64\masm64rt.inc
  include \masm64\macros64\macros64.inc
    .data
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hCursor   dq ? ; дескриптор курсора
      sWid      dq ? ; ширина монитора (колич. пикселей по x)
      sHgt      dq ? ; высота монитора (колич. пикселей по y) 
title1 db "Лаб.8",0      
 
txt01 db "Сообщение при загрузке, автозагрузке",0
txt02 db "Ветки HKLM\Software\Microsoft\WindowsNT\CurrentVersion\Winlogon",10," HKLM\ SoftWare\Microsoft\Windows\CurrentVersion. ",0
txt03 db "Ключи: LegalNoticeCaption, LegalNoticeText, RunOnce, RunOnceEx, RunServices, RunServicesOnce",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0
 
szREGSZ db 'REG_SZ',0 
 
hKey dd ?
lpdwDisp dd ? 
 

.code
entry_point proc

  
     mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,0,1000,0,ADDR mainW,hIcon
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
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
cmp rax,0 ;Раздел создан успешно ?
jne m1
invoke RegSetValueEx,hKey,"LegalNoticeCaption", 0,REG_SZ,"Hello world",15 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m1
   invoke MessageBox,0,chr$("Зміна пройшла успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m2 
   m1:
 invoke MessageBox,0,chr$("Зміна пройшла не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m2: 
 invoke RegCloseKey, hKey  ; идентификация открытого ключа для закрытия
;/////////////////////////////////////////

    .case 106 ; кнопка
  invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 cmp rax,0 ;Раздел создан успешно ?
jne m3  
invoke RegSetValueEx,hKey, "LegalNoticeText",0,REG_SZ,"My name...",15 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m3
   invoke MessageBox,0,chr$("Зміна пройшла успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m4 
   m3:
 invoke MessageBox,0,chr$("Зміна пройшла не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m4: 
 invoke RegCloseKey,hKey ; идентификация открытого ключа для закрытия
;/////////////////////////////////////////
    .case 107 ; кнопка
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnce",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;

invoke RegSetValueEx, hKey ,  "Masm32",0,REG_SZ,"FuturamaS2",10 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m5
   invoke MessageBox,0,chr$("Зміна пройшла успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m6 
   m5:
 invoke MessageBox,0,chr$("Зміна пройшла не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m6: 
 invoke RegCloseKey,hKey; идентификация открытого ключа для закрытия
 ;/////////////////////////////////////////
 
 .case 120 ; кнопка
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnceEX",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"szValueName",10 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m7
   invoke MessageBox,0,chr$("Створення пройшло успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m8 
   m7:
 invoke MessageBox,0,chr$("Створення пройшло не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m8: 
 invoke RegCloseKey,hKey; идентификация открытого ключа для закрытия
 
;/////////////////////////////////////////
 .case 108 ; кнопка
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices",10 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m9
   invoke MessageBox,0,chr$("Створення пройшло успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m10 
   m9:
 invoke MessageBox,0,chr$("Створення пройшло не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m10: 
 invoke RegCloseKey,hKey; идентификация открытого ключа для закрытия
 
;/////////////////////////////////////////
 .case 109 ; кнопка
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServicesOnce",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"Dell 11",10 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne ms7
   invoke MessageBox,0,chr$("Створення пройшло успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp ms8 
   ms7:
 invoke MessageBox,0,chr$("Створення пройшло не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	ms8: 
 invoke RegCloseKey,hKey; идентификация открытого ключа для закрытия
 
;/////////////////////////////////////////
.case 110
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServicesOnce"
invoke MessageBox,0,chr$("Ключ успешно удалён"),chr$("Реестр"),MB_ICONINFORMATION
.case 111
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnceEX"
invoke MessageBox,0,chr$("Ключ успешно удалён"),chr$("Реестр"),MB_ICONINFORMATION
 .case 112
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices"
invoke MessageBox,0,chr$("Ключ успешно удалён"),chr$("Реестр"),MB_ICONINFORMATION
  	  
 

 ;/////////////////////////////////////////
           .case 114 ; кнопка
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
cmp rax,0 ;Раздел создан успешно ?
jne m11
invoke RegSetValueEx,hKey,"LegalNoticeCaption", 0,REG_SZ,"Hello world",0 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m11
   invoke MessageBox,0,chr$("Очистка пройшла успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m12 
   m11:
 invoke MessageBox,0,chr$("очистка пройшла не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m12: 
 invoke RegCloseKey, hKey  ; идентификация открытого ключа для закрытия
;/////////////////////////////////////////

    .case 115 ; кнопка
  invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 cmp rax,0 ;Раздел создан успешно ?
jne m13  
invoke RegSetValueEx,hKey, "LegalNoticeText",0,REG_SZ,"My name...",0 ; размер ключа в байтах
 cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
 jne m13
   invoke MessageBox,0,chr$("Очистка пройшла успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	jmp m14 
   m13:
 invoke MessageBox,0,chr$("Очистка пройшла не успішно"),chr$("Реестр"),MB_ICONINFORMATION
 	m14: 
 invoke RegCloseKey,hKey ; идентификация открытого ключа для закрытия


;/////////////////////////////////////////
   
 .case 201    
           invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10;
           
 .case 202     
           invoke MsgboxI,hWin,ADDR txt02,"Ветки",MB_OK,10;
 .case 206     
           invoke MsgboxI,hWin,ADDR txt03,"ключи",MB_OK,10;
                      
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
    end