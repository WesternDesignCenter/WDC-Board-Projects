; File: QBX8LEDS.asm
; Bill Mensch 12-28-2016

     PW 128         ;Page Width (# of char/line) 
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

	;*********************************************
	;Test for Valid Processor defined in -D option
	;*********************************************

	IF	USING_816
	ELSE

	EXIT	"Not Valid Processor: Use -DUSING_02, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF




;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


		title  "W65C265QBX Program V 1.00 for the 8 LEDS QBX8LEDS.asm"
		sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: QBX8LEDS.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 2014-2016
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
;  TITLE: QBX8LEDS
;
;  DESCRIPTION: This File is the 8 LED example for working with the W65C265QBX
;
;
;
;  DEFINED FUNCTIONS:
;          badVec
;        - Process a Bad Interrupt Vector - Hang!
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
;  AUTHOR: Bill Mensch
;
;  CREATION DATE: December 27, 2016
;
;  REVISION HISTORY
;	Name		Date		Description
;----------------------------------------------------------------------
;	Bill Mensch	12/23/2016	1.00 Initial
;	Bill Mensch 	12/27/2016	1.01 Additions for P0x, P1x, P2x
;	Bill Mensch	12/28/2016	1.02 Additions for debugging memory for user code
;
; NOTE:
;    Change the lines for each version - current version is 1.00
;    See - 
;         title  "W65C265QBX Program V 1.0x for W65C265S - QBX8LEDS.asm"
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
;; IO Ports 
	PCS7:	equ $DF27 ;; Port 7 Chip Select
	PDD6:	equ $DF26 ;; Port 6 Data Direction Register
	PDD5:	equ $DF25 ;; Port 5 Data Direction Register
	PDD4:	equ $DF24 ;; Port 4 Data Direction Register
	PDD3:	equ $DF07 ;; Port 3 Data Direction Register
	PDD2:	equ $DF06 ;; Port 2 Data Direction Register
	PDD1:	equ $DF05 ;; Port 1 Data Direction Register
	PDD0:	equ $DF04 ;; Port 0 Data Direction Register
	PD7:  	equ $DF23 ;; Port 7 Data Register
	PD6:  	equ $DF22 ;; Port 6 Data Register
	PD5:  	equ $DF21 ;; Port 5 Data Register
	PD4:  	equ $DF20 ;; Port 4 Data Register
	PD3:	equ $DF03 ;; Port 3 Data Register
	PD2:	equ $DF02 ;; Port 2 Data Register
	PD1:	equ $DF01 ;; Port 1 Data Register
	PD0:	equ $DF00 ;; Port 0 Data Register
;; Control and Status Register Memory Map
	UIER:  	equ $DF49 ;; UART Interrupt Enable Register
	UIFR:  	equ $DF48 ;; UART Interrupt Flag Register
	EIER:  	equ $DF47 ;; Edge Interrupt Enable Register
	TIER:  	equ $DF46 ;; Timer Interrupt Enable Register
	EIFR:  	equ $DF45 ;; Edge Interrupt Flag Register
	TIFR:  	equ $DF44 ;; Timer Interrupt Flag Register
	TER:  	equ $DF43 ;; Timer Enable Register
	TCR:  	equ $DF42 ;; Timer Control Register
	SSCR:  	equ $DF41 ;; System Speed Control Register
	BCR:  	equ $DF40 ;; Bus Control Register
;; Timer Register Memory Map
	T7CH:	equ $DF6F ;; Timer 7 Counter High
	T7CL:	equ $DF6E ;; Timer 7 Counter Low
	T6CH:	equ $DF6D ;; Timer 6 Counter High
	T6CL:	equ $DF6C ;; Timer 6 Counter Low
	T5CH:	equ $DF6B ;; Timer 5 Counter High
	T5CL:	equ $DF6A ;; Timer 5 Counter Low
	T4CH:	equ $DF69 ;; Timer 4 Counter High
	T4CL:	equ $DF68 ;; Timer 4 Counter Low
	T3CH:	equ $DF67 ;; Timer 3 Counter High
	T3CL:	equ $DF66 ;; Timer 3 Counter Low
	T2CH:	equ $DF65 ;; Timer 2 Counter High
	T2CL:	equ $DF64 ;; Timer 2 Counter Low
	T1CH:	equ $DF63 ;; Timer 1 Counter High 
	T1CL:	equ $DF62 ;; Timer 1 Counter Low
	T0CH:	equ $DF61 ;; Timer 0 Counter High 
	T0CL:	equ $DF60 ;; Timer 0 Counter Low
;;  Timer Latches  
	T7LH:	equ $DF5F ;; Timer 7 Latch High
	T7LL:	equ $DF5E ;; Timer 7 Latch Low  
	T6LH:	equ $DF5F ;; Timer 6 Latch High   
	T6LL:	equ $DF5E ;; Timer 6 Latch Low    
	T5LH:	equ $DF5F ;; Timer 5 Latch High 
	T5LL:	equ $DF5E ;; Timer 5 Latch Low  
	T4LH:	equ $DF5F ;; Timer 4 Latch High 
	T4LL:	equ $DF5E ;; Timer 4 Latch Low  
	T3LH:	equ $DF5F ;; Timer 3 Latch High 
	T3LL:	equ $DF5E ;; Timer 3 Latch Low  
	T2LH:	equ $DF5F ;; Timer 2 Latch High 
	T2LL:	equ $DF5E ;; Timer 2 Latch Low  
	T1LH:	equ $DF5F ;; Timer 1 Latch High 
	T1LL:	equ $DF5E ;; Timer 1 Latch Low  
	T0LH:	equ $DF5F ;; Timer 0 Latch High 
	T0LL:	equ $DF5E ;; Timer 0 Latch Low  

;; Emulation Mode Vector Table

	IRQBRK:	equ $FFFE ;; BRK - Software Interrupt
	IRQRES:	equ $FFFC ;; RES - "REStart" Interrupt  
	IRQNMI:	equ $FFFA ;; Non-Maskable Interrupt
	IABORT:	equ $FFF8 ;; ABORT Interrupt          
;	IRQRVD:	equ $FFF6 ;; Reserved
	IRQCOP:	equ $FFF4 ;; COP Software Interrupt
;	IRQRVD:	equ $FFF2 ;; Reserved  
;	IRQRVD:	equ $FFF0 ;; Reserved 
	IRQ:  	equ $FFDE ;; IRQ Level Interrupt
	IRQPIB:	equ $FFDC ;; PIB Interrupt 
	IRNE66:	equ $FFDA ;; Negative Edge Interrupt on P66
	IRNE64:	equ $FFD8 ;; Negative Edge Interrupt on P64
	IRPE62:	equ $FFD6 ;; Positive Edge Interrupt on P62 for PWM
	IRPE60:	equ $FFD4 ;; Positive Edge Interrupt on P60
	IRNE57:	equ $FFD2 ;; Negative Edge Interrupt on P57
	IRPE56:	equ $FFD0 ;; Positive Edge Interrupt on P56
	IRQT7:  equ $FFCE ;; Timer 7 Interrupt 
	IRQT6:  equ $FFCC ;; Timer 6 Interrupt 
	IRQT5:  equ $FFCA ;; Timer 5 Interrupt 
	IRQT4:  equ $FFC8 ;; Timer 4 Interrupt 
	IRQT3:  equ $FFC6 ;; Timer 3 Interrupt 
	IRQT2:  equ $FFC4 ;; Timer 2 Interrupt 
	IRQT1:  equ $FFC2 ;; Timer 1 Interrupt 
	IRQT0:  equ $FFC0 ;; Timer 0 Interrupt 

;	CHIP	65C02
	LONGI	ON
	LONGA	OFF

	.sttl "W65C265QBX QBX8LEDS.asm Code"
	.page

;***************************************************************************
;***************************************************************************
;                    W65C265S QBX8LEDS.asm Code Section
;***************************************************************************
;***************************************************************************

;
;  Code to make the 8 LEDs turn ON and OFF.

;; On Chip IO Page RAM

;IORAM:		equ $DF80 ;; IO Page RAM in IO page is used by the Monitor

;; On Chip Debug RAM

;DBRAM:		equ $0140 ;; Debug RAM
 
;; On Chip Code 96 bytes of RAM available from $00c0-$011f 

	org $00C0

	START:

;Initialize the stack, memory bus and debug features

	sei
	cld
;	sep #$10	; Set X to 1 for 8-bit index registers				
	tsx
;	stx DBRAM+$00

;This is the code for the demo
;This part is just checking the registers that are effected


LEDSEQ:
	lda #$00	; Load value to set all P7x as outputs.
	sta PCS7	; All P7x pins are now outputs.

	lda #$81
	sta PD7
	jsl delay
	
	lda #$81
	sta PD7
	jsl delay
	
	lda #$42
	sta PD7
	jsl delay
	
	lda #$24
	sta PD7
	jsl delay
	
	lda #$18
	sta PD7
	jsl delay
	
	lda #$24
	sta PD7
	jsl delay
	
	lda #$42
	sta PD7
	jsl delay
	
	lda #$81
	sta PD7
	jsl delay

	bra LEDSEQ
	
delay:
	ldx #0
repeat:
	dex
	bne repeat
	rtl

	
	
	
	


		
;;-------------------------------------------------------------------------
;; FUNCTION NAME	: Event Hander re-vectors
;;------------------:------------------------------------------------------
;	IRQHandler:
;	php
;	pla
;	rti
;
;badVec:	; $FFE0 - IRQRVD2(134)
;
;	php
;	pla
;	lda #$FF
;
;	;clear Irq
;
;	pla
;	plp
;	rti
;
;;-----------------------------
;;
;;	Reset and Interrupt Vectors (define for 265, 816/02 are subsets)
;;
;;-----------------------------

;vectors	SECTION OFFSET $FFE0
;					;65C816 Interrupt Vectors
;					;Status bit E = 0 (Native mode, 16 bit mode)
;		dw	badVec		; $FFE0 - IRQRVD4(816)
;		dw	badVec		; $FFE2 - IRQRVD5(816)
;		dw	badVec		; $FFE4 - COP(816)
;		dw	badVec		; $FFE6 - BRK(816)
;		dw	badVec		; $FFE8 - ABORT(816)
;		dw	badVec		; $FFEA - NMI(816)
;		dw	badVec		; $FFEC - IRQRVD(816)
;		dw	badVec		; $FFEE - IRQ(816)
;					;Status bit E = 1 (Emulation mode, 8 bit mode)
;		dw	badVec		; $FFF0 - IRQRVD2(8 bit Emulation)(IRQRVD(265))
;		dw	badVec		; $FFF2 - IRQRVD1(8 bit Emulation)(IRQRVD(265))
;		dw	badVec		; $FFF4 - COP(8 bit Emulation)
;		dw	badVec		; $FFF6 - IRQRVD0(8 bit Emulation)(IRQRVD(265))
;		dw	badVec		; $FFF8 - ABORT(8 bit Emulation)
;
;					; Common 8 bit Vectors for all CPUs
;		dw	badVec		; $FFFA -  NMIRQ (ALL)
;		dw	START		; $FFFC -  RESET (ALL)
;		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
		
;		ends
	        end
