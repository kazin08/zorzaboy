;.INCLUDE "LCD_5110_controller.h"
;.INCLUDE "snake.h"

;**************************************************************************/
;**************************************************************************/
;EEPROM memory
;**************************************************************************/
;**************************************************************************/
.ESEG

HIGH_SCORE:		.byte	1		;memory for save the highscore
;**************************************************************************/
;**************************************************************************/
;RAM memory
;**************************************************************************/
;**************************************************************************/
.dseg

RAM_DISPLAY:	.byte	588		;set the RAM value for Display
SECUENCIA:		.byte	100		;set RAM value for the sequence of simon says

;***************************************************************************/
;***************************************************************************/
;FLASH memory
;***************************************************************************/
;***************************************************************************/


.CSEG	
.ORG	0x0000
JMP		MAIN

.ORG	0x0006
RJMP	PCINT0_HANDLER	

.ORG	0x0008
RJMP	PCINT1_HANDLER

.ORG	0x000A
RJMP	PCINT2_HANDLER

.ORG	0x0020
RJMP	TIMER0_OVF_HANDLER


.ORG 0x0034

;*********************************************************************
;Function to handle interrups of PCINT0
;*********************************************************************/

PCINT0_HANDLER:
	
	SBIC	PINB,B_BUTTON
	CALL	PAUSE_SNAKE
RETI

;*********************************************************************
;Function to handle interrups of PCINT1
;*********************************************************************/

PCINT1_HANDLER:
	
	SBIC	PIN_SNAKE,UP_BUTTON
	CALL	UP_BUTTON_PRESSED
		
	SBIC	PIN_SNAKE,LEFT_BUTTON
	CALL	LEFT_BUTTON_PRESSED
	
	SBIC	PIN_SNAKE,DOWN_BUTTON
	CALL	DOWN_BUTTON_PRESSED
		
	SBIC	PIN_SNAKE,RIGHT_BUTTON
	CALL	RIGHT_BUTTON_PRESSED
	
RETI

;*********************************************************************
;Function to handle interrups of PCINT2
;*********************************************************************/

PCINT2_HANDLER:
	;Not using it yet
RETI

;********************************************************************
;Function to handle interrups product of the overflow of TIMER0
;********************************************************************/

TIMER0_OVF_HANDLER:
	PUSH	ZL
	PUSH	ZH
	
	LDI		ZL,LOW(RAM_DISPLAY)
	LDI		ZH,HIGH(RAM_DISPLAY)	
	CALL	REFRESH_DISPLAY
	
	POP		ZH
	POP		ZL
RETI
;********************************************************************/
;END of interuptions



;************************************************************/
;TEXTS TO SHOW ON DISPLAY
;************************************************************/

score:		.db		"Score: 000"	;text to show score of the snake game
LOADING:	.db		"  LOADING..."
VIDAS:		.db		"VIDAS:"
NUMEROS:	.db		"00 -"
SIMON:		.db		"Simon dice: "
TU_TURNO:	.db		"   Tu turno   "
PRESS:		.db		"Press A "
HIGH_SC:	.db		"hi: 000 "
GAME_OVERR:	.db		"  GAME OVER "
JUEGOS:		.db		"    Juegos    "
GAME_SNAKE:	.db		"A: Snake    "
GAME_SIMON:	.db		"B: Simon    "
PAUSE_MSG:	.db		"    PAUSA   "
PRESS_A_MSG:	.db "A: continuar"
PRESS_B_MSG:	.db "B: salir"
ZORZA:		.db		"   ZORZABOY   "


;***********************************************************/
;GRAPHICS TO PRINT ON DISPLAY
;***********************************************************/

;EMPTY ARROW UP

FLECHA_UP:	.db		0x30, 0x28, 0xE4, 0x02, 0x01, 0x02, 0xE4, \
					0x28, 0x30, 0x00, 0x00, 0x07, 0x04, 0x04, \
					0x04, 0x07, 0x00, 0x00

;EMPTY ARROW DOWN

FLECHA_DWN:	.db		0x60, 0xA0, 0x3F, 0x01, 0x01, 0x01, 0x3F, \
					0xA0, 0x60, 0x00, 0x00, 0x01, 0x02, 0x04, \
					0x02, 0x01, 0x00, 0x00


;EMPTY ARROW RIGTH

FLECHA_R:	.db		0x7C, 0x44, 0x44, 0x44, 0x44, 0xC7, 0x01, \
					0x82, 0x44, 0x28, 0x10, 0x00, 0x00, 0x00, \
					0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, \
					0x00  

;EMPTY ARROW LEFT


FLECHA_L:	.db		0x10, 0x28, 0x44, 0x82, 0x01, 0xC7, 0x44, \
					0x44, 0x44, 0x44, 0x7C, 0x00, 0x00, 0x00, \
					0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, \
					0x00  
					

;FILLED ARROW UP

					
FLECHA_UP_NEG:	.db	0x30, 0x38, 0xFC, 0xFE, 0xFF, 0xFE, 0xFC, \
					0x38, 0x30, 0x00, 0x00, 0x07, 0x07, 0x07, \
					0x07, 0x07, 0x00, 0x00

;FILLED ARROW LEFT

FLECHA_L_NEG:	.db	0x10, 0x38, 0x7C, 0xFE, 0xFF, 0xFF, 0x7C, \
					0x7C, 0x7C, 0x7C, 0x7C, 0x00, 0x00, 0x00, \
					0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, \
					0x00
					
;FILLED ARROW RIGTH

FLECHA_R_NEG:	.db	0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0xFF, 0xFF, \
					0xFE, 0x7C, 0x38, 0x10, 0x00, 0x00, 0x00, \
					0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, \
					0x00

;FILLED ARROW DOWN

					
FLECHA_DWN_NEG:	.db	0x60, 0xE0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, \
					0xE0, 0x60, 0x00, 0x00, 0x01, 0x03, 0x07, \
					0x03, 0x01, 0x00, 0x00

;LINEA:		.db		0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF

;LINEA2:		.db		0xFF, 0x00



;EMPTY CIRCLE 10 (pixels) * 2 (bytes)

CIRCULO:	.db		0xF8, 0x04,	0x02, 0x01, 0x01, 0x01, 0x01, 0x02, \
					0x04, 0xF8, 0x00, 0x01, 0x02, 0x04, 0x04, 0x04, \
					0x04, 0x02, 0x01, 0x00

;FILLED CIRCLE 10*2

CIRCULO_NEG:	.db	0xF8, 0xFC, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, \
					0xFC, 0xF8, 0x00, 0x01, 0x03, 0x07, 0x07, 0x07, \
					0x07, 0x03, 0x01, 0x00


;FILLED HEART 10*2

CORAZON_NEG:	.db	0x1C, 0x3E, 0x7F, 0xFE, 0xFC, 0xFC, 0xFE, 0x7B, \
					0x3E, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, \
					0x00, 0x00, 0x00, 0x00


;EMPTY HEART 10*2

CORAZON:	.db		0x1C, 0x22, 0x41, 0x82, 0x04, 0x04, 0x82, 0x41, \
					0x22, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, \
					0x00, 0x00, 0x00, 0x00



;************************************************************************************/
;specials fonts to print at the start of the game simon says
;************************************************************************************/
;S - 9 alto * 2 bytes
S_INIT:		.db		0x8C, 0xDE, 0xDF, 0x99, 0x93, 0xF7, 0xF7, 0xF6, 0x60, \
					0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00


;i - 5 * 2
I_INIT:		.db		0x10, 0x91, 0xF3, 0x33, 0x00, \
					0x02, 0x03, 0x03, 0x02, 0x02, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00  

;m - 13 * 1
M_INIT:		.db		0x41, 0x7F, 0x7F, 0x4C, 0x06, 0x07, 0x7F, 0x7F, 0x0C, 0x06, 0x73, 0x7F, 0x5E, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 


;o - 8 * 1
O_INIT:		.db		0x1C, 0x36, 0x63, 0x63, 0x63, 0x63, 0x3F, 0x0C, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 


;n - 9 * 1
N_INIT:		.db		0x01, 0x43, 0x7F, 0x7F, 0x04, 0x02, 0x67, 0x7F, 0x3E, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


;d - 9 * 2
D_INIT:		.db		0xE0, 0xF0, 0x38, 0x18, 0x18, 0x92, 0xFE, 0xFF, 0x03, \
					0x01, 0x03, 0x03, 0x03, 0x01, 0x01, 0x03, 0x03, 0x02, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
					
					
;c - 8 * 1
C_INIT:		.db		0x08, 0x3E, 0x7E, 0x63, 0x41, 0x43, 0x47, 0x06, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


;e - 7 * 1
E_INIT:		.db		0x3E, 0x7F, 0x45, 0x55, 0x75, 0x37, 0x26, 0x00, \
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  

;***************************************************************************************/
;fonts to print at the start of the SNAKE game
;***************************************************************************************/

SNAKE_SIMBOL_INIT: .db	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x80,0x40,0x60,0x60,0x60,\
			0xE0,0xC0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,\
			0xC0,0x60,0x30,0x10,0x18,0x18,0x08,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x3E,0x7F,0xE0,0xC0,0xC0,0x80,0x00,\
			0x00,0x00,0x00,0x20,0x20,0x30,0xF0,0xF8,0x58,0x40,\
			0x20,0x10,0xF8,0x7C,0x18,0x00,0x00,0x00,0x00,0xC0,\
			0xE0,0x30,0x10,0x08,0x08,0x98,0xF8,0xF8,0x18,0x08,\
			0x00,0x00,0x00,0x00,0x00,0x80,0xE0,0x78,0x9E,0x87,\
			0xC1,0x60,0x30,0x38,0x78,0x38,0x18,0x08,0x80,0xE0,\
			0x60,0x30,0x10,0x10,0x30,0xF0,0x60,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xC0,0x80,\
			0x00,0x00,0x00,0x00,0x00,0x00,0xC1,0x67,0x3F,0x1F,\
			0x00,0x80,0xC0,0x70,0x3C,0x0F,0x03,0x80,0xC0,0xF0,\
			0x7C,0x6F,0x23,0x30,0x10,0x00,0x30,0x7C,0xCF,0x83,\
			0x80,0x80,0xE0,0x78,0x7E,0xFF,0xC3,0xC0,0x60,0x20,\
			0x20,0x80,0xE0,0x78,0x1E,0x07,0x01,0x03,0x0F,0x3C,\
			0xF0,0xC0,0x00,0x00,0x00,0x00,0x00,0x7C,0xFF,0xFF,\
			0xC8,0xCC,0xC4,0x62,0x63,0x31,0x10,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x03,0x03,0x03,\
			0x03,0x02,0x02,0x03,0x01,0x01,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x03,0x07,0x0C,0x18,0x10,0x10,0x18,0x1C,0x18,\
			0x10,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,\
			0x00,0x00,0x00,0x00

;***********************************************************************************/
;FONTS FOR ZORZABOY 64 *2
;***********************************************************************************/
										
ZORZABOY_NEG:	.db		0xE3, 0xF3, 0xFB, 0xFF, 0xFF, 0xDF, 0xCF, 0xC7, \
						0x7E, 0xFF, 0xFF, 0xC3, 0xC3, 0xFF, 0xFF, 0x7C, \
						0xFF, 0xFF, 0xFF, 0x33, 0x73, 0xFF, 0xDE, 0x9E, \
						0xE3, 0xF3, 0xFB, 0xFF, 0xFF, 0xDF, 0xCF, 0xC7, \
						0xFE, 0xFF, 0x33, 0xFF, 0xFF, 0xFF, 0xFE, 0xFC, \
						0xFF, 0xFF, 0xFF, 0xDB, 0xDB, 0xFF, 0x76, 0x74, \
						0x7E, 0xFF, 0xFF, 0xC3, 0xC3, 0xFF, 0xFF, 0x7C, \
						0x07, 0x1F, 0xFF, 0xF8, 0xF8, 0x1F, 0x0F, 0x07, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


ZORZABOY:		.db		0xC2, 0xE2, 0xF2, 0x9A, 0x9E, 0x8E, 0x86, 0x00, \
						0x3C, 0x7E, 0x82, 0x82, 0x82, 0xFE, 0x7C, 0x00, \
						0xFE, 0xFE, 0x32, 0x12, 0x72, 0x9E, 0x8C, 0x00, \
						0xC2, 0xE2, 0xF2, 0x9A, 0x9E, 0x8E, 0x86, 0x00, \
						0xFC, 0x12, 0x12, 0x12, 0xFE, 0xFE, 0xFC, 0x00, \
						0xFE, 0xFE, 0x8A, 0x8A, 0x8A, 0xFE, 0x7C, 0x00, \
						0x3C, 0x7E, 0x82, 0x82, 0x82, 0xFE, 0x7C, 0x00, \
						0x06, 0x0C, 0x08, 0xF8, 0xF8, 0x0C, 0x06, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
						0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


;***********************************************************************************/					
;CHARS TABLE, modded to work with our code
;***********************************************************************************/

CHARS_TABLE:		.db		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x2f, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x07, 0x00, 0x07, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x14, 0x7f, 0x14, 0x7f, 0x14, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x24, 0x2a, 0x7f, 0x2a, 0x12, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x23, 0x13, 0x08, 0x64, 0x62, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x36, 0x49, 0x55, 0x22, 0x50, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x05, 0x03, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x1c, 0x22, 0x41, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x41, 0x22, 0x1c, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x14, 0x08, 0x3E, 0x08, 0x14, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x08, 0x08, 0x3E, 0x08, 0x08, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0xA0, 0x60, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x08, 0x08, 0x08, 0x08, 0x08, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x60, 0x60, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x20, 0x10, 0x08, 0x04, 0x02, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3E, 0x51, 0x49, 0x45, 0x3E, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x42, 0x7F, 0x40, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x42, 0x61, 0x51, 0x49, 0x46, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x21, 0x41, 0x45, 0x4B, 0x31, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x18, 0x14, 0x12, 0x7F, 0x10, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x27, 0x45, 0x45, 0x45, 0x39, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x01, 0x71, 0x09, 0x05, 0x03, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x36, 0x49, 0x49, 0x49, 0x36, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x06, 0x49, 0x49, 0x29, 0x1E, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x36, 0x36, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x56, 0x36, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x08, 0x14, 0x22, 0x41, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x14, 0x14, 0x14, 0x14, 0x14, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x41, 0x22, 0x14, 0x08, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x02, 0x01, 0x51, 0x09, 0x06, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x32, 0x49, 0x59, 0x51, 0x3E, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7C, 0x12, 0x11, 0x12, 0x7C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x49, 0x49, 0x49, 0x36, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3E, 0x41, 0x41, 0x41, 0x22, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x41, 0x41, 0x22, 0x1C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x49, 0x49, 0x49, 0x41, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x09, 0x09, 0x09, 0x01, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3E, 0x41, 0x49, 0x49, 0x7A, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x08, 0x08, 0x08, 0x7F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x41, 0x7F, 0x41, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x20, 0x40, 0x41, 0x3F, 0x01, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x08, 0x14, 0x22, 0x41, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x40, 0x40, 0x40, 0x40, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x02, 0x0C, 0x02, 0x7F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x04, 0x08, 0x10, 0x7F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3E, 0x41, 0x41, 0x41, 0x3E, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x09, 0x09, 0x09, 0x06, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3E, 0x41, 0x51, 0x21, 0x5E, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x09, 0x19, 0x29, 0x46, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x46, 0x49, 0x49, 0x49, 0x31, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x01, 0x01, 0x7F, 0x01, 0x01, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3F, 0x40, 0x40, 0x40, 0x3F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x1F, 0x20, 0x40, 0x20, 0x1F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3F, 0x40, 0x38, 0x40, 0x3F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x63, 0x14, 0x08, 0x14, 0x63, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x07, 0x08, 0x70, 0x08, 0x07, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x61, 0x51, 0x49, 0x45, 0x43, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x7F, 0x41, 0x41, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x41, 0x41, 0x7F, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x04, 0x02, 0x01, 0x02, 0x04, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x40, 0x40, 0x40, 0x40, 0x40, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x03, 0x05, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x20, 0x54, 0x54, 0x54, 0x78, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x48, 0x44, 0x44, 0x38, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x38, 0x44, 0x44, 0x44, 0x20, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x38, 0x44, 0x44, 0x48, 0x7F, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x38, 0x54, 0x54, 0x54, 0x18, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x08, 0x7E, 0x09, 0x01, 0x02, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x18, 0xA4, 0xA4, 0xA4, 0x7C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x08, 0x04, 0x04, 0x78, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x44, 0x7D, 0x40, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x40, 0x80, 0x84, 0x7D, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7F, 0x10, 0x28, 0x44, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x41, 0x7F, 0x40, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7C, 0x04, 0x18, 0x04, 0x78, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7C, 0x08, 0x04, 0x04, 0x78, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x38, 0x44, 0x44, 0x44, 0x38, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0xFC, 0x24, 0x24, 0x24, 0x18, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x18, 0x24, 0x24, 0x18, 0xFC, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x7C, 0x08, 0x04, 0x04, 0x08, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x48, 0x54, 0x54, 0x54, 0x20, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x04, 0x3F, 0x44, 0x40, 0x20, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3C, 0x40, 0x40, 0x20, 0x7C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x1C, 0x20, 0x40, 0x20, 0x1C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x3C, 0x40, 0x30, 0x40, 0x3C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x44, 0x28, 0x10, 0x28, 0x44, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x1C, 0xA0, 0xA0, 0xA0, 0x7C, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x44, 0x64, 0x54, 0x4C, 0x44, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x10, 0x7C, 0x82, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x82, 0x7C, 0x10, 0x00, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
				0x00, 0x00, 0x06, 0x09, 0x09, 0x06, \
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00

;**********************************************************************************************************************/
;**********************************************************************************************************************/ 
;MAIN PROGRAM
;**********************************************************************************************************************/
;**********************************************************************************************************************/

MAIN:
		LDI		R16, LOW(RAMEND)
		OUT		SPL, R16
		LDI		R16, HIGH(RAMEND)
		OUT		SPH, R16				;initialize SP

		LDI		R16, PINES_BOTONES		;set to input pins 0 to 5 of PORTC
		OUT		DDRC, R16
		IN		R16, DDRB
		LDI		R17, 0xFE
		AND		R16, R17
		OUT		DDRB,R16				;Set to input PINB0, used as B button

		CLI								;KILL interrupts

		CALL	LCD_INIT
		CALL	CLEAR_SCREEN
		CALL	CLEAR_RAM


;SHOW zorzaboy 2 secs	
		
		LDI		R18, 80				;2 SECs APROX
CARGO_LOGO:
		LDI		R16, 10				;POSITION X
		LDI		R17, 17				;POSITION Y
		LDI		R23, 64				;width in PIXELS
		LDI		R24, 2				;height in BYTES 2 when is not centred
		LDI		ZL, LOW(ZORZABOY_NEG<<1)
		LDI		ZH, HIGH(ZORZABOY_NEG<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		LDI		R16, 10				;POSITION X
		LDI		R17, 17				;POSITION Y
		LDI		R23, 64				;width in PIXELES
		LDI		R24, 2				;height in BYTES 2 when is not centred
		LDI		ZL, LOW(ZORZABOY<<1)
		LDI		ZH, HIGH(ZORZABOY<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		CALL	DELAY_5MS
		CALL	DELAY_5MS
		CALL	DELAY_5MS
		CALL	DELAY_5MS
		CALL	DELAY_5MS
		DEC		R18
		BRNE	CARGO_LOGO
		

;from here, i have to show the menu with the 2 games

		CALL	CLEAR_SCREEN

		LDI		R19, 12
		LDI		ZL,LOW(JUEGOS<<1)
		LDI		ZH,HIGH(JUEGOS<<1)
		LDI		R16, 0					;value of x
		LDI		R17, 0					;value of Y
		CALL	LCD_PRINT_STRING		;print "JUEGOS" in SCREEN, on (0,0)


		LDI		R19, 12
		LDI		ZL,LOW(GAME_SNAKE<<1)
		LDI		ZH,HIGH(GAME_SNAKE<<1)
		LDI		R16, 0					;value of x
		LDI		R17, 2					;value of Y
		CALL	LCD_PRINT_STRING		;print "SNAKE" in SCREEN, on (2,0)


		LDI		R19, 12
		LDI		ZL,LOW(GAME_SIMON<<1)
		LDI		ZH,HIGH(GAME_SIMON<<1)
		LDI		R16, 0					;value of x
		LDI		R17, 3					;value of Y
		CALL	LCD_PRINT_STRING		;print "SIMON" in SCREEN, on (3,0)

ESPERO_ELECCION:
		SBIC	PINC, 5					;BOTON A
		JMP		SNAKE
		SBIC	PINB, 0					;BOTON B
		JMP		SIMON_GAME
		JMP		ESPERO_ELECCION


;**********************************************************************************************************************/
;**********************************************************************************************************************/ 
;PROGRAM FOR SIMON SAYs
;**********************************************************************************************************************/
;**********************************************************************************************************************/

SIMON_GAME:	
		CALL	CLEAR_SCREEN
		CALL	CLEAR_RAM

		CLI								;MATO LAS INTERRUPCIONES
		
		LDI		R19, 12
		LDI		ZL,LOW(LOADING<<1)
		LDI		ZH,HIGH(LOADING<<1)
		LDI		R16, 0					;value ofx
		LDI		R17, 3					;value ofY
		CALL	LCD_PRINT_STRING		;print "LOADING..." on screen, on (3,0)
		CALL	DELAY_1S

OTRA_PARTIDA:
		CALL	CLEAR_SCREEN

;******************************************************************************************/
;LOAD INIT SCREEN
;******************************************************************************************/


RENEW:
		CALL	CLEAR_RAM
		;S
		LDI		R16, 17				;POSITION X
		LDI		R17, 5				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(S_INIT<<1)
		LDI		ZH, HIGH(S_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;I
		LDI		R16, 27				;POSITION X
		LDI		R17, 4				;POSITION Y
		LDI		R23, 5				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;M
		LDI		R16, 34				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 13				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(M_INIT<<1)
		LDI		ZH, HIGH(M_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;O
		LDI		R16, 48				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 8				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(O_INIT<<1)
		LDI		ZH, HIGH(O_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;n
		LDI		R16, 55				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(N_INIT<<1)
		LDI		ZH, HIGH(N_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;D
		LDI		R16, 26				;POSITION X
		LDI		R17, 18				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(D_INIT<<1)
		LDI		ZH, HIGH(D_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;I
		LDI		R16, 36				;POSITION X
		LDI		R17, 18				;POSITION Y
		LDI		R23, 5				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;C
		LDI		R16, 42				;POSITION X
		LDI		R17, 21				;POSITION Y
		LDI		R23, 8				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(C_INIT<<1)
		LDI		ZH, HIGH(C_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;E
		LDI		R16, 51				;POSITION X
		LDI		R17, 21				;POSITION Y
		LDI		R23, 7				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(E_INIT<<1)
		LDI		ZH, HIGH(E_INIT<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;search for pressed key every 200ms
		;with this i can made a delay for 1 seg (using 5 x 200ms)


		LDI		R20, 5
VUELVO_A_VER_BOTONES:
		SBIC	PINC, 5				;look for key pressed = A
		JMP		GAME_START		;if there's one pressed, jump
		CALL	DELAY_200MS
		DEC		R20
		BRNE	VUELVO_A_VER_BOTONES



		;press A
		LDI		R16, 20				;POSITION X
		LDI		R17, 36				;POSITION Y
		LDI		R23, 6				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		R19, 7				;ancho del string
		LDI		ZL, LOW(PRESS<<1)
		LDI		ZH, HIGH(PRESS<<1)
		CALL	RAM_PRINT_STRING

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		LDI		R20, 5
VUELVO_A_VER_BOTONES2:
		SBIC	PINC, 5				;look for key pressed = A
		JMP		GAME_START		;if there's one pressed, jump
		CALL	DELAY_200MS
		DEC		R20
		BRNE	VUELVO_A_VER_BOTONES2



		CALL	CLEAR_RAM
		JMP		RENEW

		

;***************************************************************************************/
;START THE GAME
;***************************************************************************************/
WRITE_0_IN_HISC:				
		LDI		R22, 0			;See if at start HIGHSCORE is FF in EEPROM, if its set 0
		CALL	ESCRIBO_HIGH_SCORE
		CALL	LEO_HIGH_SCORE
		JMP		CARGUE_SCORE

GAME_START:
		CALL	CLEAR_RAM
		LDI		R20, 0			;Count the time simon says a move
		LDI		R21, 4			;Life counter, 0 is GameOver

		CALL	LOAD_SIMON		;Load game in RAM and show it
		CALL	LEO_HIGH_SCORE
		LDI		R22, 0xFF
		CP		R22, R9
		BREQ	WRITE_0_IN_HISC

CARGUE_SCORE:
		LDI		XL, LOW(SECUENCIA)
		LDI		XH, HIGH(SECUENCIA)		;Save the sequence simon says




CARGO_JUEGO:

		LDI		YL, LOW(SECUENCIA)
		LDI		YH, HIGH(SECUENCIA)		;Show squence

		CALL	RANDOM
		LDI		R16, 0			;Load 0 to add carry
		CLC
		ST		X+, R5			;Save the output and increment X to save the next value
		ADC		XH, R16
		;MOV		R22, R5			
		INC		R20				;Count the output data
		LDI		R25, 0			;value of cuantity of output to show all the sequence

		;SIMON_DICE
		LDI		R16, 0				;POSITION X
		LDI		R17, 1				;POSITION Y
		LDI		R23, 6				;width in PIXELES
		LDI		R24, 1				;ALTO EN BYTES
		LDI		R19, 12				;ancho del string
		LDI		ZL, LOW(SIMON<<1)
		LDI		ZH, HIGH(SIMON<<1)
		CALL	RAM_PRINT_STRING

MUESTRO_SIG_SECUENCIA:

		INC		R25

		CALL	CONT_SIMON			;call the count of simon to show the cuantity of the sequence
		
		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		LDI		R16, 0				;Load 0 to add carry
		CLC
		LD		R22, Y+				;Save the value of the sequence in R22 and increment Y to show the next value
		ADC		YH, R16
		CALL	MUESTRO_FLECHA_PULSADA		;The Arrow to show has to be in R22
		CALL	DELAY_200MS
		CALL	DELAY_200MS			;delay to show that's another arrow
		CP		R25, R20			;compare to see if i reach the max value of the sequence
		BRNE	MUESTRO_SIG_SECUENCIA



TE_TOCA:
		;TU TURNO
		LDI		R16, 0				;POSITION X (ANTES 35)
		LDI		R17, 1				;POSITION Y (ANTES 25)
		LDI		R23, 6				;width in PIXELS of character
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R19, 14				;width of the string
		LDI		ZL, LOW(TU_TURNO<<1)
		LDI		ZH, HIGH(TU_TURNO<<1)
		CALL	RAM_PRINT_STRING

		LDI		ZL, LOW(RAM_DISPLAY)
		LDI		ZH, HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

	


OTRA_OPORTUNIDAD:
		LDI		YL, LOW(SECUENCIA)
		LDI		YH, HIGH(SECUENCIA)

		LDI		R25, 0				;Counter for the user input
		CALL	CONT_USER			;Start with 0
		
		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

SIGO_SECUENCIA:
		LDI		R16, 0				;Load 0 to add carry
		CLC
		LD		R17, Y+
		ADC		YH, R16

NO_SE_PULSO_NINGUNA:
		CALL	PULSADORES_TODOS	;Rutine to show what button was pressed

		MOV		R22, R7				;Save in R22 the value of the input puressed to show it
		CPI		R22, 5
		BRGE	NO_SE_PULSO_NINGUNA

		INC		R25
		CALL	CONT_USER
		CALL	MUESTRO_FLECHA_PULSADA

		CP		R17, R7				;R7 has te value of the pressed button
		BRNE	RESTO_VIDA

		CP		R25, R20
		BRNE	SIGO_SECUENCIA

		CALL	DELAY_200MS
		CALL	DELAY_200MS
		JMP		CARGO_JUEGO

RESTO_VIDA:
		DEC		R21
		MOV		R22, R21			;Save R21 in R22 for the rutine of hearts
		BREQ	GAME_OVER
		CALL	CORAZONES			;Rutine to show one heart less
		JMP		OTRA_OPORTUNIDAD
	

GAME_OVER:
		CALL	CLEAR_RAM
		CALL	LEO_HIGH_SCORE
		CP		R20, R9
		BRGE	ESCRIBO_NUEVO_HI
		CALL	CLEAR_RAM
SIGO_GAME_OVER:
		;GAME OVER
		LDI		R16, 0				;POSITION X
		LDI		R17, 22				;POSITION Y
		LDI		R23, 6				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		R19, 12				;width of string
		LDI		ZL, LOW(GAME_OVERR<<1)
		LDI		ZH, HIGH(GAME_OVERR<<1)
		CALL	RAM_PRINT_STRING

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		CALL	DELAY_1s
		CALL	DELAY_1s

		JMP		OTRA_PARTIDA
	
ESCRIBO_NUEVO_HI:
		MOV		R22, R20
		CALL	ESCRIBO_HIGH_SCORE
		CALL	CLEAR_RAM
		JMP		SIGO_GAME_OVER

;**********************************************************************************************************************/
;**********************************************************************************************************************/ 
;PROGRAM FOR SNAKE GAME
;**********************************************************************************************************************/
;**********************************************************************************************************************/		
	
SNAKE:
		
		
	;CALL	LCD_INIT
	CALL	CLEAR_SCREEN
	CALL	INIT_TIMERS
	CALL	INIT_BUTTONS_INTERRUPT
	
RESTART_GAME:
	CLI			;Disable interruptions
	
	LDI	ZL,LOW(SNAKE_SIMBOL_INIT<<1)
	LDI	ZH,HIGH(SNAKE_SIMBOL_INIT<<1)
	
	LDI	R18,84
NEXT_R18:
	LDI	R17,6
NEXT_R17:	
	LPM	R16,Z+
	CALL	LCD_WRITE_DATA
	DEC	R17
	BRNE	NEXT_R17
	DEC	R18
	BRNE	NEXT_R18	;Show game logo in screen
	
	CALL	DELAY_1S
	CALL	DELAY_1S
	
	LDI	XL,LOW(RAM_DISPLAY)
	LDI	XH,HIGH(RAM_DISPLAY)
	MOV	ZL,XL
	MOV	ZH,XH
	CALL	CLEAR_RAM
	;CALL	PRINT_FRAME_GAME
	CALL	REFRESH_DISPLAY
	
	;CALL	DELAY_1S
	
	CALL	CLEAR_SCREEN		;Clear screen
	
	LDI	ZL,LOW(RAM_DISPLAY)
	LDI	ZH,HIGH(RAM_DISPLAY)
	
	LDI	R16,43
	LDI	R17,24
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R17,25
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R17,26
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R17,27
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R17,28
	CALL	SET_PIXEL_IN_RAM_DISPLAY	;Init the Snake in the screen
	
	LDI	R16,43	;Set init condition for the Snake
	MOV	R0,R16	;In R0 will save the POSITION of X of the head
	LDI	R16,24
	MOV	R1,R16	;In R1 will save the POSITION of Y of the head
	LDI	R16,43
	MOV	R2,R16	;In R2 will save the POSITION of X of the tail
	LDI	R16,28
	MOV	R3,R16	;In R3 will save the POSITION of Y of the tail
	LDI	R16,UP_DIRECTION
	MOV	R4,R16	;In R4 will save the direction (velocity) of the head:	
				;							0: Up
				;							1: Left
				;							2: Down
				;							3: Rigth
	
	CALL	SET_FRUIT	;Draw fruit in screen
	
	SEI					;Set interruptions
	
KEEP_PLAYING:
	LDI	R16,0
	CLC
	CP	R0,R16
	BREQ	SNAKE_GAME_OVER
	CLC
	CP	R1,R16
	BREQ	SNAKE_GAME_OVER
	LDI	R16,83
	CLC
	CP	R0,R16
	BREQ	SNAKE_GAME_OVER
	LDI	R16,47
	CLC
	CP	R1,R16
	BREQ	SNAKE_GAME_OVER		;Check if there is not in the edge of the screen
	
	CALL	MOVE_SNAKE_ONE_POSITION
	CALL	DELAY_SNAKE
	
	JMP	KEEP_PLAYING

;************************************************************
;Subrutine to execute when the game is over
;*************************************************************/	

SNAKE_GAME_OVER:

	CLI			;Disable interruptions
	
	CALL	CLEAR_SCREEN
	LDI	XL,LOW(RAM_DISPLAY)
	LDI	XH,HIGH(RAM_DISPLAY)
	CALL	CLEAR_RAM
	
	LDI	R16,0
	LDI	R17,2
	LDI	R19,12
	LDI	ZL,LOW(GAME_OVERR<<1)
	LDI	ZH,HIGH(GAME_OVERR<<1)
	CALL	LCD_PRINT_STRING
	
	CALL	DELAY_1S	;Show game over message for 1 sec
	CALL	CLEAR_SCREEN

JMP	RESTART_GAME

;************************************************************
;Funcion to show the pause menu of Snake
;************************************************************/

PAUSE_SNAKE:
	
	PUSH	R16
	PUSH	R17
	PUSH	R19
	PUSH	ZL
	PUSH	ZH
	
	CLI			;Disable interruptions
	
	CALL	CLEAR_SCREEN	;Clear screen
	
	LDI	R16,0
	LDI	R17,0
	LDI	R19,12
	LDI	ZL,LOW(PAUSE_MSG<<1)
	LDI	ZH,HIGH(PAUSE_MSG<<1)
	CALL	LCD_PRINT_STRING
	
	LDI	R16,0
	LDI	R17,2
	LDI	R19,12
	LDI	ZL,LOW(PRESS_A_MSG<<1)
	LDI	ZH,HIGH(PRESS_A_MSG<<1)
	CALL	LCD_PRINT_STRING
	
	LDI	R16,0
	LDI	R17,3
	LDI	R19,8
	LDI	ZL,LOW(PRESS_B_MSG<<1)
	LDI	ZH,HIGH(PRESS_B_MSG<<1)
	CALL	LCD_PRINT_STRING	;Print messages

	CALL	DELAY_1S

WAIT_BUTTON_PAUSE_SNAKE:	
	SBIC	PIN_SNAKE,A_BUTTON
	JMP		RETURN_FROM_PAUSE_SNAKE	;If key A is pressed, return to game
	
	SBIC	PINB,B_BUTTON
	JMP		0x00			;If key B is pressed, return to menu
	
	JMP		WAIT_BUTTON_PAUSE_SNAKE	;Wait for one key to be pressed

RETURN_FROM_PAUSE_SNAKE:
	
	POP	ZH
	POP	ZL
	POP	R19
	POP	R17
	POP	R16
	
	SEI		;set interruptions
RET

;************************************************************
;Use timer like interruptuion to refresh screen
;************************************************************/

INIT_TIMERS:
	PUSH	R16
	PUSH	R17
	PUSH	XL
	PUSH	XH
	
	LDI	R16,TCCR0A_CONFIG
	OUT	TCCR0A,R16
	
	LDI	R16,TCCR0B_CONFIG
	OUT	TCCR0B,R16
	
	LDI	R16,TCNT0_CONFIG
	OUT	TCNT0,R16
	
	LDI	XL,LOW(TIMSK0)
	LDI	XH,HIGH(TIMSK0)
	LDI	R16,TIMSK0_CONFIG	;This dir dont allow use OUT, because is out of range
	ST	X,R16				;Set configuration of the interruptions of TIMER0
	
	POP	XH
	POP	XL
	POP	R17
	POP	R16
RET

;*************************************************************
;This Routine init the interruptionts of PCINT for the
;handle of the buttons
;************************************************************/

INIT_BUTTONS_INTERRUPT:
	PUSH	R16
	PUSH	XL
	PUSH	XH
	
	LDI	XL,LOW(PCICR)
	LDI	XH,HIGH(PCICR)
	LDI	R16,PCICR_CONFIG
	ST	X,R16
	
	LDI	XL,LOW(PCMSK0)
	LDI	XH,HIGH(PCMSK0)
	LDI	R16,PCMSK0_CONFIG
	ST	X,R16
	
	LDI	XL,LOW(PCMSK1)
	LDI	XH,HIGH(PCMSK1)
	LDI	R16,PCMSK1_CONFIG
	ST	X,R16
	
	LDI	XL,LOW(PCMSK2)
	LDI	XH,HIGH(PCMSK2)
	LDI	R16,PCMSK2_CONFIG
	ST	X,R16
	
	POP	XH
	POP	XL
	POP	R16	
RET

;*************************************************************
;Routine to modify the direction (velocity) of snake to Up
;************************************************************/

UP_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Read the actual direction of the head (velocity)
	LDI	R17,DOWN_DIRECTION	
	
	CP	R16,R17		;check actual direction with the oposite direction
	BREQ	CANT_GO_UP	;If going to Down, head can't go to Up
	
	LDI	R16,UP_DIRECTION
	MOV	R4,R16
	
CANT_GO_UP:
	POP	R17
	POP	R16
RET

;*************************************************************
;Routine to modify the direction (velocity) of snake to
;the Left.
;************************************************************/

LEFT_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Read the actual direction of the head (velocity)
	LDI	R17,RIGHT_DIRECTION	
	
	CP	R16,R17		;check actual direction with the oposite direction
	BREQ	CANT_GO_LEFT	;If going to the Rigth, head can't go to the Left
	
	LDI	R16,LEFT_DIRECTION
	MOV	R4,R16
	
CANT_GO_LEFT:
	POP	R17
	POP	R16
RET

;*************************************************************
;Routine to modify the direction (velocity) of snake to Down.
;************************************************************/

DOWN_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Read the actual direction of the head (velocity)
	LDI	R17,UP_DIRECTION	
	
	CP	R16,R17		;check actual direction with the oposite direction
	BREQ	CANT_GO_DOWN	;If going to Up, head can't go to Down
	
	LDI	R16,DOWN_DIRECTION
	MOV	R4,R16
	
CANT_GO_DOWN:
	POP	R17
	POP	R16
RET

;*************************************************************
;Routine to modify the direction (velocity) of snake to the
;Right.
;************************************************************/

RIGHT_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Read the actual direction of the head (velocity)
	LDI	R17,LEFT_DIRECTION
	
	CP	R16,R17		;check actual direction with the oposite direction
	BREQ	CANT_GO_RIGHT	;If going to the Left, head can't go to the Rigth
	
	LDI	R16,RIGHT_DIRECTION
	MOV	R4,R16
	
CANT_GO_RIGHT:
	POP	R17
	POP	R16	
RET

;************************************************************
;This Routine draw the marc of the game in RAM
;************************************************************/

PRINT_FRAME_GAME:
	PUSH	R16
	PUSH	R17
	PUSH	ZL
	PUSH	ZH
	
	LDI	R16,0
	LDI	R17,0
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	
	LDI	R16,83
PRINT_NEXT_PIXEL_X_DISPLAY:
	LDI	R17,0
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R17,47
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	DEC	R16
	BRNE	PRINT_NEXT_PIXEL_X_DISPLAY
	
	LDI	R17,47
PRINT_NEXT_PIXEL_Y_DISPLAY:	
	LDI	R16,0
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	LDI	R16,83
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	DEC	R17
	BRNE	PRINT_NEXT_PIXEL_Y_DISPLAY
	
	POP	ZH
	POP	ZL
	POP	R17
	POP	R16
RET
;************************************************************
;This routine set a pixel in the RAM matrix where the data
;will sent to the screen.
;************************************************************/

SET_PIXEL_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	PUSH 	R16	;value ofX in the matrix (0-83)
	PUSH 	R17	;value ofY in the matrix (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direction of the first value of RAM
	PUSH	ZH	;Direction of the first value of RAM
	
	LDI	R18,8	;For every value of Y in the display, there are 8 value of Y in RAM
	LDI	R19,1	;Init a count where the value Y of the display will be saved

TRY_NEXT_Y_VALUE_SET:	
	MUL	R18,R19	;Mult the value of Y of the display for the cuantity of pixels that use
	CP	R17,R0	;Compare with the result of the mult with the value of Y recibed (the result never has to be > than 256)
	BRLO	Y_VALUE_FOUND_SET
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_SET

Y_VALUE_FOUND_SET:
	DEC	R19
	;At the exit of this loop, i got the value of Y of the display in R19.  Need to get the value of the pixel inside the byte.
	
	MUL	R18,R19	;with this i know the value of Y of the pixel nearest  to the recieved
	MOV	R1,R17	;In R1 will save the 0, used like auxiliar register
	
	LDI	R20,1	;Init R20 to be used like a mask to set the pixel i want
	SUB	R1,R0	;Get the diff in pixels to know the position of the pixel in the byte
	
	BREQ	MASK_FOUND_SET	;If the rest is 0, it means that the byte i want is the 0

COMPARE_NEXT_BYTES_SET:	
	LSL	R20	;Move the mask 1 place
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_SET

MASK_FOUND_SET:	;At the end of the loop i got the m ask to apply to the byte of the RAM
				;Data that i get now are:    In R16 i get the value of X of the Matrix (equal of the RAM)
				;					In R17 i get the value of Y of the Matrix
				;					In R19 i get the value of Y of the display
				;					In R20 i got the mask
				;					In ZL and ZH the direction of the beginning of the RAM

	LDI	R18,84	;Load the amount of pixels in a row
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;move Y (display)*84 value of RAM memory
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Move X value of the RAM memory

	;At this point i have the byte to by modify using the mask
	LD	R18,Z	;Read the value pointed
	OR	R18,R20	;Set the wanted bit
	ST	Z,R18	;Load the value again
	
	POP	ZH
	POP	ZL
	POP	R20
	POP	R19
	POP	R18
	POP	R17
	POP	R16
	POP	R1
 	POP	R0
RET

;************************************************************
;This Routine turn off a pixel in the RAM matrix where
;are the data to be sent to the display
;************************************************************/

CLEAR_PIXEL_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	PUSH 	R16	;value ofX in the matrix (0-83)
	PUSH 	R17	;value ofY in the matrix (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direction of the first value of RAM
	PUSH	ZH	;Direction of the first value of RAM
	
	LDI	R18,8	;For every value of Y in the display, there are 8 value of Y in RAM
	LDI	R19,1	;Init a count where the value Y of the display will be saved

TRY_NEXT_Y_VALUE_CLEAR:	
	MUL	R18,R19	;Mult the value of Y of the display for the cuantity of pixels that use
	CP	R17,R0	;Compare with the result of the mult with the value of Y recibed (the result never has to be > than 256)
	BRLO	Y_VALUE_FOUND_CLEAR
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_CLEAR

Y_VALUE_FOUND_CLEAR:
	DEC	R19
	;At the exit of this loop, i got the value of Y of the display in R19.  Need to get the value of the pixel inside the byte.
	
	MUL	R18,R19	;with this i know the value of Y of the pixel nearest  to the recieved
	MOV	R1,R17	;In R1 will save the 0, used like auxiliar register
	
	LDI	R20,1	;Init R20 to be used like a mask to set the pixel i want
	SUB	R1,R0	;Get the diff in pixels to know the position of the pixel in the byte
	
	BREQ	MASK_FOUND_CLEAR	;If the rest is 0, it means that the byte i want is the 0

COMPARE_NEXT_BYTES_CLEAR:	
	LSL	R20	;Move the mask 1 place
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_CLEAR

MASK_FOUND_CLEAR:		;At the end of the loop i got the m ask to apply to the byte of the RAM
				;Data that i get now are:    In R16 i get the value of X of the Matrix (equal of the RAM)
				;					In R17 i get the value of Y of the Matrix
				;					In R19 i get the value of Y of the display
				;					In R20 i got the mask
				;					In ZL and ZH the direction of the beginning of the RAM

	LDI	R18,84	;Load the amount of pixels in a row
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;move Y (display)*84 value of RAM memory
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Move X value of the RAM memory

	;At this point i have the byte to by modify using the mask
	LD	R18,Z	;Read the value pointed
	COM	R20
	AND	R18,R20	;Set the wanted bit
	ST	Z,R18	;Load the value again
	
	POP	ZH
	POP	ZL
	POP	R20
	POP	R19
	POP	R18
	POP	R17
	POP	R16
	POP	R1
 	POP	R0
RET

;************************************************************
;Rputine to check if the wanted pixel is turned on or off.
;To do this, the Register R21 has the value of the pixel,
;if 0 means power off, if diff of 0 is turned on.
;************************************************************/

CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	;PUSH	R21	;value ofretorno (no se guarda en el stack para poder modificarlo)
	PUSH 	R16	;value ofX in the matrix (0-83)
	PUSH 	R17	;value ofY in the matrix (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direction of the first value of RAM
	PUSH	ZH	;Direction of the first value of RAM
	
	LDI	R18,8	;For every value of Y in the display, there are 8 value of Y in RAM
	LDI	R19,1	;Init a count where the value Y of the display will be saved

TRY_NEXT_Y_VALUE_CHECK_PIXEL:	
	MUL	R18,R19	;Mult the value of Y of the display for the cuantity of pixels that use
	CP	R17,R0	;Compare with the result of the mult with the value of Y recibed (the result never has to be > than 256)
	BRLO	Y_VALUE_FOUND_CHECK_PIXEL
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_CHECK_PIXEL

Y_VALUE_FOUND_CHECK_PIXEL:
	DEC	R19
	;At the exit of this loop, i got the value of Y of the display in R19.  Need to get the value of the pixel inside the byte.

	
	MUL	R18,R19	;with this i know the value of Y of the pixel nearest  to the recieved
	MOV	R1,R17	;In R1 will save the 0, used like auxiliar register
	
	LDI	R20,1	;Init R20 to be used like a mask to set the pixel i want
	SUB	R1,R0	;Get the diff in pixels to know the position of the pixel in the byte
	
	BREQ	MASK_FOUND_CHECK_PIXEL	;If the rest is 0, it means that the byte i want is the 0

COMPARE_NEXT_BYTES_CHECK_PIXEL:	
	LSL	R20	;Move the mask 1 place
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_CHECK_PIXEL

MASK_FOUND_CHECK_PIXEL:		;At the end of the loop i got the m ask to apply to the byte of the RAM
				;Data that i get now are:    In R16 i get the value of X of the Matrix (equal of the RAM)
				;					In R17 i get the value of Y of the Matrix
				;					In R19 i get the value of Y of the display
				;					In R20 i got the mask
				;					In ZL and ZH the direction of the beginning of the RAM

	LDI	R18,84	;Load the amount of pixels in a row
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;move Y (display)*84 value of RAM memory
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Move X value of the RAM memory

	;At this point i have the byte to by modify using the mask
	LD	R18,Z	;Read the value pointed
	AND	R18,R20	;Se aplica la mascara
	MOV	R21,R18	;Si el pixel esta apagado R21 va a valer cero, sino sera un valor distinto de cero
	
	POP	ZH
	POP	ZL
	POP	R20
	POP	R19
	POP	R18
	POP	R17
	POP	R16
	POP	R1
 	POP	R0
RET



;************************************************************
;This routine move snake une position, depends of the
;direction of the tail y la cabeza. Ademas de cargar R4 y R5 con
;las direcciones of the head y la cola, se deben cargar las
;POSITIONes, ya que esta funcion utiliza funciones internas
;que utilizan esos datos
;************************************************************/

MOVE_SNAKE_ONE_POSITION:
	PUSH	R4	;Direccion of the head (velocity)
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	R19
	PUSH	R21
	PUSH	ZL
	PUSH	ZH
	
	LDI	ZL,LOW(RAM_DISPLAY)
	LDI	ZH,HIGH(RAM_DISPLAY)
	
	LDI	R18,0
	LDI	R19,0
	
	LDI	R16,UP_DIRECTION		;Cargo la direccion hacia Up
	CP	R4,R16				;La comparo con la direccion recibida
	BRNE	NOT_UP_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	DEC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	UP_PIXEL_NOT_SET
	LDI	R19,1				;Se verifica si el pixel esta prendido para saber si se va a agarrar la fruta
UP_PIXEL_NOT_SET:	
	CALL	MOVE_HEAD_UP
	
NOT_UP_DIRECTION_HEAD:
	LDI	R16,LEFT_DIRECTION		;Cargo la direccion hacia the Left	
	CP	R4,R16				;La comparo con la direccion recibida
	BRNE	NOT_LEFT_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	DEC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	LEFT_PIXEL_NOT_SET
	LDI	R19,1				;Se verifica si el pixel esta prendido para saber si se va a agarrar la fruta
LEFT_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_LEFT
	
NOT_LEFT_DIRECTION_HEAD:
	LDI	R16,DOWN_DIRECTION		;Cargo la direccion hacia Down	
	CP	R4,R16				;La comparo con la direccion recibida
	BRNE	NOT_DOWN_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	INC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	DOWN_PIXEL_NOT_SET
	LDI	R19,1				;Se verifica si el pixel esta prendido para saber si se va a agarrar la fruta
DOWN_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_DOWN
	
NOT_DOWN_DIRECTION_HEAD:
	LDI	R16,RIGHT_DIRECTION		;Cargo la direccion hacia la Rigth
	CP	R4,R16				;La comparo con la direccion recibida
	BRNE	NOT_RIGHT_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	INC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	RIGHT_PIXEL_NOT_SET
	LDI	R19,1				;Se verifica si el pixel esta prendido para saber si se va a agarrar la fruta
RIGHT_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_RIGHT
	
NOT_RIGHT_DIRECTION_HEAD:
	
	CP	R18,R19
	BRNE	DONT_MOVE_TAIL			;Si se agarro la fruta R19 vale 1, por lo que no se debe apagar el pixel of the tail
	CALL	MOVE_TAIL_ONE_POSITION
	RJMP	TAIL_MOVED
DONT_MOVE_TAIL:
	CALL	SET_FRUIT			;Si se agarro la fruta, se debe prender otra en el display
TAIL_MOVED:
	
	POP	ZH
	POP	ZL
	POP	R21
	POP	R19
	POP	R18
	POP	R17
	POP	R16
	POP	R4
RET

;************************************************************
;Esta funcion mueve la cabeza del snake una POSITION hacia Up.
;Luego de mover los valores de la RAM, modifica las nuevas POSITIONes
;of the head en los registros correspondientes.
;************************************************************/

MOVE_HEAD_UP:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	DEC	R1	;Se mueve la cabeza un pixel hacia Up
	MOV	R16,R0
	MOV	R17,R1	
	CALL	SET_PIXEL_IN_RAM_DISPLAY

	POP	ZH
	POP	ZL
	POP	R17
	POP	R16
	;POP	R1
	;POP	R0
RET

;************************************************************
;Esta funcion mueve la cabeza del snake una POSITION hacia the Left.
;Luego de mover los valores de la RAM, modifica las nuevas POSITIONes
;of the head en los registros correspondientes.
;************************************************************/

MOVE_HEAD_LEFT:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	DEC	R0	;Se mueve la cabeza un pixel hacia the Left
	MOV	R16,R0
	MOV	R17,R1	
	CALL	SET_PIXEL_IN_RAM_DISPLAY

	POP	ZH
	POP	ZL
	POP	R17
	POP	R16
	;POP	R1
	;POP	R0
RET	

;************************************************************
;Esta funcion mueve la cabeza del snake una POSITION hacia Down.
;Luego de mover los valores de la RAM, modifica las nuevas POSITIONes
;of the head en los registros correspondientes.
;************************************************************/

MOVE_HEAD_DOWN:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	INC	R1	;Se mueve la cabeza un pixel hacia the Left
	MOV	R16,R0
	MOV	R17,R1	
	CALL	SET_PIXEL_IN_RAM_DISPLAY

	POP	ZH
	POP	ZL
	POP	R17
	POP	R16
	;POP	R1
	;POP	R0
RET

;************************************************************
;Esta funcion mueve la cabeza del snake una POSITION hacia la Rigth.
;Luego de mover los valores de la RAM, modifica las nuevas POSITIONes
;of the head en los registros correspondientes.
;************************************************************/

MOVE_HEAD_RIGHT:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	INC	R0	;Se mueve la cabeza un pixel hacia the Left
	MOV	R16,R0
	MOV	R17,R1	
	CALL	SET_PIXEL_IN_RAM_DISPLAY

	POP	ZH
	POP	ZL
	POP	R17
	POP	R16
	;POP	R1
	;POP	R0
RET

;************************************************************
;Esta funcion mueve la cola del snake una POSITION y modifica
;los registros necesarios.
;************************************************************/

MOVE_TAIL_ONE_POSITION:
	;PUSH	R2	;POSITION en X of the tail (No se guarda en el stack para poder modificarlo)
	;PUSH	R3	;POSITION en Y of the tail (No se guarda en el stack para poder modificarlo)
	PUSH	R16	;Registro auxiliar para valores de X
	PUSH	R17	;Registro auxiliar para valores de Y
	PUSH	R18
	PUSH	R21
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	MOV	R16,R2
	MOV	R17,R3
	CALL	CLEAR_PIXEL_IN_RAM_DISPLAY	;Se apaga el pixel of the tail
	
	;Una vez que se apaga la cola, se debe ver en que direccion se tiene que mover para
	;no perder el resto del cuerpo de la vibora. Para esto hay que ver cual de los 4
	;pixeles que la rodean estan prendidos.
	
	LDI	R18,0
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de Up
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_UP
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de the Left
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_LEFT
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de Down
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_DOWN
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de la Rigth
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_RIGHT
	
MOVE_TAIL_UP:
	DEC	R3	;Tengo que mover la POSITION of the tail un pixel hacia Up
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_LEFT:
	DEC	R2	;Tengo que mover la POSITION of the tail un pixel hacia the Left
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_DOWN:
	INC	R3	;Tengo que mover la POSITION of the tail un pixel hacia Down
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_RIGHT:
	INC	R2	;Tengo que mover la POSITION of the tail un pixel hacia la Rigth
	;RJMP	END_MOVING_TAIL
	
END_MOVING_TAIL:
	
	POP	ZH
	POP	ZL
	POP	R21
	POP	R18
	POP	R17
	POP	R16
	;POP	R3
	;POP	R2
RET

;*************************************************************
;Funcion que prende la fruta en el display.
;************************************************************/

SET_FRUIT:
	PUSH	R0
	PUSH	R1
	PUSH	R5		;Registro donde se van a guardar los numeros random
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	R21
	PUSH	ZL		;Direccion de la RAM
	PUSH	ZH		;Direccion de la RAM
	
	LDI	R18,0
	
	LDI	R16,20
	CALL	RANDOM
	MUL	R5,R16
	MOV	R16,R0
	
	LDI	R17,11
	CALL	RANDOM
	MUL	R17,R5
	MOV	R17,R0
	
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	ADD	R21,R18
	BRNE	PIXEL_ALREADY_SET
	CALL	SET_PIXEL_IN_RAM_DISPLAY
	
	RJMP	END_SET_FRUIT
PIXEL_ALREADY_SET:
	INC	R16
	INC	R16
	INC	R17
	INC	R17
	CALL	SET_PIXEL_IN_RAM_DISPLAY
END_SET_FRUIT:
	
	POP	ZH
	POP	ZL
	POP	R21
	POP	R18
	POP	R17
	POP	R16
	POP	R5
	POP	R1
	POP	R0
RET

;*************************************************************
;Delay con el que se mueve el snake en la RAM.
;************************************************************/

DELAY_SNAKE:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI	R19,3
LOOP2_SNAKE:
	LDI R17, 200 
LOOP0_SNAKE:
	LDI R18, 200 
LOOP1_SNAKE:
	DEC	R18 
	BRNE	LOOP1_SNAKE 
	DEC	R17 
	BRNE	LOOP0_SNAKE 
	DEC	R19
	BRNE	LOOP2_SNAKE
	 
	POP	R19
	POP	R18
	POP	R17
RET

			

;*****************************************************************************************************************/
;*****************************************************************************************************************/
;EMPIEZO LAS SUBRUTINAS
;*****************************************************************************************************************/
;*****************************************************************************************************************/


;****************** LCD_INIT *************************************************************************************/
;Esta funci\F3n inicializa los 6 pines a utilizar del PORT_LCD para el control de
;la pantalla, envia una se\F1al de reset, y deja todas las salidas en estado alto
;(a excepcion de Backlight para reducir el consumo de corriente).
;*****************************************************************************************************************/

LCD_INIT:
	PUSH	R16		;Se guarda el contenido de R16 en el stack
	IN	R16,DDR_LCD	;Se lee el estado del DDR_LCD	
	SBR	R16,LCD_PINS	;Se encienden los bits 0-5
	OUT	DDR_LCD,R16	;Se configuran como salida los pines 0-5 del PORT_LCD
	
	CBI	PORT_LCD,RES_PIN_NUMBER	;Se resetea el display
	CALL	DELAY_5ms			;demora de 5ms aprox
	CALL	DELAY_5ms			;demora de 5ms aprox
	CALL	DELAY_5ms			;demora de 5ms aprox
	SBI	PORT_LCD,BL_PIN_NUMBER	;Se prende BL
	SBI	PORT_LCD,DC_PIN_NUMBER	;Se ponen en alto las dem\E1s lineas
	SBI	PORT_LCD,SCE_PIN_NUMBER
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,SCK_PIN_NUMBER
	SBI	PORT_LCD,RES_PIN_NUMBER	;Se pone en alto el reset

	LDI	R16,PCD8544_FUNCTIONSET | PCD8544_EXTENDEDINSTRUCTION
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_SETVOP | LCD_CONTRAST
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_SETTEMP | LCD_TEMP
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_SETBIAS | LCD_BIAS
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_FUNCTIONSET
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_SETYADDR
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_SETXADDR
	CALL	LCD_WRITE_COMMAND
	
	LDI	R16,PCD8544_DISPLAYCONTROL | PCD8544_DISPLAYNORMAL
	CALL	LCD_WRITE_COMMAND			;Se envian comandos de inicializacion 
		
	POP	R16	
RET

;*****************************************************************************************************************/
;Esta funcion envia un byte de datos por el pin SDIN. Utiliza el registro R17 como
;contador, y el dato a enviar lo lee de R16 (ambos registros son guardados
;en el stack).
;*****************************************************************************************************************/

LCD_WRITE_DATA:
	PUSH	R16	
	PUSH	R17	;Se guarda el contenido de R16 y R17 en el stack
	
	LDI	R17,8	;Se inicializa el contador
	
	CBI	PORT_LCD,SCE_PIN_NUMBER	;Se baja la linea SCE
	SBI	PORT_LCD,DC_PIN_NUMBER	;Se mantiene en alto la linea DC para enviar un dato

SEND_NEXT_BIT_DATA:
	CBI	PORT_LCD,SCK_PIN_NUMBER	;Se baja la linea de clock
	
	SBRC	R16,7			;Si hay un 0 en el bit mas significativo no se ejecuta la siguiente instruccion
	SBI	PORT_LCD,SDIN_PIN_NUMBER	;Si hay un 1 en el bit mas significativo, se pone en alto SDIN
	SBRS	R16,7			;Si hay un 1 en el bit mas significativo no se ejecuta la siguiente instruccion
	CBI	PORT_LCD,SDIN_PIN_NUMBER	;Si hay un 0 en el bit mas significativo, se pone en bajo SDIN
	
	LSL	R16			;Se corre R16 una POSITION a the Left
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Se sube la linea SCK para permitir la lectura
	
	CALL	DELAY_TRANSMITION	;Se llama al delay
	DEC	R17			;Se decrementa R17
	BRNE	SEND_NEXT_BIT_DATA	;Si el contador no llego a cero se envia el siguiente bit
	
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,SCE_PIN_NUMBER	
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Luego de enviar el byte completo se ponen en alto todas las lineas
	
	POP	R17
	POP	R16			;Se sacan del stack R16 y R17
RET
		
;*****************************************************************************************************************/
;Esta funcion envia un byte de comandos por el pin SDIN. Utiliza el registro R17 como
;contador, y el dato a enviar lo lee de R16 (ambos registros son guardados
;en el stack).
;*****************************************************************************************************************/

LCD_WRITE_COMMAND:
	PUSH	R16	
	PUSH	R17	;Se guarda el contenido de R16 y R17 en el stack
	
	LDI	R17,8	;Se inicializa el contador
	
	CBI	PORT_LCD,SCE_PIN_NUMBER	;Se baja la linea SCE
	CBI	PORT_LCD,DC_PIN_NUMBER	;Se mantiene en bajo la linea DC para enviar un comando

SEND_NEXT_BIT_COMMAND:
	CBI	PORT_LCD,SCK_PIN_NUMBER	;Se baja la linea de clock
	
	SBRC	R16,7			;Si hay un 0 en el bit mas significativo no se ejecuta la siguiente instruccion
	SBI	PORT_LCD,SDIN_PIN_NUMBER	;Si hay un 1 en el bit mas significativo, se pone en alto SDIN
	SBRS	R16,7			;Si hay un 1 en el bit mas significativo no se ejecuta la siguiente instruccion
	CBI	PORT_LCD,SDIN_PIN_NUMBER	;Si hay un 0 en el bit mas significativo, se pone en bajo SDIN
	
	LSL	R16			;Se corre R16 una POSITION a the Left
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Se sube la linea SCK para permitir la lectura
	
	CALL	DELAY_TRANSMITION	;Se llama al delay
	DEC	R17			;Se decrementa R17
	BRNE	SEND_NEXT_BIT_COMMAND	;Si el contador no llego a cero se envia el siguiente bit
	
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,DC_PIN_NUMBER
	SBI	PORT_LCD,SCE_PIN_NUMBER	
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Luego de enviar el byte completo se ponen en alto todas las lineas
	
	POP	R17
	POP	R16			;Se sacan del stack R16 y R17
RET

;**********************************************************/
DELAY_TRANSMITION:
	NOP
	NOP
RET
;**********************************************************/


;**********************************************************/
;delay de 5ms
;**********************************************************/

DELAY_5ms:
	PUSH	R17
	PUSH	R18
	
	LDI R17, 66 ;para 1mhz a OJO, para 8mhz era 66 ; 1 ciclo
LOOP0:
	LDI R18, 200 ; 1 ciclo
LOOP1:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP1 ; 1 si es falso 2 si es verdadero
	DEC		R17 ; 1
	BRNE	LOOP0 ; 2
	 
	POP	R18
	POP	R17
ret


;**********************************************************/
;delay de 200 msegundo
;**********************************************************/

DELAY_200ms:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19, 40
LOOP_7:
	LDI		R17, 66 ;para 1mhz a OJO, para 8mhz era 66 ; 1 ciclo
LOOP_5:
	LDI		R18, 200 ; 1 ciclo
LOOP_6:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_6 ; 1 si es falso 2 si es verdadero
	DEC		R17 ; 1
	BRNE	LOOP_5 ; 2
	DEC		R19
	BRNE	LOOP_7
	 
	POP		R19
	POP		R18
	POP		R17
ret


;**********************************************************/
;delay de 25 msegundo
;**********************************************************/

DELAY_25ms:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19, 5
LOOP_77:
	LDI		R17, 66 ;para 1mhz a OJO, para 8mhz era 66 ; 1 ciclo
LOOP_55:
	LDI		R18, 200 ; 1 ciclo
LOOP_66:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_66 ; 1 si es falso 2 si es verdadero
	DEC		R17 ; 1
	BRNE	LOOP_55 ; 2
	DEC		R19
	BRNE	LOOP_77
	 
	POP		R19
	POP		R18
	POP		R17
ret

;**********************************************************/
;delay de 1 segundo
;**********************************************************/

DELAY_1s:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19,200
LOOP_2:
	LDI R17, 66 ;para 1mhz a OJO, para 8mhz era 66 ; 1 ciclo
LOOP_0:
	LDI R18, 200 ; 1 ciclo
LOOP_1:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_1 ; 1 si es falso 2 si es verdadero
	DEC		R17 ; 1
	BRNE	LOOP_0 ; 2
	DEC		R19
	BRNE	LOOP_2
	 
	 POP	R19
	POP	R18
	POP	R17
ret

;********************************************************/
;RUTINA PARA BORRAR LA RAM DEL LCD
;********************************************************/


CLEAR_SCREEN:
	PUSH	R16
	PUSH	R17
	PUSH	R18

	LDI		R16,PCD8544_SETYADDR
	CALL	LCD_WRITE_COMMAND	;Se inicializa Y en cero
	LDI		R16,PCD8544_SETXADDR
	CALL	LCD_WRITE_COMMAND	;Se inicializa X en cero

	LDI		R18, 6		;6 filas
LOOP_12:
	LDI		R17, 84		;84 columnas
LOOP_11:
	LDI		R16, 0
	CALL	LCD_WRITE_DATA
	DEC		R17
	BRNE	LOOP_11
	DEC		R18
	BRNE	LOOP_12

	POP		R18
	POP		R17
	POP		R16

	RET


;********************************************/
;RUTINA PARA BORRAR LA RAM DEL MICRO
;********************************************/

CLEAR_RAM:
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	XL
	PUSH	XH

	LDI		XL, LOW(RAM_DISPLAY)
	LDI		XH, HIGH(RAM_DISPLAY)

	LDI		R18, 6		;6 filas
LOOP_122:
	LDI		R17, 84		;84 columnas
LOOP_111:
	LDI		R16, 0
	ST		X+, R16		;cargo ceros en la ram
	DEC		R17
	BRNE	LOOP_111
	DEC		R18
	BRNE	LOOP_122

	POP		XH
	POP		XL
	POP		R18
	POP		R17
	POP		R16

	RET

;*****************************************************************************************************************/
;Esta funcion es para imprimir en pantalla strings de caracteres 
;El string nunca va a ser mayor a 14 chars, ya que es lo maximo
;que se puede mostrar en pantalla en horizontal.
;*****************************************************************************************************************/

;*****************************************************************************************************************/
;Esta funcion es para imprimir en pantalla strings de caracteres.
;En R19 debe estar guardado el largo de la cadena, en R16 y R16 las
;POSITIONes en X e Y respectivamente donde se desea imprimir, y en Z
;debe estar guardada la direccion del primer byte de la cadena.
;*****************************************************************************************************************/

LCD_PRINT_STRING:
	PUSH	R16	;value ofX
	PUSH	R17	;value ofY
	PUSH	R18
	PUSH	R19	;Largo del string
	PUSH	ZL	;Parte baja de la direccion del string
	PUSH	ZH	;Parte alta de la direccion del string
	
	LDI	R18,PCD8544_SETXADDR
	ADD	R16,R18		;Se suma el value ofX deseado con el comando 
	LDI	R18,PCD8544_SETYADDR
	ADD	R17,R18		;Se suma el value ofY deseado con el comando


	
	CALL	LCD_WRITE_COMMAND	;Se inicializa X en el valor deseado
	MOV	R16,R17
	CALL	LCD_WRITE_COMMAND	;Se inicializa Y en el valor deseado

	CALL DELAY_TRANSMITION


NEXT_STRING_CHAR:
	LPM	R18,Z+

	CALL	LCD_PRINT_CHAR
	DEC	R19
	BRNE	NEXT_STRING_CHAR
	
	POP	ZH
	POP	ZL
	POP	R19
	POP	R18
	POP	R17
	POP	R16

RET
	
	
;***************************************************/

LCD_PRINT_CHAR:
	PUSH	R16 	;POSITION en X
	PUSH	R17		;POSITION en Y
	PUSH	R18		;Caracter
	PUSH	R30
	PUSH	R31

	;LDI	R30,PCD8544_SETXADDR
	;ADD	R16,R30			;Se suma el value ofX deseado con el comando 
	;LDI	R30,PCD8544_SETYADDR
	;ADD	R17,R30			;Se suma el value ofY deseado con el comando
	
	;CALL	LCD_WRITE_COMMAND	;Se inicializa X en el valor deseado
	;MOV		R16,R17
	;CALL	LCD_WRITE_COMMAND	;Se inicializa Y en el valor deseado
	
	SUBI	R18,32			;Se resta el offset al caracter para conocer el valor en la tabla
	LDI		R30,12			;Se debe multiplicar por 6 para obtener el value ofla tabla, ya que cada caracter son 6 bytes
	MUL		R18, R30		;El resultado se guarda en R1-R0 (el menos significativo en R0)
	
	LDI	ZL,LOW(CHARS_TABLE<<1)
	LDI	ZH,HIGH(CHARS_TABLE<<1)	;Se carga Z con la direccion de la tabla (hay que multiplicar por 2 para acceder)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;Se suma el offset para el caracter deseado
	
	LDI		R18,6			;Utilizo R18 como contador
SEND_NEXT_CHAR_BYTE:
	LPM		R16,Z+			;Leo el value ofla tabla y lo guardo en R18
	CALL	LCD_WRITE_DATA		;Envio el dato al display
	DEC		R18
	BRNE	SEND_NEXT_CHAR_BYTE	
		
	POP	R31
	POP	R30	
	POP	R18
	POP	R17
	POP	R16
RET


;*****************************************************
;Funcion que actualiza la pantalla. Lee los datos de la
;memoria RAM apuntada por Z y lo envia al display
*******************************************************/

REFRESH_DISPLAY:
	PUSH 	R16	
	PUSH	R17
	PUSH	R18
	PUSH	ZL
	PUSH	ZH

	LDI		R16,PCD8544_SETYADDR
	CALL	LCD_WRITE_COMMAND
	LDI		R16,PCD8544_SETXADDR
	CALL	LCD_WRITE_COMMAND	;Se inicializa X e Y en cero
	
	LDI		R18,6		;Cantidad de filas
SEND_NEXT_ROW_RAM:
	LDI		R17,84		;Cantidad de columnas
SEND_NEXT_COL_RAM:	
	LD		R16,Z+
	CALL	LCD_WRITE_DATA	;Se envia el dato leido
	
	DEC		R17
	BRNE	SEND_NEXT_COL_RAM
	DEC		R18
	BRNE	SEND_NEXT_ROW_RAM
	
	POP		ZH
	POP		ZL
	POP		R18
	POP		R17
	POP		R16
		
RET



;***********************************************/
;generador de numeros RANDOM
; LO GUARDO EN R5 ASI NO JODE
;***********************************************/
RANDOM:
		PUSH	R16
		PUSH	R17
		PUSH	R18

		LDI		R16, 0x70		;usa AVCC, entrada ADC0
		STS		ADMUX, R16		;para escribir en el registro ADMUX
		LDI		R16, 0xC1		;habilito el ADC y empiezo la conversion, con prescaler de x
		STS		ADCSRA, R16
NO_TERMINO:
		LDS		R16, ADCSRA		;leo para ver si termino de convertir
		CPI		R16, 0xC1
		BREQ	NO_TERMINO
		LDS		R16, ADCH		;leo los ultimos 2 bits

		LDI		R17, 0x0E		;MAPEO PARA QUERDAR CON UNA PARTE (0X1C)ANTES
		AND		R16, R17		;LO MAPEO ACA

		ROR		R16
		;ROR		R16
		;MOV		R5, R16		;lo guardo en R15 asi me queda, cuando termina la subrutina


		;LDI		R17, 0x07
		MOV		R18, R16			;para usar cpi
		;AND		R18, R17
		CPI		R18, 0x02
		BRLT	ES_UN_1			;SALTO SI ES MENOR O IGUAL
		CPI		R18, 0x04
		BRLT	ES_UN_2			;SALTO SI ES MENOR O IGUAL
		CPI		R18, 0x06
		BRLT	ES_UN_3			;SALTO SI ES MENOR O IGUAL
		LDI		R18, 4				;CHAR 4

		JMP		FIN_RANDOM

ES_UN_1:
		LDI		R18, 1				;CHAR 1
		JMP		FIN_RANDOM

ES_UN_2:
		LDI		R18, 2				;CHAR 2
		JMP		FIN_RANDOM

ES_UN_3:
		LDI		R18, 3				;CHAR 3
		JMP		FIN_RANDOM

FIN_RANDOM:
		
		MOV		R5, R18				;DEVUELVO EL DATO EN R5


		POP		R18
		POP		R17
		POP		R16

RET


;******************************************************************/
;subrutina para usar matriz para la ram y q sea mas facil
;******************************************************************/

LOAD_MATRIX_RAM:
	PUSH	R0
	PUSH	R1
	PUSH	R2			;mem aux
	PUSH	R3			;mem aux2
	PUSH	R4			;copia del resto
	PUSH	R5			;copia del ancho
	PUSH	R6			;MEMORIA PARA SUMAR CARRY
	PUSH	R16			;recibo X
	PUSH	R17			;recibo Y
	PUSH	R18			;value ofla division
	PUSH	R19			;resto de la division
	PUSH	R20			;dato a guardar?
	PUSH	R21			;8
	PUSH	R22			;84
	PUSH	R23			;recibo ancho de dibujo
	PUSH	R24			;recibo alto del dibujo
	PUSH	R25			;0
	PUSH	XL
	PUSH	XH
	PUSH	ZL
	PUSH	ZH			;recibo registro para pasar el dibujo

	LDI		R21, 8
	LDI		R22, 84
	LDI		R18, 0		;hago la "division"
	MOV		R6, R18
	;INC		R24			;ver si anda, a veces pasa mas de 2 bytes

SIGO:
	INC		R18
	MUL		R18, R21
	CP		R0, R17
	BRGE	TERMINE_LA_DIV
	JMP		SIGO

TERMINE_LA_DIV:
	MOV		R19, R18
	MUL		R19, R21
	SUB		R0, R17		;me va a dar negativo
	LDI		R19, 8		;cargo 8 para restar al resto que me da el numero para rolear
	SUB		R19, R0		;guardo en r19 el valor para rolear

	LDI		XL, LOW(RAM_DISPLAY)
	LDI		XH, HIGH(RAM_DISPLAY)

	DEC		R18			;para que multiplique bien
	MUL		R18, R22
	ADD		XL, R0
	ADD		XL, R16		;termino de apuntar a la tabla en la RAM
	ADC		XH, R1
	MOV		R21, R23	;copio el ancho
	INC		R18

PASO_AL_OTRO_ANCHO:
	CLC					;borro el carry para que no me moleste
	LDI		R25, 0
	MOV		R2, R25		;memoria para sumar lo que le falta
	MOV		R4, R19		;copio el resto en R4
	MOV		R5,	R24		;copio el ALTO del dibujo
PASO_AL_OTRO_Y:
	LPM		R20, Z		;para avanzar en la tabla la cantidad de bytes que me dice el que mando
	LDI		R25, 0
	MOV		R4, R19		;copio el resto en R4
ROLEO_OTRA_VEZ:
	ROL		R20
	ROL		R25			;parte para sumar a lo de Down
	CLC
	DEC		R4
	BRNE	ROLEO_OTRA_VEZ
	ADD		R20, R2
	ST		X, R20		;una vez q guardo incremento X EN 84
	ADD		XL, R22		;incremento X en 84
	ADC		XH, R6
	ADD		ZL, R21		;para que vaya Down, le sumo el ancho, en esta imagen esta todo ordenado
	ADC		ZH, R6
	MOV		R2, R25		;memoria para sumar lo que le falta
	DEC		R5
	BRNE	PASO_AL_OTRO_Y
	DEC		R18			;decremento para hacer bien la cuenta
	MUL		R22, R24	;para volver a la POSITION original
	SUB		XL, R0
	SBC		XH, R1
	INC		XL			;sumo 1 para avanzar un lugar en la RAM
	BREQ	SUMO_1_XH
SIGO_DSP_XH:			;SIGO DESPUES DE INCREMENTAR XH
	INC		R18
	CLC
	MUL		R21, R24	;ancho de la imagen por cant de bytes
	SBC		ZL, R0		;vuelvo al inicio
	SBC		ZH, R1
	INC		ZL			;sumo 1 para avanzar en el dibujo
	BREQ	SUMO_1_ZH
SIGO_DSP_ZH:
	DEC		R23
	BRNE	PASO_AL_OTRO_ANCHO
	JMP		FINISH

SUMO_1_XH:
	INC		XH
	JMP		SIGO_DSP_XH

SUMO_1_ZH:
	INC		ZH
	JMP		SIGO_DSP_ZH


FINISH:
	POP		ZH
	POP		ZL
	POP		XH
	POP		XL
	POP		R25
	POP		R24
	POP		R23
	POP		R22
	POP		R21
	POP		R20
	POP		R19
	POP		R18
	POP		R17
	POP		R16
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0

	RET





;*****************************************************************************************************************/
;Esta funcion es para imprimir en pantalla strings de caracteres 
;El string nunca va a ser mayor a 14 chars, ya que es lo maximo
;que se puede mostrar en pantalla en horizontal.
;*****************************************************************************************************************/

;*****************************************************************************************************************/
;Esta funcion es para escribir en RAM strings de caracteres.
;En R19 debe estar guardado el largo de la cadena, en R16 y R16 las
;POSITIONes en X e Y respectivamente donde se desea imprimir, y en Z
;debe estar guardada la direccion del primer byte de la cadena.
;*****************************************************************************************************************/

RAM_PRINT_STRING:
	PUSH	R16	;value ofX
	PUSH	R17	;value ofY
	PUSH	R18	;valores del string
	PUSH	R19	;Largo del string
	PUSH	R20 ;CARGO 0 PAR ASUMAR CARRY
	PUSH	R23	;recibo ancho de dibujo
	PUSH	R24	;recibo alto del dibujo
	PUSH	ZL	;Parte baja de la direccion del string
	PUSH	ZH	;Parte alta de la direccion del string

	LDI		R20, 0

NEXT_STRING_CHAR2:
	LDI		R23, 6	;CARGO PARA SUMAR 6 CARACTERES EN X
	LPM		R18,Z+

	CALL	RAM_PRINT_CHAR

	ADD		R16, R23
	ADC		R16, R20
	DEC		R19
	BRNE	NEXT_STRING_CHAR2
	
	POP		ZH
	POP		ZL
	POP		R24
	POP		R23
	POP		R20
	POP		R19
	POP		R18
	POP		R17
	POP		R16

RET
	
	
;***************************************************/
;RUTINA PARA ESCRIBIR CARACTERES EN LA RAM
;***************************************************/

RAM_PRINT_CHAR:
	PUSH	R16 	;POSITION en X
	PUSH	R17		;POSITION en Y
	PUSH	R18		;Caracter del string
	PUSH	R23		;recibo ancho de dibujo
	PUSH	R24		;recibo alto de dibujo
	PUSH	YL
	PUSH	YH
	PUSH	R30
	PUSH	R31

	LDI		R23, 6
	;LDI		R24, 1			;ANCHO Y ALTO DE LOS CARACTERES
	
	SUBI	R18,32			;Se resta el offset al caracter para conocer el valor en la tabla
	LDI		R30,12			;Se debe multiplicar por 12 para obtener el value ofla tabla, ya que cada caracter son 12 bytes
	;CLC
	MUL		R18, R30		;El resultado se guarda en R1-R0 (el menos significativo en R0)
	
	LDI		ZL,LOW(CHARS_TABLE<<1)
	LDI		ZH,HIGH(CHARS_TABLE<<1)	;Se carga Z con la direccion de la tabla (hay que multiplicar por 2 para acceder)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;Se suma el offset para el caracter deseado

	;LPM		R16,Z+			;Leo el value ofla tabla y lo guardo en R18

	MOV		YL, ZL
	MOV		YH, ZH			;copio la direccion donde apunta Z

	CALL	LOAD_MATRIX_RAM		;Envio el dato a la RAM

	MOV		ZL, YL
	MOV		ZH, YH				;recupero los valores anteriores
	
		
	POP		R31
	POP		R30
	POP		YH
	POP		YL
	POP		R24
	POP		R23	
	POP		R18
	POP		R17
	POP		R16
RET


;*************************************************************************/
;subrutina para los pulsadores
;Son 6 botones
;0 - Up, 1 - izq, 2 - der, 3 - Down, 4 - aceptar, 5 - pausa
; DEVUELVO EL VALOR EN R7
;*************************************************************************/

;FALTA MODIFICAR TODO SOLO ESTA LA PRUEBA QUE HICE
;
PULSADORES:

		PUSH	R18
		PUSH	R19
		PUSH	R20		


		LDI		R20, 0
		MOV		R18, R19


LEO:
		SBIC	PINC, 1
		JMP		LEO2
		JMP		LEO
LEO2:
		SBIS	PINC, 1
		JMP		SIGO_AL_PROG
		JMP		LEO2
SIGO_AL_PROG:
		INC		R20
		ADD		R19, R20
		MOV		R18, R19
		CALL	LCD_PRINT_CHAR
		CALL	DELAY_1S
		;JMP		OTRO_PULSO


		POP		R20
		POP		R19
		POP		R18

RET
*/

;******************************************************************************************/
;subrutina para los pulsadores
;Son 6 botones
;1 - Up, 2 - izq, 3 - der, 4 - Down, 5 - aceptar, 6 - pausa, 7 -ningun boton pulsado
; DEVUELVO EL VALOR EN R7
;******************************************************************************************/

PULSADORES_TODOS:

		PUSH	R18


		SBIC	PINC, 1					;flecha Up
		JMP		BOTON_FLECHA_ARRIBA
		SBIC	PINC, 2					;flecha izquierda
		JMP		BOTON_FLECHA_IZQ
		SBIC	PINC, 3					;flecha Rigth
		JMP		BOTON_FLECHA_DER
		SBIC	PINC, 4					;flecha Down
		JMP		BOTON_FLECHA_ABAJO
		SBIC	PINC, 5					;boton aceptar o boton A
		JMP		BOTON_ACEPTAR

		;boton pausa con interrupcion

		LDI		R18, 7
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_ARRIBA:
		LDI		R18, 1					;cargo el valor que le di a la flecha( 1 = Up )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_IZQ:
		LDI		R18, 2					;cargo el valor que le di a la flecha( 2 = Left)
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_DER:
		LDI		R18, 3					;cargo el valor que le di a la flecha( 3 = Rigth )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_ABAJO:
		LDI		R18, 4					;cargo el valor que le di a la flecha( 4 = Down )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES


BOTON_ACEPTAR:
		LDI		R18, 5					;cargo el valor que le di a la flecha( 5 = ACEPTAR )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

FIN_BOTONES:

		POP		R18

RET





;************************************************************************/
;cargo los graficos en RAM para el simon dice
;************************************************************************/
		
LOAD_SIMON:

		PUSH	R16		;POSITION X
		PUSH	R17		;POSITION Y
		PUSH	R19		;largo de caracteres para strings
		PUSH	R23		;width in PIXELES para la imagen o lo que sea
		PUSH	R24		;alto en bytes para la imagen o lo que sea
		PUSH	ZL		;direccion para apuntar en la flash
		PUSH	ZH
		

		CALL	CLEAR_RAM

		;SIMON_DICE
		LDI		R16, 0				;POSITION X
		LDI		R17, 1				;POSITION Y
		LDI		R23, 6				;width in PIXELES
		LDI		R24, 1				;ALTO EN BYTES
		LDI		R19, 12				;ancho del string
		LDI		ZL, LOW(SIMON<<1)
		LDI		ZH, HIGH(SIMON<<1)
		CALL	RAM_PRINT_STRING
		;numeros
		LDI		R16, 40				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R19, 4				;ancho del string
		LDI		ZL, LOW(NUMEROS<<1)
		LDI		ZH, HIGH(NUMEROS<<1)
		CALL	RAM_PRINT_STRING
		;HIGH_SCORE
		LDI		R16, 40				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R19, 7				;ancho del string
		LDI		ZL, LOW(HIGH_SC<<1)
		LDI		ZH, HIGH(HIGH_SC<<1)
		CALL	RAM_PRINT_STRING
		;
		;TU TURNO
		LDI		R16, 35				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R19, 8				;ancho del string
		LDI		ZL, LOW(TU_TURNO<<1)
		LDI		ZH, HIGH(TU_TURNO<<1)
		CALL	RAM_PRINT_STRING
		*/
		;CORAZON1
		LDI		R16, 40				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;CORAZON2
		LDI		R16, 55				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;CORAZON3
		LDI		R16, 70				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_UP
		LDI		R16, 12				;POSITION X
		LDI		R17, 12				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP<<1)
		LDI		ZH, HIGH(FLECHA_UP<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_L
		LDI		R16, 0				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L<<1)
		LDI		ZH, HIGH(FLECHA_L<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_R
		LDI		R16, 22				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R<<1)
		LDI		ZH, HIGH(FLECHA_R<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_DWN
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN<<1)
		LDI		ZH, HIGH(FLECHA_DWN<<1)
		CALL	LOAD_MATRIX_RAM



		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		POP		ZH
		POP		ZL
		POP		R24
		POP		R23
		POP		R19
		POP		R17
		POP		R16
		
		RET
		


;*******************************************************************************************/
;cantidad de datos que dijo simon
;convertir el dato a BCD para mostrarlo bien en pantalla
;el valor debe ir en R25
;*******************************************************************************************/

CONT_SIMON:
		PUSH	R0
		PUSH	R1
		PUSH	R16
		PUSH	R17			
		PUSH	R18			;valor del resto de la division "numeros"
		PUSH	R20			;valor del decimal para la division
		PUSH	R22			;guardo 48 para sumar al valor y que me de el caracter para mostrar
		PUSH	R23
		PUSH	R24
		PUSH	R25			;value ofLOS DATOS
			

		LDI		R16, 10
		LDI		R20, 0		;valor del decimal para la division



SIGO_2:
		INC		R20
		MUL		R20, R16
		CP		R25, R0
		BRLT	TERMINE_LA_DIV_2
		JMP		SIGO_2

TERMINE_LA_DIV_2:
		DEC		R20
		MOV		R23, R20
		MUL		R23, R16
		SUB		R25, R0
		MOV		R18, R25		;value ofLA RESTA, VER SI DEJO R18 U OTRO




		;numeros unidad
		LDI		R16, 77				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 71				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 1				;height in bytes 2, when is not centred
		MOV		R18, R20			;R20 ANTES, VEO Q RANDOM SALIO
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR


		POP		R25
		POP		R24
		POP		R23
		POP		R22
		POP		R20
		POP		R18
		POP		R17
		POP		R16
		POP		R1
		POP		R0

		RET


;*******************************************************************************************/
;MUESTRO LA FLECHA PULSADA EN PANTALLA Y DESPUES SIGO CON EL PROGRAMA
;*******************************************************************************************/

MUESTRO_FLECHA_PULSADA:
		

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R22			;value ofla tecla pulsada
		PUSH	R23			;width in PIXELES
		PUSH	R24			;ALTO EN BYTES
		PUSH	ZL
		PUSH	ZH


		;MOV		R22, R7			;copio el value ofla tecla pulsada en R22

		CPI		R22, 1
		BREQ	CARGO_1			;cargo Up
		CPI		R22, 2
		BREQ	CARGO_2			;cargo izq
		CPI		R22, 3
		BREQ	CARGO_3			;cargo der
		JMP		CARGO_ABAJO		;Los branchs no llegan tengo que usar JMP

CARGO_1:
		JMP		CARGO_ARRIBA
CARGO_2:
		JMP		CARGO_IZQ
CARGO_3:
		JMP		CARGO_DER



CARGO_ABAJO:
		LDI		R22, 12				;PARA VERLO GRIS 1 SEG
ABAJO_GRIS:
		;FLECHA_DWN_NEG
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN_NEG<<1)
		LDI		ZH, HIGH(FLECHA_DWN_NEG<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		
		;FLECHA_DWN
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN<<1)
		LDI		ZH, HIGH(FLECHA_DWN<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY
		CALL	DELAY_25MS
		

		DEC		R22
		BRNE	ABAJO_GRIS

		JMP		FIN_MUESTRO_FLECHAS

CARGO_ARRIBA:
		LDI		R22, 12				;PARA VERLO GRIS 1 SEG
ARRIBA_GRIS:
		;FLECHA_UP_NEG
		LDI		R16, 12				;POSITION X
		LDI		R17, 12				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP_NEG<<1)
		LDI		ZH, HIGH(FLECHA_UP_NEG<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_UP
		LDI		R16, 12				;POSITION X
		LDI		R17, 12				;POSITION Y
		LDI		R23, 9				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP<<1)
		LDI		ZH, HIGH(FLECHA_UP<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		CALL	DELAY_25MS
		

		DEC		R22
		BRNE	ARRIBA_GRIS

		JMP		FIN_MUESTRO_FLECHAS


CARGO_IZQ:
		LDI		R22, 12				;PARA VERLO GRIS 1 SEG
IZQ_GRIS:
		;FLECHA_L_NEG
		LDI		R16, 0				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L_NEG<<1)
		LDI		ZH, HIGH(FLECHA_L_NEG<<1)
		CALL	LOAD_MATRIX_RAM


		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_L
		LDI		R16, 0				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L<<1)
		LDI		ZH, HIGH(FLECHA_L<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		CALL	DELAY_25MS
		

		DEC		R22
		BRNE	IZQ_GRIS

		JMP		FIN_MUESTRO_FLECHAS



CARGO_DER:
		LDI		R22, 12				;PARA VERLO GRIS 1 SEG
DER_GRIS:
		;FLECHA_R
		LDI		R16, 22				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R_NEG<<1)
		LDI		ZH, HIGH(FLECHA_R_NEG<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_R
		LDI		R16, 22				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R<<1)
		LDI		ZH, HIGH(FLECHA_R<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		CALL	DELAY_25MS
		

		DEC		R22
		BRNE	DER_GRIS

		JMP		FIN_MUESTRO_FLECHAS


FIN_MUESTRO_FLECHAS:

		POP		ZH
		POP		ZL
		POP		R24
		POP		R23
		POP		R22
		POP		R17
		POP		R16

RET

;**************************************************************************************/
;MUESTRO LOS CORAZONES
;**************************************************************************************/

CORAZONES:

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R22			;cantidad de corazones disponibles
		PUSH	R23			;width in PIXELES
		PUSH	R24			;ALTO EN BYTES
		PUSH	ZL
		PUSH	ZH


		CPI		R22, 3
		BREQ	CORAZON3_BLANCO
		CPI		R22, 2
		BREQ	CORAZON2_BLANCO

		;CORAZON1_BLANCO
		LDI		R16, 40				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	LOAD_MATRIX_RAM

		JMP		TERMINO_CORAZONES

CORAZON2_BLANCO:
		;CORAZON2
		LDI		R16, 55				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	LOAD_MATRIX_RAM

		JMP		TERMINO_CORAZONES

CORAZON3_BLANCO:
		;CORAZON3
		LDI		R16, 70				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in PIXELES
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	LOAD_MATRIX_RAM


TERMINO_CORAZONES:

		POP		ZH
		POP		ZL
		POP		R24
		POP		R23
		POP		R22
		POP		R17
		POP		R16

RET


;**************************************************************************************/
;ESCRIBO HIGH SCORE DESDE EL EEPROM
;**************************************************************************************/

ESCRIBO_HIGH_SCORE:

		PUSH	R22			;valor a escribir en la EEPROM
		PUSH	ZL
		PUSH	ZH


		LDI		ZL, LOW(HIGH_SCORE)
		LDI		ZH, HIGH(HIGH_SCORE)

		CLI						;SACO LAS INTERRUPCIONES

EEPROM_WRITE:
 
		SBIC	EECR,EEPE 
		RJMP	EEPROM_WRITE		;ESPERO PARA PODER ESCRIBIR
 
		OUT		EEARH, ZH			;GUARDO LA DIRECCION DE DONDE ESTA EL BYTE A ESCRIBIR
		OUT		EEARL, ZL
 
		OUT		EEDR, R22			;escribo el value ofR22 en la direccion apuntada por ZL y ZH
 
		SBI		EECR,EEMPE			; Write logical one to EEMPE
 
		SBI		EECR,EEPE			;escribo en la EEPROM seteando EEPE
 

		SEI							;VUELVO A ACTIVAR LAS INTERERUPCIONES

		POP		ZH
		POP		ZL
		POP		R22

RET



;**************************************************************************************/
;LEO HIGH SCORE DESDE EL EEPROM Y LO MUESTRO
;DEVUELVO EL VALOR EN R9 PARA COMPARARLO DESPUES
;**************************************************************************************/

LEO_HIGH_SCORE:

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R20			;valor leido de la EEPROM
		PUSH	R22			;48 para sumarle y mostrar el caracter en pantalla
		PUSH	R23			;width in PIXELES
		PUSH	R24			;ALTO EN BYTES
		PUSH	R25
		PUSH	ZL
		PUSH	ZH


		LDI		ZL, LOW(HIGH_SCORE)
		LDI		ZH, HIGH(HIGH_SCORE)

		CLI						;SACO LAS INTERRUPCIONES
EEPROM_READ:
 
		SBIC	EECR, EEPE		;ESPERO PARA PODER ESCRIBIR
		RJMP	EEPROM_read

		OUT		EEARH, ZH
		OUT		EEARL, ZL
		
		SBI		EECR, EERE		;EMPIEZO A LEER LA EEPROM

		IN		R20, EEDR		;GUARDO EL DATO EN R20

		MOV		R9, R20			;COPIO EL VALOR DEL DATO LEIDO EN R9

		SEI						;VUELVO A ACTIVAR LAS INTERERUPCIONES

			
		LDI		R16, 10
		LDI		R25, 0		;valor del decimal para la division

		CPI		R20, 0xFF
		BRNE	SIGO_3		;SIGO SI NO ES 0

		LDI		R18, 0
		LDI		R25, 0
		JMP		ESCRIBO_NUMEROS

SIGO_3:
		INC		R25
		MUL		R25, R16
		CP		R20, R0
		BRLT	TERMINE_LA_DIV_3
		JMP		SIGO_3

TERMINE_LA_DIV_3:
		DEC		R25
		MOV		R23, R25
		MUL		R23, R16
		SUB		R20, R0
		MOV		R18, R20		;value ofLA RESTA, VER SI DEJO R18 U OTRO



ESCRIBO_NUMEROS:
		;numeros unidad
		LDI		R16, 76				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 70				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 2				;height in bytes 2, when is not centred
		MOV		R18, R25			;R20 ANTES, VEO Q RANDOM SALIO
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY		;LO MUESTRO EN PANTALLA


		POP		ZH
		POP		ZL
		POP		R25
		POP		R24
		POP		R23
		POP		R22
		POP		R20
		POP		R17
		POP		R16

RET


;*******************************************************************************************/
;cantidad de datos que introdujo el USUARIO
;convertir el dato a BCD para mostrarlo bien en pantalla
;el valor debe ir en R25
;*******************************************************************************************/

CONT_USER:
		PUSH	R0
		PUSH	R1
		PUSH	R16
		PUSH	R17			
		PUSH	R18			;valor del resto de la division "numeros"
		PUSH	R20			;valor del decimal para la division
		PUSH	R22			;guardo 48 para sumar al valor y que me de el caracter para mostrar
		PUSH	R23
		PUSH	R24
		PUSH	R25			;value ofLOS DATOS
			

		LDI		R16, 10
		LDI		R20, 0		;valor del decimal para la division



SIGO_4:
		INC		R20
		MUL		R20, R16
		CP		R25, R0
		BRLT	TERMINE_LA_DIV_4
		JMP		SIGO_4

TERMINE_LA_DIV_4:
		DEC		R20
		MOV		R23, R20
		MUL		R23, R16
		SUB		R25, R0
		MOV		R18, R25		;value ofLA RESTA, VER SI DEJO R18 U OTRO




		;numeros unidad
		LDI		R16, 46				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 40				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in PIXELES DEL CARACTER
		LDI		R24, 1				;height in bytes 2, when is not centred
		MOV		R18, R20			;R20 ANTES, VEO Q RANDOM SALIO
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR


		POP		R25
		POP		R24
		POP		R23
		POP		R22
		POP		R20
		POP		R18
		POP		R17
		POP		R16
		POP		R1
		POP		R0

		RET
		
