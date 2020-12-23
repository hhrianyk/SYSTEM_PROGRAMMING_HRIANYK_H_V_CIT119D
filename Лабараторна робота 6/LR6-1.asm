 
include \masm64\include64\masm64rt.inc ; библиотеки


.data ; 

 mas1 dd 3.,1.,11.,1.,0.,5.,15.,1.,0.,9.,0.,0.  ; массив чисел arr1 размером в слово
 len1 equ ($-mas1)/type mas1 ; количество чисел массива
 mas2 dd 5., 3.,0.,4.,83.,0.,2.,3.,4.,3.,0.,0.  ; массив чисел arr2 размером в слово
 mas1_2 dd  len1 dup(0) ; количество чисел массива результата
 _res dd 0. ; операнд res1 размерностью 64 разряда; змінна результ
 a  DD  100.0 ;
;Текст для MessageBox
title1 db "Лаб.6-1 SSE and AVX masm64",0

buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0
buf4 dq 25 dup(0),0

;Текст для window
txt01 db "Виконати операцію паралельного логічного множення 2-х масивів по 10-ть 64-розрядних дійсних чисел. Скласти всi результати. Якщо сума всіх отриманих чисел більше 100, то виконати обчислення квадратного кореня, а якщо навпаки - не виконувати.",0
txt02 db "Сума всіx чисел: %s",0
txt03 db "Результат обчислення квадратного кореня: %d",0
txt04 db "За умовою корінь добувати неможна",0
autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0
txt05 db "Більше 100 ",0
txt06 db "Менше 100",0
txt07 db "Корінь: %d",0
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;вихідний файл
fNameS  BYTE "Res_LR6-1S.txt",0;файл для зберігання
fNameA  BYTE "Res_LR6-1A.txt",0;файл для зберігання

fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 27;розмір файлу 

.code;cекция кода
entry_point proc
 
  
 lea rsi, mas1 ; занесення адреси масиву mas1 в rsi
 lea rdi, mas2 ; занесення адреси масиву mas2 в rdi
 lea rbx, mas1_2
 
movups XMM0,[rsi] ;mas1  ; 
movups XMM1,[rdi] ;mas2  ; 
 
mulps xmm1,xmm0 
;movupd xmmword ptr mas1_2,xmm1

 movups XMM2,[rsi+16] ;mas1  ; 
movups XMM3,[rdi+16] ;mas2  ; 
mulps xmm3,xmm2

movups XMM4,[rsi+32] ;mas1  ; 
movups XMM5,[rdi+32] ;mas2  ; 
mulps xmm5,xmm4 

addps xmm1,xmm3
addps xmm1,xmm5

movupd xmmword ptr mas1_2,xmm1

movups XMM0,mas1_2 
 movaps XMM1,XMM0          ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
movupd xmmword ptr a,xmm0
 cvttss2si eax,xmm0 
 movsxd r15,eax 
invoke wsprintf,ADDR buf2,ADDR txt02,ADDR txt06
invoke wsprintf,ADDR buf4,ADDR txt04

    cmp r15,100
    JNGE EXIT
   
     lea r15,a
    
    MOVUPS XMM5, a   
    SQRTSS xmm6, xmm5 
   cvttss2si rdi,xmm6 
 
 

 invoke wsprintf,ADDR buf2,ADDR txt02, ADDR txt05
 invoke wsprintf,ADDR buf4,ADDR txt07, rdi
EXIT:
        ;Створення Message
       invoke wsprintf,ADDR buf1,ADDR txt01 
       invoke wsprintf,ADDR buf3,ADDR txt03,r15 

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
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 106
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
             invoke MsgboxI,hWin,ADDR buf4,"Корінь:",MB_OK,10
          .case 107
      invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
  invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
  invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10
 
           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR buf1,"Завдання",MB_OK,10
                   .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
          .case 116
           invoke MsgboxI,hWin,ADDR buf4,"Корінь:",MB_OK,10

      .case 115
     invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
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