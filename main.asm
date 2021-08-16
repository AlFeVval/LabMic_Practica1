;This is a template with the most typical sections of an assembly-language program
;This program keeps an LED turned on while the PIC is biased
;The LED is attached to the pin 0 of PORTB
;The instruction set is used with a=0 (Access RAM)
;******************Header Files******************************
    list	    p=18f4550        ; list directive to define processor
    #include	    "p18f4550.inc"
    
; CONFIG1L
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC3_PLL4    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /3][96 MHz PLL Src: /4])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes from the 96 MHz PLL divided by 2)

; CONFIG1H
  CONFIG  FOSC = HSPLL_HS       ; Oscillator Selection bits (HS oscillator, PLL enabled (HSPLL))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
  CONFIG  PBADEN = ON          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)

;****************Variables Definition*********************************
    TEMP		EQU	0x22			;Reservamos 22 localidades de memoria
    CONSTANT		MASK = b'00000011'		;Mascara que delimitara los bits mas significativos
;****************Main code*****************************
			ORG     0x000             	;reset vector
  			GOTO    MAIN              	;go to the main routine
INITIALIZE:
			CLRF	TRISD			;Puerto D como salidas
			SETF	TRISC			;Puerto C como entradas
			
			RETURN				;end of initialization subroutine

MAIN:
			CALL 	INITIALIZE

BASE:
			MOVF	PORTC, 0		;PORTC es movido a WREG
			ANDLW	MASK			;
			MOVWF	TEMP			;
			CALL	DECODE		;
			MOVWF	PORTD			;
			GOTO 	BASE			;infinite loop

DECODE:
			ADDWF	PCL,1			;
			RETLW	b'01111110'		;//0
			RETLW	b'00110000'		;//1
			RETLW	b'01101101'		;//2
			RETLW	b'01111001'		;//3
			RETLW	b'00110011'		;//4
			RETLW	b'01011011'		;//5
			RETLW	b'00011111'		;//6
			RETLW	b'01110000'		;//7
			RETLW	b'01111111'		;//8
			RETLW	b'01110011'		;//9
			RETLW	b'01110111'		;//A
			RETLW	b'00011111'		;//B
			RETLW	b'01001110'		;//C
			RETLW	b'00111101'		;//D
			RETLW	b'01001111'		;//E
			RETLW	b'01000111'		;//F
			
			END                       	;end of the main program
