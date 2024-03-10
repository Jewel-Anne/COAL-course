;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    March 1, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 3.b						;
;										;
;  Description:	    Processing interrupt caused by changes on pins RB4-RB7	;
;		    LED in RB0 to RB3 will recurrence of counting 0?9 BCD	;
;		    Change in RB4-RB7 pin, MCU= interrupt routine of 		;
;		    10 blinks of 1 sec delay of interval in RB0-RB3 pin		;
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
	    MOVWF W_TEMP
	    MOVF STATUS, 0
	    MOVWF STATUS_TEMP	
	ISR
	    BCF INTCON, 0

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay

	    BSF PORTB, 0
	    BSF PORTB, 1
	    BSF PORTB, 2
	    BSF PORTB, 3
	    CALL Delay

	    BCF PORTB, 0
	    BCF PORTB, 1
	    BCF PORTB, 2
	    BCF PORTB, 3
	    CALL Delay
	POP
	    MOVF STATUS_TEMP, 0
	    MOVWF STATUS
	    MOVF W_TEMP, 0
	    goto Start
	retfie
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Init
    BSF STATUS,5
    MOVLW 0xF0 ; Set TRISB<3:0> = 0 (output) and TRISB<7:4> = 1 (input)
    MOVWF TRISB
    BSF OPTION_REG, 6
    BSF OPTION_REG, 7
    BCF STATUS, 5
    BSF INTCON, RBIE ; change to 3
    BSF INTCON, GIE
    goto Start
Start
    ;0
    BCF PORTB, 0
    BCF PORTB, 1
    BCF PORTB, 2
    BCF PORTB, 3
    CALL Delay
    
    ;1
    BCF PORTB, 0
    BCF PORTB, 1
    BCF PORTB, 2
    BSF PORTB, 3
    CALL Delay
    
    ;2
    BCF PORTB, 0
    BCF PORTB, 1
    BSF PORTB, 2
    BCF PORTB, 3
    CALL Delay
    
    ;3
    BCF PORTB, 0
    BCF PORTB, 1
    BSF PORTB, 2
    BSF PORTB, 3
    CALL Delay
    
    ;4
    BCF PORTB, 0
    BSF PORTB, 1
    BCF PORTB, 2
    BCF PORTB, 3
    CALL Delay
    
    ;5
    BCF PORTB, 0
    BSF PORTB, 1
    BCF PORTB, 2
    BSF PORTB, 3
    CALL Delay
    
    ;6
    BCF PORTB, 0
    BSF PORTB, 1
    BSF PORTB, 2
    BCF PORTB, 3
    CALL Delay
    
    ;7
    BCF PORTB, 0
    BSF PORTB, 1
    BSF PORTB, 2
    BSF PORTB, 3
    CALL Delay
    
    ;8
    BSF PORTB, 0
    BCF PORTB, 1
    BCF PORTB, 2
    BCF PORTB, 3
    CALL Delay
    
    ;9
    BSF PORTB, 0
    BCF PORTB, 1
    BCF PORTB, 2
    BSF PORTB, 3
    CALL Delay
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
    RETURN			;2 us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
end