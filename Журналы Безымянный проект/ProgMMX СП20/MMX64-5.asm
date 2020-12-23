; ������������ �������� � ������� ���-������ ��� ��������� ����� �����.
; ���� ������ ����� ������ 55, �� ��������� ��������
; a-c/b-dc  (-4,83), ��� a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; ����� - ��������� �������� a-c/b   (2,43)
title ��������� ��.
include win64a.inc
fpuDiv macro _a,_c,_b ; ������ � ������ fpuDiv
    fld _c
    fdiv _b
    fld _a
    fsubr
endm  			;; ��������� �������
.data  	         			
    _a REAL4 2.8
    _b REAL4 8.05
    _c REAL4 2.2
    _d REAL4 3.3
    arr1 dw 1,2,3,4          ; ������ ����� arr1 �������� � �����
    len1 equ ($-arr1)/type arr1  ; ���������� ����� �������
    arr2 dw 5,6,7,5 	       ; ������ ����� arr2 �������� � �����
    len2 equ ($-arr2)/type arr2    ; ���������� ����� �������
    arr1_2 BYTE (len1+len2) dup(0) ; ������ ������ ��� ����� ��������
    st1 db "FPU-MMX Result",0  ; �������� ������
    st2 dd 0	        ; ����� ����� ��� ������ ���������
  ifmt db "����� =  %d ",0
  buf dd 0,0
.code 				
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 - �������
mov rbp,rsp					
  movq MM1,QWORD PTR arr1 ; �������� ������� ����� arr1
  movq MM2,QWORD PTR arr2 ; �������� ������� ����� arr2
  paddb MM1,MM2     ; ������������ ����������� ��������
  movq QWORD PTR arr1_2,MM1 ; ���������� ����������
pextrw eax,MM1,1 ; ����������� �� ��0 ����� � eax
emms   		; ��������� ���-�������
 cmp eax,55
 jg @1 ; if >
 jmp @2
@1:  fpuDiv [_a],[_c],[_b]
 fld _d
  fmul _c
  fsub
  fisttp st2; ���������� �������������� �������� � ���������� � ������� ����
    jmp @3
@2: fpuDiv [_a],[_c],[_b]
 fisttp st2 ; ���������� �������������� �������� � ���������� � ������� ����
@3: invoke wsprintf,ADDR buf,ADDR ifmt,st2
   invoke MessageBox,0,addr buf,addr st1,MB_ICONQUESTION
invoke RtlExitUserProcess,0
WinMain endp
end	
