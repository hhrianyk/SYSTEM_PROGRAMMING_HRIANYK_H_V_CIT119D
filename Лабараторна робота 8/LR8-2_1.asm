include \masm64\include64\masm64rt.inc

.data

titl db "Програма LR8-2_1",0
 .code 	          	
entry_point proc txt2:QWORD
    invoke MessageBox,0, "Відкрита стороння програма",addr titl,MB_ICONINFORMATION          
invoke ExitProcess, 0 ; возвращение управления ОС Windows и освобождение ресурсов
entry_point endp; кінець роботи програми
   end
