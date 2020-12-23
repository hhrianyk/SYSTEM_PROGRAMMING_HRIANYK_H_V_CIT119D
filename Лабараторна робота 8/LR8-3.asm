title  ; masm64
include \masm64\include64\masm64rt.inc
include LR8-3.inc

.data ;

      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 

title1 db "���.8",0   

txt01 db "�������� �������� ���������� �������� �� FPU, SSE, AVX � ����� �������� �� ������� ����� �� ���������.",0
txt02 db "ab/sqrt(c) � d/e   ",0
txt03 db "13,3,16,41,10",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0
txt04 db "����� ����� FPU =  %d ",10,10,"����� ����� SSE =  %d ",10,10,
"����� ����� AVX =  %d ",0 

txt041 db "����� ����� FPU =  %d ",0
txt042 db "����� ����� SSE =  %d ",0
txt043 db "����� ����� AVX =  %d ",0

txt051 db "��������� FPU =  %d ",0
txt052 db "��������� SSE =  %d ",0
txt053 db "��������� AVX =  %d ",0
 

buf1 dq 9 dup(0),0; �����
buf2 dq 3 dup(0),0
buf3 dq 3 dup(0),0
buf4 dq 3 dup(0),0

buf5 dq 3 dup(0),0
buf6 dq 3 dup(0),0
buf7 dq 3 dup(0),0


tFpu dq 0
tSse dq 0
tAvx dq 0

rFpu dd 145.75
rSse dd 0.0
rAvx dd 0
 
h1 dq	?	; ������������� ������
h2 dq	?	; ������������� ������
h3 dq	?	; ������������� ������
hEventStart HANDLE ? ;����� �������
temp dd 0
.code
	
proc1 proc ;  ��������� 
 rdtsc
xchg r14,rax 
finit
lea rsi,mas1  ; ����� ������ ������� mas1

 fild dword ptr  [rsi]  ; �������� ������ �����
FIMUL dword ptr  [rsi+4]
fild dword ptr [rsi+8]
FSQRT
FDIVP
fild dword ptr [rsi+12]
FIDIV dword ptr [rsi+16]
FSUB
fistp dword ptr rFpu 

rdtsc
sub rax,r14
mov tFpu,rax

ret
proc1 endp ;

proc2 proc	; ��������� 
rdtsc
xchg r14,rax 
 lea rsi,a1   ; ����� ������ ������� mas1
 
	 movups xmm1, [rsi]  ;  
      lea rsi,b1
	 movups xmm2, [rsi]  ; 
       mulps xmm1,xmm2;
             lea rsi,c1
      movups  xmm2, [rsi];
      SQRTps xmm2,xmm2
      DIVps xmm1,xmm2
                  lea rsi,d1
      movups xmm2,[rsi]
      lea rsi,e1
      movups xmm3,[rsi]
      DIVps xmm2, xmm3
      SUBps xmm1,xmm2
      cvttss2si eax,xmm1 
       movsxd r10,eax 
         mov   rSse,eax


rdtsc
sub rax,r14
mov tSse,rax
ret
proc2 endp	;


proc3 proc	; ��������� 
rdtsc
xchg r14,rax 
 
 lea rsi,a1   ; ����� ������ ������� mas1
 
	 vmovups ymm1, [rsi]  ; 
       lea rsi,b1   ; ����� ������ �������  

       vmulps  ymm1,ymm1, [rsi];
       lea rsi,c1   ; ����� ������ ������� 

       vmovups  ymm2, [rsi];
      vsqrtps  ymm2,ymm2
      vdivps ymm1,ymm1,ymm2
      lea rsi,d1   ; ����� ������ ������� 
      vmovups xmm2, [rsi]
      lea rsi,e1   ; ����� ������ ������� 
      VDIVPS ymm2,ymm2,   [rsi]
      VSUBPS ymm1,ymm1,ymm2
      ; VCVTTSD2SI  eax,ymm1 
      vmovups rAvx,ymm1 



rdtsc
sub rax,r14
mov tAvx,rax
ret
proc3 endp	;

entry_point proc
lea rax, proc1   ; �������� ������ ��������� 
invoke CreateThread,0,0,rax,0,0,addr h1 ; ������� �������
lea rax, proc2 ; �������� ������ ��������� 
invoke CreateThread,0,0,rax,0,0,addr h2; ������� �������
lea rax, proc3 ; �������� ������ ��������� 
invoke CreateThread,0,0,rax,0,0,addr h3; ������� ������
invoke CreateEvent,0,FALSE,FALSE,0; �������� �������
mov hEventStart,rax    ; ���������� ������ �������
invoke WaitForSingleObject,hEventStart,1000

invoke wsprintf,addr buf1,ADDR txt04,tFpu,tSse,tAvx;
invoke wsprintf,addr buf2,  ADDR txt041,tFpu;
invoke wsprintf,addr buf3,ADDR txt042,tSse;
invoke wsprintf,addr buf4,ADDR txt043,tAvx;

invoke wsprintf,addr buf5,ADDR txt051,rFpu;
invoke wsprintf,addr buf6,ADDR txt052,rSse ;
invoke wsprintf,addr buf7,ADDR txt053,rSse;
 ;  

 mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,0,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp


mainW proc hWin:QWORD,uMsg:QWORD,wParam:QWORD,lParam:QWORD
     
    .switch uMsg
      .case WM_INITDIALOG ; ��������� � �������� ����. ����
        invoke SetWindowText,hWin,title1
        invoke SendMessage,hWin,WM_SETICON,1,lParam  ; ���������� ��������� ����
        invoke SendMessage,rv(GetDlgItem,hWin,101),\ ; ��������� ���� �� ����������� ������ ����������
               STM_SETIMAGE,IMAGE_ICON,lParam
           ; 102 - jpg
       ; mov hStatic, rv(GetDlgItem,hWin,101)
       ; invoke SendMessage,hStatic,STM_SETIMAGE,IMAGE_BITMAP,hBmp
        .return TRUE


      .case WM_COMMAND ; ��������� �� ���� ��� ������
        .switch wParam
 
          .case 103 ; ������
          invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10
          .case 102
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
          .case 104
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;
;/////////////////////////////////////////
           .case 105 ; ������
         invoke MsgboxI,hWin,ADDR buf5,"��������� FPU",MB_OK,10;  
;/////////////////////////////////////////

    .case 106 ; ������
         invoke MsgboxI,hWin,ADDR buf6,"��������� SSE",MB_OK,10;  
;/////////////////////////////////////////
    .case 107 ; ������
          invoke MsgboxI,hWin,ADDR buf7,"��������� AVX",MB_OK,10;  
 ;/////////////////////////////////////////
 
 .case 120 ; ������
        invoke MsgboxI,hWin,ADDR buf2,"TiCK FPU",MB_OK,10;  
 
;/////////////////////////////////////////
 .case 108 ; ������
       invoke MsgboxI,hWin,ADDR buf3,"TiCK SSE",MB_OK,10;  
 
;/////////////////////////////////////////
 .case 109 ; ������
    invoke MsgboxI,hWin,ADDR buf4,"TiCK AVX",MB_OK,10;  
 
;/////////////////////////////////////////
   
 .case 201    
           invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10;
           
 .case 202     
           invoke MsgboxI,hWin,ADDR txt02,"�����",MB_OK,10;
 .case 206     
           invoke MsgboxI,hWin,ADDR txt03,"�����",MB_OK,10;
                      
 .case 203
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
 .case 205
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;        
 .case 207
             invoke MsgboxI,hWin,ADDR buf1,"TiCK",MB_OK,10;    


        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp
    end

end