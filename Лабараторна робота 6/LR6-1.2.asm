 
include \masm64\include64\masm64rt.inc ; библиотеки


.data ; 


 mas1 dd 3.,1.,11.,1.,0.,5.,15.,1.,0.,9.,0.,0.0  ; массив чисел arr1 размером в слово
 len1 equ ($-mas1)/type mas1 ; количество чисел массива
 mas1_2 dd  len1 dup(0)
 mas2 dd 5., 3.,0.,4.,83.,0.,2.,3.,4.,3.,0.,0.  ; массив чисел arr2 размером в слово
 mas2_2 dd  len1 dup(0) ; количество чисел массива результата
 _res dd 0. ; операнд res1 размерностью 64 разряда; змінна результ
  a  DD  82.0 ;
 

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
txt05 db "Більше 100",0
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
 
m1:  vmovups ymm0,[rsi] ; перемещение упакованных чисел одинарной точности
vmovups ymm1,[rdi]   ;
vmulps ymm2,ymm0,ymm1;
vmovups [rbx],ymm2   ; перемещение в память по адресу регистра rbx
add rdi,32    ; 32 х 8 = 256
add rsi,32    ; смещение на 256
add rbx,32    ; смещение на 32 байта = 256
 
mov rcx,rdx ; занесение остатка в счетчик
  
 vmovss xmm3,dword ptr [rsi+4]   ; занесение элемента mas1
 vmulps XMM3,XMM3,dword ptr [rdi+4] ; сложение с элементом mas2
 vmovss dword ptr [rbx+4],XMM3 ; сохранение в r1
  vmovss xmm3,dword ptr [rsi+8]   ; занесение элемента mas1
 vmulps XMM3,XMM3,dword ptr [rdi+8] ; сложение с элементом mas2
 vmovss dword ptr [rbx+8],XMM3 ; сохранение в r1  

lea rbx, mas1_2

 vmovss xmm3, dword ptr [rbx]        ; 
 vaddss  XMM3,XMM3,dword ptr [rbx+4]
 vaddss  XMM3,XMM3,dword ptr [rbx+8]
 vaddss  XMM3,XMM3,dword ptr [rbx+12]
 vaddss  XMM3,XMM3,dword ptr [rbx+16]
 vaddss  XMM3,XMM3,dword ptr [rbx+20]
 vaddss  XMM3,XMM3,dword ptr [rbx+24]
 vaddss  XMM3,XMM3,dword ptr [rbx+28]
 vaddss  XMM3,XMM3,dword ptr [rbx+32]
 vaddss  XMM3,XMM3,dword ptr [rbx+36]
 vaddss  XMM3,XMM3,dword ptr [rbx+40] 
 vmovss dword ptr a,XMM3
  cvttss2si eax,xmm3 
 movsxd r15,eax 
invoke wsprintf,ADDR buf2,ADDR txt02,ADDR txt06
invoke wsprintf,ADDR buf4, ADDR txt04
 
   cmp r15,100
   JNGE EXIT
  
   
    
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