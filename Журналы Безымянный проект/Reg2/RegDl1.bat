ml /c /coff "RegDl1.asm"
rc "RegDl1.rc"
link /SUBSYSTEM:windows "RegDl1.obj" "RegDl1.res" 
del "RegDl1.obj" "RegDl1.res" 
pause
start RegDl1.exe