include \masm64\include64\masm64rt.inc

.data

titl db "�������� LR8-2_1",0
 .code 	          	
entry_point proc txt2:QWORD
    invoke MessageBox,0, "³������ �������� ��������",addr titl,MB_ICONINFORMATION          
invoke ExitProcess, 0 ; ����������� ���������� �� Windows � ������������ ��������
entry_point endp; ����� ������ ��������
   end
