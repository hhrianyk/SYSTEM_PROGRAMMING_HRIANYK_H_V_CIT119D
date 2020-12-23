ml /c /coff "AnimBlend.asm"
rc "AnimBlend.rc"
link /SUBSYSTEM:windows "AnimBlend.obj" "AnimBlend.res"
pause
del "AnimBlend.obj" "AnimBlend.res"
start AnimBlend.exe
