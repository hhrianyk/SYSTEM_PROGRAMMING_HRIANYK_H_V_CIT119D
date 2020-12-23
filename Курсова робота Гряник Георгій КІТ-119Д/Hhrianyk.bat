ml /c /coff "Hhrianyk.asm"
rc "Hhrianyk.rc"
link /SUBSYSTEM:windows "Hhrianyk.obj" "Hhrianyk.res" 
del "Hhrianyk.obj" Hhrianyk.res" 
pause
start Hhrianyk.exe