; File: HelloWorld.asm

; This is a simple example of how to turn on LEDs to represent a basic HelloWorld project in 6502 Assembly

		org	 			        ; This is the location in memory where the program is stored

; When the board is plugged in or reset, Port B of the W65C22 device is setup as INPUTS.  
; Since we are turning LEDS ON and OFF, we want Port B to be OUTPUTS
		lda	   				    ; LoaD the Accumulator with FF = 1111 1111 (ALL HIGH)
		sta					    ; STore Accumulator to address $7FC2 which is the Data Direction Register B
								; This sets each of the Port B lines to be OUTPUTS.  

; Now that Port B is setup to turn the LEDs ON, we need to tell it which ones.
		
		lda 	                ; LED OFF
		sta 				    ; This is the location of the Output Register of Port B		

		lda                     ; LED ON
		sta 				    ; This is the location of the Output Register of Port B	
		
		sta 				    ; This is the location of the Output Register of Port B	
		jmp 				    ; JuMP to beginning of program

; End of Lesson		

;-----------------------------------------------------------------------------------------------------------------		


;***************************************************************************
;***************************************************************************
; New for WDCMON V1.04
;  Needed to move Shadow Vectors into proper area
;***************************************************************************
;***************************************************************************
SH_vectors:	section
Shadow_VECTORS	SECTION OFFSET $7EFC
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

;		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	$1900		; $FFFC -  RESET (ALL)
;		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)

	        ends
;***************************************************************************

vectors	SECTION OFFSET $FFFC
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

;		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	$1900		; $FFFC -  RESET (ALL)
;		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)
	
	        ends

	        end


