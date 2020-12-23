ml /c /coff "Kl.asm"
rc "Kl.rc"
link /SUBSYSTEM:windows "Kl.obj" "Kl.res"
pause
start Kl.exe

