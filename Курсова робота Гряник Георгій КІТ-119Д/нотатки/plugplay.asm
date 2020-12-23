;---------------------------------------------
; USB Plug'n'Play Demo
; Copyright (C) ManHunter / PCL
; http://www.manhunter.ru
;---------------------------------------------

format PE GUI 4.0
entry start

include 'win32a.inc'

ID_TXT = 101

;---------------------------------------------

section '.data' data readable writeable

szOn    db 'USB drive '
drv1    db 'X: connected',13,10,0

szOff   db 'USB drive '
drv2    db 'X: removed',13,10,0

DBT_DEVICEARRIVAL        = 0x8000
DBT_DEVICEREMOVECOMPLETE = 0x8004

DBT_DEVTYP_VOLUME        = 0x00000002

struct DEV_BROADCAST
        ; Заголовок структуры
        dbch_size       dd ?
        dbch_devicetype dd ?
        dbch_reserved   dd ?

        ; Информационная часть структуры
        dbcv_unitmask   dd ?
        dbcv_flags      dd ?
ends

; Виртуальная проекция структуры DEV_BROADCAST
virtual at 0
event   DEV_BROADCAST
end     virtual

;---------------------------------------------

section '.code' code readable executable

  start:
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
        invoke  ExitProcess,0

;---------------------------------------------

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_INITDIALOG
        je      wminitdialog
        cmp     [msg],WM_COMMAND
        je      wmcommand
        cmp     [msg],WM_CLOSE
        je      wmclose
        ; Пришло сообщение об изменении состояния съемного накопителя
        cmp     [msg],WM_DEVICECHANGE
        je      update_usb
        xor     eax,eax
        jmp     finish

update_usb:
        ; Устройство подключено?
        cmp     [wparam],DBT_DEVICEARRIVAL
        je      usb_connected

        ; Устройство извлечено?
        cmp     [wparam],DBT_DEVICEREMOVECOMPLETE
        je      usb_disconnected

        jmp     processed

        ; Обработка подключения устройства
usb_connected:
        ; Указатель на структуру DEV_BROADCAST
        mov     esi,[lparam]
        ; Сообщение пришло от логического диска?
        cmp     dword [esi+event.dbch_devicetype],DBT_DEVTYP_VOLUME
        jne     processed

        ; Маска дисков
        mov     eax,[esi+event.dbcv_unitmask]

        ; Получить букву диска из маски
        bsr     eax,eax
        add     al,'A'

        ; AL - буква диска
        mov     byte [drv1],al

        ; Записать строчку в лог
        stdcall AddLog,[hwnddlg],ID_TXT,szOn
        jmp     processed

        ; Обработка отключения устройства
usb_disconnected:
        ; Указатель на структуру DEV_BROADCAST
        mov     esi,[lparam]
        ; Сообщение пришло от логического диска?
        cmp     dword [esi+event.dbch_devicetype],DBT_DEVTYP_VOLUME
        jne     processed

        ; Маска дисков
        mov     eax,[esi+event.dbcv_unitmask]

        ; Буква диска присутствует?
        or      eax,eax
        jz      processed

        ; Получить букву диска из маски
        bsr     eax,eax
        add     al,'A'

        ; AL - буква диска
        mov     byte [drv2],al

        ; Записать строчку в лог
        stdcall AddLog,[hwnddlg],ID_TXT,szOff
        jmp     processed

wminitdialog:
        jmp     processed
wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDCANCEL
        je      wmclose
        jmp     processed

wmclose:
        invoke  EndDialog,[hwnddlg],0
processed:
        mov     eax,1
finish:
        pop     edi esi ebx
        ret
endp

;---------------------------------------------

proc    AddLog  hWnd:dword,CtrlID:dword,pStr:dword
        push    eax
        invoke  GetDlgItem,[hWnd],[CtrlID]
        or      eax,eax
        jz      .AddLog_1
        mov     [CtrlID],eax
        invoke  SendMessage,[CtrlID],EM_GETLINECOUNT,0,0
        dec     eax
        invoke  SendMessage,[CtrlID],EM_LINEINDEX,eax,0
        invoke  SendMessage,[CtrlID],EM_SETSEL,eax,eax
        invoke  SendMessage,[CtrlID],EM_REPLACESEL,FALSE,[pStr]
.AddLog_1:
        pop     eax
        ret
endp

;---------------------------------------------

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
          user32,'USER32.DLL'

  include 'apia\kernel32.inc'
  include 'apia\user32.inc'

;---------------------------------------------

section '.rsrc' resource data readable

  directory RT_DIALOG,dialogs

  resource dialogs,\
           37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  dialog demonstration,"Plug'n'Play Demo",0,0,180,160,WS_CAPTION+DS_CENTER+WS_POPUP+WS_SYSMENU+DS_MODALFRAME+DS_SYSMODAL
    dialogitem 'EDIT','',ID_TXT,5,5,170,130,WS_VISIBLE+WS_BORDER+ES_READONLY+ES_MULTILINE+WS_VSCROLL+WS_HSCROLL
    dialogitem 'BUTTON','Exit',IDCANCEL,130,140,45,15,WS_VISIBLE+WS_TABSTOP+BS_PUSHBUTTON
  enddialog