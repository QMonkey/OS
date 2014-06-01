%include "constant.inc"

org	07c00h
	jmp	boot

boot:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov	fs, ax
	mov	gs, ax
	mov ss, ax
	mov sp, 07b00h

	; Clear screen
	mov	ah, 06h
	xor	al, al
	mov	bh, 07h
	xor	bl, bl
	xor	cx, cx
	mov	dx, 184fh
	int	10h

	; Display booting
	mov	ax, cs
	mov	es, ax
	mov	ax, booting
	push	ax
	xor	ax, ax
	push	ax
	mov	ax, booting_len
	push	ax
	call	display_str
	add	sp, 6

	; Display loading
	mov	ax, cs
	mov	es, ax
	mov	ax, loading
	push	ax
	mov	ax, 0100h
	push	ax
	mov	ax, loading_len
	push	ax
	call	display_str
	add	sp, 6

	; Reset floppy
	xor	ah, ah
	xor	dl, dl
	int	13h

	mov	ax, LD_BASE
	mov	es, ax
	mov	bx, LD_OFFSET
	mov	ah, 02h
	mov al, 4
	xor	ch, ch
	mov	cl, 2
	xor dx, dx
	int	13h

	test	ah, ah
	jnz	load_err

	; Display load_successfully
	mov	ax, cs
	mov	es, ax
	mov	ax, load_successfully
	push	ax
	mov	ax, 0200h
	push	ax
	mov	ax, load_successfully_len
	push	ax
	call	display_str
	add	sp, 6

	; Display checking
	mov	ax, cs
	mov	es, ax
	mov	ax, checking
	push	ax
	mov	ax, 0300h
	push	ax
	mov	ax, checking_len
	push	ax
	call	display_str
	add	sp, 6

	; Check loader
	mov	ax, LD_BASE
	mov	es, ax
	mov	bx, LD_OFFSET
	mov	ax, [es: bx + LD_SIZE - 2]
	cmp	ax, 0aa55h
	jne	invalid_loader_err

	jmp	LD_BASE: LD_OFFSET

display_str:
	push	bp
	mov	bp, sp
	push	ax
	push	bx
	push	cx
	push	dx

	mov	cx, [bp + 4]
	mov	dx, [bp + 6]
	mov	ax, [bp + 8]
	mov	bp, ax
	mov	ax, 1300h
	mov	bx, 0007h
	int	10h

	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret

load_err:
	; Display load_err and halt
	mov	ax, cs
	mov	es, ax
	mov	ax, load_err_msg
	push	ax
	mov	ax, 0200h
	push	ax
	mov	ax, load_err_msg_len
	push	ax
	call	display_str
	jmp	halt

invalid_loader_err:
	; Display invalid_loader_err and halt
	mov	ax, cs
	mov	es, ax
	mov	ax, invalid_loader_err_msg
	push	ax
	mov	ax, 0400h
	push	ax
	mov	ax, invalid_loader_err_msg_len
	push	ax
	call	display_str
	jmp	halt

halt:
	hlt
	jmp	halt
	
booting:
	db	"Booting..."
booting_len	equ	$ - booting

loading:
	db	"Loading..."
loading_len	equ	$ - loading

load_err_msg:
	db	"Failed to load!"
load_err_msg_len	equ	$ - load_err_msg

load_successfully:
	db	"Successfully load the loader!"
load_successfully_len	equ	$ - load_successfully

checking:
	db	"Checking..."
checking_len	equ	$ - checking

invalid_loader_err_msg:
	db	"Invalid loader!"
invalid_loader_err_msg_len	equ	$ - invalid_loader_err_msg

	resb	510 - ($ - $$)
	db	55h, 0aah