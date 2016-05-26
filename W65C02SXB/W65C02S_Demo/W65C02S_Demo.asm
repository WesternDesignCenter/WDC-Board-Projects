; File: W65C02S_Demo.asm
; 08/08/2013

     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_02
	ELSE
		EXIT         "Not Valid Processor: Use -DUSING_02, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF




;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


			title  "W65C02S Simulator Program V 1.00 for W65C02 - W65C02S_Demo.asm"
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: W65C02S_Demo.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 1980-2013
;               All rights reserved. Reproduction in any manner,
;               in whole or in part, is strictly prohibited without
;               the prior written approval of The Western Design Center, Inc (WDC).
;
;               Information contained in this publication regarding
;               device applications and the like is intended through
;               suggestion only and may be superseded by updates.
;               It is your responsibility to ensure that your application
;               meets with your specifications.  No representation or
;               warranty is given and no liability is assumed by
;               Western Design Center, Inc. with respect to the accuracy
;               or use of such information, or infringement of patents
;               or other intellectual property rights arising from such
;               use or otherwise.  Use of WDC's products
;               as critical components in life support systems is not
;               authorized except with express written approval by
;               WDC.  No licenses are conveyed,implicitly or otherwise,
;								under any intellectual property rights.
;
;
;
;  TITLE: W65C02S_Demo
;
;  DESCRIPTION: This File describes the WDC Simulator Example Program.
;
;
;
;  DEFINED FUNCTIONS:
;          badVec
;                   - Process a Bad Interrupt Vector - Hang!
;
;  SPECIAL_CONSIDERATIONS:
;
;
;  SHARED_DATA:
;          None
;
;  GLOBAL_MODULES:
;          None
;
;  LOCAL_MODULES:
;          See above in "DEFINED FUNCTIONS"
;
;  AUTHOR: David Gray
;
;  CREATION DATE: August 8, 2013
;
;  REVISION HISTORY
;     Name           Date         Description
;     ------------   ----------   ------------------------------------------------
;     David Gray		 08/08/2013   1.00 Initial
;
;
; NOTE:
;    Change the lines for each version - current version is 1.00b
;    See -
;         title  "W65C02S_Demo Program V 1.0x for W65C02S - W65C02S_Demo.asm"
;
;
;***************************************************************************
;endpkhdr


;***************************************************************************
;                             Include Files
;***************************************************************************
;None


;***************************************************************************
;                              Global Modules
;***************************************************************************
;None

;***************************************************************************
;                              External Modules
;***************************************************************************
;None

;***************************************************************************
;                              External Variables
;***************************************************************************
;None


;***************************************************************************
;                               Local Constants
;***************************************************************************
;
;	VIA_BASE:	equ	$f0
	VIA_BASE:	equ	$7FC0		;; base address of VIA port on SXB
	VIA_ORB:	equ	VIA_BASE
	VIA_IRB:	equ	VIA_BASE
	VIA_ORA:	equ	VIA_BASE+1
	VIA_IRA:	equ	VIA_BASE+1
	VIA_DDRB:	equ	VIA_BASE+2
	VIA_DDRA:	equ	VIA_BASE+3
	VIA_T1CLO:	equ	VIA_BASE+4
	VIA_T1CHI:	equ	VIA_BASE+5
	VIA_T1LLO:	equ	VIA_BASE+6
	VIA_T1LHI:	equ	VIA_BASE+7
	VIA_T2CLO:	equ	VIA_BASE+8
	VIA_T2CHI:	equ	VIA_BASE+9
	VIA_SR:		equ	VIA_BASE+10
	VIA_ACR:	equ	VIA_BASE+11
	VIA_PCR:	equ	VIA_BASE+12
	VIA_IFR:	equ	VIA_BASE+13
	VIA_IER:	equ	VIA_BASE+14
	VIA_ORANH:	equ	VIA_BASE+15
	VIA_IRANH:	equ	VIA_BASE+15

		CHIP	65C02
		LONGI	OFF
		LONGA	OFF

	.sttl "W65C02S Demo Code"
	.page
;***************************************************************************
;***************************************************************************
;                    W65C02S_Demo Code Section
;***************************************************************************
;***************************************************************************

;Example of how the simulator has the 7 Segment hooked up
;It uses PBx.  Each number is a bit of PBx
;When the bit is LOW (0), the segment is turned ON.
;PB7 is the decimal point.
;
;   +   0   +
;   5       1
;   +   6   +
;   4       2
;   +   3   +   7
;
;Example code to make a "6" on the LED with the W65C22S Port B
;This assumes Port B has already been made all outputs
;		lda #$82			; 10000010  - All segments with a '0' light up
;		sta VIA_ORB		; Display a '6'


		org	$2000

	START:
		sei

		cld
		ldx	#$ff
		txs

; First, we initialize the VIA chip registers
		lda	#$ff
		sta	VIA_ORB   ; start by turning all segments off
		sta	VIA_DDRB	; set all as outputs

; Now we
	FirstChar:
		lda #$82
		sta VIA_ORB		; Display a '6'
		lda #$92
		sta VIA_ORB		; Display a '5'
		lda #$C6
		sta VIA_ORB		; Display a 'C'
		lda #$C0
		sta VIA_ORB		; Display a '0'
		lda #$A4
		sta VIA_ORB		; Display a '2'
		lda #$7F
		sta VIA_ORB		; Display a '.'
		bra FirstChar	; go back to the top and display again


	IRQHandler:
		pha
		lda	VIA_IFR		; check interrupt flags register
		bit	#$40		; check for timer 1 overflow
		beq	IRQ_done	; none, nothing to do
		inc	cnt		; bump the delay counter
		lda	cnt
		cmp	delay
		bcc	IRQ_skip	; not done delaying yet
		lda	#0		; done, clear counter
		sta	cnt
		lda	bits		; get bit fields
		eor	#$ff		; invert the bits
		sta	VIA_ORB		; change the display
		asl	bits		; shift the bits
		lda	bits		; check for end of shift
		cmp	#$40		; is it end?
		bne	IRQ_skip	; no, skip
		lda	#1		; yes, reset back to first segment
		sta	bits
	IRQ_skip:
		lda	VIA_T1CLO	; clear IFR bit

	IRQ_done:
		pla
		rti


badVec:		; $FFE0 - IRQRVD2(134)
	php
	pha
	lda #$FF
				;clear Irq
	pla
	plp
	rti

This_project_end:
WDCMON_RAM_START	EQU	$7C00
ROMSPACE EQU WDCMON_RAM_START-This_project_end  ;gives space left in the ROM BEFORE WDCMON TABLES

	IF ROMSPACE<0
		EXIT         "Not Enough Memory for This Application - bumping into WDCMON! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF


	bits:	db	1
	cnt:	db	0
	wraps:	dw	0
	delay:	db	10

;***************************************************************************
;***************************************************************************
; New for WDCMON V1.04
;  Needed to move Shadow Vectors into proper area
;***************************************************************************
;***************************************************************************
	SH_vectors:	section
Shadow_VECTORS	SECTION OFFSET $7EFA
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)

	        ends


;***************************************************************************

vectors	SECTION OFFSET $FFFA
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)

	        ends

	        end
