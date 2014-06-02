%include "constant.inc"
%include "protect_mode.inc"

org	0100h
	jmp	start

gdt:
	PMDescriptor	0, 0, 0
gdt_code32:
	PMDescriptor	0, 0fffffh, DA_CER | DA_CD32 | DA_G4KB
gdt_data:
	PMDescriptor	0, 0fffffh, DA_DRW | DA_DB4GB | DA_G4KB
gdt_video:
	PMDescriptor	0b8000h, 0ffffh, DA_DRW | DA_DPL3

gdt_len	equ	$ - gdt
gdt_ptr:
	dw	gdt_len - 1
	dd	LD_BASE * 10h + gdt

selector_code32	equ	gdt_code32 - gdt
selector_data	equ	gdt_data - gdt
selector_video	equ	(gdt_video - gdt) | DA_DPL3

start:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, stack_top

	mov	ax, loading_kernel
	push	ax
	mov	ax, 0400h
	push	ax
	mov	ax, loading_kernel_len
	push	ax
	call	display_str
	add	sp, 6

	; Reset floppy
	xor	ah, ah
	xor	dl, dl
	int	13h

	mov	ax, KN_BASE
	mov	es, ax
	mov	bx, KN_OFFSET
	mov	ah, 02h
	mov al, 1
	xor	ch, ch
	mov	cl, 6
	xor dx, dx
	int	13h

	test	ah, ah
	jnz	load_err
	mov	ax, KN_BASE
	mov	es, ax
	mov	bx, KN_OFFSET
	mov	ax, [es: bx]
	cmp	ax, 0aa55h
	jne	load_err

	jmp	KN_BASE: KN_OFFSET

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
	mov	ax, 0500h
	push	ax
	mov	ax, load_err_msg_len
	push	ax
	call	display_str
	jmp	halt

halt:
	hlt
	jmp	halt

loading_kernel:
	db	"Loading kernel..."
loading_kernel_len	equ	$ - loading_kernel

load_err_msg:
	db	"Failed to load!"
load_err_msg_len	equ	$ - load_err_msg

load_successfully:
	db	"Successfully load the kernel!"
load_successfully_len	equ	$ - load_successfully

stack_segment:
	resb	200h
	stack_top	equ	LD_BASE * 10h + $

	resb	LD_SIZE - 2 - ($ - $$)
	db	55h, 0aah