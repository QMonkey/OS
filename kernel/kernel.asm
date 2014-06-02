%include "constant.inc"

	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax

	mov	ax, message
	mov	bp, ax
	mov	ah, 13h
	mov	al, 01h
	mov	cx, message_len
	mov	dx, 0
	mov	bx, 000ch
	int	10H

halt:
	hlt
	jmp	halt

message:
	db	'Hello, I am kernel. You are in 32 bit protect mode! Nice to meet you!'
message_len	equ	$ - message

	resb	2046 - ($ - $$)
	db	55h, 0aah