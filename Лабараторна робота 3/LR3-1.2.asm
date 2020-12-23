include \masm64\include64\masm64rt.inc ; библиотеки

.data ;
;Текст для MessageBox
title1 db "Лаб.3-1.2 Робота з файлами. masm64",0
txt1 db"Назва файлу: %hS",10,
"Тип файлу: %hS",10,
"Розташування файлу:C:\masm64\bin64\%hS",10,
"Розмір файлу: %d byte",10,
"Адресса в памяті: %ph",10,10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0

_file1 db "Res_LR3-1.1A.txt",0; файл для аналізу
hFile01 HANDLE ?   ; для збереження даних
;допоміжні дані для аналізу
file01_pype db 'txt',0
file01_size dq ?
; Повідомлення про помилку
title2 db "Інформація від автора",0
msg1 db "Помилка! Файл  %hS  не доступен!",0
buf dq 0

.code;cекция кода
entry_point proc

invoke CreateFile,addr _file1,GENERIC_READ,0,0,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
mov hFile01,rax ; сохранение дескриптора файла
.if hFile01 == INVALID_HANDLE_VALUE ; если CreateFile возвращает ошибку
invoke wsprintf,ADDR buf,ADDR msg1,addr _file1
  invoke MessageBox,0,addr buf,addr title2,0 ; сообщение об ошибке
   ret
.endif
   invoke GetFileSize,hFile01,0 ; получение размера файла 01
   mov file01_size,rax; запис розміру
   
  invoke wsprintf,ADDR buf,ADDR txt1,addr _file1,ADDR file01_pype,ADDR _file1,file01_size,addr hFile01; створення даних для MessageBox
  invoke MessageBox,0,ADDR buf,ADDR title1,MB_ICONINFORMATION ;Створення MessageBox

entry_point endp; кінець роботи програм
end