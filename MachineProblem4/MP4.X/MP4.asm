;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    March 1, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 4						;
;										;
;  Description:	    This Code shows how Sleep Instruction works			;
;		    Output= RB0-RB3; Input= RB4-RB7				;
;		    This code will blink the output for interval		;
;		    of 1 second for 10 times and will execute Sleep		;
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
	Var	    
	W_TEMP	
	STATUS_TEMP 
endc				;end of general purpose registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    GOTO Init
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    
	    PUSH
		    MOVWF W_TEMP	
		    SWAPF STATUS, 0
		    MOVWF STATUS_TEMP

	    ISR
		    BCF INTCON, 0

	    POP
		    SWAPF STATUS_TEMP, 0
		    MOVWF STATUS
		    SWAPF W_TEMP, 1
		    SWAPF W_TEMP, 0
		    
	RETFIE			;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Init
	MOVLW 0x0A
	MOVWF Var
	BSF STATUS,5		;Bit Set F (goes to Bank 1)
	MOVLW 0xF0
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	BSF OPTION_REG, 7	;Enables internal pull-up resistors on PORTB
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	BSF INTCON, 7		;GIE: Enable all un-masked interrupts
	BSF INTCON, 3		;RBIE: Enables RB Port change interrupt
	
    ;Clearing of bits in PORTB register
	BCF PORTB, 0	
        BCF PORTB, 1
        BCF PORTB, 2
        BCF PORTB, 3
	
	goto Start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Start	
    ;Setting the bits into high
	BSF PORTB, 0
        BSF PORTB, 1
        BSF PORTB, 2
        BSF PORTB, 3
	
        CALL Delay		;1 second delay
	
    ;Clearing of bits in PORTB register
	BCF PORTB, 0
        BCF PORTB, 1
        BCF PORTB, 2
        BCF PORTB, 3
	
	CALL Delay		;1 second delay
	
        decfsz Var, 1		;Decrement F, Skip if 0
        goto Start 
        goto loopx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
loopx
        NOP			;No operation
        Sleep			
	BCF INTCON, 7		;GIE: Disables all interrupts
	MOVLW 0x0A
	MOVWF Var
	goto Start
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
				;3A + 770B + 197,122C - 197,879
				;3(167) + 770(24) + 197,122(6) - 197,879
				;501 + 18,480 + 1,182,732 - 197,879
				;1,201,713 - 197,879
				;DELAY = 1,003,834 us == 1.003 seconds
    RETURN			;2 us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
end
	