include \masm64\include64\masm64rt.inc ; библиотеки
err1 PROTO arg_a:QWORD
.data ;

mas1 dq 85,85,4,85,3,5,5,32,5,13,54,12,64,5   ;масив
a dq 55h                                       ;шукане число
_res dq 0;                                     ;реультат
len1 dq 14 ; вычисление количества слов в mas

;Текст для MessageBox
title1 db "Лаб.3-1.1 Робота з файлами. masm64",0
txt1 db"Kількість елементів, значення яких дорівнює 55h: %d",10,
"Адрес результату: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
buf1 dq 3 dup(0),0
msg1 db "STOP!",10," В масиві було знайдено більше ніж 3 елемента вказані за умовою, тому програма зупинилася.",10,"Повідомлення дублюється в файл  ",0;Помилка
msg3 db "STOP!",10," В масиві було знайдено більше ніж 3 елемента вказані за умовою, тому програма зупинилася.",10,"Повідомлення дублюється в файл  ",0;Помилка


fName  BYTE "Res_LR3-1.1.txt",0;файл для зберігання
fHandle dq ? ;        для даних файлу         
cWritten dq ? ;
BSIZE equ 120;розмір файлу 
;для інформації від автора
_file1 db "Res_LR3-1.1A.txt",0 ; файл від 
hFile01 HANDLE ?
from_file db 4096 dup(?)
read_by_file dq ?
write_by_file dq ?
file01_size dq ?
;Інформація від автора
title2 db "Інформація від автора",0
msg2 db "Помилка! Файл 'Res_LR3-1.1A' не доступен!",0
buf dq 0

.code;cекция кода
entry_point proc

invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
     mov fHandle, rax;відкрити та записа данні файла

invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
mov hFile01,rax ; сохранение дескриптора файла
.if hFile01 == INVALID_HANDLE_VALUE ; если CreateFile возвращает ошибку
  invoke MessageBox,0,addr msg2,addr title1,0 ; сообщение об ошибке
   ret
.endif ; якщо невиконуєтьсяя попередня умова  то виконується це
   invoke GetFileSize,hFile01,0 ; получение размера файла 01
   mov file01_size,rax; 
   invoke ReadFile,hFile01,addr from_file,file01_size,addr read_by_file,0;підготовка даних
  invoke MessageBox,0,addr from_file,addr title2,0 ; виклик MessageBox
  invoke err1,len1 ; виклик процедури


entry_point endp; кінець роботи програми


err1 proc arg_a:QWORD; arg_a передается в rcx
lea rsi,mas1 	 ; початковий адрес массива marc 
mov r11,a

m1:  
movzx rax, word ptr [rsi] 
cmp rax,r11	; порівняня елементів
jne m2 	; якщо не рівні ,то перейти на m2

inc _res;+1 до результату
mov r14,_res

m2:  add rsi,8 ; збільшити адресу для вибору нового елементу
dec rcx 	   ; зменшити лічильник кількості чисел mas1

 cmp _res,3   ; порівняння реультату
 jle m3       ;перейти на  m3, якщо <=3
 
 ;вивод відповідногоповідомлення про помилка та збереження даних у файл
     invoke wsprintf,ADDR buf1,ADDR msg1
     invoke WriteFile,fHandle,ADDR buf1,BSIZE ,ADDR cWritten,0
     invoke CloseHandle,fHandle
     invoke MessageBox,0,addr msg3,addr title1,0 ; сообщение об ошибке

 ret           ; вийти з програми

m3:cmp rcx,0      ;
jnz m1 		; перейти на  m1, якщо не нуль
;вивод відповідного повідомлення про успішне завершення роботи програми та збереження даних у файл
  invoke wsprintf,ADDR buf1,ADDR txt1,_res,ADDR _res
  invoke WriteFile,fHandle,ADDR buf1,BSIZE ,ADDR cWritten,0
  invoke CloseHandle,fHandle

  invoke wsprintf,ADDR buf1,ADDR txt1,_res,ADDR _res
  invoke MessageBox,0,ADDR buf1,ADDR title1,MB_ICONINFORMATION ;Створення MessageBox


ret
err1 endp ;кінець роботи програми
   end