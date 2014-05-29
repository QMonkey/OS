; Descriptor Attribute

; TYPE
; Data Type
DA_DTR		EQU	0	; Read only
DA_DTRA		EQU	1	; Read only, Accessed
DA_DTRW		EQU	2	; Read, Write
DA_DTRWA	EQU	3	; Read, Write, Accessed
DA_DTRE		EQU	4	; Read, Downward Expand
DA_DTREA	EQU	5	; Read, Downward Expand, Accessed
DA_DTRWE	EQU	6	; Read, Write, Downward Expand
DA_DTRWEA	EQU	7	; Read, Write, Downward Expand, Accessed

; Code Type
DA_CTE		EQU	8	; Execute
DA_CTEA		EQU	9	; Execute, Accessed
DA_CTER		EQU	0AH	; Execute, Read
DA_CTERA	EQU	0BH	; Execute, Read, Accessed
DA_CTECO	EQU	0CH	; Execute, Consistent
DA_CTECOA	EQU	0DH	; Execute, Consistent, Accessed
DA_CTERCO	EQU	0EH	; Execute, Read, Consistent
DA_CTERCOA	EQU	0FH	; Execute, Read, Consistent, Accessed
; TYPE End

; S: Segment Type
DA_SG	EQU	00H	; System or Gate
DA_DC	EQU	10H	; Data or Code

; DPL: Descriptor Privilege Level
DA_DPL0		EQU	00H
DA_DPL1		EQU	20H
DA_DPL2		EQU	40H
DA_DPL3		EQU	60H

; P: Present
DA_P	EQU	80H
DA_NP	EQU	00H

; D/B
; D: Code Segment
DA_CD32	EQU	4000H	; 32 bit address, 32 bit or 8 bit operand
DA_CD16	EQU	0000H	; 16 bit address, 16 bit or 8 bit operand

; B: Extend Data Segment
DA_DB4GB	EQU	4000H	; Stack segment upper limits 4GB
DA_DB64KB	EQU	0000H	; Stack segment upper limits 64KB

; B: Stack Segment
DA_SB32		EQU	4000H	; Use 32 bit esp
DA_SB16		EQU	0000H	; Use 16 bit sp
; D/B End

; G: Granularity
DA_G1B	EQU	0000H
DA_G4KB	EQU	8000H

; Data Segment
DA_DRW	EQU	DA_P | DA_DC | DA_DTRW

; Code Segment
DA_CE	EQU	DA_P | DA_DC | DA_CTE
