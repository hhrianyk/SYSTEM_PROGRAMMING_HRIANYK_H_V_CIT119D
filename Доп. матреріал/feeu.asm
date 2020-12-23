
include \masm64\include64\masm64rt.inc
.data         
a1 dq 5.0
a2 real8 5.1 ;
a3 real8 2. 
.code   
entry_point proc  
finit ; инициирование сопроцессора 
fld a1  ; st(0) := opA 
fld a2 
fld a3 
fadd st(2),st(0) 
invoke ExitProcess, 0
entry_point endp
end