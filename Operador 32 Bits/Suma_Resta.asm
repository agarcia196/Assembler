.include "./m328Pdef.inc"

;Asignación de un nombre a los registros

.def ByteA0 = R16
.def ByteA1 = R17
.def ByteA2 = R18
.def ByteA3 = R19
.def SignoA = R24

.def ByteB0 = R20
.def ByteB1 = R21
.def ByteB2 = R22
.def ByteB3 = R23
.def SignoB = R25
.def Pulsadores = R26
.def SalidaSC= R27
.def NibleBajo = R30
.def NibleAlto = R31

Main:
;Cargar de Número 1 
ldi ByteA0,0b11111111
ldi ByteA1,0b01000000
ldi ByteA2,0b10000110
ldi ByteA3,0b11100001
ldi SignoA,0b00100000

;Cargar de Número 2
ldi ByteB0,0b11111111
ldi ByteB1,0b11001111
ldi ByteB2,0b10111100
ldi ByteB3,0b11001111
ldi SignoB,0b00100000

ldi NibleBajo,0b00001111
ldi NibleAlto,0b11110000

rjmp Validar_Signo

Validar_Signo:
CP SignoA,SignoB 
BREQ Sumar ;Si el valor de Z=1 entonces brinca a Sumar
CLN
BRPL Verificar_Mayor_Numero

Validar_Signo1:
BREQ Restar2 ;Si el valor de Z=1 entonces brinca a Restar2
rjmp Restar1

Verificar_Mayor_Numero:
CP ByteA3,ByteB3
BREQ Verificar_Byte2
BRLO A_SignoB
rjmp Validar_Signo1

Verificar_Byte2:
CP ByteA2,ByteB2
BREQ Verificar_Byte1
BRLO A_SignoB
rjmp Validar_Signo1

Verificar_Byte1:
CP ByteA1,ByteB1
BREQ Verificar_Byte0
BRLO A_SignoB
rjmp Validar_Signo1

Verificar_Byte0:
CP ByteA0,ByteB0
BRLO A_SignoB
rjmp Validar_Signo1

A_SignoB:
BST SignoB,5
BLD SignoA,5
SEZ
rjmp Validar_Signo1

Sumar:
CLC ; Pone en bajo la bandera de carry C=0
ADD ByteA0,ByteB0 ; Se realiza una suma simple del primer Byte de cada número
ADC ByteA1,ByteB1 ; Se realiza una suma con carry del segundo Byte de cada número
ADC ByteA2,ByteB2 ; Se realiza una suma con carry del tercer Byte de cada número
ADC ByteA3,ByteB3 ; Se realiza una suma con carry del cuarto Byte de cada número
BRCS MeterCarry
rjmp Imprimir

SumaSinCarry:
ADD ByteA0,ByteB0 ; Se realiza una suma simple del primer Byte de cada número
ADD ByteA1,ByteB1 ; Se realiza una suma simple del Segundo Byte de cada número
ADD ByteA2,ByteB2 ; Se realiza una suma simple del Tercero Byte de cada número
ADD ByteA3,ByteB3 ; Se realiza una suma simple del Cuarto Byte de cada número
rjmp Imprimir

Restar1: ;Resta con ByteA negativo
NEG ByteA0 ; Complemento a 2 al ByteA0
NEG ByteA1 ; Complemento a 2 al ByteA1
NEG ByteA2 ; Complemento a 2 al ByteA2
NEG ByteA3 ; Complemento a 2 al ByteA3
rjmp SumaSinCarry

Restar2: ;Resta con ByteB negativo
NEG ByteB0 ; Complemento a 2 al ByteB0
NEG ByteB1 ; Complemento a 2 al ByteB1
NEG ByteB2 ; Complemento a 2 al ByteB2
NEG ByteB3 ; Complemento a 2 al ByteB3
rjmp SumaSinCarry

MeterCarry:
CLC
SET
BLD SignoA,4
rjmp Imprimir

Imprimir:
out DDRB,NibleBajo
OUT DDRD,NibleAlto
IN Pulsadores,PinC ; Lectura Port C Input Pins 
CPI Pulsadores,1  ; Compara si el registro pulsadores es igual a 1,2,4 o 8 y procede a
BREQ ImprimirByte0 ; imprimir el registro correspondiente
CPI Pulsadores,2
BREQ ImprimirByte1
CPI Pulsadores,4
BREQ ImprimirByte2
CPI Pulsadores,8
BREQ ImprimirByte3
rjmp Imprimir

ImprimirByte0:
out PORTB,ByteA0
OUT PORTD,ByteA0
rjmp Imprimir

ImprimirByte1:
out PORTB,ByteA1
OUT PORTD,ByteA1
rjmp Imprimir

ImprimirByte2:
out PORTB,ByteA2
OUT PORTD,ByteA2
rjmp Imprimir

ImprimirByte3:
;MOV ByteB3,ByteA3
;bst SignoA,4; Se captura bit 4 y se envia a la Bandera T
;bld ByteB3,4; Se asigna valor de bandera T a el bit 5 para llevar el acarreo
;bst SignoA,5; Se captura bit 4 y se envia a la Bandera T
;bld ByteB3,5; Se asigna valor de bandera T a el bit 5 para llevar el acarreo
OUT PORTD,ByteA3
out PORTB,ByteA3
OUT PORTC,SignoA
In Pulsadores,PinC
CPI Pulsadores,8
BRNE Imprimir

