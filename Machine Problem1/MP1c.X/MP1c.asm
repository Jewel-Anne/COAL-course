;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 27, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 1.c						;
;										;
;  Description:	    This Code shows the function of RRF				;
;		    in PIC16F84A Microcontroller.				;
;		    It can be used as division operator. In this case:		;
;		    Shift to right 1x ==> Literals / 2^1			;
;		    You can set the Binary Literal at line 45 under MAIN	;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;#############    DECLARATION AND CONFIGURATION OF A PROCESSOR    ##############	
list p=16f84a			;Defining microcontroller model
#include <p16f84a.inc>		;Processor library for PIC16
__CONFIG _CP_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC	;Sets processor configuration bits

	
; General Purpose Registers (GPR):
Shift  EQU 0CH

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG 00H			;Start assembling lines below this statement at RESET vector (00h)
	    goto Initial
	ORG 04H			;Start assembling lines below this statement at Peripheral Interrupt Vector (04H)
	    retfie		;Return from interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	    
Initial
    ;Setting PORTB as Output
	BSF STATUS, 5		;Bit Set F (goes to Bank 1)
	MOVLW b'00000000'	;Set PORTB all Outputs
	MOVWF TRISB		;Transfer W Register literals to F Register 86H
	BCF STATUS, 5		;Bit Clear F (goes to Bank 0)
	goto MAIN
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
MAIN
	MOVLW b'00000010'	;SET THE BINARY YOU WANT TO DIVIDE HERE!
	MOVWF Shift		;Transfer W Register literals to F Register 0CH
	BCF STATUS, C		;Bit Clear F (clear carry bit)
	RRF Shift, f		;Shift to Right (Divide the Literals by 2^1)
	MOVF Shift, 0		;Move data from Shift to W Register
	MOVWF PORTB		;Move data from W REgister to Output
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end
	