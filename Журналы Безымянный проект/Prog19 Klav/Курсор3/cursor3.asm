.686    ; директива определения типа микропроцессора
.model  flat, stdcall  ; задание линейной модели памяти и соглашения ОС Windows
option casemap:none       ; отличие малых и больших  букв
include \masm32\include\windows.inc ; файлы структур, констант …
include \masm32\macros\macros.asm
uselib user32,kernel32
.data  
myXY POINT <>  ; структура определения х- и у-координат точки
ccc CURSORINFO <>
titl db "Координаты курсора",0
buf db 50 dup(?),0
ifmt db "Текущие координаты курсора: X=  %d,  Y=  %d",0dh,0ah,0ah,
 "Автор программы:        Харьков, НТУ ХПИ",0
temp dd 0
.code 
_st: 
invoke GetCursorPos, addr myXY
invoke  wsprintf, ADDR buf, ADDR ifmt, myXY.x,myXY.y 
invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; Обычный курсор-стрелка
  invoke  Sleep,10000
  fn MessageBeep,MB_ICONEXCLAMATION ; звук "Восклицание"
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; Обычный курсор-стрелка

            invoke GetCursorInfo,addr ccc;  курсор
            mov ccc.flags, 0 
			invoke  Sleep,10000
           
invoke ExitProcess, NULL ; возврат управления Windows 
end _st ; директива окончания программы
