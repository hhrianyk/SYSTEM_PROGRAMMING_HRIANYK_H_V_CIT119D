    .686               ; директива визначення типу мікропроцесора
.model  flat, stdcall  ; завдання лінійної моделі пам’яті та угоди ОС Windows
   option casemap:none        ; відмінність малих та великих  літер
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32, comctl32
    IDD_DLG1 equ 1000    
    DlgProc  PROTO :DWORD,:DWORD,:DWORD,:DWORD ; прототип проц.
.data
  hInstance dd ?
  hWnd dd ?
  icce INITCOMMONCONTROLSEX <>
.code    
start:
   mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX ; розмір структури, в байтах
    invoke InitCommonControlsEx, offset icce ;реєструє класи стандартного органу управління
    invoke GetModuleHandle, NULL
    mov hInstance, eax
 invoke DialogBoxParam, hInstance,\;дескриптор екземпляра програми 
      IDD_DLG1,\;ідентифікує шаблон блоку діалогу  
       0,\;дескриптор вікна власника
        offset DlgProc, 0 ;покажчик на процедуру діал. вікна та LPARAM
     invoke ExitProcess,eax
    
DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
    .if uMsg == WM_INITDIALOG
invoke SendMessage, hWin, WM_SETICON, 1, FUNC(LoadIcon, NULL, IDI_ASTERISK)
invoke AnimateWindow,hWin,500,AW_ACTIVATE or AW_BLEND

invoke SetFocus,hWin
    .elseif uMsg == WM_COMMAND
    .elseif uMsg == WM_CLOSE
invoke AnimateWindow,hWin,500,AW_HIDE or AW_BLEND
invoke EndDialog,hWin,NULL
    .endif
        mov eax,FALSE
 ret
 DlgProc endp
end start
