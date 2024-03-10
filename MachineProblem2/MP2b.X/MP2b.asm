;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 28, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 2.b						;
;										;
;  Description:	    This Code shows a BCD Counter of 0-9			;
;		    using 1-second interval.					;
;		    It uses 4 bits of output (RB0-RB3)				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;#############    DECLARATION AND CONFIGURATION OF A PROCESSOR    ##############	
list p=16f84a			;Defining microcontroller model
#include <p16f84a.inc>		;Processor library for PIC16
__CONFIG _CP_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC	;Sets processor configuration bits

	
;##### DIRECTIVE EQU(equivalent) = text substitution for constant/variable #####
; Special Purpose Registers (SFR):
STATUS	  EQU 03H		;STATUS equivalent to 03H File Address
PORTA	  EQU 05H	
PORTB	  EQU 06H 	
TRISA     EQU 85H	
TRISB     EQU 86H
; General Purpose Registers (GPR):
cblock 	0x20 			;start of general purpose registers
	CounterA 		;used in delay subroutine
	CounterB 		;used in delay subroutine
	CounterC 		;used in delay subroutine
endc
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    goto Initial
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    retfie		;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Initial
	BSF STATUS, 5		;Bit Set F (goes to Bank 1)
	
    ;Setting PORTB as Output
	MOVLW b'00000000'	;Move to W Register the binary input 00H
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	BCF STATUS, 0		;Bit Clear F (Move the Carry in the register)
	
	goto Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main
	MOVLW b'00000000'	;Set 1st bit into decimal 0
	MOVWF PORTB		;Transfer W Register literals to F Register 06H
	Call Delay		;Subroutine of 1 second delay

	MOVLW b'00000001'	;Decimal == 1
	MOVWF PORTB		
	Call Delay		
	
	MOVLW b'00000010'	;Decimal == 2
	MOVWF PORTB		
	Call Delay		
	
	MOVLW b'00000011'	;Decimal == 3
	MOVWF PORTB		
	Call Delay	
        
	MOVLW b'00000100'	;Decimal == 4
	MOVWF PORTB		
	Call Delay	
	
	MOVLW b'00000101'	;Decimal == 5
	MOVWF PORTB		
	Call Delay
	
	MOVLW b'00000110'	;Decimal == 6
	MOVWF PORTB		
	Call Delay
	
	MOVLW b'00000111'	;Decimal == 7
	MOVWF PORTB		
	Call Delay
	
	MOVLW b'00001000'	;Decimal == 8
	MOVWF PORTB		
	Call Delay
	
	MOVLW b'00001001'	;Decimal == 9
	MOVWF PORTB		
	Call Delay
	
	goto Main
    
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
	