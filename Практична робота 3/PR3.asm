title создание и запись в файл; masm64
include \masm64\include64\masm64rt.inc 
.data
const1 dq 191
const2 dq 10
const3 dq 16
const5 dq 0
x1 dq 1
temp dq 1
fName  BYTE "File3.txt",0
fHandle dq ?  ;
cWritten dq ? ;
hFile dq ?,0

buf dq 0
fmt db "Для функції Y = 10*Х + 16/X знайти найменше  значеня, яке  перевищує  191, починаючи  з Х = 1. ", 
"Вивести значение аргумента и функции.",10,10, 
"При х = %d   функция Y = 10*Х + 16/X = %d ",10, 10,
"Автор: Гряник Г.В., гр.КІТ-119Д",0
titl1 db " masm64. Файлы",0

szFileName db "C:\Masm64\bin64\File-3.exe",0
buf2 dq 0,0
fmt2 db "%d",0

BSIZE equ 10
.code  	
entry_point proc

m1: mov rax,const2
  mul x1
  mov temp,rax
  mov rax,const3
  mov rdx,0
  div x1
  add rax,temp
  add rax,const2; 10*Х + 16/х
  mov const5,rax
  cmp rax,const1 ; сравнение с 191
    jnc exit ; перейти, якщо  >
    inc x1   ;  Х+1
    jmp m1   ; 
exit:
inc x1   ;  Х+1

;invoke WinExec,addr szFileName,SW_SHOW;
invoke wsprintf,addr buf,addr fmt,x1,const5
invoke MessageBox,0,addr buf,addr titl1,MB_ICONINFORMATION

invoke wsprintf,addr buf2,addr fmt2,x1
invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0
 mov fHandle, rax;
invoke WriteFile,fHandle,ADDR buf2,BSIZE,ADDR cWritten,0
invoke CloseHandle,fHandle

entry_point endp
end