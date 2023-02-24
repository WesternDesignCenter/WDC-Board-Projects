; File: EDUGS.asm
; 09/20/2022

;These lines are formatting for the listing file.
     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

;Example of testing for the correct processor.  
;Note this code would not assemble for the W65C816S
				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_02
	ELSE
		EXIT         "Not Valid Processor: Use -DUSING_02, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF


;Title, will go in listing file.

			title  "02EDU Getting Started v1.00 "
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: 	EDUGS.asm
;
;  DATA_RIGHTS: The Western Design Center, Inc.
;               Copyright(C) 1980-2023
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
;		under any intellectual property rights.
;
;
;
;  TITLE: EDUGS
;
;  DESCRIPTION: Assembly Getting Started Example for the W65C02EDU 
;
;
;
;  DEFINED FUNCTIONS:
;       badVec
;      		- Process a Bad Interrupt Vector - Hang!
;	IRQHandler
;		- Pull acc from stack and return from interrupt.
;	DELAY
;		- Simple delay function using X, Y reg
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
;  CREATION DATE: September 20, 2022
;
;  REVISION HISTORY
;     Name           	Date         Description
;     ------------   	----------   ------------------------------------------------
;     David Gray	09/16/2022   1.00 Initial
;
;
; NOTE:
;    Change the lines for each version - current version is 1.00
;    See -
;         title  "02EDU Getting Started v1.00 "
;
;
;***************************************************************************
;endpkhdr


;***************************************************************************
;                             Include Files
;***************************************************************************
;None
			include	"02EDU.inc"

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
	

		CHIP	65C02
		LONGI	OFF
		LONGA	OFF

	.sttl "02EDU Getting Started Code"
	.page
;***************************************************************************
;***************************************************************************
;                    W65C02EDU Getting Started Code Section
;***************************************************************************
;***************************************************************************
;
;Example code to control 8 LEDs driven from the PIA Port B
;and buzzer driven by CA2
;Note that W65C21N has pullups on the PX and CXX lines, 
;This means that the LEDS and CA2 are high on start up.
;Microswith SW_CA2 on the EDU board needs to be switched on for this example to work properly
;CAUTION: By default poweron and SW_CA2 ON, the buzzer will continuously beep
;NOTE, this version only works if you are using an updated monitor that supports
;the ECNX uploader.  If you have the original monitor, use mk02_EDUGS.bat and EDUGS.asm


;Init_Serial	equ	$F800
Write_Byte	equ	$F803
;Read_Byte	equ	$F806
;Check_Byte	equ	$F809



		org $8000

	START:
	
		

		.byte 'WDC',$00
		sei

		cld
		ldx	#$ff		; Initialize the stack pointer
		txs
		
		lda #'O'
		jsr Write_Byte

		lda #'K'
		jsr Write_Byte


		lda #'.'
		jsr Write_Byte
		lda #'.'
		jsr Write_Byte
		lda #'.'
		jsr Write_Byte
		lda #'!'
		jsr Write_Byte

; First, we initialize the PIA chip registers and set Port A to OUTPUTS
; LEDS and buzzer are turned off in this section.
		lda #$FF
		sta PIA_DDRA
		lda #$34	;set Bit 2 of Control Register High to access Data Reg
		sta PIA_CRA	;set CA2 LOW as well / BUZZER IS OFF
		lda #$00	;turn all LEDS OFF for now
		sta PIA_PA
; Simple binary counter with audible beep when the count rolls over to zero
COUNT:
		inc A		;increment count
		sta PIA_PA	;each store changes the LEDS
		jsr DELAY	;delay loop.
		bne COUNT
		lda #$3C	;CA2 go high, keep CR2 high
		sta PIA_CRA	;buzzer is ON
		jsr DELAY	;delay loops to hear the buzzer
		jsr DELAY	;
		jsr DELAY
		jsr DELAY
		lda #$34	;CA2 go low, keep CR2 high
		sta PIA_CRA	;BUZZER IS OFF
		lda #$00	;reset count
		bra COUNT

		
;*****************************************************
;	Delay
;
;	Delay For 65535 Cycles 
;
;*****************************************************

DELAY:
		pha
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
		pla
		rts

;*****************************************************
;
;	IRQ and NMI Handlers below. 
;	Vectors and Shadow Vectors below that.
;	All code below can be copied to 
;	your new project.
;
;*****************************************************	
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

;
;;***************************************************************************
;;***************************************************************************
;; New for WDCMON V1.04
;;  Needed to move Shadow Vectors into proper area
;;***************************************************************************
;;***************************************************************************
;	SH_vectors:	section
;Shadow_VECTORS	SECTION OFFSET $7EFA
;					;65C02 Interrupt Vectors
;					; Common 8 bit Vectors for all CPUs
;
;		dw	badVec		; $FFFA -  NMIRQ (ALL)
;		dw	START		; $FFFC -  RESET (ALL)
;		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
;
;	        ends
;
;
;;***************************************************************************
;
;vectors	SECTION OFFSET $FFFA
;					;65C02 Interrupt Vectors
;					; Common 8 bit Vectors for all CPUs
;
;		dw	badVec		; $FFFA -  NMIRQ (ALL)
;		dw	START		; $FFFC -  RESET (ALL)
;		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
;
;	        ends

	        end
