include \masm64\include64\masm64rt.inc ; ���������� ��� �����������

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


DATE1 STRUCT               ; ����������� ������ ��������� � ������ DATE1
Name1   dW ? 			; ��� 1 ���� ���������  
Name2   dw ? 			; ��� 2 ���� ���������  
Name3   dw ? 			; ��� 3 ���� ���������  
Name4   dw ? 			; ��� 4 ���� ���������  
Name5   dw ? 			; ��� 5 ���� ���������  
Name6   dW ? 			; ��� 6 ���� ���������  

DATE1 ENDS 	 	  ; ��������� ������ ��������� � ������ Date1
.data 			          	; ��������� ����������� ������
  Car1  DATE1 <1,10,2,3,1,1> 		      ; ��������� � ������ Car1
  Car2  DATE1 <2,-11,6,7,2,1> 		; ��������� � ������ Car2
  Car3  DATE1 <3,12,10,11,3,1> 		; ��������� � ������ Car3
  Car4  DATE1 <4,13,14,15,31,1> 		; ��������� � ������ Car4

_res1 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
_res2 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
_res3 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
_res4 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
_res5 dq 0 ; ������� res1 ������������ 64 �������; ����� �������
_res6 dq 0 ; ������� res1 ������������ 64 �������; ����� �������

 params MSGBOXPARAMSA <>  

;����� ��� MessageBox
titl1 db "���.4-1.1 ���������. masm64",0
txt1 db "��������: ���� ������� 4 � 6. ��������� ���� �������� ������� �������.", 10,10,
"������� ������ - ��� �������:",10,\
"          |01|10|02|03|01|01|",10,\
"          |01|10|02|03|01|01|",10,\
"          |03|12|10|11|03|01|",10,\
"          |04|13|14|15|31|01|",10,\
"-------------------------",10,\
"����: |%d|%d|%d|%d|%d|%d| ",10,10,\
"�����: ������ �.�., ��.ʲ�-119�",0

st2 db 20 dup(?),0 ; 
.code
entry_point proc
xor ebx,ebx
movzx  ebx,Car1.Name1	; ���������� ������ ������� ����� 
  add   bx,Car2.Name1     	; bx := Car1.Name1  +  Car2.Name1
  add   bx,Car3.Name1 	; 
  add   bx,Car4.Name1 	; 
movsxd  r15,ebx 
mov _res1,r15 ; 
movzx  ebx,Car1.Name2	; ���������� ������ ������� ����� 
  add   bx,Car2.Name2     	; bx := Car1.Name2  +  Car2.Name2
  add   bx,Car3.Name2 	; 
  add   bx,Car4.Name2 	; 
movsxd  r15,ebx 
mov _res2,r15 ; 
movzx  ebx,Car1.Name3	; ���������� ������ ������� ����� 
  add   bx,Car2.Name3     	; bx := Car1.Name3  +  Car2.Name3
  add   bx,Car3.Name3 	; 
  add   bx,Car4.Name3 	; 
movsxd  r15,ebx 
mov _res3,r15 ; 
movzx  ebx,Car1.Name4	; ���������� ������ ������� ����� 
  add   bx,Car2.Name4     	; bx := Car1.Name4  +  Car2.Name4
  add   bx,Car3.Name4 	; 
  add   bx,Car4.Name4 	; 
movsxd  r15,ebx 
mov _res4,r15 ; 
movzx  ebx,Car1.Name5	; ���������� ������ ������� ����� 
  add   bx,Car2.Name5     	; bx := Car1.Name5  +  Car2.Name5
  add   bx,Car3.Name5 	; 
  add   bx,Car4.Name5 	; 
movsxd  r15,ebx 
mov _res5,r15 ;  
movzx  ebx,Car1.Name6	; ���������� ������ ������� ����� 
  add   bx,Car2.Name6     	; bx := Car1.Name6  +  Car2.Name6
  add   bx,Car3.Name6 	; 
  add   bx,Car4.Name6 	; 
movsxd  r15,ebx 
mov _res6,r15 ; 
invoke wsprintf,ADDR st2,ADDR txt1,_res1,_res2,_res3,_res4,_res5,_res6   ; ������� ��������������

  mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
    mov params.hwndOwner,0     ; ���������� ���� ���������
    invoke GetModuleHandle,0   ; ��������� ����������� ���������
    mov params.hInstance,rax   ; ���������� ����������� ���������
        lea rax,st2
    mov params.lpszText,rax   ; ����� ��������
        lea rax,titl1
    mov params.lpszCaption,rax     ; ����� ������� ����
    mov params.dwStyle,MB_USERICON ; ����� ����
    mov params.lpszIcon,IDI_ICON    ; ������ ������
    mov params.dwContextHelpId,0  ;�������� �������
    mov params.lpfnMsgBoxCallback,0 ;
    mov params.dwLanguageId,LANG_NEUTRAL ; ���� ��������
        lea rcx,params
   invoke MessageBoxIndirect
invoke ExitProcess, 0 
entry_point endp
end	

