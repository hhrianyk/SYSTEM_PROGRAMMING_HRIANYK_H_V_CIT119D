include \masm64\include64\masm64rt.inc ; ���������� ��� �����������
 IDI_ICON  EQU 1001

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

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
    classname db "template_class",0
    caption db "����� � Windows-����",0
    Hello db "������ ��������� ����������� � windows ����!!!",10,
	" masm64",0


;����� ��� Window
titl1 db "���.4-1.1 ���������. masm64",0
txt1 db "��������: ���� ������� 4 � 6. ��������� ���� �������� ������� �������.", 10,10,0
txt2 db "������� ������ - ��� �������:",10,0
txt3 db "          |01|10|02|03|01|01|",10,0
txt4 db "          |01|10|02|03|01|01|",10,0
txt5 db "          |03|12|10|11|03|01|",10,0
txt6 db "          |04|13|14|15|31|01|",10,0
txt7 db "--------------------------------------",10,0
txt8 db "����: |%d|%d|%d|%d|%d|%d| ",10,0


autor db "�����: ������ �.�., ��.ʲ�-119�",0

st2 db 32 dup(?),0 ; 
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
invoke wsprintf,ADDR st2,ADDR txt8,_res1,_res2,_res3,_res4,_res5,_res6   ; ������� ��������������

  mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,IDI_ICON,IDI_ICON) ; �������� � ���������� ����������a ������
  mov hCursor,rv(LoadCursor,0,IDC_ARROW) ; �������� ������� � ����������
  mov sWid,rv(GetSystemMetrics,SM_CXSCREEN) ; ��������� ���. �������� �� � ��������
  mov sHgt,rv(GetSystemMetrics,SM_CYSCREEN) ; ��������� ���. �������� �� y ��������
call main
    invoke ExitProcess,0
    ret
entry_point endp	

main proc
    LOCAL wc  :WNDCLASSEX ; ���������� ��������� ����������
    LOCAL lft :QWORD ;  ���. ���������� ���������� � ����� 
    LOCAL top :QWORD  ; � ���������� ������ �� ����� ���. ����.
    LOCAL wid :QWORD
    LOCAL hgt :QWORD
    mov wc.cbSize,SIZEOF WNDCLASSEX ; �����. ������ ���������
    mov wc.style,CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW ; ����� ����
    mov wc.lpfnWndProc,ptr$(WndProc) ; ����� ��������� WndProc
    mov wc.cbClsExtra,0 ; ���������� ������ �� ��������� ������
    mov wc.cbWndExtra,0 ; ���������� ������ �� ��������� ����
    mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
   mrm wc.hIcon,  hIcon ; ����� ������
   mrm wc.hCursor,hCursor ; ����� �������
   mrm wc.hbrBackground,4 ; ���� ����
    mov wc.lpszMenuName,0 ; ���������� ��� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; �� ������
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
   mov wid, 600 ; ������ ����������������� ���� � �������
   mov hgt, 340 ; ������ ����������������� ���� � �������
    mov rax,sWid ; �����. �������� �������� �� x
    sub rax,wid ; ������ � = �(��������) - �(���� �����������)
    shr rax,1   ; ��������� �������� �
    mov lft,rax ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
  ; ---------------------------------
  ; centre window at calculated sizes
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
            ADDR classname,ADDR titl1, \
            WS_OVERLAPPED or WS_VISIBLE or WS_SYSMENU,\
            lft,top,wid,hgt,0,0,hInstance,0
    mov hWnd,rax ; ���������� ����������� ����
  call msgloop
    ret
main endp

msgloop proc
    LOCAL msg  :MSG
    LOCAL pmsg :QWORD
    mov pmsg,ptr$(msg) ; ��������� ������ ��������� ���������
    jmp gmsg           ; jump directly to GetMessage()
  mloop:
    invoke TranslateMessage,pmsg
    invoke DispatchMessage,pmsg ; �������� �� ������������ � WndProc
  gmsg:
    test rax, rv(GetMessage,pmsg,0,0,0) ; ���� GetMessage �� ������ ����
    jnz mloop
    ret
msgloop endp

WndProc proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
LOCAL hdc:HDC   	; �������������� ����� �� ����������� ����
LOCAL ps:PAINTSTRUCT ; �� ��������� PAINTSTRUCT
LOCAL rect:RECT      ; �� ��������� ��������� RECT

.switch uMsg
 .case WM_DESTROY ; ���� ���� ��������� ��� ����������� ����
        invoke PostQuitMessage,NULL
 .case WM_PAINT   ; ���� ���� ��� � ������������� 
  invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
  invoke GetClientRect,hWnd,ADDR rect ; ��������� � ��������� rect 
                             ; ������������� ����
  invoke  DrawText, hdc,ADDR autor,0, ADDR rect, \ ; ��������� ������
   DT_SINGLELINE or DT_CENTER or DT_VCENTER
   invoke TextOut,hdc,10,10,ADDR txt1,74
   invoke TextOut,hdc,50,40,ADDR txt2,32
   invoke TextOut,hdc,50,70,ADDR txt3,32
   invoke TextOut,hdc,50,100,ADDR txt4,32
   invoke TextOut,hdc,50,130,ADDR txt5,32
   invoke TextOut,hdc,50,160,ADDR txt6,31
   invoke TextOut,hdc,50,180,ADDR txt7,40
   invoke TextOut,hdc,50,200,ADDR st2,32
   invoke TextOut,hdc,80,250,ADDR autor,32

  invoke EndPaint,hWnd, ADDR ps                ; ���������� ���������
  .endsw
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end
