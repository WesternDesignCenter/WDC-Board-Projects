; File: W65C265S_LEDDemo.asm
; 08/08/2013

     PW 128         ;Page Width (# of char/line) 
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_134
	ELSE
		EXIT         "Not Valid Processor: Use -DUSING_02, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF




;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


			title  "W65C816S Simulator Program V 1.00 for W65C816 - W65C816S_Demo.asm"
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: W65C134S_LEDCS03.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 1978-2023
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
;  TITLE: W65C134S_LEDCS03
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
;  CREATION DATE: July 3, 2014
;
;  REVISION HISTORY
;     Name           Date         Description
;     ------------   ----------   ------------------------------------------------
;     David Gray		 07/03/2014   1.00 Initial
;
;
; NOTE:
;    Change the lines for each version - current version is 1.00b
;    See - 
;         title  "W65C134S_LEDCS03 Program V 1.0x for W65C134S - W65C134S_LEDCS03.asm"
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
;	VIA_BASE:	equ	$7FC0		;; base address of VIA port on SXB
;; IO Ports 
  PCS3: 			equ $0007 ;; Port 7 Chip Select
  PD3:				equ $0003 ;; Port 3 Data Register


		CHIP	65C02
		LONGI	OFF
		LONGA	OFF

	.sttl "W65C134S Demo Code"
	.page
;***************************************************************************
;***************************************************************************
;                    W65C265S_Demo Code Section
;***************************************************************************
;***************************************************************************

;
;Example code to make an LED connected to P72 turn ON.


		org	$2000

	START:
		sei
		cld
		ldx	#$ff
		txs
		;This is the code for the demo
		;This part is just checking the registers that are effected
		lda #$F0				; Load value of P7x Data Direction Register.  
		sta PCS3				; Store for Debug - Should be 0xFBh
		lda #$05					; Load value of P7x Data Register
		sta PD3				; Store for Debug - should be 0x04h
		rti							; ReTurn from subroutine Long - We are done
		

;;-------------------------------------------------------------------------
;; FUNCTION NAME	: Event Hander re-vectors
;;------------------:------------------------------------------------------
	IRQHandler:
		pha
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
;;-----------------------------------
;;
;;	Reset and Interrupt Vectors 
;;
;;-----------------------------------

	dw	badVec		; $FFD1,0 - PE44 - Positive Edge Interrupt
	dw	badVec		; $FFD3,2 - PE45 - Positive Edge Interrupt
	dw	badVec		; $FFD5,4 - NE46 - Negative Edge Interrupt
	dw	badVec		; $FFD7,6 - NE47 - Negative Edge Interrupt
	dw	badVec		; $FFD9,8 - PE50 - Positive Edge Interrupt
	dw	badVec		; $FFDB,A - PE51 - Positive Edge Interrupt
	dw	badVec		; $FFDD,C - NE52 - Negative Edge Interrupt
	dw	badVec		; $FFDF,E - NE53 - Negative Edge Interrupt

	dw	badVec		; $FFE1,0 - Reserved
	dw	badVec		; $FFE3,2 - Reserved
	dw	badVec		; $FFE5,4 - IRQAT - TXD or Timer A Interrupt  Interrupt
	dw	badVec		; $FFE7,6 - IRQAR - TXD Interrupt
	dw	badVec		; $FFE9,8 - IRQSIB - SIB Interrupt
	dw	badVec		; $FFEB,A - PE54 - Positive Edge Interrupt
	dw	badVec		; $FFED,C - PE55 - Positive Edge Interrupt
	dw	badVec		; $FFEF,E - PE56 - Positive Edge Interrupt

	dw	badVec		; $FFF1,0 - NE57 - Negative Edge Interrupt
	dw	badVec		; $FFF3,2 - IRQT1 - Timer 1 Interrupt
	dw	badVec		; $FFF5,4 - IRQT2 - Timer 2 Interrupt
	dw	badVec		; $FFF7,6 - IRQ1 - IRQ1 Interrupt
	dw	badVec		; $FFF9,8 - IRQ2 - IRQ2 Interrupt

				; Common Vectors for all CPUs

	dw	badVec		; $FFFA -  NMIRQ - Non-Maskable Interrupt
	dw	START		; $FFFC -  RESET - Restart Interrupt
	dw	IRQHandler	; $FFFE -  IRQBRK - Software BRK Interrupt
	        end