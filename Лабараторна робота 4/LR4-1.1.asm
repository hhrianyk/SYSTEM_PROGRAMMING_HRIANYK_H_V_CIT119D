include \masm64\include64\masm64rt.inc ; библиотеки для подключения

IDI_ICON  EQU 1001
MSGBOXPARAMSA STRUCT
   cbSize          DWORD ?,?
   hwndOwner       QWORD ?
   hInstance       QWORD ?
   lpszText        QWORD ?
   lpszCaption     QWORD ?
   dwStyle         DWORD ?,?
   lpszIcon        QWORD ?
   dwContextHelpId QWORD ?
   lpfnMsgBoxCallback QWORD ?
   dwLanguageId       DWORD ?,?
MSGBOXPARAMSA ENDS


DATE1 STRUCT               ; определения данные СТРУКТУРА с именем DATE1
Name1   dW ? 			; имя 1 поля структуры  
Name2   dw ? 			; имя 2 поля структуры  
Name3   dw ? 			; имя 3 поля структуры  
Name4   dw ? 			; имя 4 поля структуры  
Name5   dw ? 			; имя 5 поля структуры  
Name6   dW ? 			; имя 6 поля структуры  

DATE1 ENDS 	 	  ; окончания данные СТРУКТУРА с именем Date1
.data 			          	; директива определения данные
  Car1  DATE1 <1,10,2,3,1,1> 		      ; структура с именем Car1
  Car2  DATE1 <2,-11,6,7,2,1> 		; структура с именем Car2
  Car3  DATE1 <3,12,10,11,3,1> 		; структура с именем Car3
  Car4  DATE1 <4,13,14,15,31,1> 		; структура с именем Car4

_res1 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res2 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res3 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res4 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res5 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ
_res6 dq 0 ; операнд res1 размерностью 64 разряда; змінна результ

 params MSGBOXPARAMSA <>  

;Текст для MessageBox
titl1 db "Лаб.4-1.1 СТРУКТУРИ. masm64",0
txt1 db "Завдання: Дана матриця 4 х 6. Визначити суму елементів кожного стовпця.", 10,10,
"Вхідний массив - вид матриці:",10,\
"          |01|10|02|03|01|01|",10,\
"          |01|10|02|03|01|01|",10,\
"          |03|12|10|11|03|01|",10,\
"          |04|13|14|15|31|01|",10,\
"-------------------------",10,\
"сума: |%d|%d|%d|%d|%d|%d| ",10,10,\
"Автор: Гряник Г.В., гр.КІТ-119Д",0

st2 db 20 dup(?),0 ; 
.code
entry_point proc
xor ebx,ebx
movzx  ebx,Car1.Name1	; заполнение нулями старшей части 
  add   bx,Car2.Name1     	; bx := Car1.Name1  +  Car2.Name1
  add   bx,Car3.Name1 	; 
  add   bx,Car4.Name1 	; 
movsxd  r15,ebx 
mov _res1,r15 ; 
movzx  ebx,Car1.Name2	; заполнение нулями старшей части 
  add   bx,Car2.Name2     	; bx := Car1.Name2  +  Car2.Name2
  add   bx,Car3.Name2 	; 
  add   bx,Car4.Name2 	; 
movsxd  r15,ebx 
mov _res2,r15 ; 
movzx  ebx,Car1.Name3	; заполнение нулями старшей части 
  add   bx,Car2.Name3     	; bx := Car1.Name3  +  Car2.Name3
  add   bx,Car3.Name3 	; 
  add   bx,Car4.Name3 	; 
movsxd  r15,ebx 
mov _res3,r15 ; 
movzx  ebx,Car1.Name4	; заполнение нулями старшей части 
  add   bx,Car2.Name4     	; bx := Car1.Name4  +  Car2.Name4
  add   bx,Car3.Name4 	; 
  add   bx,Car4.Name4 	; 
movsxd  r15,ebx 
mov _res4,r15 ; 
movzx  ebx,Car1.Name5	; заполнение нулями старшей части 
  add   bx,Car2.Name5     	; bx := Car1.Name5  +  Car2.Name5
  add   bx,Car3.Name5 	; 
  add   bx,Car4.Name5 	; 
movsxd  r15,ebx 
mov _res5,r15 ;  
movzx  ebx,Car1.Name6	; заполнение нулями старшей части 
  add   bx,Car2.Name6     	; bx := Car1.Name6  +  Car2.Name6
  add   bx,Car3.Name6 	; 
  add   bx,Car4.Name6 	; 
movsxd  r15,ebx 
mov _res6,r15 ; 
invoke wsprintf,ADDR st2,ADDR txt1,_res1,_res2,_res3,_res4,_res5,_res6   ; функция преобразования

  mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
    mov params.hwndOwner,0     ; дескриптор окна владельца
    invoke GetModuleHandle,0   ; получение дескриптора программы
    mov params.hInstance,rax   ; сохранение дескриптора программы
        lea rax,st2
    mov params.lpszText,rax   ; адрес сообщени¤
        lea rax,titl1
    mov params.lpszCaption,rax     ; адрес заглави¤ окна
    mov params.dwStyle,MB_USERICON ; стиль окна
    mov params.lpszIcon,IDI_ICON    ; ресурс значка
    mov params.dwContextHelpId,0  ;контекст справки
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ¤зык сообщени¤
        lea rcx,params
   invoke MessageBoxIndirect
invoke ExitProcess, 0 
entry_point endp
end	

