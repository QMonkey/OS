; Descriptor Attribute

; TYPE
; DATA TYPE
DA_DTR		EQU	0	; Read only
DA_DTRA		EQU	1	; Read only, Accessed
DA_DTRW		EQU	2	; Read, Write
DA_DTRWA	EQU	3	; Read, Write, Accessed
DA_DTRE		EQU	4	; Read, Downward Expand
DA_DTREA	EQU	5	; Read, Downward Expand, Accessed
DA_DTRWE	EQU	6	; Read, Write, Downward Expand
DA_DTRWEA	EQU	7	; Read, Write, Downward Expand, Accessed

; CODE TYPE
DA_CTE		EQU	8	; Execute
DA_CTEA		EQU	9	; Execute, Accessed
DA_CTER		EQU	0AH	; Execute, Read
DA_CTERA	EQU	0BH	; Execute, Read, Accessed
DA_CTECO	EQU	0CH	; Execute, Consistent
DA_CTECOA	EQU	0DH	; Execute, Consistent, Accessed
DA_CTERCO	EQU	0EH	; Execute, Read, Consistent
DA_CTERCOA	EQU	0FH	; Execute, Read, Consistent, Accessed
; TYPE End

; S: Segment type
DA_SG	EQU	0	; System or Gate
DA_DC	EQU	1	; Data or Code

; DPL: Descriptor Privilege Level
DA_DPL0		EQU	00H
DA_DPL1		EQU	20H
DA_DPL2		EQU	40H
DA_DPL3		EQU	60H

; P: Present
DA_P	EQU	80H
DA_NP	EQU	00H

; D/B
DA_32	EQU	4000H

; G: Granularity
DA_G1B	EQU	0000H
DA_G4KB	EQU	8000H

; DATA Segment
DA_DRW	EQU	DA_P | DA_DC | DA_DTRW

; CODE Segment
DA_CE	EQU	DA_P | DA_DC | DA_CTE
