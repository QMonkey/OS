%include "constant.inc"

org	0100h
	jmp	start

start:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax

	mov	ax, .prompt
	mov	bp, ax
	mov	ah, 13h
	mov	al, 01h
	mov	cx, .str_len
	mov	dx, 0600h
	mov	bx, 000ch
	int	10H

.prompt:
	db	"wagaga"
	.str_len	equ	$-.prompt
	resb	LD_SIZE - 2 - ($ - $$)
	db	55h, 0aah