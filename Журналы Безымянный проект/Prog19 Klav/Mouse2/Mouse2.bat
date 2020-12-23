ml /c /coff  "Mouse2.asm" 
rc "Mouse2.rc"
link /SUBSYSTEM:windows "Mouse2.obj" "Mouse2.res"
del "Mouse2.obj" "Mouse2.res"
pause
start Mouse2.exe