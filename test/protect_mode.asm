%include "constant.inc"
%include "protect_mode.inc"

	org	07c00h
	jmp	boot

GDT:
	PMDescriptor 0, 0, 0
GDT_CODE32:
	PMDescriptor 0, Code32Len - 1, DA_CE + DA_CD32
GDT_CODE16:
	PMDescriptor 0, 0ffffh, DA_CE
GDT_DATA:
	PMDescriptor 0, DataLen - 1, DA_DRW
GDT_VIDEO:
	PMDescriptor 0b8000h, 0ffffh, DA_DRW

GdtLen	equ	$-GDT
GdtPtr	dw	GdtLen - 1
	dd	0

SelectorCode32	equ	GDT_CODE32 - GDT
SelectorCode16	equ	GDT_CODE16 - GDT
SelectorData	equ	GDT_DATA - GDT
SelectorVideo	equ	GDT_VIDEO - GDT

data_segment:
	resb	26

DataLen	equ	$-data_segment

boot:
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax

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
	shl	eax, 4
	add	eax, Code16
	mov	[GDT_CODE16 + 2], ax
	shr	eax, 16
	mov	[GDT_CODE16 + 4], al
	mov	[GDT_CODE16 + 7], ah

	xor	eax, eax
	mov	ax, ds
	shl	eax, 4
	add	eax, data_segment
	mov	[GDT_DATA + 2], ax
	shr	eax, 16
	mov	[GDT_DATA + 4], al
	mov	[GDT_DATA + 7], ah

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
	mov	ax, SelectorData
	mov	ds, ax
	xor	edi, edi
	cld