%include "constant.inc"
%include "protect_mode.inc"

	org	07c00h
	jmp	boot

; GDT
GDT:
	PMDescriptor 0, 0, 0
GDT_CODE32:
	PMDescriptor 0, Code32Len - 1, 98h + DA_32
GDT_VIDEO:
	PMDescriptor 0b8000h, 0ffffh, 92h
; GDT End

GdtLen	equ	$ - GDT
GdtPtr	dw	GdtLen - 1
	dd	0

SelectorCode32	equ	GDT_CODE32 - GDT
SelectorVideo	equ	GDT_VIDEO - GDT

boot:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, 0100h

;	mov	ax, rmStr
;	mov	bp, ax
;	mov	ah, 13h
;	mov	al, 01h
;	mov	cx, rmLen
;	mov	dx, 0
;	mov	bx, 000ch
;	int	10H

	xor	eax, eax
	mov	ax, cs
	shl	eax, 4
	add	eax, Code32
	mov	[GDT_CODE32 + 2], ax
	shr	eax, 16
	mov	[GDT_CODE32 + 4], al
	mov	[GDT_CODE32 + 7], ah

	xor	eax, eax
	mov	ax, ds
	shl	eax, 4
	add	eax, GDT
	mov	[GdtPtr + 2], eax

	lgdt	[GdtPtr]

	cli

	in	al, 92h
	or	al, 2
	out	92h, al

	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	dword	SelectorCode32: 0

Code32:
	mov	ax, SelectorVideo
	mov	gs, ax
	xor	edi, edi
	mov	edi, (80 * 11 + 79) * 2
	mov	ah, 0ch
	mov	al, 'P'
	mov	[gs:edi], ax

halt:
	hlt
	jmp	halt

Code32Len	equ	$-Code32

rmStr:
	db	"Real Mode", 0ah, 0dh
rmLen	equ	$-rmStr
pmStr:
	db	"Protect Mode", 0ah, 0dh
pmLen	equ	$-pmStr

	resb	510-($-$$)
	dw	0xaa55
