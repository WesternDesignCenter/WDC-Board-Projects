; File: VIA_Test.asm
; 02-13-2018

     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************



;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


			title  "65C02 MyMENSCH SA Program V 1.00 - VIA_Test"
			sttl


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: VIA_Test.asm
;
;  DATA_RIGHTS: Western Design Center
;               Copyright(C) 1980-2018
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
;  TITLE: VIA_Test
;
;  DESCRIPTION: This File describes the WDC MyMENSCH VIA_Test Program.
;
;
;
;  DEFINED FUNCTIONS:
;          badVec
;                   - Process a Bad Interrupt Vector - Hang!
;
;  SPECIAL_CONSIDERATIONS:
;	None
;
;  SHARED_DATA:
;	None
;
;  GLOBAL_MODULES:
;	None
;
;  LOCAL_MODULES:
;	See above in "DEFINED FUNCTIONS"
;
;  AUTHOR: Bill Mensch
;
;  CREATION DATE: February 13, 2018
;
;  REVISION HISTORY
;     Name           Date         Description
;     ------------   ----------   ------------------------------------------------
;     Bill Mensch    02-13-2018   1.00 Initial
;
;
; NOTE:
;    Change the lines for each version - current version is 1.00
;    See -
;         title  "VIA test code for MyMENSCH Program V 1.00 - VIA_Test"
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
	VIAB_BASE:	equ	$7F30		; base address of VIA
	VIAB_ORB:	equ	VIAB_BASE
	VIAB_IRB:	equ	VIAB_BASE
	VIAB_ORA:	equ	VIAB_BASE+1
	VIAB_IRA:	equ	VIAB_BASE+1
	VIAB_DDRB:	equ	VIAB_BASE+2
	VIAB_DDRA:	equ	VIAB_BASE+3

	VIA_BASE:	equ	$7F20		; base address of VIA
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

	GPIOB_BASE:	equ	$7F08		; base address of GPIOB LED port
	GPIOB_DATA:	equ	GPIOB_BASE+0
	GPIOB_DDR:	equ	GPIOB_BASE+1
	GPIOB_IFR:	equ	GPIOB_BASE+2
	GPIOB_IER:	equ	GPIOB_BASE+3
	GPIOB_ESR:	equ	GPIOB_BASE+4
	GPIOB_PER:	equ	GPIOB_BASE+5

	GPIOA_BASE:	equ	$7F00		; base address of GPIOB LED port
	GPIOA_DATA:	equ	GPIOA_BASE+0
	GPIOA_DDR:	equ	GPIOA_BASE+1
	GPIOA_IFR:	equ	GPIOA_BASE+2
	GPIOA_IER:	equ	GPIOA_BASE+3
	GPIOA_ESR:	equ	GPIOA_BASE+4
	GPIOA_PER:	equ	GPIOA_BASE+5
	
	ACIA_BASE:	equ	$7F6C		; base address of ACIA
	ACIA_DATA:	equ	ACIA_BASE
	ACIA_STAT:	equ	ACIA_BASE+1
	ACIA_CMD:	equ	ACIA_BASE+2
	ACIA_CTRL:	equ	ACIA_BASE+3
	

	CHIP	65C02
	LONGI	OFF
	LONGA	OFF

	.sttl "W65C265i1 Code"

	.page

;***************************************************************************
;***************************************************************************
;                   Simple LED Routines for MyMENSCH
;***************************************************************************
;***************************************************************************
;

;***************************************************************************
;Important, this is your jump table.  This needs to be in the code to work 
;properly with the included MyMENSCH firmware.
;***************************************************************************

	org $8000
;;This is for interrupts ONLY!!!	
;	jmp Start
;	jmp NMI_Handle
;	jmp BRK_Handle
;	jmp NoINT	;IRQ_ACIA_C
;	jmp NoINT	;IRQ_ACIA_B
;	jmp NoINT	;IRQ_ACIA_A
;	jmp NoINT	;IRQ_ADC
;	jmp NoINT	;IRQ_I2C
;	jmp NoINT	;IRQ_SPI
;	jmp NoINT	;IRQ_VIA_D
;	jmp NoINT	;IRQ_VIA_C
;	jmp NoINT	;IRQ_VIA_B
;	jmp NoINT	;IRQ_VIA_A
;	jmp NoINT	;IRQ_GPIO_A / Keypad Interrupt
;	jmp NoINT	;IRQ_GPIO_E

;	org $0700;	This is here for W65C02SOC demo if needed. 
Start:

;	sei			; Turn on interrupts

	cld
	ldx #$ff		; Initialize the stack pointer
	txs

; First, we initialize GPIO_B outputs for driving the LEDs

	lda #$ff
	sta GPIOB_DDR		; set all GPIO pins as outputs
	
;	lda #$55
;	sta GPIOB_DATA
	
;	lda GPIOB_DATA
;	sta $1000
;	
;	lda $1000
;	sta GPIOB_DATA
;	
	lda #$AF
	sta GPIOB_DATA
	

HOME:
;	lda #$81
;	sta GPIOB_DATA

	bra HOME
	
;This is the main interrutpt/break handler		
BRK_Handle:

	php
	pha
	lda #$FF

;clear Irq

	pla
	plp
	
	rti


;; This code is here in case the system gets an NMI.  It clears the intterupt flag and returns.
;
NMI_Handle:				; $FFE0 - IRQRVD2
	php
	pha
	lda #$FF

;clear Irq

	pla
	plp
	rti

;NoINT Routine for Each of the Hardware Priority Coded Interrupts that are not used 
;If a hardware interrupt will be activated, remove the jmp NoINT above and add a routine for 
;the appropriate interrupt funtion.
NoINT:
	rti


	        end
	ends
	