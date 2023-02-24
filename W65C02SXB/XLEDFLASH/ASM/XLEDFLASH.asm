; File: XLEDFLASH.asm
; 11/08/2019

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


			title  "W65C02SXB Demo Program - XLEDFLASH.asm"
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: XLEDFLASH.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 1980-2019
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
;  TITLE: XLEDFLASH
;
;  DESCRIPTION: This File describes the WDC Simulator Example Program.
;
;
;
;  DEFINED FUNCTIONS:
;	badVec- Process a Bad Interrupt Vector - Hang!
;	DELAY - Simple delay loop  
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
;  CREATION DATE: November 08, 2019
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
;                               Local Constants
;***************************************************************************
;
	XCS0:		equ 	$7F00
	XCS1:		equ 	$7F20
	XCS2:		equ 	$7F40
	XCS3:		equ 	$7F60
	
	PIA_BASE:	equ	$7FA0
	PIA_CRA:	equ	PIA_BASE+1
	PIA_DATAA:	equ	PIA_BASE+0
	PIA_DDRA:	equ	PIA_BASE+0
	PIA_CRB:	equ	PIA_BASE+3
	PIA_DATAB:	equ	PIA_BASE+2
	PIA_DDRB:	equ	PIA_BASE+2

	.sttl "W65C02SXB Demo Code"
	.page
;***************************************************************************
;***************************************************************************
;                    W65C02SXB_Demo Code Section
;***************************************************************************
;***************************************************************************
		CHIP	65C02
		LONGI	OFF
		LONGA	OFF

		org	$2000
START:
		sei

		cld
		ldx	#$ff
		txs
		
		lda #$30
		sta PIA_CRA
		
		lda #$FF
		sta PIA_DDRA
		
		lda #$34
		sta PIA_CRA
		
		lda #$55
		sta PIA_DATAA

FLASHLED:
;XCS0
		ldy #$00
?L0B		ldx #$00
?L0A		inc XCS0
		dex
		bne ?L0A
		dey
		bne ?L0B
		
		jsr 	DELAY
		jsr 	DELAY
		
;XCS1
		ldy #$00
?L1B		ldx #$00
?L1A		inc XCS1
		dex
		bne ?L1A
		dey
		bne ?L1B
		jsr 	DELAY
		jsr 	DELAY

;XCS2
		ldy #$00
?L2B		ldx #$00
?L2A		inc XCS2
		dex
		bne ?L2A
		dey
		bne ?L2B
		
		jsr 	DELAY
		jsr 	DELAY
		
;XCS3
		ldy #$00
?L3B		ldx #$00
?L3A		inc XCS3
		dex
		bne ?L3A
		dey
		bne ?L3B
		jsr 	DELAY
		jsr 	DELAY
		
		bra 	FLASHLED
		
;*****************************************************
;	Delay
;
;	Delay For 65535 Cycles 
;
;*****************************************************

DELAY:
		phx
		phy

		ldy #$00
?L2		ldx #$00
?L1		dex
		bne ?L1
		dey
		bne ?L2

		ply
		plx
		rts
;*****************************************************

IRQHandler:
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
