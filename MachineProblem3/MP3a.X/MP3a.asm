;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    March 1, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 3.a						;
;										;
;  Description:	    Processing interrupt caused by change on pin RB0/INT	;
;		    the LED in RB7 pin is Blinking Fast				;
;		    Change in RB0/INT pin, MCU= interrupt routine of 		;
;		    10 blinks of 1 sec delay of interval in RB7 pin		;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;#############    DECLARATION AND CONFIGURATION OF A PROCESSOR    ##############	
list p=16f84a			;Defining microcontroller model
#include <p16f84a.inc>		;Processor library for PIC16
__CONFIG _CP_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC	;Sets processor configuration bits

	
;##### DIRECTIVE EQU(equivalent) = text substitution for constant/variable #####
; Special Purpose Registers (SFR):
STATUS	    EQU 03H		;STATUS equivalent to 03H File Address
PORTA	    EQU 05H	
PORTB	    EQU 06H 	
TRISA	    EQU 85H	
TRISB	    EQU 86H
OPTION_REG  EQU 81H	
INTCON	    EQU	0BH
; General Purpose Registers (GPR):
cblock 	0x20 			;start of general purpose registers
	CounterA    
	CounterB   
	CounterC        
	W_TEMP	
	STATUS_TEMP 
endc				;end of general purpose registers
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    GOTO Init
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    PUSH
		BCF INTCON, 0
		MOVWF W_TEMP
		SWAPF STATUS, W
		MOVWF STATUS_TEMP
	    ISR
		BCF INTCON, INTF
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
		
		BSF PORTB,7
		call Delay
		BCF PORTB,7
		call Delay
	    POP
		SWAPF STATUS_TEMP,W
		MOVWF STATUS
		SWAPF W_TEMP, F
		SWAPF W_TEMP, W
		    
	RETFIE			;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Init
	BSF STATUS, 5
	MOVLW b'00000001' 
	MOVWF TRISB
	BSF OPTION_REG,7
	BSF OPTION_REG,6
	BCF STATUS,5
	BSF INTCON,INTE 
	BSF INTCON,GIE
	BCF PORTB,7
	goto Blink
Blink
	BSF PORTB,7
	call Delay2

	BCF PORTB,7
	call Delay2
	goto Blink
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Delay
    MOVLW D'6'			;1 us
    MOVWF CounterC		;1 us
    MOVLW D'24'			;1 us
    MOVWF CounterB		;1 us
    MOVLW D'167'		;1 us
    MOVWF CounterA		;1 us
loop
    DECFSZ CounterA,1		;167 x 1 cycle + 1 cycle = 168 us
    GOTO loop			;166 * 2 us = 332 us
    DECFSZ CounterB,1		;24 x 1 cycle + 1 cycle = 25 us
    GOTO loop			;24 * 2 us = 48 us
    DECFSZ CounterC,1		;6 x 1 cycle + 1 cycle = 7 us
    GOTO loop			;5 * 2 us = 10 us
    NOP				;1 us
				;TOTAL = 597 us
    RETURN			;2 us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Delay2
    MOVLW D'1'			;1 us
    MOVWF CounterC		;1 us
    MOVLW D'24'			;1 us
    MOVWF CounterB		;1 us
    MOVLW D'167'		;1 us
    MOVWF CounterA		;1 us
loop2
    DECFSZ CounterA,1		;167 x 1 cycle + 1 cycle = 168 us
    GOTO loop2			;166 * 2 us = 332 us
    DECFSZ CounterB,1		;24 x 1 cycle + 1 cycle = 25 us
    GOTO loop2			;24 * 2 us = 48 us
    DECFSZ CounterC,1		;6 x 1 cycle + 1 cycle = 7 us
    GOTO loop2			;5 * 2 us = 10 us
    NOP				;1 us
				;TOTAL = 597 us
				;3A + 770B + 197,122C - 197,879
				;3(167) + 770(24) + 197,122(6) - 197,879
				;501 + 18,480 + 1,182,732 - 197,879
				;1,201,713 - 197,879
				;DELAY = 1,003,834 us == 1.003 seconds
    RETURN			;2 us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
end
	