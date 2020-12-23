 
include \masm64\include64\masm64rt.inc ; библиотеки

 
mDIV macro x, y ;; макрос с именем mSub
fld x ;; загрузка x
fld y ;; загрузка y
fdiv ;; x/y
endm ;; окончание макроса

.data ; 
a real4 1.7   ; операнд а1 размерностью 64 разряда константа 2
b real4 7.2   ; операнд b1 размерностью 64 разряда ;змзмінна  d 
const1 real4 16.16
const2 real4 3.0

tick1 dq 0;
tick2 dq 0;

res1 dd 0,0; операнд res1 размерностью 64 разряда; змінна результ

;Текст для MessageBox
title1 db " Mакроси. masm64",0
 
;Текст для window
txt01 db "Підрахувати кількість тіків виконання розвязування виразу: (16.16/a-b/16.16)/ab  із макросом та без макросу.",10,10,
"Змінні: a=1.7, b=7.2",0
txt02 db"Результат: %d",10,"Адрес змінної в памяти: %ph",0
txt03 db "Результат тіків з макросом: %d",10,"Результат тіків без макросу: %d",0
autor db"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 25 dup(0),0
buf2 dq 25 dup(0),0
 

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0


fName  BYTE "PR6.txt",0;файл для зберігання
fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 50 ;розмір файлу 
.code;cекция кода
entry_point proc



 fisttp res1
 ;movsxd  rax,res1

rdtsc 
xchg rdi,rax
finit ; инициализация FPU
;mov ecx,4;
mDIV [const1],[a]
mDIV [b],[const1]
fsub 
fdiv a
fmul b
 fisttp res1
 ;movsxd  rax,res1
 
 rdtsc ; получение числа тактов
sub rax,rdi ; вычитание из последнего числа тактов предыдущего числа
mov tick1,rax

rdtsc 
xchg rdi,rax
 finit ; инициализация FPU
;mov ecx,4;
fld const1
fld a
FDIV 
fld b
fld const1
fDIV  
fsub 
fdiv a
fmul b
 fisttp res1
 ;movsxd  rax,res1
 
  rdtsc ; получение числа тактов
sub rax,rdi ; вычитание из последнего числа тактов предыдущего числа
mov tick2,rax
        
     invoke wsprintf,ADDR buf1,ADDR txt02,res1,ADDR res1
     invoke wsprintf,ADDR buf2,ADDR txt03,tick1,tick2
      
 
    
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
          invoke MsgboxI,hWin,ADDR buf1,"Результат виразу:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf2,"Результат тіків:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
   invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10

           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf1,"Результат виразу:",MB_OK,10
          .case 116
          invoke MsgboxI,hWin,ADDR buf2,"Результат тіків:",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
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