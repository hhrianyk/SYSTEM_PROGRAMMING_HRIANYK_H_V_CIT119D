include \masm64\include64\masm64rt.inc; библиотеки для подключения

 
DATE2 STRUCT              ; тип данных структура
  _Monitor   db 22 dup(?) ; назва
  _marka     db 15 dup(?) ; марка
  _modem     db 15 dup(?) ; модель
  _Diagonal  dq   ?       ; діагональ
  _Update    dq   ?       ;  
DATE2 ENDS        ; окончания данных СТРУКТУРА

.data             
Samsung DATE2 <"Монітор 24",   "Samsung " , "S24R350",24,75>      ; структура с именем ASUS
AOS     DATE2 <"Монітор 23", "АОС",      "24G2U/BK",23,144>      ; структура с именем HP
LG      DATE2 <"Монітор 27",   "LG",       "27GL83A-B",27,144>      ; структура с именем ACER 
ACER    DATE2 <"Монітор 36.6", "ACER",   "UM.UE2EE.A01",36.6,144>      ; структурас именем MSI

  a   dq 24;
_res1 dq  0;

title1 db "  СТРУКТУРИ. masm64", 0 
txt01  db"Задана послідовність структур.",10,
" Підрахувати кількість моніторів діагональ яких більше 24.",0
txt02 db "+-------------+----------+-------------+-----+------+",10,
"| Монітор       | Марка      | Модель       |Діаг.|Update|",10, 
"+-------------+----------+-------------+-----+------+",10,
"|Монітор 24   | Samsung | S24R350       | 24  | 75Гц |",10, 
"|Монітор 23.8| АОС         | 24G2U/BK    | 23  | 144Гц|",10, 
"|Монітор 27   | LG             |27GL83A-B| 27  | 144Гц|",10, 
"|Монітор 36.6| ACER        | UM.UE2EE.A0Z| 36.6| 144Гц|",10,\
"+-------------+----------+-------------+-----+------+",0


txt03 db "Кількість моніторів:  %d  ",0;Прибуток фірми
autor db"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 10 dup(?),0

       hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
   


  fName  BYTE "PR5.txt",0;файл для зберігання
fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 50 ;розмір файлу 

.code 				
entry_point proc

mov rax, Samsung._Diagonal ; загрузка адреса первой строки структуры
cmp rax, a
JNLE m1
inc _res1
m1:
mov rax, AOS._Diagonal ; загрузка адреса первой строки структуры
cmp rax, a
JNLE m2
m2: 
inc _res1
mov rax, LG._Diagonal ; загрузка адреса первой строки структуры
cmp rax, a
JNLE m3
inc _res1
m3:
mov rax, ACER._Diagonal ; загрузка адреса первой строки структуры
cmp rax, a
JNLE m4
inc _res1
m4:
invoke wsprintf,ADDR buf1,ADDR txt03,_res1

      mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,1000,0,ADDR main,hIcon
    invoke ExitProcess,0
    ret
entry_point endp

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
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
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR txt02,"Структура",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf1,"Результат  підрахунку",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
 
   invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10

           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf1,"Результат  підрахунку",MB_OK,10
          .case 116
          invoke MsgboxI,hWin,ADDR txt02,"Структура",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
               rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     .case 117    
      rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
     
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end

