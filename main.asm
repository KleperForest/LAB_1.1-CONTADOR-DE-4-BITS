//*********************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de Microcontroladores
// Autor: Alan Gomez
// Proyecto: Laboratorio 1.asm
// Descripción: Primer Laboratorio de Programación de Microcontroladores. 
// Hardware: ATmega328p
// Created: 1/24/2024 5:38:40 PM
//*********************************************************************
// Encabezado
//*********************************************************************
.include "M328PDEF.inc"

.cseg; Comensamos con el segmento de Codigo. 
.org 0x00 ;Posicion 0
//*********************************************************************
// Stack Pointer
//*********************************************************************
LDI R16, LOW(RAMEND)// Ultima direccion de la memorio RAM 16bits
OUT SPL, R16 // Se colocara en el registro SPL
LDI R17, HIGH(RAMEND)// Seleccionamos la parte alta 
OUT SPH, R17 //Se colocara en el registro SPH
//*********************************************************************

//*********************************************************************
//Configuracion MCU
//*********************************************************************
SETUP:

	; VELOCIDAD*****************************************************

	LDI R16, 0b1000_0000
	LDI R16, (1 << CLKPCE) 
	STS CLKPR, R16        // Habilitando el prescaler 

	LDI R16, 0b0000_0100
	STS CLKPR, R16   //Frecuencia 1MHz	 16/16 = 1
		
	;ENTRADAS Y SALIDAS*****************************************************

	LDI R16, 0b1111_1100; Se configuran todos los pines de PORTD como salidas
	OUT DDRD, R16

	LDI R16, 0xFF; Se configuran todos los pines de PORTB como salidas
	OUT DDRB, R16
				   
	LDI R16, 0b0001_1111; Se configuran PC0, PC1, PC2, PC3, PC4 
	;Como entrada con pull up  
	OUT PORTC, R16
	
	LDI R16, 0b0010_0000;Se configura PC5 como salida
	OUT DDRC, R16

//*********************************************************************
//LOOP infinito
//*********************************************************************
LOOP: 
	
	IN R16, PINC; Cargo a r16 el valor de los pines C
	SBRS R16, PC0; Salta si el bit PC0 es 1 
	RJMP ENCENDER; Ir a  modulo de ENCENDER

	RJMP LOOP; LOOP				   
	
//*********************************************************************
//Subrutinas
//*********************************************************************
ENCENDER:
	LDI R16, 255   //Cargar con un valor a R16
	delay:
		DEC R16 //Decrementa R16
		BRNE delay   //Si R16 no es igual a 0, tira al delay

	LDI R16, 0xFF; Carga R16 con un inmediato 0b1111_1111
	OUT PIND, R16; Carga a PIND que es un I/O, con el r16
	LDI R16, 0xFF; Carga R16 con un inmediato 0b1111_1111		 
	OUT PINB, R16 ; Carga a PINB que es un I/O, con el r16
	LDI R16, 0b0010_0000; Carga R16 con un inmediato 0b0001_0000 
	; Para solo prender el PC5
	OUT PINC, R16; ; Carga a PINB que es un I/O, con el r16
	
	

	
RJMP LOOP	

	