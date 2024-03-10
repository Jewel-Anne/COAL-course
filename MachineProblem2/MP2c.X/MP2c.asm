;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 28, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 2.c						;
;										;
;  Description:	    This Code shows a BCD Counter of 00H-FFH			;
;		    using 1-second interval.					;
;		    It will increment every negative input in RA4.		;
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
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    goto Initial
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    retfie		;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Initial
	BSF STATUS, 5		;Bit Set F (goes to Bank 1)
	
    ;Setting PORTA as Input and PORTB as Output
	MOVLW b'00010000'	;Move to W Register the binary input 10H
	MOVWF TRISA		;Transfer W Register literals to F Register 85H
	MOVLW b'00000000'	;Move to W Register the binary input 00H
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	CLRF PORTB		;Initialize PORTB to 0
	
	goto Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main
    BTFSS PORTA, 4		;Check if RA4 is high
    goto Main			;If it's high, keep waiting for falling edge
    BTFSC PORTA, 4		;Check if RA4 is now low
    goto Main			;If it's still high, keep waiting for falling edge
    INCF PORTB, 1		;If it's low, increment PORTB
    goto Main			;Wait for next falling edge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end
	