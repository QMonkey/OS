; Protect Mode Segment Descriptor
%macro PMDescriptor 3
	dw	%2 & 0FFFFh				; Limit
	dw	%1 & 0FFFFh				; Base 1
	db	(%1 >> 16) & 0FFh			; Base 2
	dw	((%2 >> 8) & 0F00h) | (%3 & 0F0FFh)	; Attr 1 + Base 2 + Attr 2
	db	(%1 >> 24) & 0FFh			; Base 3
%endmacro
