.INCLUDE "LCD_5110_controller.h"
.INCLUDE "snake.h"

;**************************************************************************/
;**************************************************************************/
;memoria EEPROM 
;**************************************************************************/
;**************************************************************************/
.ESEG

	HIGH_SCORE:		.byte	1		;memoria para guardar el highscore
;**************************************************************************/
;**************************************************************************/
;memoria RAM
;**************************************************************************/
;**************************************************************************/
	.dseg

	RAM_DISPLAY:	.byte	588		;por si me paso con los graficos
	SECUENCIA:		.byte	100		;secuencia para el simon dice

;***************************************************************************/
;***************************************************************************/
;memoria flash
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

;;*******************************************************************
;Esta funcion atiende las interrupciones producto de PCINT0
;*********************************************************************/

PCINT0_HANDLER:
	
	SBIC	PINB,B_BUTTON
	CALL	PAUSE_SNAKE
RETI

;;*******************************************************************
;Esta funcion atiende las interrupciones producto de PCINT1
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

;;*******************************************************************
;Esta funcion atiende las interrupciones producto de PCINT2
;*********************************************************************/

PCINT2_HANDLER:
	;Estas interrupciones no estan siendo utilizadas
RETI

;;*******************************************************************
;Esta funcion atiende las interrupciones producto del overflow del TIMER0
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
;fin interrupciones


;************************************************************/
;TEXTOS PARA MOSTRAR EN DISPLAY
;************************************************************/

score:		.db		"Score: 000"	;texto para mostrar el score en el snake
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
;GRAFICOS PARA MOSTRAR EN DISPLAY
;***********************************************************/

;FLECHA ARRIBA SIN RELLENO

FLECHA_UP:	.db		0x30, 0x28, 0xE4, 0x02, 0x01, 0x02, 0xE4, \
					0x28, 0x30, 0x00, 0x00, 0x07, 0x04, 0x04, \
					0x04, 0x07, 0x00, 0x00

;FLECHA ABAJO SIN RELLENO

FLECHA_DWN:	.db		0x60, 0xA0, 0x3F, 0x01, 0x01, 0x01, 0x3F, \
					0xA0, 0x60, 0x00, 0x00, 0x01, 0x02, 0x04, \
					0x02, 0x01, 0x00, 0x00


;FLECHA RIGTH SIN RELLENO

FLECHA_R:	.db		0x7C, 0x44, 0x44, 0x44, 0x44, 0xC7, 0x01, \
					0x82, 0x44, 0x28, 0x10, 0x00, 0x00, 0x00, \
					0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, \
					0x00  

;FLECHA LEFT SIN RELLENO


FLECHA_L:	.db		0x10, 0x28, 0x44, 0x82, 0x01, 0xC7, 0x44, \
					0x44, 0x44, 0x44, 0x7C, 0x00, 0x00, 0x00, \
					0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, \
					0x00  
					

;FLECHA ARRIBA CON RELLENO

					
FLECHA_UP_NEG:	.db	0x30, 0x38, 0xFC, 0xFE, 0xFF, 0xFE, 0xFC, \
					0x38, 0x30, 0x00, 0x00, 0x07, 0x07, 0x07, \
					0x07, 0x07, 0x00, 0x00

;FLECHA LEFT CON RELLENO

FLECHA_L_NEG:	.db	0x10, 0x38, 0x7C, 0xFE, 0xFF, 0xFF, 0x7C, \
					0x7C, 0x7C, 0x7C, 0x7C, 0x00, 0x00, 0x00, \
					0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, \
					0x00
					
;FLECHA RIGTH CON RELLENO					

FLECHA_R_NEG:	.db	0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0xFF, 0xFF, \
					0xFE, 0x7C, 0x38, 0x10, 0x00, 0x00, 0x00, \
					0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, \
					0x00

;FLECHA ABAJO CON RELLENO

					
FLECHA_DWN_NEG:	.db	0x60, 0xE0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, \
					0xE0, 0x60, 0x00, 0x00, 0x01, 0x03, 0x07, \
					0x03, 0x01, 0x00, 0x00

;LINEA:		.db		0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF

;LINEA2:		.db		0xFF, 0x00



;CIRCULO VACIO 10 (pixels) * 2 (bytes)

CIRCULO:	.db		0xF8, 0x04,	0x02, 0x01, 0x01, 0x01, 0x01, 0x02, \
					0x04, 0xF8, 0x00, 0x01, 0x02, 0x04, 0x04, 0x04, \
					0x04, 0x02, 0x01, 0x00

;CIRCULO LLENO 10*2

CIRCULO_NEG:	.db	0xF8, 0xFC, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, \
					0xFC, 0XF8, 0x00, 0x01, 0x03, 0x07, 0x07, 0x07, \
					0x07, 0x03, 0x01, 0x00


;CORAZON LLENO 10*2

CORAZON_NEG:	.db	0x1C, 0x3E, 0x7F, 0xFE, 0xFC, 0xFC, 0xFE, 0x7B, \
					0x3E, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, \
					0x00, 0x00, 0x00, 0x00


;CORAZON VACIO 10*2

CORAZON:	.db		0x1C, 0x22, 0x41, 0x82, 0x04, 0x04, 0x82, 0x41, \
					0x22, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, \
					0x00, 0x00, 0x00, 0x00



;************************************************************************************/
;letras especiales para el inicio del simon dice
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
;letras para el SNAKE en pantalla de inicio
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
;LETRAS PARA ZORZABOY 64 *2
;***********************************************************************************/
										
ZORZABOY_NEG:	.db		0xE3, 0xF3, 0xFB, 0xFF, 0xFF, 0xDF, 0xCF, 0xC7, \
						0X7E, 0xFF, 0xFF, 0xC3, 0xC3, 0xFF, 0xFF, 0x7C, \
						0xFF, 0xFF, 0xFF, 0x33, 0x73, 0xFF, 0xDE, 0x9E, \
						0xE3, 0xF3, 0xFB, 0xFF, 0xFF, 0xDF, 0xCF, 0xC7, \
						0xFE, 0xFF, 0x33, 0xFF, 0xFF, 0xFF, 0xFE, 0xFC, \
						0xFF, 0xFF, 0xFF, 0xDB, 0xDB, 0xFF, 0x76, 0x74, \
						0X7E, 0xFF, 0xFF, 0xC3, 0xC3, 0xFF, 0xFF, 0x7C, \
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
;TABLA DE CARACTERES, modificada para q ande con mi programa para escribir en RAM						
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
;PROGRAMA PRINCIPAL
;**********************************************************************************************************************/
;**********************************************************************************************************************/

MAIN:
		LDI		R16, LOW(RAMEND)
		OUT		SPL, R16
		LDI		R16, HIGH(RAMEND)
		OUT		SPH, R16				;Se inicializa el SP

		LDI		R16, PINES_BOTONES		;Se declaran como entrada los pines del 0 al 5 del PORTC
		OUT		DDRC, R16
		IN		R16, DDRB
		LDI		R17, 0xFE
		AND		R16, R17
		OUT		DDRB,R16		;Se declara como entrada PINB0, ya que el boton B se encuentra conectado a ese pin

		CLI								;MATO LAS INTERRUPCIONES

		CALL	LCD_INIT
		CALL	CLEAR_SCREEN
		CALL	CLEAR_RAM


;aca MUESTRO zorzaboy 2 segundos	
		
		LDI		R18, 80				;2 SEGS APROX
CARGO_LOGO:
		LDI		R16, 10				;POSICION DE X
		LDI		R17, 17				;POSICION DE Y
		LDI		R23, 64				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(ZORZABOY_NEG<<1)
		LDI		ZH, HIGH(ZORZABOY_NEG<<1)
		CALL	CARGO_MATRIZ_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		LDI		R16, 10				;POSICION DE X
		LDI		R17, 17				;POSICION DE Y
		LDI		R23, 64				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(ZORZABOY<<1)
		LDI		ZH, HIGH(ZORZABOY<<1)
		CALL	CARGO_MATRIZ_RAM

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
		

;a partir de aca tengo que hacer el menu para mostrar los 2 juegos

		CALL	CLEAR_SCREEN

		LDI		R19, 12
		LDI		ZL,LOW(JUEGOS<<1)
		LDI		ZH,HIGH(JUEGOS<<1)
		LDI		R16, 0					;valor de x
		LDI		R17, 0					;valor de Y
		CALL	LCD_PRINT_STRING		;imprimo "JUEGOS" en la pantalla, en (0,0)


		LDI		R19, 12
		LDI		ZL,LOW(GAME_SNAKE<<1)
		LDI		ZH,HIGH(GAME_SNAKE<<1)
		LDI		R16, 0					;valor de x
		LDI		R17, 2					;valor de Y
		CALL	LCD_PRINT_STRING		;imprimo "SNAKE" en la pantalla, en (2,0)


		LDI		R19, 12
		LDI		ZL,LOW(GAME_SIMON<<1)
		LDI		ZH,HIGH(GAME_SIMON<<1)
		LDI		R16, 0					;valor de x
		LDI		R17, 3					;valor de Y
		CALL	LCD_PRINT_STRING		;imprimo "SIMON" en la pantalla, en (3,0)

ESPERO_ELECCION:
		SBIC	PINC, 5					;BOTON A
		JMP		SNAKE
		SBIC	PINB, 0					;BOTON B
		JMP		SIMON_GAME
		JMP		ESPERO_ELECCION


;**********************************************************************************************************************/
;**********************************************************************************************************************/ 
;PROGRAMA PARA SIMON DICE
;**********************************************************************************************************************/
;**********************************************************************************************************************/

SIMON_GAME:	
		CALL	CLEAR_SCREEN
		CALL	CLEAR_RAM

		CLI								;MATO LAS INTERRUPCIONES
		
		LDI		R19, 12
		LDI		ZL,LOW(LOADING<<1)
		LDI		ZH,HIGH(LOADING<<1)
		LDI		R16, 0					;valor de x
		LDI		R17, 3					;valor de Y
		CALL	LCD_PRINT_STRING		;imprimo "LOADING..." en la pantalla, en (3,0)
		CALL	DELAY_1S

OTRA_PARTIDA:
		CALL	CLEAR_SCREEN

;******************************************************************************************/
;CARGO PANTALLA DE INICIO
;******************************************************************************************/

		;cargo la pantalla de inicio
		; letra especial para simon dice
		

		
RENUEVO:
		CALL	CLEAR_RAM
		;S
		LDI		R16, 17				;POSICION DE X
		LDI		R17, 5				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(S_INIT<<1)
		LDI		ZH, HIGH(S_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;I
		LDI		R16, 27				;POSICION DE X
		LDI		R17, 4				;POSICION DE Y
		LDI		R23, 5				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;M
		LDI		R16, 34				;POSICION DE X
		LDI		R17, 7				;POSICION DE Y
		LDI		R23, 13				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(M_INIT<<1)
		LDI		ZH, HIGH(M_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;O
		LDI		R16, 48				;POSICION DE X
		LDI		R17, 7				;POSICION DE Y
		LDI		R23, 8				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(O_INIT<<1)
		LDI		ZH, HIGH(O_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;n
		LDI		R16, 55				;POSICION DE X
		LDI		R17, 7				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(N_INIT<<1)
		LDI		ZH, HIGH(N_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;D
		LDI		R16, 26				;POSICION DE X
		LDI		R17, 18				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(D_INIT<<1)
		LDI		ZH, HIGH(D_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;I
		LDI		R16, 36				;POSICION DE X
		LDI		R17, 18				;POSICION DE Y
		LDI		R23, 5				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(I_INIT<<1)
		LDI		ZH, HIGH(I_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;C
		LDI		R16, 42				;POSICION DE X
		LDI		R17, 21				;POSICION DE Y
		LDI		R23, 8				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(C_INIT<<1)
		LDI		ZH, HIGH(C_INIT<<1)
		CALL	CARGO_MATRIZ_RAM
		;E
		LDI		R16, 51				;POSICION DE X
		LDI		R17, 21				;POSICION DE Y
		LDI		R23, 7				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(E_INIT<<1)
		LDI		ZH, HIGH(E_INIT<<1)
		CALL	CARGO_MATRIZ_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;busco por tecla pulsada cada 200ms?
		;hago delay de 1 seg con eso


		LDI		R20, 5
VUELVO_A_VER_BOTONES:
		SBIC	PINC, 5						;me fijo si esta pulsado el boton A
		JMP		EMPIEZO_JUEGO				;si hay uno pulsado salgo
		CALL	DELAY_200MS
		DEC		R20
		BRNE	VUELVO_A_VER_BOTONES



		;press A
		LDI		R16, 20				;POSICION DE X
		LDI		R17, 36				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		R19, 7				;ancho del string
		LDI		ZL, LOW(PRESS<<1)
		LDI		ZH, HIGH(PRESS<<1)
		CALL	RAM_PRINT_STRING

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;busco por tecla pulsada cada 200ms
		;hago delay de 1 seg con eso


		LDI		R20, 5
VUELVO_A_VER_BOTONES2:
		SBIC	PINC, 5				;me fijo si esta pulsado el boton A
		JMP		EMPIEZO_JUEGO				;si hay uno pulsado salgo
		CALL	DELAY_200MS
		DEC		R20
		BRNE	VUELVO_A_VER_BOTONES2



		CALL	CLEAR_RAM
		JMP		RENUEVO

		

;***************************************************************************************/
;EMPIEZA EL JUEGO
;***************************************************************************************/
ESCRIBO_0_EN_HI:				
		LDI		R22, 0			;SI EMPIEZO Y EL HIGH SCORE ES FF EN LA EEPROM
		CALL	ESCRIBO_HIGH_SCORE
		CALL	LEO_HIGH_SCORE
		JMP		CARGUE_SCORE

EMPIEZO_JUEGO:
		CALL	CLEAR_RAM
		LDI		R20, 0			;CONTADOR DE NUMEROS QUE DIJO SIMON
		LDI		R21, 4			;CONTADOR DE VIDAS son 3 porque en 0 es game over

		CALL	LOAD_SIMON		;cargo el juego en la RAM y lo muestro
		CALL	LEO_HIGH_SCORE
		LDI		R22, 0xFF
		CP		R22, R9
		BREQ	ESCRIBO_0_EN_HI

CARGUE_SCORE:
		LDI		XL, LOW(SECUENCIA)
		LDI		XH, HIGH(SECUENCIA)		;PARA GUARDAR LA SECUENCIA DE SIMON




CARGO_JUEGO:

		LDI		YL, LOW(SECUENCIA)
		LDI		YH, HIGH(SECUENCIA)		;PARA MOSTRAR LA SECUENCIA

		CALL	RANDOM
		LDI		R16, 0			;cargo 0 para sumar carry
		CLC
		ST		X+, R5			;GUARDO Q SALIO e incremento X para guardar el proximo dato
		ADC		XH, R16
		;MOV		R22, R5			;COPIO EL DATO PARA COMPARALO
		INC		R20				;cuento los datos que salieron
		LDI		R25, 0			;valor de la cantidad que salio para mostrar toda la secuencia

		;SIMON_DICE
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 1				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES
		LDI		R24, 1				;ALTO EN BYTES
		LDI		R19, 12				;ancho del string
		LDI		ZL, LOW(SIMON<<1)
		LDI		ZH, HIGH(SIMON<<1)
		CALL	RAM_PRINT_STRING

MUESTRO_SIG_SECUENCIA:

		INC		R25

		CALL	CONT_SIMON			;llamo al contador de simon dice para mostrar la cantidad de la secuencia
		
		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		LDI		R16, 0				;guardo 0 para sumar el carry
		CLC
		LD		R22, Y+				;guardo el valor de la secuencia en R22 e incremento Y para el proximo valor
		ADC		YH, R16
		CALL	MUESTRO_FLECHA_PULSADA		;la flecha q se muestra debe ir en R22
		CALL	DELAY_200MS
		CALL	DELAY_200MS			;demora para que se vea que es otra flecha
		CP		R25, R20			;comparo para ver si llegue al maximo valor de la secuencia
		BRNE	MUESTRO_SIG_SECUENCIA



TE_TOCA:
		;TU TURNO
		LDI		R16, 0				;POSICION DE X (ANTES 35)
		LDI		R17, 1				;POSICION DE Y (ANTES 25)
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R19, 14				;ancho del string
		LDI		ZL, LOW(TU_TURNO<<1)
		LDI		ZH, HIGH(TU_TURNO<<1)
		CALL	RAM_PRINT_STRING

		LDI		ZL, LOW(RAM_DISPLAY)
		LDI		ZH, HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

	


OTRA_OPORTUNIDAD:
		LDI		YL, LOW(SECUENCIA)
		LDI		YH, HIGH(SECUENCIA)

		LDI		R25, 0				;CONTADOR PARA PULSADOR DEL USUARIO
		CALL	CONT_USER				;MUESTRO 0 PARA EL CONTADOR DEL USUARIO
		
		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

SIGO_SECUENCIA:
		LDI		R16, 0				;guardo 0 para sumar el carry
		CLC
		LD		R17, Y+
		ADC		YH, R16

NO_SE_PULSO_NINGUNA:
		CALL	PULSADORES_TODOS			;RUTINA PARA VER QUE BOTON SE APRETA

		MOV		R22, R7						;guardo en R22 el valor de la tecla pulsada para mostrarla en la subrutiina
		CPI		R22, 5
		BRGE	NO_SE_PULSO_NINGUNA

		INC		R25
		CALL	CONT_USER
		CALL	MUESTRO_FLECHA_PULSADA

		CP		R17, R7						;R7 TIENE EL VALOR DEL BOTON PULSADO
		BRNE	RESTO_VIDA

		CP		R25, R20
		BRNE	SIGO_SECUENCIA

		CALL	DELAY_200MS
		CALL	DELAY_200MS
		JMP		CARGO_JUEGO

RESTO_VIDA:
		DEC		R21
		MOV		R22, R21			;GUARDO R21 EN R22 PARA LA FUNCION CORAZONES
		BREQ	GAME_OVER
		CALL	CORAZONES			;RUTINA PARA MOSTRAR UN CORAZON  MENOS
		JMP		OTRA_OPORTUNIDAD
	

GAME_OVER:
		CALL	CLEAR_RAM
		CALL	LEO_HIGH_SCORE
		CP		R20, R9
		BRGE	ESCRIBO_NUEVO_HI
		CALL	CLEAR_RAM
SIGO_GAME_OVER:
		;GAME OVER
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 22				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		R19, 12				;ancho del string
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
;PROGRAMA PARA EL SNAKE
;**********************************************************************************************************************/
;**********************************************************************************************************************/		
	
SNAKE:
		
		
	;CALL	LCD_INIT
	CALL	CLEAR_SCREEN
	CALL	INIT_TIMERS
	CALL	INIT_BUTTONS_INTERRUPT
	
RESTART_GAME:
	CLI	;Se deshabilitan las interrupciones
	
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
	BRNE	NEXT_R18	;Se imprime el logo del juego
	
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
	
	CALL	CLEAR_SCREEN		;Se limpia la pantalla
	
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
	CALL	SET_PIXEL_IN_RAM_DISPLAY	;Se inicializa la viborita en la pantalla
	
	LDI	R16,43	;Se inicializan las condiciones iniciales del snake
	MOV	R0,R16	;En R0 se va a guardar la posicion en X de la cabeza
	LDI	R16,24
	MOV	R1,R16	;En R1 se va a guardar la posicion en Y de la cabeza
	LDI	R16,43
	MOV	R2,R16	;En R2 se va a guardar la posicion en X de la cola
	LDI	R16,28
	MOV	R3,R16	;En R3 se va a guardar la posicion en Y de la cola
	LDI	R16,UP_DIRECTION
	MOV	R4,R16	;En R4 se guarda la direccion (velocidad) de la cabeza:	0: Arriba
			;							1: Izquierda 
			;							2: Abajo
			;							3: Derecha
	
	CALL	SET_FRUIT	;Se dibuja la fruta en la pantalla
	
	SEI	;Se habilitan las interrupciones
	
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
	BREQ	SNAKE_GAME_OVER		;Se verifica que no se esté en los bordes de la pantalla
	
	CALL	MOVE_SNAKE_ONE_POSITION
	CALL	DELAY_SNAKE
	
	JMP	KEEP_PLAYING

;;************************************************************
;Subrutina que se ejecuta cuando se pierde en el juego
;*/	

SNAKE_GAME_OVER:

	CLI			;Se deshabilitan las interrupciones
	
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
	
	CALL	DELAY_1S	;Se muestra el mensaje por unos segundos
	CALL	CLEAR_SCREEN

JMP	RESTART_GAME

;;************************************************************
;Funcion que muestra el menu de pausa del snake
;*/

PAUSE_SNAKE:
	
	PUSH	R16
	PUSH	R17
	PUSH	R19
	PUSH	ZL
	PUSH	ZH
	
	CLI			;Se deshabilitan las interrupciones
	
	CALL	CLEAR_SCREEN	;Se limpia la pantalla
	
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
	CALL	LCD_PRINT_STRING	;Se imprimen los mensajes

	CALL	DELAY_1S

WAIT_BUTTON_PAUSE_SNAKE:	
	SBIC	PIN_SNAKE,A_BUTTON
	JMP	RETURN_FROM_PAUSE_SNAKE	;Si se presiona A se retorna al juego
	
	SBIC	PINB,B_BUTTON
	JMP	0x00			;Si se presiona B se salta al menu principal
	
	JMP	WAIT_BUTTON_PAUSE_SNAKE	;Se espera a que se presione alguno de los botones

RETURN_FROM_PAUSE_SNAKE:
	
	POP	ZH
	POP	ZL
	POP	R19
	POP	R17
	POP	R16
	
	SEI		;Se vuelven a habilitar las interrupciones
RET

;;***********************************************************
;Esta funcion inicializa el timer para utilizarlo como interrupcion
;para refrescar la pantalla.
;*/

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
	LDI	R16,TIMSK0_CONFIG	;Esta direccion no permite usar OUT porque esta fuera de rango
	ST	X,R16			;Se configuran las interrupciones del TIMER0
	
	POP	XH
	POP	XL
	POP	R17
	POP	R16
RET

;;************************************************************
;Esta funcion inicializa las interrupciones de PCINT para el
;manejo de los botones.
;*/

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

;;************************************************************
;Funcion que modifica la direccion (velocidad) del snake hacia arriba
;*/

UP_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Se lee la direccion actual de la cabeza (velocidad)
	LDI	R17,DOWN_DIRECTION	
	
	CP	R16,R17		;Se compara la direccion actual con su direccion opuesta
	BREQ	CANT_GO_UP	;Si se dirigia hacia abajo, la cabeza no puede ir hacia arriba
	
	LDI	R16,UP_DIRECTION
	MOV	R4,R16
	
CANT_GO_UP:
	POP	R17
	POP	R16
RET

;;************************************************************
;Funcion que modifica la direccion (velocidad) del snake hacia
;la izquierda.
;*/

LEFT_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Se lee la direccion actual de la cabeza (velocidad)
	LDI	R17,RIGHT_DIRECTION	
	
	CP	R16,R17		;Se compara la direccion actual con su direccion opuesta
	BREQ	CANT_GO_LEFT	;Si se dirigia hacia la derecha, la cabeza no puede ir hacia la izquierda
	
	LDI	R16,LEFT_DIRECTION
	MOV	R4,R16
	
CANT_GO_LEFT:
	POP	R17
	POP	R16
RET

;;************************************************************
;Funcion que modifica la direccion (velocidad) del snake hacia abajo.
;*/

DOWN_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Se lee la direccion actual de la cabeza (velocidad)
	LDI	R17,UP_DIRECTION	
	
	CP	R16,R17		;Se compara la direccion actual con su direccion opuesta
	BREQ	CANT_GO_DOWN	;Si se dirigia hacia arriba, la cabeza no puede ir hacia abajo
	
	LDI	R16,DOWN_DIRECTION
	MOV	R4,R16
	
CANT_GO_DOWN:
	POP	R17
	POP	R16
RET

;;************************************************************
;Funcion que modifica la direccion (velocidad) del snake hacia la
;derecha.
;*/

RIGHT_BUTTON_PRESSED:
	PUSH	R16
	PUSH	R17
	
	MOV	R16,R4		;Se lee la direccion actual de la cabeza (velocidad)
	LDI	R17,LEFT_DIRECTION
	
	CP	R16,R17		;Se compara la direccion actual con su direccion opuesta
	BREQ	CANT_GO_RIGHT	;Si se dirigia hacia la izquierda, la cabeza no puede ir hacia la derecha
	
	LDI	R16,RIGHT_DIRECTION
	MOV	R4,R16
	
CANT_GO_RIGHT:
	POP	R17
	POP	R16	
RET

;;***********************************************************
;Esta funcion dibuja el marco del juego en la RAM.
;*/

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
;;***********************************************************
;Esta funcion setea un pixel dentro de la matriz de la RAM donde 
;se encuentran los datos que se enviarán al display.
;*/

SET_PIXEL_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	PUSH 	R16	;Valor de X en la matriz (0-83)
	PUSH 	R17	;Valor de Y en la matriz (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direccion del primer valor de la RAM
	PUSH	ZH	;Direccion del primer valor de la RAM
	
	LDI	R18,8	;Por cada valor de Y en el display, son 8 valores de Y en la RAM
	LDI	R19,1	;Inicializo un contador donde se guardará el valor de Y del display

TRY_NEXT_Y_VALUE_SET:	
	MUL	R18,R19	;Multiplico el valor de Y del display por la cantidad de pixeles que ocupa
	CP	R17,R0	;Comparo el resultado de la multiplicacion con el valor de Y recibido (El resultado nunca va a superar los 256)
	BRLO	Y_VALUE_FOUND_SET
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_SET

Y_VALUE_FOUND_SET:
	DEC	R19
	;Al salir de este bucle ya tengo el valor de Y del display en R19. Falta tener el valor del pixel dentro del byte.
	
	MUL	R18,R19	;De esta forma conozco el valor de Y en pixeles mas cercano al recibido
	MOV	R1,R17	;Como en R1 se van a guardar ceros, lo utilizo como registro auxiliar
	
	LDI	R20,1	;Inicializo R20, que luego va a ser usado como mascara para setear el pixel indicado
	SUB	R1,R0	;Obtengo la diferencia en pixeles para conocer la posicion del pixel dentro del byte
	
	BREQ	MASK_FOUND_SET	;Si la resta es cero, significa que el byte deseado es el cero

COMPARE_NEXT_BYTES_SET:	
	LSL	R20	;Hay que correr la mascara un lugar
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_SET

MASK_FOUND_SET:			;Al salir del bucle ya tengo la mascara que se le debe aplicar al byte de la RAM
				;Los datos que tengo hasta ahora son:	En R16 tengo el valor de X en la matriz (es igual al de la RAM)
				;					En R17 tengo el valor de Y de la matriz
				;					En R19 tengo el valor de Y en el display
				;					En R20 tengo la mascara
				;					En ZL y ZH la direccion del comiendo de la RAM

	LDI	R18,84	;Cargo la cantidad de pizeles que hay en una fila
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;Me muevo Y(display)*84 valores en la memoria RAM
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Me muevo X valores en la memoria RAM

	;Al llegar acá, ya tengo ubicado el byte que se debe modificar aplicando la mascara
	LD	R18,Z	;Se lee el valor apuntado
	OR	R18,R20	;Se setea el bit deseado
	ST	Z,R18	;Se vuelve a cargar el valor
	
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

;;***********************************************************
;Esta funcion apaga un pixel dentro de la matriz de la RAM donde 
;se encuentran los datos que se enviarán al display.
;*/

CLEAR_PIXEL_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	PUSH 	R16	;Valor de X en la matriz (0-83)
	PUSH 	R17	;Valor de Y en la matriz (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direccion del primer valor de la RAM
	PUSH	ZH	;Direccion del primer valor de la RAM
	
	LDI	R18,8	;Por cada valor de Y en el display, son 8 valores de Y en la RAM
	LDI	R19,1	;Inicializo un contador donde se guardará el valor de Y del display

TRY_NEXT_Y_VALUE_CLEAR:	
	MUL	R18,R19	;Multiplico el valor de Y del display por la cantidad de pixeles que ocupa
	CP	R17,R0	;Comparo el resultado de la multiplicacion con el valor de Y recibido (El resultado nunca va a superar los 256)
	BRLO	Y_VALUE_FOUND_CLEAR
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_CLEAR

Y_VALUE_FOUND_CLEAR:
	DEC	R19
	;Al salir de este bucle ya tengo el valor de Y del display en R19. Falta tener el valor del pixel dentro del byte.
	
	MUL	R18,R19	;De esta forma conozco el valor de Y en pixeles mas cercano al recibido
	MOV	R1,R17	;Como en R1 se van a guardar ceros, lo utilizo como registro auxiliar
	
	LDI	R20,1	;Inicializo R20, que luego va a ser usado como mascara para setear el pixel indicado
	SUB	R1,R0	;Obtengo la diferencia en pixeles para conocer la posicion del pixel dentro del byte
	
	BREQ	MASK_FOUND_CLEAR	;Si la resta es cero, significa que el byte deseado es el cero

COMPARE_NEXT_BYTES_CLEAR:	
	LSL	R20	;Hay que correr la mascara un lugar
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_CLEAR

MASK_FOUND_CLEAR:		;Al salir del bucle ya tengo la mascara que se le debe aplicar al byte de la RAM
				;Los datos que tengo hasta ahora son:	En R16 tengo el valor de X en la matriz (es igual al de la RAM)
				;					En R17 tengo el valor de Y de la matriz
				;					En R19 tengo el valor de Y en el display
				;					En R20 tengo la mascara
				;					En ZL y ZH la direccion del comiendo de la RAM

	LDI	R18,84	;Cargo la cantidad de pizeles que hay en una fila
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;Me muevo Y(display)*84 valores en la memoria RAM
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Me muevo X valores en la memoria RAM

	;Al llegar acá, ya tengo ubicado el byte que se debe modificar aplicando la mascara
	LD	R18,Z	;Se lee el valor apuntado
	COM	R20
	AND	R18,R20	;Se setea el bit deseado
	ST	Z,R18	;Se vuelve a cargar el valor
	
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

;;***********************************************************
;Esta funcion verifica si el pixel deseado se encuentra encendido
;o no. Para esto utiliza el registro R21, el cual vale cero si el
;pixel esta apagado y distinto de cero si esta prendido.
;*/

CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY:
	PUSH	R0
	PUSH	R1
	;PUSH	R21	;Valor de retorno (no se guarda en el stack para poder modificarlo)
	PUSH 	R16	;Valor de X en la matriz (0-83)
	PUSH 	R17	;Valor de Y en la matriz (0-47)
	PUSH	R18
	PUSH	R19
	PUSH	R20	
	PUSH	ZL	;Direccion del primer valor de la RAM
	PUSH	ZH	;Direccion del primer valor de la RAM
	
	LDI	R18,8	;Por cada valor de Y en el display, son 8 valores de Y en la RAM
	LDI	R19,1	;Inicializo un contador donde se guardará el valor de Y del display

TRY_NEXT_Y_VALUE_CHECK_PIXEL:	
	MUL	R18,R19	;Multiplico el valor de Y del display por la cantidad de pixeles que ocupa
	CP	R17,R0	;Comparo el resultado de la multiplicacion con el valor de Y recibido (El resultado nunca va a superar los 256)
	BRLO	Y_VALUE_FOUND_CHECK_PIXEL
	INC	R19
	JMP	TRY_NEXT_Y_VALUE_CHECK_PIXEL

Y_VALUE_FOUND_CHECK_PIXEL:
	DEC	R19
	;Al salir de este bucle ya tengo el valor de Y del display en R19. Falta tener el valor del pixel dentro del byte.

	
	MUL	R18,R19	;De esta forma conozco el valor de Y en pixeles mas cercano al recibido
	MOV	R1,R17	;Como en R1 se van a guardar ceros, lo utilizo como registro auxiliar
	
	LDI	R20,1	;Inicializo R20, que luego va a ser usado como mascara para setear el pixel indicado
	SUB	R1,R0	;Obtengo la diferencia en pixeles para conocer la posicion del pixel dentro del byte
	
	BREQ	MASK_FOUND_CHECK_PIXEL	;Si la resta es cero, significa que el byte deseado es el cero

COMPARE_NEXT_BYTES_CHECK_PIXEL:	
	LSL	R20	;Hay que correr la mascara un lugar
	DEC	R1
	BRNE	COMPARE_NEXT_BYTES_CHECK_PIXEL

MASK_FOUND_CHECK_PIXEL:		;Al salir del bucle ya tengo la mascara que se le debe aplicar al byte de la RAM
				;Los datos que tengo hasta ahora son:	En R16 tengo el valor de X en la matriz (es igual al de la RAM)
				;					En R17 tengo el valor de Y de la matriz
				;					En R19 tengo el valor de Y en el display
				;					En R20 tengo la mascara
				;					En ZL y ZH la direccion del comiendo de la RAM

	LDI	R18,84	;Cargo la cantidad de pizeles que hay en una fila
	MUL	R19,R18	
	ADD	ZL,R0
	ADC	ZH,R1	;Me muevo Y(display)*84 valores en la memoria RAM
	
	LDI	R18,0
	ADD	ZL,R16
	ADC	ZH,R18	;Me muevo X valores en la memoria RAM

	;Al llegar acá, ya tengo ubicado el byte que se debe modificar aplicando la mascara
	LD	R18,Z	;Se lee el valor apuntado
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



;;***********************************************************
;Esta funcion mueve el snake una posicion, dependiendo de las
;direccion de la cola y la cabeza. Ademas de cargar R4 y R5 con
;las direcciones de la cabeza y la cola, se deben cargar las
;posiciones, ya que esta funcion utiliza funciones internas
;que utilizan esos datos
;*/

MOVE_SNAKE_ONE_POSITION:
	PUSH	R4	;Direccion de la cabeza (velocidad)
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
	
	LDI	R16,UP_DIRECTION		;Cargo la direccion hacia arriba
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
	LDI	R16,LEFT_DIRECTION		;Cargo la direccion hacia la izquierda	
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
	LDI	R16,DOWN_DIRECTION		;Cargo la direccion hacia abajo	
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
	LDI	R16,RIGHT_DIRECTION		;Cargo la direccion hacia la derecha
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
	BRNE	DONT_MOVE_TAIL			;Si se agarro la fruta R19 vale 1, por lo que no se debe apagar el pixel de la cola
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

;;***********************************************************
;Esta funcion mueve la cabeza del snake una posicion hacia arriba.
;Luego de mover los valores de la RAM, modifica las nuevas posiciones
;de la cabeza en los registros correspondientes.
;*/

MOVE_HEAD_UP:
	;PUSH	R0	;Posicion en X de la cabeza
	;PUSH	R1	;Posicion en Y de la cabeza
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	DEC	R1	;Se mueve la cabeza un pixel hacia arriba
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

;;***********************************************************
;Esta funcion mueve la cabeza del snake una posicion hacia la izquierda.
;Luego de mover los valores de la RAM, modifica las nuevas posiciones
;de la cabeza en los registros correspondientes.
;*/

MOVE_HEAD_LEFT:
	;PUSH	R0	;Posicion en X de la cabeza
	;PUSH	R1	;Posicion en Y de la cabeza
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	DEC	R0	;Se mueve la cabeza un pixel hacia la izquierda
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

;;***********************************************************
;Esta funcion mueve la cabeza del snake una posicion hacia abajo.
;Luego de mover los valores de la RAM, modifica las nuevas posiciones
;de la cabeza en los registros correspondientes.
;*/

MOVE_HEAD_DOWN:
	;PUSH	R0	;Posicion en X de la cabeza
	;PUSH	R1	;Posicion en Y de la cabeza
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	INC	R1	;Se mueve la cabeza un pixel hacia la izquierda
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

;;***********************************************************
;Esta funcion mueve la cabeza del snake una posicion hacia la derecha.
;Luego de mover los valores de la RAM, modifica las nuevas posiciones
;de la cabeza en los registros correspondientes.
;*/

MOVE_HEAD_RIGHT:
	;PUSH	R0	;Posicion en X de la cabeza
	;PUSH	R1	;Posicion en Y de la cabeza
	PUSH	R16
	PUSH	R17
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	INC	R0	;Se mueve la cabeza un pixel hacia la izquierda
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

;;***********************************************************
;Esta funcion mueve la cola del snake una posicion y modifica
;los registros necesarios.
;*/

MOVE_TAIL_ONE_POSITION:
	;PUSH	R2	;Posicion en X de la cola (No se guarda en el stack para poder modificarlo)
	;PUSH	R3	;Posicion en Y de la cola (No se guarda en el stack para poder modificarlo)
	PUSH	R16	;Registro auxiliar para valores de X
	PUSH	R17	;Registro auxiliar para valores de Y
	PUSH	R18
	PUSH	R21
	PUSH	ZL	;Direccion de la RAM
	PUSH	ZH	;Direccion de la RAM
	
	MOV	R16,R2
	MOV	R17,R3
	CALL	CLEAR_PIXEL_IN_RAM_DISPLAY	;Se apaga el pixel de la cola
	
	;Una vez que se apaga la cola, se debe ver en que direccion se tiene que mover para
	;no perder el resto del cuerpo de la vibora. Para esto hay que ver cual de los 4
	;pixeles que la rodean estan prendidos.
	
	LDI	R18,0
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de arriba
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_UP
	
	MOV	R16,R2
	MOV	R17,R3
	DEC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de la izquierda
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_LEFT
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R17
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de abajo
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_DOWN
	
	MOV	R16,R2
	MOV	R17,R3
	INC	R16
	CALL	CHECK_IF_PIXEL_SET_IN_RAM_DISPLAY	;Verifico si esta prendido el pixel de la derecha
	CP	R21,R18		;Si son iguales es porque el pixel esta apagado
	BRNE	MOVE_TAIL_RIGHT
	
MOVE_TAIL_UP:
	DEC	R3	;Tengo que mover la posicion de la cola un pixel hacia arriba
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_LEFT:
	DEC	R2	;Tengo que mover la posicion de la cola un pixel hacia la izquierda
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_DOWN:
	INC	R3	;Tengo que mover la posicion de la cola un pixel hacia abajo
	RJMP	END_MOVING_TAIL
	
MOVE_TAIL_RIGHT:
	INC	R2	;Tengo que mover la posicion de la cola un pixel hacia la derecha
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

;;************************************************************
;Funcion que prende la fruta en el display.
;*/

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

;;************************************************************
;Delay con el que se mueve el snake en la RAM.
;*/

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


;****************** LCD_INIT ****************************
Esta funci\F3n inicializa los 6 pines a utilizar del PORT_LCD para el control de
la pantalla, envia una se\F1al de reset, y deja todas las salidas en estado alto
(a excepcion de Backlight para reducir el consumo de corriente).*/

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

;**********************************************************
Esta funcion envia un byte de datos por el pin SDIN. Utiliza el registro R17 como
contador, y el dato a enviar lo lee de R16 (ambos registros son guardados
en el stack).*/

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
	
	LSL	R16			;Se corre R16 una posicion a la izquierda
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
		
;**********************************************************
Esta funcion envia un byte de comandos por el pin SDIN. Utiliza el registro R17 como
contador, y el dato a enviar lo lee de R16 (ambos registros son guardados
en el stack).*/

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
	
	LSL	R16			;Se corre R16 una posicion a la izquierda
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

;***********************************************************
Esta funcion es para imprimir en pantalla strings de caracteres 
El string nunca va a ser mayor a 14 chars, ya que es lo maximo
que se puede mostrar en pantalla en horizontal.
*/

;***********************************************************
Esta funcion es para imprimir en pantalla strings de caracteres.
En R19 debe estar guardado el largo de la cadena, en R16 y R16 las
posiciones en X e Y respectivamente donde se desea imprimir, y en Z
debe estar guardada la direccion del primer byte de la cadena.
*/

LCD_PRINT_STRING:
	PUSH	R16	;Valor de X
	PUSH	R17	;Valor de Y
	PUSH	R18
	PUSH	R19	;Largo del string
	PUSH	ZL	;Parte baja de la direccion del string
	PUSH	ZH	;Parte alta de la direccion del string
	
	LDI	R18,PCD8544_SETXADDR
	ADD	R16,R18		;Se suma el valor de X deseado con el comando 
	LDI	R18,PCD8544_SETYADDR
	ADD	R17,R18		;Se suma el valor de Y deseado con el comando


	
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
	PUSH	R16 	;Posicion en X
	PUSH	R17		;Posicion en Y
	PUSH	R18		;Caracter
	PUSH	R30
	PUSH	R31

	;LDI	R30,PCD8544_SETXADDR
	;ADD	R16,R30			;Se suma el valor de X deseado con el comando 
	;LDI	R30,PCD8544_SETYADDR
	;ADD	R17,R30			;Se suma el valor de Y deseado con el comando
	
	;CALL	LCD_WRITE_COMMAND	;Se inicializa X en el valor deseado
	;MOV		R16,R17
	;CALL	LCD_WRITE_COMMAND	;Se inicializa Y en el valor deseado
	
	SUBI	R18,32			;Se resta el offset al caracter para conocer el valor en la tabla
	LDI		R30,12			;Se debe multiplicar por 6 para obtener el valor de la tabla, ya que cada caracter son 6 bytes
	MUL		R18, R30		;El resultado se guarda en R1-R0 (el menos significativo en R0)
	
	LDI	ZL,LOW(CHARS_TABLE<<1)
	LDI	ZH,HIGH(CHARS_TABLE<<1)	;Se carga Z con la direccion de la tabla (hay que multiplicar por 2 para acceder)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;Se suma el offset para el caracter deseado
	
	LDI		R18,6			;Utilizo R18 como contador
SEND_NEXT_CHAR_BYTE:
	LPM		R16,Z+			;Leo el valor de la tabla y lo guardo en R18
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
Funcion que actualiza la pantalla. Lee los datos de la
memoria RAM apuntada por Z y lo envia al display
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

CARGO_MATRIZ_RAM:
	PUSH	R0
	PUSH	R1
	PUSH	R2			;mem aux
	PUSH	R3			;mem aux2
	PUSH	R4			;copia del resto
	PUSH	R5			;copia del ancho
	PUSH	R6			;MEMORIA PARA SUMAR CARRY
	PUSH	R16			;recibo X
	PUSH	R17			;recibo Y
	PUSH	R18			;valor de la division
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
	ROL		R25			;parte para sumar a lo de abajo
	CLC
	DEC		R4
	BRNE	ROLEO_OTRA_VEZ
	ADD		R20, R2
	ST		X, R20		;una vez q guardo incremento X EN 84
	ADD		XL, R22		;incremento X en 84
	ADC		XH, R6
	ADD		ZL, R21		;para que vaya abajo, le sumo el ancho, en esta imagen esta todo ordenado
	ADC		ZH, R6
	MOV		R2, R25		;memoria para sumar lo que le falta
	DEC		R5
	BRNE	PASO_AL_OTRO_Y
	DEC		R18			;decremento para hacer bien la cuenta
	MUL		R22, R24	;para volver a la posicion original
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





;***********************************************************
Esta funcion es para imprimir en pantalla strings de caracteres 
El string nunca va a ser mayor a 14 chars, ya que es lo maximo
que se puede mostrar en pantalla en horizontal.
*/

;***********************************************************
Esta funcion es para escribir en RAM strings de caracteres.
En R19 debe estar guardado el largo de la cadena, en R16 y R16 las
posiciones en X e Y respectivamente donde se desea imprimir, y en Z
debe estar guardada la direccion del primer byte de la cadena.
*/

RAM_PRINT_STRING:
	PUSH	R16	;Valor de X
	PUSH	R17	;Valor de Y
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
	PUSH	R16 	;Posicion en X
	PUSH	R17		;Posicion en Y
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
	LDI		R30,12			;Se debe multiplicar por 12 para obtener el valor de la tabla, ya que cada caracter son 12 bytes
	;CLC
	MUL		R18, R30		;El resultado se guarda en R1-R0 (el menos significativo en R0)
	
	LDI		ZL,LOW(CHARS_TABLE<<1)
	LDI		ZH,HIGH(CHARS_TABLE<<1)	;Se carga Z con la direccion de la tabla (hay que multiplicar por 2 para acceder)
	
	ADD		ZL,R0
	ADC 	ZH,R1			;Se suma el offset para el caracter deseado

	;LPM		R16,Z+			;Leo el valor de la tabla y lo guardo en R18

	MOV		YL, ZL
	MOV		YH, ZH			;copio la direccion donde apunta Z

	CALL	CARGO_MATRIZ_RAM		;Envio el dato a la RAM

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
;0 - arriba, 1 - izq, 2 - der, 3 - abajo, 4 - aceptar, 5 - pausa
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
;1 - arriba, 2 - izq, 3 - der, 4 - abajo, 5 - aceptar, 6 - pausa, 7 -ningun boton pulsado
; DEVUELVO EL VALOR EN R7
;******************************************************************************************/

PULSADORES_TODOS:

		PUSH	R18


		SBIC	PINC, 1					;flecha arriba
		JMP		BOTON_FLECHA_ARRIBA
		SBIC	PINC, 2					;flecha izquierda
		JMP		BOTON_FLECHA_IZQ
		SBIC	PINC, 3					;flecha derecha
		JMP		BOTON_FLECHA_DER
		SBIC	PINC, 4					;flecha abajo
		JMP		BOTON_FLECHA_ABAJO
		SBIC	PINC, 5					;boton aceptar o boton A
		JMP		BOTON_ACEPTAR

		;boton pausa con interrupcion

		LDI		R18, 7
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_ARRIBA:
		LDI		R18, 1					;cargo el valor que le di a la flecha( 1 = arriba )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_IZQ:
		LDI		R18, 2					;cargo el valor que le di a la flecha( 2 = izquierda )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_DER:
		LDI		R18, 3					;cargo el valor que le di a la flecha( 3 = derecha )
		MOV		R7, R18					;devuelvo el valor 7 si no hay teclas pulsadas
		JMP		FIN_BOTONES

BOTON_FLECHA_ABAJO:
		LDI		R18, 4					;cargo el valor que le di a la flecha( 4 = abajo )
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

		PUSH	R16		;posicion de X
		PUSH	R17		;posicion de Y
		PUSH	R19		;largo de caracteres para strings
		PUSH	R23		;ancho en PIXELES para la imagen o lo que sea
		PUSH	R24		;alto en bytes para la imagen o lo que sea
		PUSH	ZL		;direccion para apuntar en la flash
		PUSH	ZH
		

		CALL	CLEAR_RAM

		;SIMON_DICE
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 1				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES
		LDI		R24, 1				;ALTO EN BYTES
		LDI		R19, 12				;ancho del string
		LDI		ZL, LOW(SIMON<<1)
		LDI		ZH, HIGH(SIMON<<1)
		CALL	RAM_PRINT_STRING
		;numeros
		LDI		R16, 40				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R19, 4				;ancho del string
		LDI		ZL, LOW(NUMEROS<<1)
		LDI		ZH, HIGH(NUMEROS<<1)
		CALL	RAM_PRINT_STRING
		;HIGH_SCORE
		LDI		R16, 40				;POSICION DE X
		LDI		R17, 13				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R19, 7				;ancho del string
		LDI		ZL, LOW(HIGH_SC<<1)
		LDI		ZH, HIGH(HIGH_SC<<1)
		CALL	RAM_PRINT_STRING
		;
		;TU TURNO
		LDI		R16, 35				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R19, 8				;ancho del string
		LDI		ZL, LOW(TU_TURNO<<1)
		LDI		ZH, HIGH(TU_TURNO<<1)
		CALL	RAM_PRINT_STRING
		*/
		;CORAZON1
		LDI		R16, 40				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	CARGO_MATRIZ_RAM
		;CORAZON2
		LDI		R16, 55				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	CARGO_MATRIZ_RAM
		;CORAZON3
		LDI		R16, 70				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON_NEG<<1)
		LDI		ZH, HIGH(CORAZON_NEG<<1)
		CALL	CARGO_MATRIZ_RAM
		;FLECHA_UP
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 12				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP<<1)
		LDI		ZH, HIGH(FLECHA_UP<<1)
		CALL	CARGO_MATRIZ_RAM
		;FLECHA_L
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L<<1)
		LDI		ZH, HIGH(FLECHA_L<<1)
		CALL	CARGO_MATRIZ_RAM
		;FLECHA_R
		LDI		R16, 22				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R<<1)
		LDI		ZH, HIGH(FLECHA_R<<1)
		CALL	CARGO_MATRIZ_RAM
		;FLECHA_DWN
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 32				;POSICION DE Y (32)
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN<<1)
		LDI		ZH, HIGH(FLECHA_DWN<<1)
		CALL	CARGO_MATRIZ_RAM



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
		PUSH	R25			;VALOR DE LOS DATOS
			

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
		MOV		R18, R25		;VALOR DE LA RESTA, VER SI DEJO R18 U OTRO




		;numeros unidad
		LDI		R16, 77				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 71				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
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
		

		PUSH	R16			;posicion de X
		PUSH	R17			;posicion de Y
		PUSH	R22			;valor de la tecla pulsada
		PUSH	R23			;ancho EN PIXELES
		PUSH	R24			;ALTO EN BYTES
		PUSH	ZL
		PUSH	ZH


		;MOV		R22, R7			;copio el valor de la tecla pulsada en R22

		CPI		R22, 1
		BREQ	CARGO_1			;cargo arriba
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
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 32				;POSICION DE Y (32)
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN_NEG<<1)
		LDI		ZH, HIGH(FLECHA_DWN_NEG<<1)
		CALL	CARGO_MATRIZ_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY


		
		;FLECHA_DWN
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 32				;POSICION DE Y (32)
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 3				;ALTO EN BYTES anda bien con 1 byte mas
		LDI		ZL, LOW(FLECHA_DWN<<1)
		LDI		ZH, HIGH(FLECHA_DWN<<1)
		CALL	CARGO_MATRIZ_RAM

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
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 12				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP_NEG<<1)
		LDI		ZH, HIGH(FLECHA_UP_NEG<<1)
		CALL	CARGO_MATRIZ_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_UP
		LDI		R16, 12				;POSICION DE X
		LDI		R17, 12				;POSICION DE Y
		LDI		R23, 9				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_UP<<1)
		LDI		ZH, HIGH(FLECHA_UP<<1)
		CALL	CARGO_MATRIZ_RAM

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
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L_NEG<<1)
		LDI		ZH, HIGH(FLECHA_L_NEG<<1)
		CALL	CARGO_MATRIZ_RAM


		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_L
		LDI		R16, 0				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_L<<1)
		LDI		ZH, HIGH(FLECHA_L<<1)
		CALL	CARGO_MATRIZ_RAM

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
		LDI		R16, 22				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R_NEG<<1)
		LDI		ZH, HIGH(FLECHA_R_NEG<<1)
		CALL	CARGO_MATRIZ_RAM

		LDI		ZL,LOW(RAM_DISPLAY)
		LDI		ZH,HIGH(RAM_DISPLAY)
		CALL	REFRESH_DISPLAY

		;CALL	DELAY_1S

		;FLECHA_R
		LDI		R16, 22				;POSICION DE X
		LDI		R17, 23				;POSICION DE Y
		LDI		R23, 11				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES
		LDI		ZL, LOW(FLECHA_R<<1)
		LDI		ZH, HIGH(FLECHA_R<<1)
		CALL	CARGO_MATRIZ_RAM

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

		PUSH	R16			;posicion de X
		PUSH	R17			;posicion de Y
		PUSH	R22			;cantidad de corazones disponibles
		PUSH	R23			;ancho EN PIXELES
		PUSH	R24			;ALTO EN BYTES
		PUSH	ZL
		PUSH	ZH


		CPI		R22, 3
		BREQ	CORAZON3_BLANCO
		CPI		R22, 2
		BREQ	CORAZON2_BLANCO

		;CORAZON1_BLANCO
		LDI		R16, 40				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	CARGO_MATRIZ_RAM

		JMP		TERMINO_CORAZONES

CORAZON2_BLANCO:
		;CORAZON2
		LDI		R16, 55				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	CARGO_MATRIZ_RAM

		JMP		TERMINO_CORAZONES

CORAZON3_BLANCO:
		;CORAZON3
		LDI		R16, 70				;POSICION DE X
		LDI		R17, 37				;POSICION DE Y
		LDI		R23, 10				;ancho EN PIXELES
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		ZL, LOW(CORAZON<<1)
		LDI		ZH, HIGH(CORAZON<<1)
		CALL	CARGO_MATRIZ_RAM


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
 
		OUT		EEDR, R22			;escribo el valor de R22 en la direccion apuntada por ZL y ZH
 
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

		PUSH	R16			;posicion de X
		PUSH	R17			;posicion de Y
		PUSH	R20			;valor leido de la EEPROM
		PUSH	R22			;48 para sumarle y mostrar el caracter en pantalla
		PUSH	R23			;ancho EN PIXELES
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
		MOV		R18, R20		;VALOR DE LA RESTA, VER SI DEJO R18 U OTRO



ESCRIBO_NUMEROS:
		;numeros unidad
		LDI		R16, 76				;POSICION DE X
		LDI		R17, 13				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 70				;POSICION DE X
		LDI		R17, 13				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 2				;ALTO EN BYTES 2 para cuando no esta centrado
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
		PUSH	R25			;VALOR DE LOS DATOS
			

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
		MOV		R18, R25		;VALOR DE LA RESTA, VER SI DEJO R18 U OTRO




		;numeros unidad
		LDI		R16, 46				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
		LDI		R22, 48
		ADD		R18, R22			;LE SUMO 48 PARA MOSTRAR EL NUMERO
		CALL	RAM_PRINT_CHAR

		;numeros decena
		LDI		R16, 40				;POSICION DE X
		LDI		R17, 25				;POSICION DE Y
		LDI		R23, 6				;ancho EN PIXELES DEL CARACTER
		LDI		R24, 1				;ALTO EN BYTES 2 para cuando no esta centrado
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
		
