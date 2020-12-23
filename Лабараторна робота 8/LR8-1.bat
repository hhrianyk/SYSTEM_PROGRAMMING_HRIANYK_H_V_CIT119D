ml /c /coff "LR8-1.asm"
rc "LR8-1.rc"
link /SUBSYSTEM:windows "LR8-1.obj" "LR8-1.res" 
del "LR8-1.obj" "LR8-1.res" 
pause
start LR8-1.exe