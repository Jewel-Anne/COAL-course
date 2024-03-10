;###########################     COMMENT HEADER	    ############################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Author:	    Jewel Anne A. Reyes						;                          
;  Date:	    February 27, 2023						;             
;  Version:	    1.0.0							;
;  Title:	    Machine Problem 2.a						;
;										;
;  Description:	    This Code shows the running light of			;
;		    1 LED or logic probe with 1-sec interval.			;
;		    It will start from RB7 to RB0 and vice versa.		;
;		    There are diff methods to produce running lights.		;
;		    This code uses a data lookup table.				;
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
    cblock	0x20 		;start of general purpose registers
	count			;used in table read routine
	CounterA 		;used in delay routine
	CounterB 		;used in delay routine
	CounterC 		;used in delay routine
    endc

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
	
	BCF STATUS, RP0		;Bit Clear F (goes to Bank 0)
	CLRF PORTB		;set all outputs low
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Start	
	CLRF	count		;set counter register to zero
Read	
	MOVF	count, w	;put counter value in W
	CALL	Table	
	MOVWF	PORTB
	CALL	Delay		;1 second delay
	INCF	count,	w	;increment F
	XORLW	d'14'		;check for last (14th) entry
	BTFSC	STATUS,	Z
	GOTO	Start		;if start from beginning
	INCF	count,	f	;else do next
	GOTO	Read
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Table	
    ADDWF   PCL, f		;data table for bit pattern
    RETLW   b'10000000'		;RETLW Return with Literal in W
    RETLW   b'01000000'
    RETLW   b'00100000'
    RETLW   b'00010000'
    RETLW   b'00001000'
    RETLW   b'00000100'
    RETLW   b'00000010'
    RETLW   b'00000001'
    RETLW   b'00000010'
    RETLW   b'00000100'
    RETLW   b'00001000'
    RETLW   b'00010000'
    RETLW   b'00100000'
    RETLW   b'01000000'
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
END   