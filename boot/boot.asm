	org	07c00h

	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ax, message
	mov	bp, ax
	mov	cx, len
	mov	ax, 01301h
	mov	bx, 000ch
	mov	dl, 0
	int	10h

halt:
	hlt
	jmp	halt

message:
	db	"Hello, world!", 0ah, 0dh
len	equ	$-message
times	510-($-$$)	db	0
dw	0xaa55
