.686    ; директива определения типа микропроцессора
.model  flat, stdcall  ; задание линейной модели памяти и соглашения ОС Windows
option casemap:none       ; отличие малых и больших  букв
include \masm32\include\windows.inc ; файлы структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32
.data  
myXY POINT <>  ; структура определения х- и у-координат
cursor_rect RECT <>
titl db "Координаты курсора",0
buf db 50 dup(?),0
ifmt db "Текущие координаты курсора: X=  %d,  Y=  %d",0dh,0ah,0ah,
"После нажатия на кнопку <OK> ограничивается перемещение курсора на 10 С",0dh,0ah,
 "Автор программы:        Харьков, НТУ ХПИ",0
temp dd 0
.code 
_st: 
invoke GetCursorPos, addr myXY
invoke wsprintf,addr buf,addr ifmt,myXY.x,myXY.y ;
invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
 mov cursor_rect.left,450
 mov cursor_rect.top,450
 mov cursor_rect.right,650
 mov cursor_rect.bottom,650
invoke ClipCursor, addr cursor_rect

fn Sleep,10000
 mov cursor_rect.left,0
 mov cursor_rect.top,0
invoke GetSystemMetrics,SM_CXSCREEN ; получение ширины екрана в пикселях
 mov cursor_rect.right,eax
invoke GetSystemMetrics,SM_CYSCREEN ; получение высоты екрана в пикселях
 mov cursor_rect.bottom,eax
invoke ClipCursor, addr cursor_rect
fn MessageBeep,MB_ICONHAND ;звук "Критическая ошибка" 
invoke ExitProcess, NULL ;возврат управления Windows 
end _st  ; директива окончания программы