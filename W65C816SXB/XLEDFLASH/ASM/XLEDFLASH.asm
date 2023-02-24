; File: XLEDFLASH.asm
; 11/08/2019

     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_816
	ELSE
		EXIT         "Not Valid Processor: Use -DUSING_816, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF




;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


			title  "W65C816SXB Demo Program - XLEDFLASH.asm"
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
;     David Gray		 11/08/2019   1.00 Initial
;
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

	.sttl "W65C816SXB Demo Code"
	.page
;***************************************************************************
;***************************************************************************
;                    W65C816SXB_Demo Code Section
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

Shadow_VECTORS	SECTION OFFSET $7EE0
					;65C816 Interrupt Vectors
					;Status bit E = 0 (Native mode, 16 bit mode)
		dw	badVec		; $FFE0 - IRQRVD4(816)
		dw	badVec		; $FFE2 - IRQRVD5(816)
		dw	badVec		; $FFE4 - COP(816)
		dw	badVec		; $FFE6 - BRK(816)
		dw	badVec		; $FFE8 - ABORT(816)
		dw	badVec		; $FFEA - NMI(816)
		dw	badVec		; $FFEC - IRQRVD(816)
		dw	badVec		; $FFEE - IRQ(816)
					;Status bit E = 1 (Emulation mode, 8 bit mode)
		dw	badVec		; $FFF0 - IRQRVD2(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF2 - IRQRVD1(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF4 - COP(8 bit Emulation)
		dw	badVec		; $FFF6 - IRQRVD0(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF8 - ABORT(8 bit Emulation)

					; Common 8 bit Vectors for all CPUs
		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
		
	ends
	
vectors	SECTION OFFSET $FFE0
					;65C816 Interrupt Vectors
					;Status bit E = 0 (Native mode, 16 bit mode)
		dw	badVec		; $FFE0 - IRQRVD4(816)
		dw	badVec		; $FFE2 - IRQRVD5(816)
		dw	badVec		; $FFE4 - COP(816)
		dw	badVec		; $FFE6 - BRK(816)
		dw	badVec		; $FFE8 - ABORT(816)
		dw	badVec		; $FFEA - NMI(816)
		dw	badVec		; $FFEC - IRQRVD(816)
		dw	badVec		; $FFEE - IRQ(816)
					;Status bit E = 1 (Emulation mode, 8 bit mode)
		dw	badVec		; $FFF0 - IRQRVD2(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF2 - IRQRVD1(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF4 - COP(8 bit Emulation)
		dw	badVec		; $FFF6 - IRQRVD0(8 bit Emulation)(IRQRVD(265))
		dw	badVec		; $FFF8 - ABORT(8 bit Emulation)

					; Common 8 bit Vectors for all CPUs
		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
		
		ends
	        end
