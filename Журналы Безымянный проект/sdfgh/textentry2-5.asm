 include \masm64\include64\masm64rt.inc
.data?
      hInstance dq ? ; хэндл окна
      hIcon     dq ? ; хэндл иконки
      hImg1     dq ? ; хэндл рисунка
      tEdit     dq ? ; хэндл окна ввода
	  buffer BYTE 260 dup(?) ;;; для хранения текста
.data
	  pbuf dq buffer ;;; для MessageBox,т.к.не используется ADDR
rus db  'Russian_Russia.866',0      ; русская локаль

.code
entry_point proc
mov hInstance, rvcall(GetModuleHandle,0); хэндл исполняемого модуля (гл.окна)
mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,128,128, LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon
  .exit
entry_point endp

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG
rcall SendMessage,hWin,WM_SETICON,1,lParam ; установить иконку в строке заголовка
 mov hImg1,rvcall(GetDlgItem,hWin,102); извлекает дескриптор органа управления в заданном диал. окне
rcall SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области
      .case WM_COMMAND
        .switch wParam
          .case 103    ; кнопка <Ввод текста>
mov hIcon,rv(LoadImage,hInstance,11,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,200,0,ADDR GetUserText,hIcon
       test rax, rax  ; нажата ли кнопка отмены
       jz notext
rcall MessageBox,hWin,pbuf,"Пользовательский текст", MB_ICONQUESTION
notext:
          .case 101   ; кнопка <Close>
            jmp exit_dialog  
        .endsw
      .case WM_CLOSE
exit_dialog:
        rcall EndDialog,hWin,0
    .endsw
    xor rax, rax
    ret
main endp

GetUserText proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG ; SendMessage отправляет заданное сообщение окну
rcall SendMessage,hWin,WM_SETICON,1,lParam ; иконка в строке заголовка 
  mov hImg1, rvcall(GetDlgItem,hWin,205); извлекает дескриптор
rcall SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; иконка в клиентской области
  mov tEdit, rvcall(GetDlgItem,hWin,201)
invoke SetFocus, tEdit ; установка курсора в поле ввода 
  .case WM_COMMAND
.switch wParam
   .case 202
rcall GetWindowText,tEdit,pbuf,sizeof buffer; записать текст по адресу буфера
            .if rax == 0
rcall MessageBox,hWin,"Введите текст или нажмите Cancel","Текст отсутствует", MB_ICONWARNING
 rcall SetFocus,tEdit ; установка фокуса на окно Edit
            .else
              rcall EndDialog,hWin, 1 
            .endif
   .case 203
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
