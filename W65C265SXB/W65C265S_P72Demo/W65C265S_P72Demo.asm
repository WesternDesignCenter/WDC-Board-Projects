; File: W65C265S_LEDDemo.asm
; 08/08/2013

     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_816
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
;  FILE_NAME: W65C265S_LEDDemo.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 2014
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
;  TITLE: W65C265S_LEDDemo
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
;         title  "W65C265S_LEDDemo Program V 1.0x for W65C265S - W65C265S_LEDDemo.asm"
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
  PCS7: 			equ $DF27 ;; Port 7 Chip Select
  PDD6: 			equ $DF26 ;; Port 6 Data Direction Register
  PDD5: 			equ $DF25 ;; Port 5 Data Direction Register
  PDD4: 			equ $DF24 ;; Port 4 Data Direction Register
  PDD3:				equ $DF07	;; Port 3 Data Direction Register
  PDD2:				equ $DF06	;; Port 2 Data Direction Register
  PDD1:				equ $DF05	;; Port 1 Data Direction Register
  PDD0:				equ $DF04	;; Port 0 Data Direction Register
  PD7:  			equ $DF23 ;; Port 7 Data Register
  PD6:  			equ $DF22 ;; Port 6 Data Register
  PD5:  			equ $DF21 ;; Port 5 Data Register
  PD4:  			equ $DF20 ;; Port 4 Data Register
  PD3:				equ $DF03 ;; Port 3 Data Register
  PD2:				equ $DF02 ;; Port 2 Data Register
  PD1:				equ $DF01 ;; Port 1 Data Register
  PD0:				equ $DF00 ;; Port 0 Data Register

;; Control and Status Register Memory Map
  UIER:  			equ $DF49 ;; UART Interrupt Enable Register
  UIFR:  			equ $DF48 ;; UART Interrupt Flag Register
  EIER:  			equ $DF47 ;; Edge Interrupt Enable Register
  TIER:  			equ $DF46 ;; Timer Interrupt Enable Register
  EIFR:  			equ $DF45 ;; Edge Interrupt Flag Register
  TIFR:  			equ $DF44 ;; Timer Interrupt Flag Register
  TER:  			equ $DF43 ;; Timer Enable Register
  TCR:  			equ $DF42 ;; Timer Control Register
  SSCR:  			equ $DF41 ;; System Speed Control Register
  BCR:  			equ $DF40 ;; Bus Control Register
;; Timer Register Memory Map
  T7CH:				equ $DF6F ;; Timer 7 Counter High
  T7CL:				equ $DF6E ;; Timer 7 Counter Low
  T6CH:				equ $DF6D ;; Timer 6 Counter High
  T6CL:				equ $DF6C ;; Timer 6 Counter Low
  T5CH:				equ $DF6B ;; Timer 5 Counter High
  T5CL:				equ $DF6A ;; Timer 5 Counter Low
  T4CH:				equ $DF69 ;; Timer 4 Counter High
  T4CL:				equ $DF68 ;; Timer 4 Counter Low
  T3CH:				equ $DF67 ;; Timer 3 Counter High
  T3CL:				equ $DF66 ;; Timer 3 Counter Low
  T2CH:				equ $DF65 ;; Timer 2 Counter High
  T2CL:				equ $DF64 ;; Timer 2 Counter Low
  T1CH:				equ $DF63 ;; Timer 1 Counter High
  T1CL:				equ $DF62 ;; Timer 1 Counter Low
  T0CH:				equ $DF61 ;; Timer 0 Counter High
  T0CL:				equ $DF60 ;; Timer 0 Counter Low
;;  Latches
  T7LH:				equ $DF5F ;; Timer 7 Latch High
  T7LL:				equ $DF5E ;; Timer 7 Latch Low
  T6LH:				equ $DF5F ;; Timer 6 Latch High
  T6LL:				equ $DF5E ;; Timer 6 Latch Low
  T5LH:				equ $DF5F ;; Timer 5 Latch High
  T5LL:				equ $DF5E ;; Timer 5 Latch Low
  T4LH:				equ $DF5F ;; Timer 4 Latch High
  T4LL:				equ $DF5E ;; Timer 4 Latch Low
  T3LH:				equ $DF5F ;; Timer 3 Latch High
  T3LL:				equ $DF5E ;; Timer 3 Latch Low
  T2LH:				equ $DF5F ;; Timer 2 Latch High
  T2LL:				equ $DF5E ;; Timer 2 Latch Low
  T1LH:				equ $DF5F ;; Timer 1 Latch High
  T1LL:				equ $DF5E ;; Timer 1 Latch Low
  T0LH:				equ $DF5F ;; Timer 0 Latch High
  T0LL:				equ $DF5E ;; Timer 0 Latch Low
;; On Chip RAM
  OCRAM_BASE: equ $DF80 ;; RAM Registers

;; Emulation Mode Vector Table
  IRQBRK:			equ $FFFE ;; BRK - Software Interrupt
  IRQRES:			equ $FFFC ;; RES - "REStart" Interrupt
  IRQNMI:			equ $FFFA ;; Non-Maskable Interrupt
  IABORT:			equ $FFF8 ;; ABORT Interrupt
;  IRQRVD:			equ $FFF6 ;; Reserved
  IRQCOP:			equ $FFF4 ;; COP Software Interrupt
;  IRQRVD:			equ $FFF2 ;; Reserved
;  IRQRVD:			equ $FFF0 ;; Reserved
  IRQ:  			equ $FFDE  ;; IRQ Level Interrupt
  IRQPIB:			equ $FFDC  ;; PIB Interrupt
  IRNE66:			equ $FFDA  ;; Negative Edge Interrupt on P66
  IRNE64:			equ $FFD8	 ;; Negative Edge Interrupt on P64
  IRPE62:			equ $FFD6	 ;; Positive Edge Interrupt on P62 for PWM
  IRPE60:			equ $FFD4	 ;; Positive Edge Interrupt on P60
  IRNE57:			equ $FFD2  ;; Negative Edge Interrupt on P57
  IRPE56:			equ $FFD0	 ;; Positive Edge Interrupt on P56
  IRQT7:  		equ $FFCE	 ;; Timer 7 Interrupt
  IRQT6:  		equ $FFCC	 ;; Timer 6 Interrupt
  IRQT5:  		equ $FFCA	 ;; Timer 5 Interrupt
  IRQT4:  		equ $FFC8	 ;; Timer 4 Interrupt
  IRQT3:  		equ $FFC6	 ;; Timer 3 Interrupt
  IRQT2:  		equ $FFC4	 ;; Timer 2 Interrupt
	IRQT1:  		equ $FFC2	 ;; Timer 1 Interrupt
	IRQT0:  		equ $FFC0	 ;; Timer 0 Interrupt


;		CHIP	65C02
		LONGI	OFF
		LONGA	OFF

	.sttl "W65C265S Demo Code"
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
		;Initialize the stack
		sei
		cld
		ldx	#$ff
		txs
		;This is the code for the demo
		;This part is just checking the registers that are effected
		lda PCS7				; Load value of P7x Data Direction Register.
		sta $3000				; Store for Debug - Should be 0xFBh
		lda PD7					; Load value of P7x Data Register
		sta $3001				; Store for Debug - should be 0x04h
		;This part is what actually turns the LED ON
		lda #$00 				; Set Bit 2 low to make LED turn ON
		sta PD7					; Sets P72 HIGH.
		brk							; ReTurn from subroutine Long - We are done
    lda #$04
    sta PD7
    brk

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
		;;-----------------------------
		;;
		;;		Reset and Interrupt Vectors (define for 265, 816/02 are subsets)
		;;
		;;-----------------------------

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
