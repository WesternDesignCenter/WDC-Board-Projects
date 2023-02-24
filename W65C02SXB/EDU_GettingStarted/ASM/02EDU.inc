; File: 02EDU.inc
; 2021/04/01

	PIA:			equ	$7FA0
	ACIA:			equ	$7F80
	VIA_BASE_ADR:  		EQU  	$7FC0       ; (Base address of the 6522 VIA.)

;W65C22 VIA Registers
	PB:     		EQU  VIA_BASE_ADR+0   ; Addresses of 16 registers in 6522.
	PA:     		EQU  VIA_BASE_ADR+1   ; (We really only need the first four for this.)
	DDRB:   		EQU  VIA_BASE_ADR+2
	DDRA:   		EQU  VIA_BASE_ADR+3
	T1CL:   		EQU  VIA_BASE_ADR+4
	T1CH:   		EQU  VIA_BASE_ADR+5
	T1LL:   		EQU  VIA_BASE_ADR+6
	T1LH:   		EQU  VIA_BASE_ADR+7
	T2CL:   		EQU  VIA_BASE_ADR+8
	T2CH:   		EQU  VIA_BASE_ADR+9
	SR:     		EQU  VIA_BASE_ADR+$A
	ACR:    		EQU  VIA_BASE_ADR+$B
	PCR:    		EQU  VIA_BASE_ADR+$C
	IFR:    		EQU  VIA_BASE_ADR+$D
	IER:    		EQU  VIA_BASE_ADR+$E
	PANOHS: 		EQU  VIA_BASE_ADR+$F
;W65C22 VIA Constants		
	VIA_CA2:		equ      $01
	VIA_CA1:		equ      $02
	VIA_SR:			equ      $04
	VIA_CB2:		equ      $08
	VIA_CB1:		equ      $10
	VIA_TIMER2:		equ      $20
	VIA_TIMER1:		equ      $40
	VIA_IRQ:		equ      $80

;W65C51N ACIA Registers				
	ACIA_DR:		equ	ACIA
	ACIA_SR:		equ	ACIA+1
	ACIA_CMD:		equ	ACIA+2
	ACIA_CNT:		equ	ACIA+3
;W65C51N ACIA Constants			
	ACIA_RTS:		equ	$08
	ACIA_IRQ:		equ	$80
	ACIA_DSR:		equ	$40
	ACIA_DCD:		equ	$20
	ACIA_TDRE:		equ	$10
	ACIA_RDRF:		equ	$08
	ACIA_OVRN:		equ	$04
	ACIA_FE:		equ	$02
	ACIA_PE:		equ	$01
	ACIA_DTR:		equ	$01
	
	Buffer_Size:		equ      70
	Buffer_Range:		equ      Buffer_Size - 6
			
	ACIA_A_Buffer_Size:	equ	Buffer_Range

;W65C21 PIA Registers				
	PIA_PA:			equ	PIA	;CRA2 MUST BE 1
	PIA_DDRA:		equ	PIA	;CRA2 MUST BE 0
	PIA_CRA:		equ	PIA+1	;Control Register A
	PIA_PB:			equ	PIA+2	;CRB2 MUST BE 1
	PIA_DDRB:		equ	PIA+2   ;CRB2 MUST BE 0
	PIA_CRB:		equ	PIA+3	;Control Register B
	
;W65C21 PIA/LED Constants 	
	LED0:			equ	$01
	LED1:			equ	$02
	LED2:			equ	$04
	LED3:			equ	$08
	LED4:			equ	$10
	LED5:			equ	$20
	LED6:			equ	$40
	LED7:			equ     $80
				
	LED_DATA:		equ	PIA_PA
	LED_DDR:		equ	PIA_DDRA
				

;I2C			
	;i2c		
	i2c:			equ	$7F00	;XCS0B
	i2c_Transmit:		equ	i2c
	i2c_Receive:		equ	i2c
	i2c_S0:			equ	i2c
	i2c_S1:			equ	i2c+1
	i2c_Control:		equ 	i2c+1	; WRITE IS CONTROL
	i2c_Status:		equ 	i2c+1	; READ IS STATUS
	i2c_Clock:		equ	i2c	; MUST SETUP CTRL FOR ACCESS FIRST
			
	i2c_Enable:		equ	$80
	i2c_Int_Enable:		equ	$40
				
	i2c_Start:		equ	$C5	;$80
	i2c_Stop:		equ	$C3	;$40
	i2c_Rd:			equ	$01
	i2c_Wr:			equ	$00
	i2c_NACK:		equ	$08
	i2c_IACK:		equ	$01
			
	;i2c status pins		
	i2c_PIN:		equ	$80
	i2c_STS:		equ	$20
	i2c_BER:		equ	$02
	i2c_AD0LRB:		equ	$08
	i2c_AAS:		equ	$04
	i2c_LAB:		equ	$02
	i2c_BB:			equ	$01
			
	;i2c clock setting		
	i2c_S24:		equ	$10
	i2c_S23:		equ	$08
	i2c_S22:		equ	$04
	i2c_S21:		equ	$02
	i2c_S20:		equ	$01
			
;RTC MCP79411		
	RTC_ID:			equ	$6F
	RTC_Power:		equ	$03
	RTC_Control:		equ	$07
	RTC_OSCTrim:		equ	$08
	RTC_VBatEn:		equ	$08
	RTC_EXTOSC:		equ	$08
	RTC_SQWEN:		equ	$40
	RTC_OUT:		equ	$80
	RTC_SQWFS0:		equ	$00
	RTC_SQWFS1:		equ	$01
	RTC_SQWFS2:		equ	$02
	RTC_SQWFS3:		equ	$03
	RTC_Time:		equ	$00
	RTC_Date:		equ	$04
	RTC_OSCRUN:		equ	$20
	RTC_ST:			equ     $80
			
	RTC_SEC:		equ	$00
	RTC_MIN:		equ	$01
	RTC_HOUR:		equ	$02
	RTC_WKDAY:		equ	$03
	RTC_DATE:		equ	$04
	RTC_MTH:		equ	$05
	RTC_YEAR:		equ	$06
	RTC_CONTROL:		equ	$07
	RTC_OSCTRIM:		equ	$08
			
	RTC_ALM0SEC:		equ      $0A
	RTC_ALM0MIN:		equ      $0B
	RTC_ALM0HOUR:		equ      $0C
	RTC_ALM0WKDAY:		equ      $0D
	RTC_ALM0DATE:		equ      $0E
	RTC_ALM0MTH:		equ      $0F
			
	RTC_ALM1SEC:		equ      $11
	RTC_ALM1MIN:		equ      $12
	RTC_ALM1HOUR:		equ      $13
	RTC_ALM1WKDAY:		equ      $14
	RTC_ALM1DATE:		equ      $15
	RTC_ALM1MTH:		equ      $16
			
	RTC_PWRDNMIN:		equ      $18
	RTC_PWRDNHOUR:		equ      $19
	RTC_PWRDNDATE:		equ      $1A
	RTC_PWRDNMTH:		equ      $1B
			
	RTC_PWRUPMIN:		equ      $1C
	RTC_PWRUPHOUR:		equ      $1D
	RTC_PWRUPDATE:		equ      $1E
	RTC_PWRUPMTH:		equ      $1F
		
;ADC ADS1015IDGSR
	;ADC = 1001000x (VSS) or 1001001x (VDD) : 48 or 49 before the ROL
	ADC_ID:			equ 	$48
		
;Cryptochip ATECC608	
	ATECC_ID:		equ      $60
		
	ATECC_Reset:		equ      $00
	ATECC_Sleep:		equ      $01
	ATECC_Idle:		equ      $02
	ATECC_Command:		equ      $03
		
	ATECC_AES:		equ	$51
	ATECC_CheckMac:		equ	$28
	ATECC_Counter:		equ	$24
	ATECC_DeriveKey:	equ	$1C
	ATECC_ECDH:		equ	$43
	ATECC_GenDig:		equ	$15
	ATECC_GenKey:		equ	$40
	ATECC_Info:		equ	$30
	ATECC_KDF:		equ	$56
	ATECC_Lock:		equ	$17
	ATECC_MAC:		equ	$08
	ATECC_Nonce:		equ	$16
	ATECC_PrivWrite:	equ	$46
	ATECC_Random:		equ	$1B
	ATECC_Read:		equ	$02
	ATECC_SecureBoot:	equ	$80
	ATECC_SelfTest:		equ	$77
	ATECC_Sign:		equ	$41
	ATECC_SHA:		equ	$47
	ATECC_Verify:		equ	$45
	ATECC_UpdateExtra:	equ	$20
	ATECC_Write:		equ	$12
