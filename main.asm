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
		LDI		R23, 64				;width in pixels
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
		SBIC	PINC, 5					;buttonA
		JMP		SNAKE
		SBIC	PINB, 0					;buttonB
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
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(S_INIT<<1)
		LDI		ZH, HIGH(S_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;I
		LDI		R16, 27				;POSITION X
		LDI		R17, 4				;POSITION Y
		LDI		R23, 5				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;M
		LDI		R16, 34				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 13				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(M_INIT<<1)
		LDI		ZH, HIGH(M_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;O
		LDI		R16, 48				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 8				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(O_INIT<<1)
		LDI		ZH, HIGH(O_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;n
		LDI		R16, 55				;POSITION X
		LDI		R17, 7				;POSITION Y
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(N_INIT<<1)
		LDI		ZH, HIGH(N_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;D
		LDI		R16, 26				;POSITION X
		LDI		R17, 18				;POSITION Y
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(D_INIT<<1)
		LDI		ZH, HIGH(D_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;I
		LDI		R16, 36				;POSITION X
		LDI		R17, 18				;POSITION Y
		LDI		R23, 5				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;C
		LDI		R16, 42				;POSITION X
		LDI		R17, 21				;POSITION Y
		LDI		R23, 8				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(C_INIT<<1)
		LDI		ZH, HIGH(C_INIT<<1)
		CALL	LOAD_MATRIX_RAM
		;E
		LDI		R16, 51				;POSITION X
		LDI		R17, 21				;POSITION Y
		LDI		R23, 7				;width in pixels
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
		LDI		R23, 6				;width in pixels
		LDI		R24, 2				;height in bytes
		LDI		R19, 7				;length of the string
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
		LDI		R23, 6				;width in pixels
		LDI		R24, 1				;height in bytes
		LDI		R19, 12				;length of the string
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
		LDI		R23, 6				;width in pixels
		LDI		R24, 2				;height in bytes
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
	;PUSH	R21	;value ofretorno (don't save in the stack so it can be modify)
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
;direction of the tail and the head. Load R4 and R5 with
;the directions of the head y the tail, must load the
;POSITIONs, because this routine use internal routines
;that use this data
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
	
	LDI	R16,UP_DIRECTION		;load the direction to Up
	CP	R4,R16				;compare with the recieve direction
	BRNE	NOT_UP_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	DEC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	UP_PIXEL_NOT_SET
	LDI	R19,1				;check if the pixel is on to know if the snake will eat the fruit
UP_PIXEL_NOT_SET:	
	CALL	MOVE_HEAD_UP
	
NOT_UP_DIRECTION_HEAD:
	LDI	R16,LEFT_DIRECTION		;load the direction to the Left	
	CP	R4,R16				;compare with the recieve direction
	BRNE	NOT_LEFT_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	DEC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	LEFT_PIXEL_NOT_SET
	LDI	R19,1				;check if the pixel is on to know if the snake will eat the fruit
LEFT_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_LEFT
	
NOT_LEFT_DIRECTION_HEAD:
	LDI	R16,DOWN_DIRECTION		;load the direction to Down	
	CP	R4,R16				;compare with the recieve direction
	BRNE	NOT_DOWN_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	INC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	DOWN_PIXEL_NOT_SET
	LDI	R19,1				;check if the pixel is on to know if the snake will eat the fruit
DOWN_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_DOWN
	
NOT_DOWN_DIRECTION_HEAD:
	LDI	R16,RIGHT_DIRECTION		;load the direction to la Rigth
	CP	R4,R16				;compare with the recieve direction
	BRNE	NOT_RIGHT_DIRECTION_HEAD
	
	MOV	R16,R0
	MOV	R17,R1
	INC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY
	CP	R18,R21
	BREQ	RIGHT_PIXEL_NOT_SET
	LDI	R19,1				;check if the pixel is on to know if the snake will eat the fruit
RIGHT_PIXEL_NOT_SET:
	CALL	MOVE_HEAD_RIGHT
	
NOT_RIGHT_DIRECTION_HEAD:
	
	CP	R18,R19
	BRNE	DONT_MOVE_TAIL			;if snake take the fruit R19 is 1, so the pixel of the tail will not turn off
	CALL	MOVE_TAIL_ONE_POSITION
	RJMP	TAIL_MOVED
DONT_MOVE_TAIL:
	CALL	SET_FRUIT			;if snake take the fruit, it has to turn on another in the display
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
;this routine move the head of the snake one POSITION to Up.
;after move the values of the RAM, modify the new POSITIONs
;of the head in the correct registers.
;************************************************************/

MOVE_HEAD_UP:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;direction of the RAM
	PUSH	ZH	;direction of the RAM
	
	DEC	R1	;move the head one pixel to Up
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
;this routine move the head of the snake one POSITION to the Left.
;after move the values of the RAM, modify the new positions
;of the head in the correct registers.
;************************************************************/

MOVE_HEAD_LEFT:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;direction of the RAM
	PUSH	ZH	;direction of the RAM
	
	DEC	R0	;move the head one pixel to the Left
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
;this routine move the head of the snake one POSITION to Down.
;after move the values of the RAM, modify the new positions
;of the head in the correct registers.
;************************************************************/

MOVE_HEAD_DOWN:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;direction of the RAM
	PUSH	ZH	;direction of the RAM
	
	INC	R1	;move the head one pixel to the Left
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
;this routine move the head of the snake one POSITION to la Rigth.
;after move the values of the RAM, modify the new positions
;of the head in the correct registers.
;************************************************************/

MOVE_HEAD_RIGHT:
	;PUSH	R0	;POSITION en X of the head
	;PUSH	R1	;POSITION en Y of the head
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;direction of the RAM
	PUSH	ZH	;direction of the RAM
	
	INC	R0	;move the head one pixel to the Left
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
;rhis routine move the tail of snake one POSITION and modify
;the necesary registers.
;************************************************************/

MOVE_TAIL_ONE_POSITION:
	;PUSH	R2	;POSITION en X of the tail (don't save in the stack so it can be modify)
	;PUSH	R3	;POSITION en Y of the tail (don't save in the stack so it can be modify)
	PUSH	R16	;aux registers for values of X
	PUSH	R17	;aux registers for values of Y
	PUSH	R18
	PUSH	R21
	PUSH	ZL	;direction of the RAM
	PUSH	ZH	;direction of the RAM
	
	MOV	R16,R2
	MOV	R17,R3
	CALL	CLEAR_PIXEL_IN_RAM_DISPLAY	;turn off the pixel of the tail
	
	;when the tail turn off, it must verify the direction to move
	;to not lose the body of the snake. To do this, need to check what of the 4
	;pixels that round the snake are turned on.
	
	LDI	R18,0
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;verify if the pixel is turned on of Up
	CP	R21,R18		;if are equal then the pixel is power off
	BRNE	MOVE_TAIL_UP
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;verify if the pixel is turned on of the Left
	CP	R21,R18		;if are equal then the pixel is power off
	BRNE	MOVE_TAIL_LEFT
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;verify if the pixel is turned on of Down
	CP	R21,R18		;if are equal then the pixel is power off
	BRNE	MOVE_TAIL_DOWN
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;verify if the pixel is turned on of la Rigth
	CP	R21,R18		;if are equal then the pixel is power off
	BRNE	MOVE_TAIL_RIGHT
	
MOVE_TAIL_UP:
	DEC	R3	;need to move the POSITION of the tail one pixel to Up
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_LEFT:
	DEC	R2	;need to move the POSITION of the tail one pixel to the Left
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_DOWN:
	INC	R3	;need to move the POSITION of the tail one pixel to Down
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_RIGHT:
	INC	R2	;need to move the POSITION of the tail one pixel to the Rigth
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
;Routine to turn on the fruit in the display.
;************************************************************/

SET_FRUIT:
	PUSH	R0
	PUSH	R1
	PUSH	R5		;register to save the random numbers
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	R21
	PUSH	ZL		;direction of the RAM
	PUSH	ZH		;direction of the RAM
	
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
;Delay where the snake move in the RAM.
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
;START of the SUBROUTINES
;*****************************************************************************************************************/
;*****************************************************************************************************************/


;****************** LCD_INIT *************************************************************************************/
;This routine init the 6 pins of the PORT_LCD for the control of the screen,
;sends a reset sign and set all other outputs in high level
;(except for the Backlight to reduce the current consumption).
;*****************************************************************************************************************/

LCD_INIT:
	PUSH	R16		;save the content of R16 in the stack
	IN	R16,DDR_LCD	;read the state of DDR_LCD	
	SBR	R16,LCD_PINS	;turn on bits 0-5
	OUT	DDR_LCD,R16	;set as output pins 0-5 of PORT_LCD
	
	CBI	PORT_LCD,RES_PIN_NUMBER	;reset the display
	CALL	DELAY_5ms			;delay of 5ms aprox
	CALL	DELAY_5ms			;delay of 5ms aprox
	CALL	DELAY_5ms			;delay of 5ms aprox
	SBI	PORT_LCD,BL_PIN_NUMBER	;turn on BL
	SBI	PORT_LCD,DC_PIN_NUMBER	;Set to high the other lines
	SBI	PORT_LCD,SCE_PIN_NUMBER
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,SCK_PIN_NUMBER
	SBI	PORT_LCD,RES_PIN_NUMBER	;set to one the reset

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
	CALL	LCD_WRITE_COMMAND			;send init commands 
		
	POP	R16	
RET

;*****************************************************************************************************************/
;This routine sends one byte of data through the SDIN pin. It uses the Register R17 like a counter
;and the data to send read from R16 (both registers are saved in the stack).
;*****************************************************************************************************************/

LCD_WRITE_DATA:
	PUSH	R16	
	PUSH	R17	;save the content of R16 y R17 in the stack
	
	LDI	R17,8	;Init the counter
	
	CBI	PORT_LCD,SCE_PIN_NUMBER	;Set to down the line SCE
	SBI	PORT_LCD,DC_PIN_NUMBER	;Maint in high the line DC to send data

SEND_NEXT_BIT_DATA:
	CBI	PORT_LCD,SCK_PIN_NUMBER	;Set to down the line of clock
	
	SBRC	R16,7			;if there's a 0 in the MSB the next instruction don't execute
	SBI	PORT_LCD,SDIN_PIN_NUMBER	;if there's a 1 in the MSB, set to high SDIN
	SBRS	R16,7			;if there's a 1 in the MSB the next instruction don't execute
	CBI	PORT_LCD,SDIN_PIN_NUMBER	;if there's a 0 in the MSB, set to down SDIN
	
	LSL	R16			;move R16 one POSITION to the Left
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Set to up the line SCK to allow read
	
	CALL	DELAY_TRANSMITION	;call for delay
	DEC	R17			;decrement R17
	BRNE	SEND_NEXT_BIT_DATA	;if counter not reach zero, send the next bit
	
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,SCE_PIN_NUMBER	
	SBI	PORT_LCD,SCK_PIN_NUMBER	;afther send the complete byte, set to high all the lines
	
	POP	R17
	POP	R16			;get from the stack R16 y R17
RET
		
;*****************************************************************************************************************/
;This routine sends a byte through the SDIN pin. It use the R17 register like
;a counter, and R16 read the data to send (both registers are saved 
;in the stack).
;*****************************************************************************************************************/

LCD_WRITE_COMMAND:
	PUSH	R16	
	PUSH	R17	;save the content of R16 y R17 in the stack
	
	LDI	R17,8	;Init the counter
	
	CBI	PORT_LCD,SCE_PIN_NUMBER	;Set to down the line SCE
	CBI	PORT_LCD,DC_PIN_NUMBER	;Set to Down the DC line to send a command

SEND_NEXT_BIT_COMMAND:
	CBI	PORT_LCD,SCK_PIN_NUMBER	;Set to down the line of clock
	
	SBRC	R16,7			;if there's a 0 in the MSB the next instruction don't execute
	SBI	PORT_LCD,SDIN_PIN_NUMBER	;if there's a 1 in the MSB, set to high SDIN
	SBRS	R16,7			;if there's a 1 in the MSB the next instruction don't execute
	CBI	PORT_LCD,SDIN_PIN_NUMBER	;if there's a 0 in the MSB, set to down SDIN
	
	LSL	R16			;move R16 one POSITION a the Left
	SBI	PORT_LCD,SCK_PIN_NUMBER	;Set to up the line SCK to allow read
	
	CALL	DELAY_TRANSMITION	;call for delay
	DEC	R17			;decrement R17
	BRNE	SEND_NEXT_BIT_COMMAND	;if counter not reach zero, send the next bit
	
	SBI	PORT_LCD,SDIN_PIN_NUMBER
	SBI	PORT_LCD,DC_PIN_NUMBER
	SBI	PORT_LCD,SCE_PIN_NUMBER	
	SBI	PORT_LCD,SCK_PIN_NUMBER	;afther send the complete byte, set to high all the lines
	
	POP	R17
	POP	R16			;get from the stack R16 y R17
RET

;**********************************************************/
DELAY_TRANSMITION:
	NOP
	NOP
RET
;**********************************************************/


;**********************************************************/
;delay of 5ms
;**********************************************************/

DELAY_5ms:
	PUSH	R17
	PUSH	R18
	
	LDI R17, 66 ;For 8mhz is 66
LOOP0:
	LDI R18, 200 ; 1 ciclo
LOOP1:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP1 ; 1 if false and 2 if true
	DEC		R17 ; 1
	BRNE	LOOP0 ; 2
	 
	POP	R18
	POP	R17
ret


;**********************************************************/
;delay of 200 ms
;**********************************************************/

DELAY_200ms:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19, 40
LOOP_7:
	LDI		R17, 66 ;For 8mhz is 66
LOOP_5:
	LDI		R18, 200 ; 1 ciclo
LOOP_6:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_6 ; 1 if false and 2 if true
	DEC		R17 ; 1
	BRNE	LOOP_5 ; 2
	DEC		R19
	BRNE	LOOP_7
	 
	POP		R19
	POP		R18
	POP		R17
ret


;**********************************************************/
;delay of 25 ms
;**********************************************************/

DELAY_25ms:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19, 5
LOOP_77:
	LDI		R17, 66 ;For 8mhz is 66
LOOP_55:
	LDI		R18, 200 ; 1 ciclo
LOOP_66:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_66 ; 1 if false and 2 if true
	DEC		R17 ; 1
	BRNE	LOOP_55 ; 2
	DEC		R19
	BRNE	LOOP_77
	 
	POP		R19
	POP		R18
	POP		R17
ret

;**********************************************************/
;delay of 1 s
;**********************************************************/

DELAY_1s:
	PUSH	R17
	PUSH	R18
	PUSH	R19
	
	LDI		R19,200
LOOP_2:
	LDI R17, 66 ;For 8mhz is 66
LOOP_0:
	LDI R18, 200 ; 1 ciclo
LOOP_1:
	DEC		R18 ; 1 ciclo
	BRNE	LOOP_1 ; 1 if false and 2 if true
	DEC		R17 ; 1
	BRNE	LOOP_0 ; 2
	DEC		R19
	BRNE	LOOP_2
	 
	 POP	R19
	POP	R18
	POP	R17
ret

;********************************************************/
;Routine for erase the RAM from the LCD
;********************************************************/


CLEAR_SCREEN:
	PUSH	R16
	PUSH	R17
	PUSH	R18

	LDI		R16,PCD8544_SETYADDR
	CALL	LCD_WRITE_COMMAND	;Init Y in zero
	LDI		R16,PCD8544_SETXADDR
	CALL	LCD_WRITE_COMMAND	;Init X in zero

	LDI		R18, 6		;6 rows
LOOP_12:
	LDI		R17, 84		;84 columns
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
;Rpoutine to erease the RAM from the uController
;********************************************/

CLEAR_RAM:
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	XL
	PUSH	XH

	LDI		XL, LOW(RAM_DISPLAY)
	LDI		XH, HIGH(RAM_DISPLAY)

	LDI		R18, 6		;6 rows
LOOP_122:
	LDI		R17, 84		;84 columns
LOOP_111:
	LDI		R16, 0
	ST		X+, R16		;load zeros in RAM
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
;This routine prints strings of chars on the screen.
;The max number of chars in the string is 14
;that's the max char supported in the screen.
;*****************************************************************************************************************/

;*****************************************************************************************************************/
;This routine prints strings of chars on the screen.
;The length of the strings needs to be in R19, in R16 and R17 the
;POSITIONs of X and Y respectively where it will going to print and
;in Z need to be the direction of the first byte of the string.
;*****************************************************************************************************************/

LCD_PRINT_STRING:
	PUSH	R16	;value ofX
	PUSH	R17	;value ofY
	PUSH	R18
	PUSH	R19	;length of the string
	PUSH	ZL	;direction of the low part of the string
	PUSH	ZH	;direction of the high part of the string
	
	LDI	R18,PCD8544_SETXADDR
	ADD	R16,R18		;add the value ofX desired with the command 
	LDI	R18,PCD8544_SETYADDR
	ADD	R17,R18		;add the value ofY desired with the command


	
	CALL	LCD_WRITE_COMMAND	;Init in X in the desired value
	MOV	R16,R17
	CALL	LCD_WRITE_COMMAND	;Init in Y in the desired value

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
	PUSH	R16 	;POSITION in X
	PUSH	R17		;POSITION in Y
	PUSH	R18		;Character
	PUSH	R30
	PUSH	R31

	;LDI	R30,PCD8544_SETXADDR
	;ADD	R16,R30			;add the value ofX desired with the command 
	;LDI	R30,PCD8544_SETYADDR
	;ADD	R17,R30			;add the value ofY desired with the command
	
	;CALL	LCD_WRITE_COMMAND	;Init in X in the desired value
	;MOV		R16,R17
	;CALL	LCD_WRITE_COMMAND	;Init in Y in the desired value
	
	SUBI	R18,32			;Subtract the offset to the character to know the value in the table
	LDI		R30,12			;Multiply by 6 to obtain the value of the table because the every character has 6 bytes
	MUL		R18, R30		;The result will be saved in R1-R0 (Less significant in R0)
	
	LDI	ZL,LOW(CHARS_TABLE<<1)
	LDI	ZH,HIGH(CHARS_TABLE<<1)	;Load Z with the direction of the table (mult by 2 to access it)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;add the offset for the desired character
	
	LDI		R18,6			;use R18 as a counter
SEND_NEXT_CHAR_BYTE:
	LPM		R16,Z+			;read the value of the table and save it in R18
	CALL	LCD_WRITE_DATA	;send the data to the display
	DEC		R18
	BRNE	SEND_NEXT_CHAR_BYTE	
		
	POP	R31
	POP	R30	
	POP	R18
	POP	R17
	POP	R16
RET


;*****************************************************
;Routine that refresh the screen. Read the data from
;the RAM memory pointed by Z and send it to the display
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
	CALL	LCD_WRITE_COMMAND	;Init X and Y in zero
	
	LDI		R18,6		;quantity of rows
SEND_NEXT_ROW_RAM:
	LDI		R17,84		;quantity of columns
SEND_NEXT_COL_RAM:	
	LD		R16,Z+
	CALL	LCD_WRITE_DATA	;send the data readed
	
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
;RANDOM numbers generator
;Save the value in R5
;***********************************************/
RANDOM:
		PUSH	R16
		PUSH	R17
		PUSH	R18

		LDI		R16, 0x70		;use AVCC, ADC0 input
		STS		ADMUX, R16		;for write in the ADMUX register
		LDI		R16, 0xC1		;Enable ADC and start the conversion with x prescaler
		STS		ADCSRA, R16
NO_TERMINO:
		LDS		R16, ADCSRA		;check if the conversion was finished
		CPI		R16, 0xC1
		BREQ	NO_TERMINO
		LDS		R16, ADCH		;Read the last 2 bits (most randoms bits)

		LDI		R17, 0x0E		;Map to get with one part of the byte
		AND		R16, R17		

		ROR		R16
		;ROR		R16
		;MOV		R5, R16		;save it in R15


		;LDI		R17, 0x07
		MOV		R18, R16		;for use the cpi
		;AND		R18, R17
		CPI		R18, 0x02
		BRLT	ES_UN_1			;branch if less or equal
		CPI		R18, 0x04
		BRLT	ES_UN_2			;branch if less or equal
		CPI		R18, 0x06
		BRLT	ES_UN_3			;branch if less or equal
		LDI		R18, 4			;CHAR 4

		JMP		FIN_RANDOM

ES_UN_1:
		LDI		R18, 1			;CHAR 1
		JMP		FIN_RANDOM

ES_UN_2:
		LDI		R18, 2			;CHAR 2
		JMP		FIN_RANDOM

ES_UN_3:
		LDI		R18, 3			;CHAR 3
		JMP		FIN_RANDOM

FIN_RANDOM:
		
		MOV		R5, R18			;Return the value in R5


		POP		R18
		POP		R17
		POP		R16

RET


;******************************************************************/
;Subroutine to use a matrix for the RAM
;******************************************************************/

LOAD_MATRIX_RAM:
	PUSH	R0
	PUSH	R1
	PUSH	R2			;mem aux
	PUSH	R3			;mem aux2
	PUSH	R4			;copy of the rest
	PUSH	R5			;copy of the width
	PUSH	R6			;memory to add carry
	PUSH	R16			;receive X
	PUSH	R17			;receive Y
	PUSH	R18			;value of the division
	PUSH	R19			;resto de the division
	PUSH	R20			;data to be saved
	PUSH	R21			;8
	PUSH	R22			;84
	PUSH	R23			;receive width
	PUSH	R24			;receive height
	PUSH	R25			;0
	PUSH	XL
	PUSH	XH
	PUSH	ZL
	PUSH	ZH			;receive the register to pass the draw

	LDI		R21, 8
	LDI		R22, 84
	LDI		R18, 0		;make the division
	MOV		R6, R18

SIGO:
	INC		R18
	MUL		R18, R21
	CP		R0, R17
	BRGE	TERMINE_LA_DIV
	JMP		SIGO

TERMINE_LA_DIV:
	MOV		R19, R18
	MUL		R19, R21
	SUB		R0, R17		;this return a negative number
	LDI		R19, 8		;load 8 for sub the rest of the div, this return the number to roll
	SUB		R19, R0		;save the number to roll in R19

	LDI		XL, LOW(RAM_DISPLAY)
	LDI		XH, HIGH(RAM_DISPLAY)

	DEC		R18			;to fix the mult
	MUL		R18, R22
	ADD		XL, R0
	ADD		XL, R16		;finish to point the table in RAM
	ADC		XH, R1
	MOV		R21, R23	;copy the width
	INC		R18

PASO_AL_OTRO_ANCHO:
	CLC					;clear carry
	LDI		R25, 0
	MOV		R2, R25		;memory to add what is missing
	MOV		R4, R19		;copy the rest in R4
	MOV		R5,	R24		;copy the height of the draw
PASO_AL_OTRO_Y:
	LPM		R20, Z		;to move in the table the quantity of bytes sent
	LDI		R25, 0
	MOV		R4, R19		;copy the rest in R4
ROLEO_OTRA_VEZ:
	ROL		R20
	ROL		R25			;to add the low part
	CLC
	DEC		R4
	BRNE	ROLEO_OTRA_VEZ
	ADD		R20, R2
	ST		X, R20		;after save increment X in 84
	ADD		XL, R22		;increment X in 84
	ADC		XH, R6
	ADD		ZL, R21		;to move down, add the width of the image/draw
	ADC		ZH, R6
	MOV		R2, R25		;memory to add what is missing
	DEC		R5
	BRNE	PASO_AL_OTRO_Y
	DEC		R18			;decrement to fix the count
	MUL		R22, R24	;return to the original position
	SUB		XL, R0
	SBC		XH, R1
	INC		XL			;add 1 to move one place in RAM
	BREQ	SUMO_1_XH
SIGO_DSP_XH:			;continue after increment XH
	INC		R18
	CLC
	MUL		R21, R24	;width of the picture by quantity of bytes
	SBC		ZL, R0		;return to start
	SBC		ZH, R1
	INC		ZL			;add 1 to move foward in the draw
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
;This routine prints strings of chars on the screen.
;The max number of chars in the string is 14
;that's the max char supported in the screen.
;*****************************************************************************************************************/

;*****************************************************************************************************************/
;This routine prints strings of chars on the screen.
;The length of the strings needs to be in R19, in R16 and R17 the
;POSITIONs of X and Y respectively where it will going to print and
;in Z need to be the direction of the first byte of the string.
;*****************************************************************************************************************/


RAM_PRINT_STRING:
	PUSH	R16	;value ofX
	PUSH	R17	;value ofY
	PUSH	R18	;value of the string
	PUSH	R19	;length of the string
	PUSH	R20 ;load 0 to add carry
	PUSH	R23	;receive width of the draw
	PUSH	R24	;receive height of the draw
	PUSH	ZL	;direction of the low part of the string
	PUSH	ZH	;direction of the high part of the string

	LDI		R20, 0

NEXT_STRING_CHAR2:
	LDI		R23, 6	;load tu add 6 chars in X
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
;Routine to write characters in RAM
;***************************************************/

RAM_PRINT_CHAR:
	PUSH	R16 	;POSITION en X
	PUSH	R17		;POSITION en Y
	PUSH	R18		;Character of the string
	PUSH	R23		;receive width of the draw
	PUSH	R24		;receive height of the draw
	PUSH	YL
	PUSH	YH
	PUSH	R30
	PUSH	R31

	LDI		R23, 6
	
	SUBI	R18,32		;Subs the offset to the character yo know the value in the table
	LDI		R30,12		;mult by 12 to obtain the value of the table, every character has 12 bytes
	;CLC
	MUL		R18, R30	;the result will be saved in R1-R0 (Less significant in R0)
	
	LDI		ZL,LOW(CHARS_TABLE<<1)
	LDI		ZH,HIGH(CHARS_TABLE<<1)	;Load Z with the direction of the table (mult by 2 to access it)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;add the offset for the desired character

	;LPM		R16,Z+		;read the value of the table and save it in R18

	MOV		YL, ZL
	MOV		YH, ZH			;copy the direction where z points

	CALL	LOAD_MATRIX_RAM	;send the data to the RAM

	MOV		ZL, YL
	MOV		ZH, YH			;retreive the previous values
	
		
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
;subroutine for the push buttons
;6 buttons
;0 - Up, 1 - left, 2 - right, 3 - Down, 4 - ok, 5 - pause
;return the value in R7
;*************************************************************************/

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
;subroutine for the push buttons
;6 buttons (7 is no button pushed)
;1 - Up, 2 - left, 3 - right, 4 - Down, 5 - ok, 6 - pause, 7 -ningun buttonpulsado
;return the value in R7
;******************************************************************************************/

PULSADORES_TODOS:

		PUSH	R18


		SBIC	PINC, 1					;arrow Up
		JMP		BOTON_FLECHA_ARRIBA
		SBIC	PINC, 2					;arrow izquierda
		JMP		BOTON_FLECHA_IZQ
		SBIC	PINC, 3					;arrow Rigth
		JMP		BOTON_FLECHA_DER
		SBIC	PINC, 4					;arrow Down
		JMP		BOTON_FLECHA_ABAJO
		SBIC	PINC, 5					;button ok or button A
		JMP		BOTON_ACEPTAR

		;button pause with interruption

		LDI		R18, 7
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES

BOTON_FLECHA_ARRIBA:
		LDI		R18, 1					;load the value assigned to the row( 1 = Up )
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES

BOTON_FLECHA_IZQ:
		LDI		R18, 2					;load the value assigned to the row( 2 = Left)
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES

BOTON_FLECHA_DER:
		LDI		R18, 3					;load the value assigned to the row( 3 = Rigth )
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES

BOTON_FLECHA_ABAJO:
		LDI		R18, 4					;load the value assigned to the row( 4 = Down )
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES


BOTON_ACEPTAR:
		LDI		R18, 5					;load the value assigned to the row( 5 = ok )
		MOV		R7, R18					;return 7 if there is no pushed buttons
		JMP		FIN_BOTONES

FIN_BOTONES:

		POP		R18

RET





;************************************************************************/
;Load the graphics in RAM for the game Simon Says
;************************************************************************/
		
LOAD_SIMON:

		PUSH	R16		;POSITION X
		PUSH	R17		;POSITION Y
		PUSH	R19		;length of character for strings
		PUSH	R23		;width in pixels for the image
		PUSH	R24		;height in bytes for the image
		PUSH	ZL		;direction to point to the FLASH
		PUSH	ZH
		

		CALL	CLEAR_RAM

		;SIMON_DICE
		LDI		R16, 0				;POSITION X
		LDI		R17, 1				;POSITION Y
		LDI		R23, 6				;width in pixels
		LDI		R24, 1				;height in bytes
		LDI		R19, 12				;length of the string
		LDI		ZL, LOW(SIMON<<1)
		LDI		ZH, HIGH(SIMON<<1)
		CALL	RAM_PRINT_STRING
		;numeros
		LDI		R16, 40				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R19, 4				;length of the string
		LDI		ZL, LOW(NUMEROS<<1)
		LDI		ZH, HIGH(NUMEROS<<1)
		CALL	RAM_PRINT_STRING
		;HIGH_SCORE
		LDI		R16, 40				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R19, 7				;length of the string
		LDI		ZL, LOW(HIGH_SC<<1)
		LDI		ZH, HIGH(HIGH_SC<<1)
		CALL	RAM_PRINT_STRING
		;
		;TU TURNO
		LDI		R16, 35				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R19, 8				;length of the string
		LDI		ZL, LOW(TU_TURNO<<1)
		LDI		ZH, HIGH(TU_TURNO<<1)
		CALL	RAM_PRINT_STRING
		*/
		;CORAZON1
		LDI		R16, 40				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;CORAZON2
		LDI		R16, 55				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;CORAZON3
		LDI		R16, 70				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_UP
		LDI		R16, 12				;POSITION X
		LDI		R17, 12				;POSITION Y
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes
		LDI		ZL, LOW(FLECHA_UP<<1)
		LDI		ZH, HIGH(FLECHA_UP<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_L
		LDI		R16, 0				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
		LDI		ZL, LOW(FLECHA_L<<1)
		LDI		ZH, HIGH(FLECHA_L<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_R
		LDI		R16, 22				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
		LDI		ZL, LOW(FLECHA_R<<1)
		LDI		ZH, HIGH(FLECHA_R<<1)
		CALL	LOAD_MATRIX_RAM
		;FLECHA_DWN
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in pixels
		LDI		R24, 3				;height in bytes (works well with one byte more)
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
;quantity of moves that Simon says
;convert the data to BCD to show well in screen
;the value most be in R25
;*******************************************************************************************/

CONT_SIMON:
		PUSH	R0
		PUSH	R1
		PUSH	R16
		PUSH	R17			
		PUSH	R18			;value of the rest of the division "numbers"
		PUSH	R20			;value of the decimal for the division
		PUSH	R22			;save 48 to add to the value and give me the character to show
		PUSH	R23
		PUSH	R24
		PUSH	R25			;value of data
			

		LDI		R16, 10
		LDI		R20, 0		;value of the decimal for the division



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
		MOV		R18, R25		;value of the sub




		;numbers unidad
		LDI		R16, 77				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
		CALL	RAM_PRINT_CHAR

		;numbers decena
		LDI		R16, 71				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 1				;height in bytes 2, when is not centred
		MOV		R18, R20			;R20 , get the random value
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
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
;show the pushed arrow in screnn and continue with the program
;*******************************************************************************************/

MUESTRO_FLECHA_PULSADA:
		

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R22			;value of the pushed button
		PUSH	R23			;width in pixels
		PUSH	R24			;height in bytes
		PUSH	ZL
		PUSH	ZH


		;MOV		R22, R7			;copy the value of the pushed button in R22

		CPI		R22, 1
		BREQ	CARGO_1			;load Up
		CPI		R22, 2
		BREQ	CARGO_2			;load izq
		CPI		R22, 3
		BREQ	CARGO_3			;load der
		JMP		CARGO_ABAJO		;branch can't reach, so use JMP

CARGO_1:
		JMP		CARGO_ARRIBA
CARGO_2:
		JMP		CARGO_IZQ
CARGO_3:
		JMP		CARGO_DER



CARGO_ABAJO:
		LDI		R22, 12				;see the arrow in gray
ABAJO_GRIS:
		;FLECHA_DWN_NEG
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in pixels
		LDI		R24, 3				;height in bytes works well with one mor byte
		LDI		ZL, LOW(FLECHA_DWN_NEG<<1)
		LDI		ZH, HIGH(FLECHA_DWN_NEG<<1)
		CALL	LOAD_MATRIX_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		
		;FLECHA_DWN
		LDI		R16, 12				;POSITION X
		LDI		R17, 32				;POSITION Y (32)
		LDI		R23, 9				;width in pixels
		LDI		R24, 3				;height in bytes works well with one mor byte
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
		LDI		R22, 12				;see the arrow in gray
ARRIBA_GRIS:
		;FLECHA_UP_NEG
		LDI		R16, 12				;POSITION X
		LDI		R17, 12				;POSITION Y
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes
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
		LDI		R23, 9				;width in pixels
		LDI		R24, 2				;height in bytes
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
		LDI		R22, 12				;see the arrow in gray
IZQ_GRIS:
		;FLECHA_L_NEG
		LDI		R16, 0				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
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
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
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
		LDI		R22, 12				;see the arrow in gray
DER_GRIS:
		;FLECHA_R
		LDI		R16, 22				;POSITION X
		LDI		R17, 23				;POSITION Y
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
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
		LDI		R23, 11				;width in pixels
		LDI		R24, 2				;height in bytes
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
;Show hearts in screen
;**************************************************************************************/

CORAZONES:

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R22			;quantity of hearts left
		PUSH	R23			;width in pixels
		PUSH	R24			;height in bytes
		PUSH	ZL
		PUSH	ZH


		CPI		R22, 3
		BREQ	CORAZON3_BLANCO
		CPI		R22, 2
		BREQ	CORAZON2_BLANCO

		;CORAZON1_BLANCO
		LDI		R16, 40				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	LOAD_MATRIX_RAM

		JMP		TERMINO_CORAZONES

CORAZON2_BLANCO:
		;CORAZON2
		LDI		R16, 55				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	LOAD_MATRIX_RAM

		JMP		TERMINO_CORAZONES

CORAZON3_BLANCO:
		;CORAZON3
		LDI		R16, 70				;POSITION X
		LDI		R17, 37				;POSITION Y
		LDI		R23, 10				;width in pixels
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
;Write High Score from the EEPROM
;**************************************************************************************/

ESCRIBO_HIGH_SCORE:

		PUSH	R22			;value of data to write in the EEPROM
		PUSH	ZL
		PUSH	ZH


		LDI		ZL, LOW(HIGH_SCORE)
		LDI		ZH, HIGH(HIGH_SCORE)

		CLI						;quit the interruptions

EEPROM_WRITE:
 
		SBIC	EECR,EEPE 
		RJMP	EEPROM_WRITE		;wait until i can write
 
		OUT		EEARH, ZH			;save the direction where is the byte to write
		OUT		EEARL, ZL
 
		OUT		EEDR, R22			;write the value of R22 in the direction pointed by Zl and Zh
 
		SBI		EECR,EEMPE			;Write logical one to EEMPE
 
		SBI		EECR,EEPE			;write in the EEPROM seting EEPE
 

		SEI							;Resume interruptions

		POP		ZH
		POP		ZL
		POP		R22

RET



;**************************************************************************************/
;Read the High Score from the EEPROM and show it in the screen
;Return the value in R9 to compare it
;**************************************************************************************/

LEO_HIGH_SCORE:

		PUSH	R16			;POSITION X
		PUSH	R17			;POSITION Y
		PUSH	R20			;value readed form EEPROM
		PUSH	R22			;48 to add and show the character in screen
		PUSH	R23			;width in pixels
		PUSH	R24			;height in bytes
		PUSH	R25
		PUSH	ZL
		PUSH	ZH


		LDI		ZL, LOW(HIGH_SCORE)
		LDI		ZH, HIGH(HIGH_SCORE)

		CLI						;quit the interruptions
EEPROM_READ:
 
		SBIC	EECR, EEPE		;wait until i can write
		RJMP	EEPROM_read

		OUT		EEARH, ZH
		OUT		EEARL, ZL
		
		SBI		EECR, EERE		;start reading the EEPROM

		IN		R20, EEDR		;save the data in R20

		MOV		R9, R20			;Copy the readed value in R9

		SEI						;Resume interruptions

			
		LDI		R16, 10
		LDI		R25, 0		;value of the decimal for the division

		CPI		R20, 0xFF
		BRNE	SIGO_3		;continue if it not 0

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
		MOV		R18, R20		;value of the sub



ESCRIBO_NUMEROS:
		;numbersunidad
		LDI		R16, 76				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 2				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
		CALL	RAM_PRINT_CHAR

		;numbersdecena
		LDI		R16, 70				;POSITION X
		LDI		R17, 13				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 2				;height in bytes 2, when is not centred
		MOV		R18, R25			;R20 , get the random value
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
		CALL	RAM_PRINT_CHAR

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY		;show it on the screen


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
;quantity of data pushed by the user
;convert the data to BCD to show it well on screen
;the value most be in R25
;*******************************************************************************************/

CONT_USER:
		PUSH	R0
		PUSH	R1
		PUSH	R16
		PUSH	R17			
		PUSH	R18			;value of the rest of the division "numbers"
		PUSH	R20			;value of the decimal for the division
		PUSH	R22			;save 48 to add to the value and give me the character to show
		PUSH	R23
		PUSH	R24
		PUSH	R25			;value of data
			

		LDI		R16, 10
		LDI		R20, 0		;value of the decimal for the division



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
		MOV		R18, R25		;value of the sub




		;numbersunidad
		LDI		R16, 46				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 1				;height in bytes 2, when is not centred
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
		CALL	RAM_PRINT_CHAR

		;numbersdecena
		LDI		R16, 40				;POSITION X
		LDI		R17, 25				;POSITION Y
		LDI		R23, 6				;width in pixels of the character
		LDI		R24, 1				;height in bytes 2, when is not centred
		MOV		R18, R20			;R20 , get the random value
		LDI		R22, 48
		ADD		R18, R22			;add 48 to show the number
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
		
