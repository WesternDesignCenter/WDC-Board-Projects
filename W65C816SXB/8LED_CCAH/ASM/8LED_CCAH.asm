; File: SIM_8LED_CCAH.asm
; 09/16/2016

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


			title  "6502 xSimul8r Program V 1.00 - 8 LED Active High"
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: SIM_8LED_CCAH.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 1980-2016
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
;  TITLE: 8LED_CCAH
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
;  CREATION DATE: September 16, 2016
;
;  REVISION HISTORY
;     Name           Date         Description
;     ------------   ----------   ------------------------------------------------
;     David Gray	09/16/2016   1.00 Initial
;
;
; NOTE:
;    Change the lines for each version - current version is 1.00
;    See -
;         title  "6502 xSimul8r Program V 1.00 - 8 LED Active High"
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

	.sttl "6502 xSimul8r Demo Code"
	.page
;***************************************************************************
;***************************************************************************
;                    6502 xSimul8r Demo Code Section
;***************************************************************************
;***************************************************************************
;
;Example code to controll 8 LEDs driven from the W65C22 VIA Port B

		org	$2000		;Our program code will be at $2000

	START:
		sei

		cld
		ldx	#$ff		; Initialize the stack pointer
		txs

; First, we initialize the VIA chip registers and set Port B to OUTPUTS
		lda	#$ff
		sta	VIA_DDRB	; set all as outputs

; Now we initialize the X register to use to count from 0 - 255 (FF)
		ldx #$00
;This is our loop where we get a value from $3000 in memory and load it
;into VIA Port B Output Register.  If ran all at once, this will cycle through memory 
;from $3000 - $30FF.  The content at each memory address will be output to Port B 
;which will be visable on the 8 LEDs as a binary equivalent. 
;This exercise is meant to be done in the xSimul8r using single stepping.  The user can 
;load the memory at $3000 with any data they wish. 
LOADER:
		lda $3000,x		; Load the value that is in memory at 3000 + x index.
		sta VIA_ORB		; Display value on LEDs.  Value can be seen in ORB register of VIA
		inx				; Increment the value of X by 1
		bne LOADER		; Branch to the label "LOADER" if the value of the X-register is not $00

;After 256 loops, the program is done and we give control back to the simulator. 		
	IRQHandler:
		pla
		rti

;This code is here in case the system gets an NMI.  It clears the intterupt flag and returns.
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
