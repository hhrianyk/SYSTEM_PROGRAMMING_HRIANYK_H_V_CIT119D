include \masm64\include64\masm64rt.inc

.data

titl db "Програма LR8-2_2",0
 .code 	          	
entry_point proc txt2:QWORD
    invoke MessageBox,0, addr txt2,addr titl,MB_ICONINFORMATION          
invoke ExitProcess, 0 ; возвращение управления ОС Windows и освобождение ресурсов
entry_point endp; кінець роботи програми
   end