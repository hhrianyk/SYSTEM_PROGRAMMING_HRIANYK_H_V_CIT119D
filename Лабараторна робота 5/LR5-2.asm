 
include \masm64\include64\masm64rt.inc ; библиотеки


fpuDiv macro _a,_b,_c ; макрос с именем fpuDiv
mov rax,_b
mul _c
mov rbx,_a
sub rbx ,rax
mov rax,rbx

endm ;; окончание макроса

.data ; 
 a1 dq 2 
 b1 dq 8 
 c1 dq 5 
 d1 dq 3 

 arr1 dw 1,2,3,44,4,32,53,21,14,51,51,13,13,14,15,13,5,23,13,23,14,53,52,23,64,63,63,23,52,64 ; массив чисел arr1 размером в слово
 len1 equ ($-arr1)/type arr1 ; количество чисел массива
 arr2 dw 5,6,7,2,3,31,12,21,4,1,5,3,43,54,3,83,15,53,73,83,54,13,42,63,74,13,3,2,2,4  ; массив чисел arr2 размером в слово
 arr1_2 dq len1 dup(0) ; количество чисел массива результата
 _res dq 1 ; операнд res1 размерностью 64 разряда; змінна результ
 
 

;Текст для MessageBox
title1 db "Лаб.5-2 MMX команди masm64",0


textM db "Третє число менше 15",0
textB db "Третє число більше 15",0
buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0



;Текст для window
txt01 db "Виконати операції рхоr (xor) по модулю для цілих чисел 2-х масивів.",10,"Якщо трете число менше 15, то виконати операцію",10,
"(b – dс)/a – с, де a, b, c, d – дійсні числа;",10,
"інакше - виконати операцію b - dс.",10,10,
"Змінні: a=%d, b=%d, c=%d, d=%d",0
txt02 db "%s",0
txt03 db "Результат: %d",10,"Адрес змінної в памяти: %ph",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0


      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;вихідний файл
fName  BYTE "Res_LR5-2.txt",0;файл для зберігання
fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 27;розмір файлу 

.code;cекция кода
entry_point proc
 mov rbp,rsp
 movq MM1,QWORD PTR arr1 ; загрузка массива чисел arr1
 movq MM2,QWORD PTR arr2 ; загрузка массива чисел arr2
 pxor  MM1,MM2 ; параллельное циклическое сложение
 movq QWORD PTR arr1_2,MM1 ; сохранение результата
pextrw eax,MM1,3 ; 

cmp eax,15 ; сравнение
jg m1 ; if >
jmp m2
m1:
fpuDiv [b1],[c1],[d1]
 mov rdx,0
 div  a1
 sub rax,c1
mov _res,rax ; сохранение целочисленного значения  


invoke wsprintf,ADDR buf2,ADDR txt02, ADDR textB
jmp m3
m2: emms
 fpuDiv [b1],[c1],[d1]
mov _res,rax ; сохранение целочисленного значения 


invoke wsprintf,ADDR buf2,ADDR txt02, ADDR textM
m3:

        ;Створення Message
     invoke wsprintf,ADDR buf1,ADDR txt01,a1,b1,c1,d1
       invoke wsprintf,ADDR buf3,ADDR txt03,_res,ADDR _res

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
           ; 102 - jpg
        mov hStatic, rv(GetDlgItem,hWin,101)
        invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; сообщение от меню или кнопки
        .switch wParam
          .case 103 ; кнопка
          invoke MsgboxI,hWin,ADDR buf1,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf3,"Результат:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0

           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR buf1,"Завдання",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
          invoke MsgboxI,hWin,ADDR buf3,"Результат:",MB_OK,10

          .case 115
     invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
              rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
              
        .endsw
      .case WM_CLOSE ; если есть сообщение о закрытии окна
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
main endp
    end