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
 invoke GetCursorPos, addr myXY ; получение координат курсора
 invoke  wsprintf, ADDR buf, \ ; адрес буфера, куда будет записана последовательность символов
  ADDR ifmt, myXY.x,myXY.y ; адрес строки преобразования формата 
 invoke MessageBox, NULL, addr buf, addr titl, MB_ICONINFORMATION
 invoke GetSystemMetrics,SM_CXSCREEN ; получение ширина экрана в пикселях
mov temp,eax
xor esi,esi
m1:
invoke SetCursorPos,esi,0 ; установка курсора за координатами
invoke Sleep,50 ; задержка
add esi,20          ; увеличение координаты
cmp temp,esi     ; сравнение с максимальной координатой
jge  m1  ; если temp > esi
invoke GetSystemMetrics,SM_CYSCREEN ; получение высоты экрана в пикселях
invoke SetCursorPos,0,eax ; установка курсора  за координатами
fn MessageBeep,MB_ICONEXCLAMATION ; звук "Восклицание"
invoke ExitProcess, NULL ; возвращение управления Windows  
entry_point endp
   end

