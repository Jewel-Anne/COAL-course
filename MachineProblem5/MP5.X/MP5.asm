;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 28, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 5						;
;										;
;  Description:	    This Code shows the running light of			;
;		    1 LED or logic probe with 1-sec interval.			;
;		    It uses a Watchdog Timer with Prescaler/Postscaler		;
;		    rate of 1:128 for 2.3 seconds.				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;#############    DECLARATION AND CONFIGURATION OF A PROCESSOR    ##############	
list p=16f84a			;Defining microcontroller model
#include <p16f84a.inc>		;Processor library for PIC16
__CONFIG _CP_OFF & _PWRTE_ON & _WDT_ON & _XT_OSC	;Sets processor configuration bits

	
;##### DIRECTIVE EQU(equivalent) = text substitution for constant/variable #####
; Special Purpose Registers (SFR):
STATUS	    EQU 03H		;STATUS equivalent to 03H File Address
PORTA	    EQU 05H	
PORTB	    EQU 06H 	
TRISA	    EQU 85H	
TRISB	    EQU 86H
OPTION_REG  EQU 81H		;this is optional since it is already in p16f84a.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    GOTO Initial
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    RETFIE		;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
Initial
   	BSF STATUS, RP0		;Bit Set F (goes to Bank 1)
	
    ;Setting PORTB as Output
	MOVLW b'00000000'	;Move to W Register the binary input 00H
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	
	BSF OPTION_REG, 3	;Assigning Prescaler to WDT
	
    ;Setting Prescaler/Postcaler to 1:128 Rate or 2.3 Seconds (1.1.1) 
	BSF OPTION_REG, 2	;Set the Bit 2 
	BSF OPTION_REG, 1	;Set the Bit 1
	BSF OPTION_REG, 0	;Set the Bit 0
	
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	Goto Start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Start	
	BSF PORTB, 0		;Setting RB0 to high
	MOVLW b'00000101'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Infinite	
	CLRWDT			;Reset WDT
	BCF PORTB, 0		;Setting RB0 to low
	Goto Infinite		;Having infinite loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END   