; Параллельное сложение с помощью ММХ-команд над массивами целых чисел.
; Если второе слово больше 55, то выполнить операцию
; a - c/b - dc  (-4,83), де a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; иначе - выполнить операцию a-c/b   (2,43)
include \masm64\include64\masm64rt.inc
IDI_ICON  EQU 1001
MSGBOXPARAMSA STRUCT
   cbSize          DWORD ?,?
   hwndOwner       QWORD ?
   hInstance       QWORD ?
   lpszText        QWORD ?
   lpszCaption     QWORD ?
   dwStyle         DWORD ?,?
   lpszIcon        QWORD ?
   dwContextHelpId QWORD ?
   lpfnMsgBoxCallback QWORD ?
   dwLanguageId       DWORD ?,?
MSGBOXPARAMSA ENDS

fpuDiv macro _a,_c,_b ; макрос с именем fpuDiv
    fld _c
    fdiv _b
    fld _a
    fsubr
endm 	;; окончание макроса
.data

params MSGBOXPARAMSA <>         			
    _a REAL4 2.8
    _b REAL4 8.05
    _c REAL4 2.2
    _d REAL4 3.3
    arr1 dw 1,2,3,4          ; массив чисел arr1 размером в слово
    len1 equ ($-arr1)/type arr1  ; количество чисел массива
    arr2 dw 5,6,7,5 	       ; массив чисел arr2 размером в слово
    len2 equ ($-arr2)/type arr2    ; количество чисел массива
    arr1_2 dw len1 dup(0) ; размер буфера для чисел массивов
    tit1 db "masm64. Oперации MMX-FPU",0  ; название окошка
    st2 dd 0 	        ; буфер чисел длЯ вывода сообщения
    buf1 db 0,0
ifmt db "Параллельное сложение с помощью ММХ-команд над массивами целых чисел.",10,
"Если второе слово больше 55, то выполнить операцию:",10,
"a - c/b - dc  (-4,83), где a = 2,7; b = 8,05; c = 2,2; d = 3,3;",10,
"иначе - выполнить операцию a - c/b   (2,43)",10,10,"Ответ =  %d ",10,10,
"Автор: Рысованый А.Н., каф. ВТП, фак. КИТ, НТУ ХПИ",10,
9,"Сайт:  http://blogs.kpi.kharkov.ua/v2/asm/",0
len11 equ ($-ifmt)/type ifmt

.code 
entry_point proc
  movq MM1,QWORD PTR arr1 ; загрузка массива чисел arr1
  movq MM2,QWORD PTR arr2 ; загрузка массива чисел arr2
  paddw MM1,MM2     ; параллельное циклическое сложение
  movq QWORD PTR arr1_2,MM1 ; сохранение результата
pextrw eax,MM1,1 ; копирование первого после нулевого слова в eax
 cmp eax,55
 jg @1 ; if >
 jmp @2
@1: emms ; последняя ммх-команда - освобождение сопроцессора
 fpuDiv [_a],[_c],[_b]
 fld _d
 fmul _c
 fsub
 fisttp st2; сохранение целочисленного значения и округление в сторону нуля
 invoke wsprintf,ADDR buf1,ADDR ifmt,st2
 
   mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
    mov params.hwndOwner,0    ; дескриптор окна владельца
   invoke GetModuleHandle,0   ; получение дескриптора программы
    mov params.hInstance,rax  ; сохранение дескриптора программы
        lea rax, buf1       ; адрес сообщения
    mov params.lpszText,rax   
        lea rax,tit1 ;Caption ; адрес заглавия окна
    mov params.lpszCaption,rax     
    mov params.dwStyle,MB_USERICON ; стиль окна
    mov params.lpszIcon,IDI_ICON   ; ресурс значка
    mov params.dwContextHelpId,0  ; контекст справки
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; язык сообщения
        lea rcx,params
   invoke MessageBoxIndirect
    ;  invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
jmp @3
@2: emms
    fpuDiv [_a],[_c],[_b]
	fisttp st2 ; сохранение целочисленного значения и округление в сторону нуля
   invoke wsprintf,ADDR buf1,ADDR ifmt,st2
  
   mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
    mov params.hwndOwner,0    ; дескриптор окна владельца
   invoke GetModuleHandle,0   ; получение дескриптора программы
    mov params.hInstance,rax  ; сохранение дескриптора программы
        lea rax, buf1       ; адрес сообщения
    mov params.lpszText,rax   
        lea rax,tit1 ;Caption ; адрес заглавиЯ окна
    mov params.lpszCaption,rax     
    mov params.dwStyle,MB_USERICON ; стиль окна
    mov params.lpszIcon,IDI_ICON   ; ресурс значка
    mov params.dwContextHelpId,0  ; контекст справки
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; язык сообщениЯ
        lea rcx,params
   invoke MessageBoxIndirect
     ;invoke MessageBox,0,addr buf1,addr tit1,MB_ICONQUESTION
@3:
.data
fmt2 db 3 dup("%x "),0    ; строка форматирования
fName db "MMX64-5-1.txt",0
hFile dq ?
buf2 db 3 dup(0); 
fHandle dq ? ;
cWritten dq ? ;
BSIZE equ 338
fName2 BYTE "notepad C:\masm64\bin64\MMX64-5-1.txt",0 ; имя файла
  
.code
invoke CreateFile,ADDR fName,GENERIC_WRITE,0,0,CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE,0
mov hFile,rax

invoke WriteFile,hFile,ADDR buf1,BSIZE,ADDR cWritten,0
invoke CloseHandle,hFile

invoke WinExec,addr fName2,SW_SHOW
invoke ExitProcess,0
entry_point endp
end	
