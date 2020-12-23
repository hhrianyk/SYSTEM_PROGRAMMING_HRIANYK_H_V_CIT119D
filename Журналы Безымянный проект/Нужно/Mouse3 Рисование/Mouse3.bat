rc Mouse3.rc
ml /c /coff Mouse3.asm
link /subsystem:windows Mouse3.obj Mouse3.res
pause
del Mouse3.obj Mouse3.res
start Mouse3.exe