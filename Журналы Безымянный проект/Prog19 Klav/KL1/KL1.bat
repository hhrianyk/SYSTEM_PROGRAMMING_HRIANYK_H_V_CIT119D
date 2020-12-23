ml /c /coff  "KL1.asm" 
link /SUBSYSTEM:windows "KL1.obj"
pause
del KL1.obj
start KL1.exe