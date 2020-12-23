 
  include \masm64\include64\masm64rt.inc
  include \masm64\macros64\macros64.inc
  
    .data
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      hImg1     dq ? ; ����� �������
      tEdit     dq ? ; ����� ���� �����
 buffer BYTE 260 dup(?) ;;; ��� �������� ������
title1 db "���.8.2",0      
txt01 db "������ ���� ��������, �������� ��������, � �������� ������������ (calc.exe). �������� �������� �������� ���������� 5 ������, � �������� calc.exe ���������� 8 ������.",0
 
autor db "�����: ������ �.�., ��.ʲ�-119�",0


  pbuf dq buffer ;;; ��� MessageBox,�.�.�� ������������ ADDR
  rus db  'Russian_Russia.866',0      ; 
 
programname1 db  "c:\windows\system32\calc.exe",0
programname2 db  "LR8-2_1.exe",0
 

buf1 dd 0   ;
buf2 dq 3 dup(0),0; �����
P        dd ? ; ����� ���������� ��� �������������� ��������

startInfo dd ?
startInfo2 dd ?
processInfo PROCESS_INFORMATION <> ; ���������� � �������� � ��� ��������� ����
processInfo2 PROCESS_INFORMATION <> ; ���������� � �������� � ��� ��������� ����
 

.code
entry_point proc

 

     mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
     ;mov hBmp, rv(ResImageLoad,10,,128,128,LR_DEFAULTCOLOR)
     invoke DialogBoxParam,hInstance,1000,0,ADDR mainW,hIcon
    invoke ExitProcess,0
    ret
    entry_point endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
 mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,64,64,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,3000,0,ADDR GetUserText,hIcon
        test rax, rax  ; ������ �� ������ ������
       jz notext
       invoke wsprintf,addr buf2 ,ADDR pbuf
notext:
;/////////////////////////////////////////
    .case 106 ; ������
     rcall MessageBox, hWin,buf2,"  �����", MB_ICONQUESTION
   

;/////////////////////////////////////////
   .case 107 ; ������
    invoke  MsgboxI,hWin,"³������ ��������","�����������",MB_OK,10 
   invoke GetStartupInfo,ADDR startInfo ; ������������ ��������� STARTUPINFO
 invoke CreateProcess,ADDR programname2,NULL,NULL,NULL,FALSE,\
        NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo2
  ; invoke CloseHandle,processInfo2.hThread ; �������� ������ ������

   invoke CreateProcess,ADDR programname1,NULL,NULL,NULL,FALSE,\
         NORMAL_PRIORITY_CLASS,0,0,ADDR startInfo,ADDR processInfo

    invoke  Sleep, 5000
         invoke TerminateProcess,processInfo2.hProcess,0 ; ������ ������ 
   invoke  Sleep, 3000
invoke FindWindow, 0,"�����������"
   invoke GetWindowThreadProcessId,rax, addr P ;
    invoke  OpenProcess,PROCESS_TERMINATE,FALSE,P 
    or      rax,rax
    invoke  TerminateProcess,rax,0

   invoke TerminateProcess,processInfo.hProcess,0
invoke TerminateProcess,processInfo.hProcess,0 ; ������ ������ 
; rcall SendMessage,processInfo.hThread,WM_SYSCOMMAND,SC_CLOSE,0;
   
  invoke  MsgboxI,hWin,"������� �� ����","�����������",MB_OK,10 
           

  ;/////////////////////////////////////////
   
 .case 200    
           invoke MsgboxI,hWin,ADDR txt01,"��������",MB_OK,10;
           
 .case 203
          invoke MsgboxI,hWin,ADDR autor,"�����",MB_OK,10
 .case 205
             rcall SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,0;        
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp

;/////////////////////////////////////////
GetUserText proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG ; SendMessage ���������� �������� ��������� ����
invoke SendMessage,hWin,WM_SETICON,1,lParam ; ������ � ������ ��������� 
  mov hImg1, rvcall(GetDlgItem,hWin,304); ��������� ����������
invoke SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; ������ � ���������� �������
  mov tEdit, rvcall(GetDlgItem,hWin,301)
invoke SetFocus, tEdit ; ��������� ������� � ���� ����� 

.case WM_COMMAND
.switch wParam
   .case 302
rcall GetWindowText,tEdit,pbuf,sizeof buffer; �������� ����� �� ������ ������
            .if rax == 0
rcall MessageBox,hWin,"������ ����� ","����� �������", MB_ICONWARNING
 rcall SetFocus,tEdit ; ��������� ������ �� ���� Edit
            .else
             rcall EndDialog,hWin, 1 
            .endif
 .case 309
            jmp exit_dialog
   .endsw
      .case WM_CLOSE
exit_dialog:
       rcall EndDialog,hWin,0 
.endsw
    xor rax, rax
    ret
GetUserText endp
    end