C:\masm32\bin\ml /c /coff "Process.asm" 
C:\masm32\bin\rc "Process.rc"
C:\masm32\bin\link /SUBSYSTEM:windows "Process.obj" "Process.res"
pause
start Process.exe