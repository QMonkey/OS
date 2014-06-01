%include "constant.inc"

org	0100h
	jmp	start

start:
	mov	ax, .prompt
	mov	bp, ax
	mov	ah, 13h
	mov	al, 01h
	mov	cx, .str_len
	mov	dx, 0
	mov	bx, 000ch
	int	10H

.prompt:
	db	'wagaga'
	.str_len	equ	$-.prompt
	resb	LD_SIZE - ($ - $$)
	db	55h, 0aah