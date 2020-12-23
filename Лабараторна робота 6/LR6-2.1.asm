include \masm64\include64\masm64rt.inc
.data	

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
classname db "template_class",0
caption db "��������� ������",0
MouseClick db 0  ; ���� ������� 
myXY POINT <>  ; ��������� ��� �- �� �-���������

 mas dd 500 ; 
 m dd  0.25 
 R dd 1.0
 r dd 1.0
 t dd 0.0 ; ������� ���������� 

 delta dd 0.1175 ; ���� ������
 xdiv2 dq ?    ; �������� �� X 
 ydiv2 dq ?    ; �������� �� Y
 tmp dd 0       ; ��������� ����������
 divK dd 100.0 ; ���������� �����������
 xr dd 0. 	; ���������� �������
 yr dd 0
 temp1 dd 0


 text01 db "x=%d y=%d",0
 AppName db "Rina",0
buf1 dq 3 dup(0),0

.code
entry_point proc
 


 invoke GetSystemMetrics,SM_CXSCREEN ; ��������� ������ ������ � ��������
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� �
  mov xdiv2,rax
 invoke GetSystemMetrics,SM_CYSCREEN ; ��������� ������ ������ � ��������
  shr rax,1 ; ������� �� 2 � ����������� �������� ������ �� Y
  mov ydiv2,rax
 
 mov r10d,mas ; ���������� ���������� ������
 mov temp1,r10d
finit
l1:                         ; x = x0 + �fcosf

fld m   ; m
fmul t ; m*alpha
fcos       ;cos(m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)cos(m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FCOS       ;cos(t-r*t)
FMUL m     ;m*cos(t-rt)
FADD       ;(R-RM)cos(m*t)+m*cos(t-rt)
FMUL divK  ; �����*((R-RM)cos(m*t)+m*cos(t-rt))
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 




fld m
fmul t ; m*alpha
fsin       ;sin (m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)sin (m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FSIN       ;sin (t-r*t)
FMUL m     ;m*cos(t-rt)
FSUB      ;(R-RM)sin (m*t)-m*sin (t-rt)
FMUL divK  ; �����*((R-RM)sin (m*t)+m*sin (t-rt))FMUL divK
fstp tmp
fild ydiv2      
fsub tmp  
 
fistp dword ptr yr ; ���������� X ��� ��������� �� �����


 
invoke Sleep,1             ; ��������
invoke SetCursorPos,xr,yr ; ������������ ������� �� xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3
dec temp1   ; ���������� ��������
jz l2       ; ����������� ���������
jmp l1	; ����� �� �����
l2: 
  mov hInstance,rv(GetModuleHandle,0) ; ��������� � ���������� ����������a ��������
  mov hIcon,  rv(LoadIcon,hInstance,10) ; �������� � ���������� ����������a ������
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
    mov wc.cbClsExtra,0 ; ���������� ������ ��� ��������� ������
    mov wc.cbWndExtra,0 ; ���������� ������ ��� ��������� ����
   mrm wc.hInstance,hInstance ; ���������� ���� ����������� � ���������
   mrm wc.hIcon,  hIcon ; ����� ������
   mrm wc.hCursor,hCursor ; ����� �������
   mrm wc.hbrBackground,5 ; ���� ����
    mov wc.lpszMenuName,0 ; ���������� ���� � ��������� � ������ ������� ����
    mov wc.lpszClassName,ptr$(classname) ; ��� ������
   mrm wc.hIconSm,hIcon
 invoke RegisterClassEx,ADDR wc ; ����������� ������ ����
   mov wid, 420 ; ������ ����������������� ���� � ��������
   mov hgt, 420 ; ������ ����������������� ���� � ��������
    mov rax,sWid ; �����. �������� �������� �� x
    sub rax,wid ; ������ � = �(��������) - �(���� ������������)
    shr rax,1   ; ��������� �������� �
    mov lft,rax ;

    mov rax, sHgt ; �����. �������� �������� �� y
    sub rax, hgt ;
    shr rax, 1 ;
    mov top, rax ;
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES, \
         ADDR classname,ADDR caption, \
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
LOCAL hdc:HDC   	; �������������� ����� ��� ����������� ����
LOCAL ps:PAINTSTRUCT ; ��� ��������� PAINTSTRUCT
LOCAL rect:RECT      ; ��� ��������� ��������� RECT
.switch uMsg
 .case WM_DESTROY ; ���� ���� ��������� ��� ����������� ����
        invoke PostQuitMessage,NULL
 .case WM_LBUTTONDOWN    ; ��������� �� ����� ������� 
mov rax,lParam  ; 32-��������� ���������� ������� �����
and rax,0ffffh  ; ��������� ������� ����� - ���������� �
mov myXY.x,eax	; ���������� ���������� X
mov rax,lParam  ; 32-��������� ���������� ������� �����
shr rax,16 		; ����� ������ �� 4 ����� ��� ���������  Y 
mov myXY.y,eax  ; ���������� ���������� Y
;mov MouseClick,TRUE 	; ������������� ��������� ���������
invoke InvalidateRect,hWnd,0,TRUE ; ��� ������������� ����
 .case WM_PAINT      ; ���� ���� ��������� � ������������� 
invoke BeginPaint,hWnd,ADDR ps ; ���������� ���������
mov  hdc,rax 		  ; ���������� ���������
      		; �������� ������������ ������
   mov r10d,mas ; ���������� ���������� ������
 mov temp1,r10d
 invoke InvalidateRect,hWnd,0,TRUE ; ����� ������� � WM_PAINT
finit
    invoke BeginPaint,hWnd, ADDR ps ; ����� ���������������� ���������
  mov hdc,rax            ; ���������� ���������
 
l1:   
                      
invoke wsprintf,ADDR buf1,ADDR text01,xr,yr                        
   invoke TextOut,hdc, 10,30,ADDR buf1,15 

 sub xr, 480
 sub yr, 200

 invoke TextOut,hdc,xr,yr,\ ; ���������� ������ ������
      addr AppName ,4; ����� �������� ������ � ���. ������ ������

 

  fld m   ; m
fmul t ; m*alpha
fcos       ;cos(m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)cos(m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FCOS       ;cos(t-r*t)
FMUL m     ;m*cos(t-rt)
FADD       ;(R-RM)cos(m*t)+m*cos(t-rt)
FMUL divK  ; �����*((R-RM)cos(m*t)+m*cos(t-rt))
	fild xdiv2      
	fadd 
 
fistp dword ptr xr 
 

fld m
fmul t ; m*alpha
fsin       ;sin (m*t)
fld R      ; R
fld R      ; R
Fmul m     ; Rm
FSUB       ; R-RM
FMUL       ;(R-RM)sin (m*t)
fld t      ; t
fld t      ; t
FMUL m     ; R*t
FSUB       ; t-R*t
FSIN       ;sin (t-r*t)
FMUL m     ;m*cos(t-rt)
FSUB      ;(R-RM)sin (m*t)-m*sin (t-rt)
FMUL divK  ; �����*((R-RM)sin (m*t)+m*sin (t-rt))FMUL divK
fstp tmp
fild ydiv2      
fsub tmp  
 
fistp dword ptr yr ; ���������� X ��� ��������� �� �����
 
 
invoke Sleep,4             ; ��������
invoke SetCursorPos,xr,yr ; ������������ ������� �� xr, yr 
movss XMM3,delta
addss XMM3,t
movss t,XMM3

dec temp1   ; ���������� ��������
jz l2       ; ����������� ���������
jmp l1	; ����� �� �����
l2: 
 
invoke EndPaint,hWnd, ADDR ps			; ���������� ������ ������
      .endif
 
 
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
  ret
 WndProc endp
    end