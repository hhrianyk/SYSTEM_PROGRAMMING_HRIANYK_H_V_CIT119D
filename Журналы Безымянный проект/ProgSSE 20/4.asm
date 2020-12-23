include \masm64\include64\masm64rt.inc
.data
	buf BYTE 128 dup(?)	
	pBuf QWORD buf	
	arr1 REAL8 1.0, 2.0, 4.0, 16.0
	;	      a    b     c    d
      temp1 real8 0.
.code     ; ab/c + sqrt(d)	
calculate proc array: QWORD
	mov rax, array
	movsd xmm0, real8 ptr[rax + sizeof real8 * 0]	
	mulsd xmm0, real8 ptr[rax + sizeof real8 * 1]
	DIVSD xmm0, real8 ptr[rax + sizeof real8 * 2]		
	SQRTSD xmm1, real8 ptr[rax + sizeof real8 * 3]
	addsd xmm0, xmm1
     ; vcvttsd2si rax,xmm0
     movsd temp1,xmm0
      RET	
calculate endp

entry_point proc
	rcall calculate, offset arr1
	rcall fptoa, temp1, pBuf
	mcat pBuf, pBuf, " = 1.0 * 2.0 / 4.0 + sqrt(16.0)"
	invoke MsgboxI, 0, pBuf, "Результаты", 0, 0
	.exit
entry_point endp
end	