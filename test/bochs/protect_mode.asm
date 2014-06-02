%include "constant.inc"
%include "protect_mode.inc"

	org	0100h
	jmp	boot

; GDT
GDT: PMDescriptor 0, 0, 0
GDT_CODE32:
	PMDescriptor 0, Code32Len - 1, DA_CE | DA_CD32
GDT_CODE16:
	PMDescriptor 0, Code16Len - 1, DA_CE
GDT_VIDEO:
	PMDescriptor 0b8000h, 0ffffh, DA_DRW
GDT_NORMAL:
	PMDescriptor 0, 0ffffh, DA_DRW
; GDT End

GdtLen	equ	$ - GDT
GdtPtr	dw	GdtLen - 1
	dd	0

SelectorCode32	equ	GDT_CODE32 - GDT
SelectorCode16	equ	GDT_CODE16 - GDT
SelectorVideo	equ	GDT_VIDEO - GDT
SelectorNormal	equ	GDT_NORMAL - GDT

[SECTION .s16]
[BITS 16]
boot:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, 0100h

	mov	ax, rmStr
	mov	bp, ax
	mov	ah, 13h
	mov	al, 01h
	mov	cx, rmLen
	mov	dx, 0
	mov	bx, 000ch
	int	10H

	xor	eax, eax
	mov	ax, cs
	shl	eax, 4
	add	eax, Code32
	mov	[GDT_CODE32 + 2], ax
	shr	eax, 16
	mov	[GDT_CODE32 + 4], al
	mov	[GDT_CODE32 + 7], ah

	xor	eax, eax
	mov	ax, cs
	shl	ax, 4
	add	eax, Code16
	mov	[GDT_CODE16 + 2], ax
	shr	eax, 16
	mov	[GDT_CODE16 + 4], al
	mov	[GDT_CODE16 + 7], ah

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

[SECTION .s32]
[BITS 32]
Code32:
	mov	ax, SelectorVideo
	mov	gs, ax
	xor	edi, edi
	mov	edi, (80 * 1 + 0) * 2
	mov	esi, pmStr
	mov	ah, 0ch
	mov	ecx, pmLen
.loop:
	lodsb
	mov	[gs:edi], ax
	add	edi, 2
	loop	.loop
	jmp	SelectorCode16: 0
Code32Len	equ	$-Code32

[SECTION .s16]
[BITS 16]
Code16:
	mov	ax, SelectorNormal
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax

	mov	eax, cr0
	and	al, 0feh
	mov	cr0, eax
	jmp	0: real
Code16Len	equ	$-Code16

real:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax

	in	al, 92h
	and	al, 0fdh
	out	92h, al

	sti

;	mov	ax, rmStr
;	mov	bp, ax
;	mov	ah, 13h
;	mov	al, 01h
;	mov	cx, rmStr
;	mov	dx, 0
;	mov	bx, 000ch
;	int	10H

halt:
	hlt
	jmp	halt

rmStr:
	db	"Real Mode"
rmLen	equ	$-rmStr
pmStr:
	db	"Protect Mode"
pmLen	equ	$-pmStr
