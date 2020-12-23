 
include \masm64\include64\masm64rt.inc ; библиотеки
.data ; 
 mas1 db  'Do not bite the hand that feeds you ' ; массив байтов с символами кода ASCII
 len1 equ $-mas1     ; определение количества байтов в массиве mas1
 poz dq 0; індекс елементу
 

;Текст для MessageBox
title1 db "Лаб.5-1 Рядкові команди masm64",0

buf1 dq 35 dup(0),0
buf2 dq 25 dup(0),0


;Текст для window
txt01  db "Заданий текст з 8 слів з різною кількістю символів.",10," У словах з парним номером змінити порядок букв на зворотний.",10,10,
"Текст: Do not bite the hand that feeds you",10,10,
"У словах з парним номером змінити порядок букв на зворотний.",0
txt02 db "Результат: %s",10,"Адрес змінної в памяти: %ph",0
txt04 db "Результат: %s  ",0
txt05 db "Адрес змінної в памяти: %ph",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0

;params MSGBOXPARAMSA <>

      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;вихідний файл
fName  BYTE "Res_LR5-1.txt",0;файл для зберігання
fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 47;розмір файлу 


.code;cекция кода
entry_point proc
mov poz,0; 
lea rdi,mas1
mov rcx,len1 ; установить в счетчик max значение букв
mov esi,0
mov edx,0

jnz m1 
m2:
mov rax,len1
sub rax,rcx
;sub rax,poz
 dec rax   ;счётчик словa

mov rbx,poz
dec rbx
 m3:
 mov  dl, mas1[rax] 
 mov  dh, mas1[rbx]
 mov mas1[rax],dh
 mov mas1[rbx],dl

inc rbx
cmp rbx,rax
jz m4
dec rax
cmp rbx,rax
jz m4

jnz m3
m1: 
enter 38,0 ; создает кадр стека: кол. байт и уровень вложенности
mov rax, ' ' 
repne scasb	     ; повторять, пока не будет равняться

inc r10

   TEST r10, 1
    JZ  m2   	;четное, переход на метку m2
 m4:  
 
mov poz,len1
sub poz,rcx

cmp rcx,0
jnz m1 

        ;Створення MessageBox
      invoke wsprintf,ADDR buf1,ADDR txt02, ADDR mas1,ADDR mas1
     ;invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION

      invoke wsprintf,ADDR buf2,ADDR txt04,ADDR mas1
      invoke wsprintf,ADDR txt04,ADDR txt05,ADDR mas1  

    mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     mov hBmp, rv(ResImageLoad,20)
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
           ; 102 - jpg
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
          invoke MsgboxI,hWin,ADDR buf1,"Результат:",MB_OK,10
          .case 107
               invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
               mov fHandle, rax;відкрити та записа данні файла
               invoke WriteFile,fHandle,ADDR buf2,BSIZE ,ADDR cWritten,0
               invoke CloseHandle,fHandle
                         .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR txt01,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 111
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 113
          invoke MsgboxI,hWin,ADDR buf1,"Результат:",MB_OK,10
          .case 115
               invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
               mov fHandle, rax;відкрити та записа данні файла
               invoke WriteFile,fHandle,ADDR buf2,BSIZE ,ADDR cWritten,0
               invoke CloseHandle,fHandle
              rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
              
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end
