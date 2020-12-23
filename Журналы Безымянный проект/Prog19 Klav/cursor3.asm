; Смена вида курсора
include \masm64\include64\masm64rt.inc
.data  
myXY POINT <>  ; структура определения х- и у-координат точки
titl db "Координаты курсора",0
buf db 50 dup(?),0
ifmt db "Текущие координаты курсора: X=  %d,  Y=  %d",0dh,0ah,0ah,
 "Автор программы:        Харьков, НТУ ХПИ",0
temp dd 0
.code 
entry_point proc
invoke GetCursorPos,addr myXY
invoke wsprintf,ADDR buf,ADDR ifmt,myXY.x,myXY.y 
invoke MessageBox,0,addr buf,addr titl,MB_ICONINFORMATION
   invoke LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; Обычный курсор-стрелка
  invoke  Sleep,5000
  fn MessageBeep,MB_ICONEXCLAMATION ; звук "Восклицание"
   invoke  LoadCursor,0,IDC_SIZEALL
   invoke SetSystemCursor,EAX,OCR_NORMAL ; Обычный курсор-стрелка
invoke ExitProcess, NULL ; возврат управления Windows 
entry_point endp
   end
