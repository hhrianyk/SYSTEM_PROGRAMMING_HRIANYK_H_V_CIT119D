include \masm64\include64\masm64rt.inc 
.data
szTestKey db 'Software\Microsoft\Windows\CurrentVersion\Policies\Ext',0
szREGSZ db 'REG_DWORD',0
hKey dd ?
lpdwDisp dd ?
szValueName1 db "Timer",0
setValue dq "9",0
buf1 LPDWORD 128,0
getKol LPBYTE "9",0
buf3 LPDWORD 128,0


error dd ?,0
ertit db "Описание ошибки",0
ook db "Ключ успешно создан",0
bed db "Ключ не создан",0
kk db "Реестр",0
kol dd 0 ; для максимального числа первой строки
titl db "Результат программы",0
buf dd 0,0
ifmt db "Условие: Ограниченое количестсва запусков программы ",10,10,\
"Осталось количество запусков: %c",0

.code
entry_point proc

; СОЗДАЕМ РАЗДЕЛ
invoke RegCreateKeyEx,HKEY_CURRENT_USER,ADDR szTestKey,0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
cmp rax,0 ;Раздел создан успешно ?
jne m1

; ПРОВЕРЯЕМ РАЗДЕЛ 
cmp lpdwDisp,REG_OPENED_EXISTING_KEY
je m2

; СОЗДАЕМ КЛЮЧ И ЗАПИСЫВАЕМ ДАННЫЕ
invoke RegSetValueEx,hKey,addr szValueName1,0,REG_SZ,addr setValue,1 ; размер ключа в байтах
cmp rax,0 ;ПРОВЕРКА КЛЮЧА НА СОЗДАНИЕ 
jne m1
invoke MessageBox,0,addr ook,addr kk,MB_ICONINFORMATION
jmp m3
m2:
; ОТКРЫВАЕМ КЛЮЧ СЧИТЫВАЕМ ДАННЫЕ И ЗАПИСЫВАЕМ НОВЫЕ
invoke RegQueryValueEx,hKey,addr szValueName1,0,addr buf1,addr getKol,addr buf3 ;
cmp getKol,"0"
je ex
dec getKol
invoke RegSetValueEx,hKey,addr szValueName1,0,REG_SZ,addr getKol,1 ; размер ключа в байтах

m3:
; ЗАКРЫВАЕМ РАЗДЕЛ
invoke RegCloseKey,hKey ; идентификация открытого ключа для закрытия

jmp next
m1:

; ВЫВОДИМ СООБЩЕНИЕ ОБ ОШИБКЕ
invoke FormatMessage,FORMAT_MESSAGE_FROM_SYSTEM,NULL,rax,NULL,addr error,100,NULL
invoke MessageBox,0,addr error,addr bed,MB_ICONINFORMATION
jmp ex
next:

invoke wsprintf, ADDR buf, ADDR ifmt,getKol
invoke MessageBox,0,addr buf,addr titl,MB_ICONEXCLAMATION
ex:
invoke ExitProcess,0
entry_point endp
end	