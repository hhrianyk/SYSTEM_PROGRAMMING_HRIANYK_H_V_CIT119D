 
  include \masm64\include64\masm64rt.inc
  include \masm64\macros64\macros64.inc
    .data
      hInstance dq ? ; ���������� ��������
      hWnd      dq ? ; ���������� ����
      hIcon     dq ? ; ���������� ������
      hCursor   dq ? ; ���������� �������
      sWid      dq ? ; ������ �������� (�����. �������� �� x)
      sHgt      dq ? ; ������ �������� (�����. �������� �� y) 
title1 db "���.8",0      
 
txt01 db "��������� ��� ��������, ������������",0
txt02 db "����� HKLM\Software\Microsoft\WindowsNT\CurrentVersion\Winlogon",10," HKLM\ SoftWare\Microsoft\Windows\CurrentVersion. ",0
txt03 db "�����: LegalNoticeCaption, LegalNoticeText, RunOnce, RunOnceEx, RunServices, RunServicesOnce",0
autor db "�����: ������ �.�., ��.ʲ�-119�",0
 
szREGSZ db 'REG_SZ',0 
 
hKey dd ?
lpdwDisp dd ? 
 

.code
entry_point proc

  
     mov hInstance,rv(GetModuleHandle,0)
     mov hIcon,rv(LoadImage,hInstance,10,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
   ;  mov hBmp, rv(ResImageLoad,20,,128,128,LR_DEFAULTCOLOR)
    invoke DialogBoxParam,0,1000,0,ADDR mainW,hIcon
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
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
cmp rax,0 ;������ ������ ������� ?
jne m1
invoke RegSetValueEx,hKey,"LegalNoticeCaption", 0,REG_SZ,"Hello world",15 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m1
   invoke MessageBox,0,chr$("���� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m2 
   m1:
 invoke MessageBox,0,chr$("���� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m2: 
 invoke RegCloseKey, hKey  ; ������������� ��������� ����� ��� ��������
;/////////////////////////////////////////

    .case 106 ; ������
  invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 cmp rax,0 ;������ ������ ������� ?
jne m3  
invoke RegSetValueEx,hKey, "LegalNoticeText",0,REG_SZ,"My name...",15 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m3
   invoke MessageBox,0,chr$("���� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m4 
   m3:
 invoke MessageBox,0,chr$("���� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m4: 
 invoke RegCloseKey,hKey ; ������������� ��������� ����� ��� ��������
;/////////////////////////////////////////
    .case 107 ; ������
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnce",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;

invoke RegSetValueEx, hKey ,  "Masm32",0,REG_SZ,"FuturamaS2",10 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m5
   invoke MessageBox,0,chr$("���� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m6 
   m5:
 invoke MessageBox,0,chr$("���� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m6: 
 invoke RegCloseKey,hKey; ������������� ��������� ����� ��� ��������
 ;/////////////////////////////////////////
 
 .case 120 ; ������
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnceEX",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"szValueName",10 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m7
   invoke MessageBox,0,chr$("��������� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m8 
   m7:
 invoke MessageBox,0,chr$("��������� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m8: 
 invoke RegCloseKey,hKey; ������������� ��������� ����� ��� ��������
 
;/////////////////////////////////////////
 .case 108 ; ������
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices",10 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m9
   invoke MessageBox,0,chr$("��������� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m10 
   m9:
 invoke MessageBox,0,chr$("��������� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m10: 
 invoke RegCloseKey,hKey; ������������� ��������� ����� ��� ��������
 
;/////////////////////////////////////////
 .case 109 ; ������
invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServicesOnce",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 
invoke RegSetValueEx,  hKey,  "Masm64",0,REG_SZ,"Dell 11",10 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne ms7
   invoke MessageBox,0,chr$("��������� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp ms8 
   ms7:
 invoke MessageBox,0,chr$("��������� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	ms8: 
 invoke RegCloseKey,hKey; ������������� ��������� ����� ��� ��������
 
;/////////////////////////////////////////
.case 110
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServicesOnce"
invoke MessageBox,0,chr$("���� ������� �����"),chr$("������"),MB_ICONINFORMATION
.case 111
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunOnceEX"
invoke MessageBox,0,chr$("���� ������� �����"),chr$("������"),MB_ICONINFORMATION
 .case 112
invoke RegDeleteKey,HKEY_LOCAL_MACHINE,"SoftWare\Microsoft\Windows\CurrentVersion\RunServices"
invoke MessageBox,0,chr$("���� ������� �����"),chr$("������"),MB_ICONINFORMATION
  	  
 

 ;/////////////////////////////////////////
           .case 114 ; ������
 invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
cmp rax,0 ;������ ������ ������� ?
jne m11
invoke RegSetValueEx,hKey,"LegalNoticeCaption", 0,REG_SZ,"Hello world",0 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m11
   invoke MessageBox,0,chr$("������� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m12 
   m11:
 invoke MessageBox,0,chr$("������� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m12: 
 invoke RegCloseKey, hKey  ; ������������� ��������� ����� ��� ��������
;/////////////////////////////////////////

    .case 115 ; ������
  invoke RegCreateKeyEx,HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows NT\CurrentVersion\Winlogon",0,ADDR szREGSZ,REG_OPTION_VOLATILE,KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp;
 cmp rax,0 ;������ ������ ������� ?
jne m13  
invoke RegSetValueEx,hKey, "LegalNoticeText",0,REG_SZ,"My name...",0 ; ������ ����� � ������
 cmp rax,0 ;�������� ����� �� �������� 
 jne m13
   invoke MessageBox,0,chr$("������� ������� ������"),chr$("������"),MB_ICONINFORMATION
 	jmp m14 
   m13:
 invoke MessageBox,0,chr$("������� ������� �� ������"),chr$("������"),MB_ICONINFORMATION
 	m14: 
 invoke RegCloseKey,hKey ; ������������� ��������� ����� ��� ��������


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
        .endsw
      .case WM_CLOSE ; ���� ���� ��������� � �������� ����
         invoke EndDialog,hWin,0 ; 
    .endsw
    xor rax, rax
    ret
mainW endp
    end