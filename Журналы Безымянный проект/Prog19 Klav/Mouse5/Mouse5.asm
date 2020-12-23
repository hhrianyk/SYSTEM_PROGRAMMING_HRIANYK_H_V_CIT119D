;Програма обмеження переміщення курсора в прямокутній області 
.686    ; директива визначення типу мікропроцесора
.model  flat, stdcall  ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none       ; відмінність малих та великих  літер
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32
.data  
myXY POINT <>  ; структура визначення х- та у-координат
cursor_rect RECT <>
titl db "Координаты курсора",0
buf db 50 dup(?),0
ifmt db "X=   Y=",0dh,0ah,"   %d   %d  ",0dh,0ah,0ah,  "Автор программы: НТУ ХПИ",0
temp dd 0
.code 
_st: 
invoke GetCursorPos, addr myXY
invoke  wsprintf, ADDR buf, \; адреса буфера, куди буде записана послідовність 
  ADDR ifmt, myXY.x,myXY.y ; адреса рядка перетворення формату 
invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
mov cursor_rect.left,450
mov cursor_rect.top,450
mov cursor_rect.right,650
mov cursor_rect.bottom,650
invoke ClipCursor, addr cursor_rect ; обмеження переміщення курсора
invoke ExitProcess, NULL ; повернення управління Windows
end _st 
