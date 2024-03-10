;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 26, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 1						;
;										;
;  Description:	    This Code shows the configuration of			;
;		    ports of PIC16F84A Microcontroller.				;
;		    It will reflect PORTA input to PORTB			;
;		    PORTA = input(DIP Switch); PORTB = output(Logic Probes)	;
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
	MOVLW b'11111111'	;Move to W Register the binary input FFH
	MOVWF TRISA		;Transfer W Register literals to F Register 85H
	MOVLW b'00000000'	;Move to W Register the binary input 00H
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	goto Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main
	MOVF PORTA, 0		;Move data from PORTA to W Register
	MOVWF PORTB		;Move data from W REgister to PORTB
	goto Main		;Looping and Updating
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
end
	