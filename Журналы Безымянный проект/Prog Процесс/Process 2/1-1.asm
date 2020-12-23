.686 	           ; директива визначення типу мікропроцесора
.model flat,stdcall ; завдання лінійної моделі пам’яті та угоди ОС Windows
option casemap:none          ; відмінність малих та великих літер
include \masm32\include\windows.inc ; файли структур, констант …
include \masm32\macros\macros.asm
uselib kernel32,user32 
.data
st1 db "Процесс активный",0         ; буфер виведення повідомлення
titl db "Просто MessageBox",0
 .code 			          	; директива визначення даних
 start:
  invoke MessageBox, \ 	         ; АРІ-функція виведення вікна консолі
 NULL, \ 			              ; hwnd – ідентифікатор вікна
  addr st1, \ 	      ; адреса рядка, яка містить  текст повідомлення
   addr titl, \            ; адреса рядка, яка містить  заголовок повідомлення
     MB_ICONINFORMATION+180000h           ; вигляд вікна
invoke ExitProcess, 0 ; повернення керування ОС Windows та визволення ресурсів
end start 	        ; директива закінчення програми з іменем start

