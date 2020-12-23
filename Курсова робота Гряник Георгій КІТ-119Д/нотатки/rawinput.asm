;---------------------------------------------
; Raw Input Devices Demo
; Copyright (C) ManHunter / PCL
; http://www.manhunter.ru
;---------------------------------------------

format PE GUI 4.0
entry start

include 'win32a.inc'

;---------------------------------------------

struct RAWINPUTDEVICELIST
    hDevice dd ?
    dwType  dd ?
ends

struct RID_DEVICE_INFO_MOUSE
    dwId                dd ?
    dwNumberOfButtons   dd ?
    dwSampleRate        dd ?
    fHasHorizontalWheel dd ?
ends

struct RID_DEVICE_INFO_KEYBOARD
    dwType                 dd ?
    dwSubType              dd ?
    dwKeyboardMode         dd ?
    dwNumberOfFunctionKeys dd ?
    dwNumberOfIndicators   dd ?
    dwNumberOfKeysTotal    dd ?
ends

struct RID_DEVICE_INFO_HID
    dwVendorId      dd ?
    dwProductId     dd ?
    dwVersionNumber dd ?
    usUsagePage     dw ?
    usUsage         dw ?
ends

struct RID_DEVICE_INFO
    cbSize dd ?
    dwType dd ?
    union
        mouse    RID_DEVICE_INFO_MOUSE
        keyboard RID_DEVICE_INFO_KEYBOARD
        hid      RID_DEVICE_INFO_HID
    ends
ends

RIM_TYPEMOUSE    = 0
RIM_TYPEKEYBOARD = 1
RIM_TYPEHID      = 2

RIDI_DEVICENAME = 0x20000007
RIDI_DEVICEINFO = 0x2000000b

DIGCF_PRESENT      = 0x00000002
DIGCF_ALLCLASSES   = 0x00000004
SPDRP_DEVICEDESC   = 0x00000000
SPDRP_FRIENDLYNAME = 0x0000000C

struct SP_DEVINFO_DATA
    cbSize    dd ?
    ClassGuid rb 16
    DevInst   dd ?
    Reserved  dd ?
ends

section '.data' data readable writeable

riddi   RID_DEVICE_INFO

numDev  dd ?
pcbSize dd ?

align 4
ridl    rb 20*sizeof.RAWINPUTDEVICELIST
devname rb 200h
buff    rb 500h

instanceID rb 100h
szClass rb 100h
DeviceInstanceId rb 100h
PropertyBuffer rb 100h

hDevInfo dd ?

align 4
pspDevInfoData SP_DEVINFO_DATA

tmp dd ?

;---------------------------------------------

section '.code' code readable executable

  start:
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
        invoke  ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_INITDIALOG
        je      .wminitdialog
        cmp     [msg],WM_COMMAND
        je      .wmcommand
        cmp     [msg],WM_CLOSE
        je      .wmclose
        xor     eax,eax
        jmp     .finish

.wminitdialog:
        ; Получить количество устройств ввода
        invoke  GetRawInputDeviceList,NULL,numDev,sizeof.RAWINPUTDEVICELIST
        or      eax,eax
        jnz     .processed

        ; Получить список устройств ввода
        invoke  GetRawInputDeviceList,ridl,numDev,sizeof.RAWINPUTDEVICELIST

        mov     esi,ridl
        mov     ebx,[numDev]
.loc_loop:
        ; RAWINPUTDEVICELIST.hDevice
        lodsd
        push    eax
        ; Имя устройства
        mov     [pcbSize],200h
        invoke  GetRawInputDeviceInfo,eax,RIDI_DEVICENAME,devname,pcbSize

        ; Преобразовать строку имени устройства из вида
        ; \\?\HID#VID_0D9F&PID_00A6#6&166ed471&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}
        ; в Instance ID вида
        ; HID\VID_0D9F&PID_00A6\6&166ed471&0&0000
        push    esi
        mov     esi,devname
        mov     edi,instanceID
@@:
        lodsb
        cmp     al,'\'
        je      @b
        cmp     al,'?'
        je      @b
        dec     esi

        ; Тут дополнительно формируется юникодная строка класса устройства
        xor     ecx,ecx
        xor     eax,eax
@@:
        lodsb
        cmp     al,'#'
        je      @f
        stosb
        mov     word [szClass+ecx],ax
        inc     ecx
        inc     ecx
        jmp     @b
@@:
        mov     word [szClass+ecx],0

        mov     al,'\'
        stosb
@@:
        lodsb
        cmp     al,'#'
        je      @f
        stosb
        jmp     @b
@@:
        mov     al,'\'
        stosb
@@:
        lodsb
        cmp     al,'#'
        je      @f
        stosb
        jmp     @b
@@:
        mov     al,0
        stosb

        ; Получить хэндл списка устройств этого класса
        invoke  SetupDiGetClassDevs,NULL,szClass,NULL,DIGCF_ALLCLASSES+DIGCF_PRESENT
        mov     [hDevInfo],eax

        push    ebx
        xor     ebx,ebx
.loc_enum_devs:
        ; Получить информацию о следующем устройстве этого класса
        mov     [pspDevInfoData.cbSize],sizeof.SP_DEVINFO_DATA
        invoke  SetupDiEnumDeviceInfo,[hDevInfo],ebx,pspDevInfoData
        or      eax,eax
        jz      .no_more_devs
        invoke  SetupDiGetDeviceInstanceId,[hDevInfo], pspDevInfoData, DeviceInstanceId, 100h, tmp

        ; InstanceId устройства соответствует нашему устройству?
        invoke  lstrcmpi,instanceID,DeviceInstanceId
        or      eax,eax
        jnz     .loc_next_device

        ; Получить человекопонятное название устройства
        invoke  SetupDiGetDeviceRegistryProperty,[hDevInfo],\
                pspDevInfoData,SPDRP_FRIENDLYNAME,NULL,\
                PropertyBuffer,100h,tmp
        or      eax,eax
        jnz     .no_more_devs

        ; Получить описание устройства
        invoke  SetupDiGetDeviceRegistryProperty,[hDevInfo],\
                pspDevInfoData,SPDRP_DEVICEDESC,NULL,\
                PropertyBuffer,100h,tmp
        or      eax,eax
        jnz     @f
        ; Никакого названия не найдено, записать в строку "Unknown"
        invoke  lstrcpy,PropertyBuffer,szUnknown
@@:
        jmp     .no_more_devs

.loc_next_device:
        inc     ebx
        jmp     .loc_enum_devs

.no_more_devs:
        ; Прибраться за собой
        invoke  SetupDiDestroyDeviceInfoList,[hDevInfo]

        pop     ebx
        pop     esi
        pop     eax

        push    eax
        ; Информация об устройстве
        mov     [pcbSize],sizeof.RID_DEVICE_INFO
        invoke  GetRawInputDeviceInfo,eax,RIDI_DEVICEINFO,riddi,pcbSize
        pop     eax

        ; Mouse
        cmp     [riddi.dwType],RIM_TYPEMOUSE
        jne     @f
        invoke  wsprintf,buff,mask0,devname,eax,[riddi.mouse.dwNumberOfButtons],\
                [riddi.mouse.dwSampleRate],[riddi.mouse.fHasHorizontalWheel],PropertyBuffer
        add     esp,32
        jmp     .loc_log
@@:
        ; Keyboard
        cmp     [riddi.dwType],RIM_TYPEKEYBOARD
        jne     @f
        invoke  wsprintf,buff,mask1,devname,eax,[riddi.keyboard.dwKeyboardMode],\
                [riddi.keyboard.dwNumberOfFunctionKeys],\
                [riddi.keyboard.dwNumberOfIndicators],\
                [riddi.keyboard.dwNumberOfKeysTotal],PropertyBuffer
        add     esp,36
        jmp     .loc_log
@@:
        ; HID
        invoke  wsprintf,buff,mask2,devname,eax,[riddi.hid.dwVendorId],\
                [riddi.hid.dwProductId],[riddi.hid.dwVersionNumber],PropertyBuffer
        add     esp,32
.loc_log:
        stdcall AddLog,[hwnddlg],ID_LOG,buff
        lodsd
        dec     ebx
        jnz     .loc_loop
        jmp     .processed

.wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDCANCEL
        je      .wmclose
        jmp     .processed

.wmclose:
        invoke  EndDialog,[hwnddlg],0

.processed:
        mov     eax,1

.finish:
        pop     edi esi ebx
        ret
endp

mask0 db 'Mouse: %s',13,10,'hDevice = %.8Xh',13,10,'NumberOfButtons = %u',13,10,'SampleRate = %u',13,10,'HasHorizontalWheel = %u',13,10,'Description = %s',13,10,13,10,0
mask1 db 'Keyboard: %s',13,10,'hDevice = %.8Xh',13,10,'KeyboardMode = %u',13,10,'NumberOfFunctionKeys = %u',13,10,'NumberOfIndicators = %u',13,10,'NumberOfKeysTotal = %u',13,10,'Description = %s',13,10,13,10,0
mask2 db 'HID: %s',13,10,'hDevice = %.8Xh',13,10,'VendorId = %u',13,10,'ProductId = %u',13,10,'VersionNumber = %u',13,10,'Description = %s',13,10,13,10,0
szUnknown db 'Unknown',0

;---------------------------------------------
; procedure AddLog
; void AddLog(hWnd:dword,CtrlID:dword,&string)
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

  library kernel32,'kernel32.dll',\
          user32,'user32.dll',\
          user33,'user32.dll',\
          setupapi,'setupapi.dll'

  ;include 'apia\kernel32.inc'
  ;include 'apia\user32.inc'

import user33,GetRawInputDeviceList,'GetRawInputDeviceList',\
        GetRawInputDeviceInfo,'GetRawInputDeviceInfoA'

import setupapi,SetupDiGetClassDevs,'SetupDiGetClassDevsW',\
        SetupDiEnumDeviceInfo,'SetupDiEnumDeviceInfo',\
        SetupDiGetDeviceInstanceId,'SetupDiGetDeviceInstanceIdA',\
        SetupDiGetDeviceRegistryProperty,'SetupDiGetDeviceRegistryPropertyA',\
        SetupDiDestroyDeviceInfoList,'SetupDiDestroyDeviceInfoList'

;---------------------------------------------

section '.rsrc' resource data readable

  directory RT_DIALOG,dialogs

  resource dialogs,\
           37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  ID_LOG = 100

  dialog demonstration,'Raw Input Devices Demo',0,0,260,200,WS_CAPTION+WS_SYSMENU+DS_CENTER+DS_SYSMODAL
    dialogitem 'EDIT','',ID_LOG,6,5,247,175,WS_VISIBLE+ES_LEFT+ES_MULTILINE+ES_AUTOVSCROLL+ES_READONLY+WS_BORDER+WS_VSCROLL
    dialogitem 'BUTTON','Exit',IDCANCEL,110,182,50,15,WS_VISIBLE+WS_TABSTOP+BS_PUSHBUTTON
  enddialog
