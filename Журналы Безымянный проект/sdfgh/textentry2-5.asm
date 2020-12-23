 include \masm64\include64\masm64rt.inc
.data?
      hInstance dq ? ; ����� ����
      hIcon     dq ? ; ����� ������
      hImg1     dq ? ; ����� �������
      tEdit     dq ? ; ����� ���� �����
	  buffer BYTE 260 dup(?) ;;; ��� �������� ������
.data
	  pbuf dq buffer ;;; ��� MessageBox,�.�.�� ������������ ADDR
rus db  'Russian_Russia.866',0      ; ������� ������

.code
entry_point proc
mov hInstance, rvcall(GetModuleHandle,0); ����� ������������ ������ (��.����)
mov hIcon, rv(LoadImage,hInstance,10,IMAGE_ICON,128,128, LR_DEFAULTCOLOR)
    invoke DialogBoxParam,hInstance,100,0,ADDR main,hIcon
  .exit
entry_point endp

main proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
    .switch uMsg
      .case WM_INITDIALOG
rcall SendMessage,hWin,WM_SETICON,1,lParam ; ���������� ������ � ������ ���������
 mov hImg1,rvcall(GetDlgItem,hWin,102); ��������� ���������� ������ ���������� � �������� ����. ����
rcall SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; ������ � ���������� �������
      .case WM_COMMAND
        .switch wParam
          .case 103    ; ������ <���� ������>
mov hIcon,rv(LoadImage,hInstance,11,IMAGE_ICON,128,128,LR_DEFAULTCOLOR)
invoke DialogBoxParam,hInstance,200,0,ADDR GetUserText,hIcon
       test rax, rax  ; ������ �� ������ ������
       jz notext
rcall MessageBox,hWin,pbuf,"���������������� �����", MB_ICONQUESTION
notext:
          .case 101   ; ������ <Close>
            jmp exit_dialog  
        .endsw
      .case WM_CLOSE
exit_dialog:
        rcall EndDialog,hWin,0
    .endsw
    xor rax, rax
    ret
main endp

GetUserText proc hWin:QWORD,uMsg:QWORD,wParam:QWORD, lParam:QWORD
.switch uMsg
      .case WM_INITDIALOG ; SendMessage ���������� �������� ��������� ����
rcall SendMessage,hWin,WM_SETICON,1,lParam ; ������ � ������ ��������� 
  mov hImg1, rvcall(GetDlgItem,hWin,205); ��������� ����������
rcall SendMessage,hImg1,STM_SETIMAGE,IMAGE_ICON,lParam ; ������ � ���������� �������
  mov tEdit, rvcall(GetDlgItem,hWin,201)
invoke SetFocus, tEdit ; ��������� ������� � ���� ����� 
  .case WM_COMMAND
.switch wParam
   .case 202
rcall GetWindowText,tEdit,pbuf,sizeof buffer; �������� ����� �� ������ ������
            .if rax == 0
rcall MessageBox,hWin,"������� ����� ��� ������� Cancel","����� �����������", MB_ICONWARNING
 rcall SetFocus,tEdit ; ��������� ������ �� ���� Edit
            .else
              rcall EndDialog,hWin, 1 
            .endif
   .case 203
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
