include \masm64\include64\masm64rt.inc
.data  
String db 'c:\masm64\bin64\DSC00386.JPG',0; ������ ���� � ������-������ bmp-�����

.code 
entry_point proc
 invoke SystemParametersInfo,SPI_SETDESKWALLPAPER,NULL,addr String,SPIF_SENDWININICHANGE 

invoke ExitProcess, NULL ; ����������� ���������� Windows  
entry_point endp
   end

