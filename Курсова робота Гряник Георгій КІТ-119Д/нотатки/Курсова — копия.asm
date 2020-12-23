;OPTION DOTNAME ; включение и отключение функции ассемблера
include \masm64\include64\masm64rt.inc
includelib comdlg32.lib
includelib user32.lib
includelib msvcrt.lib
includelib comctl32.lib
; OPTION PROLOGUE:none
; OPTION EPILOGUE:none


.data
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?


DEV_BROADCAST struct 
        ; Заголовок структуры
        dbch_size       dd ?
        dbch_devicetype dd ?
        dbch_reserved   dd ?

        ; Информационная часть структуры
        dbcv_unitmask   dd ?
        dbcv_flags      dd ?
DEV_BROADCAST ends

; Виртуальная проекция структуры DEV_BROADCAST
;virtual dq 0
;event   DEV_BROADCAST
;virtual ends


title1 db "Курсач", 0 
 
szOn    db 'USB drive '
drv1    db 'X: connected',13,10,0

szOff   db 'USB drive '
drv2    db 'X: removed',13,10,0

  DBT_DEVICEARRIVAL        dq 8000h
  DBT_DEVICEREMOVECOMPLETE dq  8004h

  DBT_DEVTYP_VOLUME     dq 2h


 .code 	          	
entry_point proc 

      mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,100,0,ADDR DialogProc,hIcon
         
invoke ExitProcess, 0 ; возвращение управления ОС Windows и освобождение ресурсов
entry_point endp; кінець роботи програми
;------------------------------------------------------------
DialogProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG ; сообщение о создании диал. окна
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; отправляет сообщение окну
         invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; сообщение окну по дескриптору органа управления
                STM_SETIMAGE,IMAGE_ICON,lParam
           ; 101 - jpg
        mov hStatic, rv(GetDlgItem,hWin,101)
        invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
          .case 103 ; кнопка
         rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
      .case 105
     ; invoke SetDlgItemText,hWin,102,ADDR szOff
      

        push    rbx
        push    rsi 
        push    rdi
        cmp     uMsg,WM_INITDIALOG
        je      wminitdialog
        cmp     uMsg,WM_COMMAND
        je      wmcommand
        cmp     uMsg,WM_CLOSE
        je      wmclose
        ; Пришло сообщение об изменении состояния съемного накопителя
        cmp     uMsg,WM_DEVICECHANGE
        je      update_usb
        xor     eax,eax
        jmp     finish

update_usb:
        ; Устройство подключено?
         invoke SetDlgItemText,hWin,102," Устройство подключено?"
        mov   rax,DBT_DEVICEARRIVAL
        cmp     wParam,rax
        je      usb_connected

        ; Устройство извлечено?
        invoke SetDlgItemText,hWin,102," Устройство извлечено?"
        mov     rax,DBT_DEVICEREMOVECOMPLETE
        cmp     wParam,rax
        je      usb_disconnected

        jmp     processed

        ; Обработка подключения устройства
usb_connected:
        ; Указатель на структуру DEV_BROADCAST
        mov     rsi,lParam
        ; Сообщение пришло от логического диска?
        ;cmp     dword [esi+event.dbch_devicetype],DBT_DEVTYP_VOLUME
        ;jne     processed

        ; Маска дисков
       ; mov     eax,[esi+event.dbcv_unitmask]

        ; Получить букву диска из маски
        bsr     eax,eax
        add     al,'A'

        ; AL - буква диска
        mov     drv1,al

        ; Записать строчку в лог
        invoke SetDlgItemText,hWin,102,ADDR szOn
        ;stdcall AddLog,[hWin],102,szOn
        jmp     processed

        ; Обработка отключения устройства
usb_disconnected:
        ; Указатель на структуру DEV_BROADCAST
        mov     rsi,lParam
        ; Сообщение пришло от логического диска?
       ; cmp     dword [esi+event.dbch_devicetype],DBT_DEVTYP_VOLUME
       ; jne     processed

        ; Маска дисков
       ; mov     eax,[esi+event.dbcv_unitmask]

        ; Буква диска присутствует?
        or      eax,eax
        jz      processed

        ; Получить букву диска из маски
        bsr     rax,rax
        add     al,'A'

        ; AL - буква диска
        mov     drv2,al

        ; Записать строчку в лог
         invoke SetDlgItemText,hWin,102,ADDR szOff
       ; stdcall AddLog,[hwnddlg],102,szOff
        jmp     processed

wminitdialog:
        jmp     processed
wmcommand:
        cmp     wParam,BN_CLICKED shl 16 + IDCANCEL
        je      wmclose
        jmp     processed

wmclose:
         rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;

processed:
        mov     eax,1
finish:
        pop     rdi
        pop     rsi 
        pop     rbx
     
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
DialogProc endp
    end
 