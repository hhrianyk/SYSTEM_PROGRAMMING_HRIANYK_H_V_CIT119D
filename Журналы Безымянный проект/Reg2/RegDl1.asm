.686                        ; ��������� ���������� ���� �������������
.model  flat, stdcall  ; �������� ����� ����� ������ �� ����� �� Windows
option casemap:none                     ; �������� ����� �� �������  ����
include \masm32\include\windows.inc ; ����� ��������, �������� �
include \masm32\macros\macros.asm
uselib user32,kernel32,masm32,advapi32,comctl32
 
WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
IDD_DLG1 = 1000
IDC_CREATEKEY = 1001
IDC_DELETEKEY = 1002
.data
  hInstance dd ?
  hWnd dd ?
  icce INITCOMMONCONTROLSEX <>
szREGSZ db 'REG_SZ',0
szTestKey db 'Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID',0
setValue db "0",0
ValSize1 db 4,0
szValueName1 db "NoTrayContextMenu",0
hKey dd ?
lpdwDisp dd ? 
.code
start:
    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX ; ������ ��������� � ������
invoke InitCommonControlsEx, offset icce ;������������ ������ ������������ ������ ����������
invoke GetModuleHandle, NULL
    mov hInstance, eax
invoke DialogBoxParam, hInstance,IDD_DLG1,0,offset WndProc,0;
     invoke ExitProcess,eax
 
WndProc proc hWin :DWORD, uMsg :DWORD, wParam :DWORD, lParam :DWORD
.if uMsg==WM_INITDIALOG ; 
.elseif uMsg==WM_COMMAND ; 
    .if wParam==IDC_CREATEKEY ; 
invoke RegCreateKeyEx,HKEY_CURRENT_USER,ADDR szTestKey,0,ADDR szREGSZ,REG_OPTION_VOLATILE,\ ;����� �����
 KEY_ALL_ACCESS,0,ADDR hKey,ADDR lpdwDisp ; ����� ��� �������� ���������� � ��������� �����
	  .IF eax == ERROR_SUCCESS   ;���� ������ ������� ?
invoke RegSetValueEx,\ 	; ������������ �������� ��� ���������� �����
 hKey,ADDR szValueName1,\ ;��� ����� ��� ���������
 0,REG_SZ,ADDR setValue,ValSize1 ; ������ ����� � ������
invoke RegCloseKey,hKey  ; ������������� ��������� ����� ��� �������� 
 invoke MessageBox,0,chr$("���� ������� ������"),chr$("������"),MB_ICONINFORMATION
	  .ELSEIF
 invoke MessageBox,0,chr$("���� �� ������"),chr$("������"),MB_ICONINFORMATION
	  .ENDIF
      
	.ELSEIF wParam==IDC_DELETEKEY ;
invoke RegDeleteKey,HKEY_CURRENT_USER,ADDR szTestKey 
	  .IF eax == ERROR_SUCCESS ;  ���� ������ ������� ?
invoke RegCloseKey,addr hKey ;�������� ����������� ����� � ��������� �������
invoke MessageBox,0,chr$("���� ������� �����"),chr$("������"),MB_ICONINFORMATION
      .ELSEIF
invoke MessageBox,0,chr$("���� �� �����"),chr$("������"),MB_ICONINFORMATION
  	  .ENDIF
	  .else
.endif
.elseif uMsg==WM_CLOSE ;��� ��������
invoke EndDialog, hWin, 0
.else
mov eax, FALSE
ret
.endif
xor eax,eax
ret
WndProc ENDP
end start
