 
include \masm64\include64\masm64rt.inc ; библиотеки


.data ; 

 mas1 dw 3  ,1 ,11 ,1 ,0 ,5 ,15 ,1    ;  
 
 mas2 dw 5  , 3 ,0 ,4 ,83 ,0 ,2 ,3    ; 
 len1 EQU (LENGTHOF mas2) ; количество элементов в массиве 
 sum dw len1 DUP(0),0
 sum2 dw len1 DUP(0),0 
 
 mas3 dd   3.0  ,1.0 ,11.0 ,1.0 ,5. ,5. ,15. ,1.    ;  
 mas4 real8 12.0, 4.0, 6.0, 37.0  



;Текст для MessageBox
title1 db "PR 7",0

buf1 dq 55 dup(0),0
buf2 dq 25 dup(0),0
buf3 dq 25 dup(0),0
buf4 dq 25 dup(0),0

;Текст для window
txt01 db "Виконати особисті математичні обчислення в кожного мультимедійного розширення",0
txt01_1 db "Задано два масива, допомогою команд MMX  вибрати із кожної пари більше значення",0
txt01_2 db "Порахувати суму чисел масиву",0
txt01_3 db "Вирішит вираз  ",0

txt02_1 db "Результат: ",len1 dup("%d "),0
txt02_2 db "Сума всіx чисел: %d",0
txt02_3 db "Результат: -2",0


txt03_1 db "Масиви: ",10, "3, 1, 11, 1, 0, 5, 15, 1",10,  "5, 3, 0, 4, 83, 0, 2, 3",0
txt03_2 db "Масив:  3  ,1  ,11  ,1  ,5  ,5 ,15 ,1 ,0",0
txt03_3 db "Вираз:  SQRT(a+b)-d/c",0

autor db "Автор: Гряник Г.В., гр.КІТ-119Д",0
 
      hInstance dq ? ; дескриптор програми
      hWnd      dq ? ; дескриптор окна
      hIcon     dq ? ; дескриптор иконки
      hBmp      dq ?
      hStatic   dq ?
    classname db "template_class",0
 
;вихідний файл
fNameM  BYTE "PR7_M.txt",0;файл для зберігання
fNameS  BYTE "PR7_S.txt",0;файл для зберігання
fNameA  BYTE "PR7_A.txt",0;файл для зберігання

fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 27;розмір файлу 

.code;cекция кода
entry_point proc
 mov rax,len1 ; счетчик чисел 
mov rbx,4    ; кол. чисел в 64 разрядах
xor rdx,rdx ; подготовка к делению
div rbx     ; определение уол. циклов и остатка
mov rcx,rax  ; кол. циклов в счетчике
lea rsi,mas1 ; 
lea rdi,mas2 ;
lea rbx,sum  ; адрес хранения результата
@@:
movq MM0,qword ptr[rsi] ; загрузка чисел mas1
movq MM1,qword ptr[rdi] ; загрузка чисел mas2
pmaxsw   MM0,MM1         ; 
movq qword ptr[rbx],MM0 ;
add rsi,8 ; адр. начала следующего цикла
add rdi,8 ; 
add rbx,8 ;
  loop @b 

 cmp rdx,0  ; определение остатка необработанных элементов массивов
 jz  exit   ; если элементы закончились, то перейти на exit
 mov rcx,rdx ; занесение в счетчик количества необработанных чисел
m2:  mov ax,word ptr [rsi] ; занесение необработанного элемента из mas1
 add  ax,word ptr [rdi]        ; сложение элементов двух массивов
 mov  word ptr [rbx],ax      ; результат
 add rsi,2     ; подготовка к выборке элемента из mas1
 add rdi,2     ; подготовка к выборке элемента из mas2
 add rbx,2     ; подготовка к записи результата в память
 loop m2       ; ecx := ecx – 1 и переход, если ecx /= 0
 exit:
  
movzx rsi,sum
movzx rdi,sum[2]
movzx r10,sum[4]
movzx r11,sum[6]
movzx r12,sum[8]
movzx r13,sum[10]
movzx r14,sum[12]
movzx r15,sum[14]

invoke wsprintf,ADDR buf1,ADDR txt02_1,rsi,rdi,r10,r11,r12,r13,r14,r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lea rsi, mas3 ; занесення адреси масиву mas1 в rsi
movups XMM0,[rsi] ;
movups XMM1,[rsi+16] ;
addps xmm0,xmm1
 movaps XMM1,XMM0          ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
shufps XMM1,XMM1,11111001b ;  
addss XMM0,XMM1            ;  
cvttss2si eax,xmm0 
movsxd r15,eax 
invoke wsprintf,ADDR buf2,ADDR txt02_2,r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov rcx,4
 
lea rbx,mas4
 
	vmovsd xmm1,real8 ptr [rbx]  ; xmm1 - b - переслать двойное слово
      vmovsd xmm2,real8 ptr [rbx+8];
      vaddsd xmm1,xmm2,xmm1 
      SQRTSD xmm1,xmm1
      vmovsd xmm3, real8 ptr [rbx+16]
      vmovsd xmm4,real8 ptr [rbx+24]
      vdivsd xmm3, xmm3,xmm4
      vsubsd xmm1,xmm1,xmm3
      cvttss2si eax,xmm2 
      movsxd r15,eax 

     invoke wsprintf,ADDR buf3,ADDR txt02_3,r15
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
          invoke MsgboxI,hWin,ADDR txt01_2,"Завдання",MB_OK,10
          invoke MsgboxI,hWin,ADDR txt03_2,"Масив",MB_OK,10
         ;rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 105
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 106
          
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
 
          .case 107
      invoke CreateFile,ADDR fNameS,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла
  invoke WriteFile,fHandle,ADDR buf2 ,BSIZE ,ADDR cWritten,0
 
  invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10
           .case 1001
           invoke MsgboxI,hWin,ADDR txt01_1,"Завдання",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_1,"Масив",MB_OK,10
           .case 1002
            invoke MsgboxI,hWin,ADDR buf1,"Результат",MB_OK,10
           .case 1003
             invoke CreateFile,ADDR fNameM,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
             mov fHandle, rax;відкрити та записа данні файла
            invoke WriteFile,fHandle,ADDR buf1 ,BSIZE ,ADDR cWritten,0
            invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10
          .case 1005
           invoke MsgboxI,hWin,ADDR txt01_3,"Завдання",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_3,"Масив",MB_OK,10
             .case 1006 
            invoke MsgboxI,hWin,ADDR buf3,"Результат",MB_OK,10

            .case 1005 
            invoke MsgboxI,hWin,ADDR txt01_3,"Завдання",MB_OK,10
           invoke MsgboxI,hWin,ADDR txt03_3,"Рівняння",MB_OK,10
         .case 1008
   
         invoke MsgboxI,hWin,ADDR txt01 ,"Завдання",MB_OK,10

            .case 1007
              invoke CreateFile,ADDR fNameA,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
             mov fHandle, rax;відкрити та записа данні файла
            invoke WriteFile,fHandle,ADDR buf3 ,BSIZE ,ADDR cWritten,0
            invoke MsgboxI,hWin,"Успішно збережено","SAVE",MB_OK,10
           .case 110 ; кнопка
          invoke MsgboxI,hWin,ADDR buf1,"Завдання",MB_OK,10
          rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0; закрытие окна
          .case 113
          invoke MsgboxI,hWin,ADDR autor,"Автор",MB_OK,10
          .case 112
          invoke MsgboxI,hWin,ADDR buf2,"Результат:",MB_OK,10
          .case 116
           invoke MsgboxI,hWin,ADDR buf4,"Корінь:",MB_OK,10
        .case 221
   
         invoke MsgboxI,hWin,ADDR txt01 ,"Завдання",MB_OK,10
        .case 216
         invoke MsgboxI,hWin,ADDR txt01_1,"Завдання",MB_OK,10
        .case 219
         invoke MsgboxI,hWin,ADDR txt01_2,"Завдання",MB_OK,10
         .case 220
         invoke MsgboxI,hWin,ADDR txt01_3,"Завдання",MB_OK,10

 
        .case 222
         invoke MsgboxI,hWin,ADDR txt03_1,"Масив",MB_OK,10
        .case 223
         invoke MsgboxI,hWin,ADDR txt03_2,"Масив",MB_OK,10
         .case 224
         invoke MsgboxI,hWin,ADDR txt03_3,"Вираз",MB_OK,10

        .case 212
         invoke MsgboxI,hWin,ADDR buf1,"Результат",MB_OK,10
        .case 217
         invoke MsgboxI,hWin,ADDR buf2,"Результат",MB_OK,10
         .case 218
         invoke MsgboxI,hWin,ADDR buf3,"Результат",MB_OK,10


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