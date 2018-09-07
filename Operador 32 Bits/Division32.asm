.include "./m328Pdef.inc"

.def ByteA0 = R16
.def ByteA1 = R17
.def ByteA2 = R18
.def ByteA3 = R19
.def ByteB0 = R20
.def ByteB1 = R21
.def ByteB2 = R22
.def ByteB3 = R23
.def Contador0 = R24
.def Contador1 = R25
.def Contador2 = R26
.def Contador3 = R27
.def Zero = R31
.def SignoA = R29
.def SignoB = R30
.def Pulsadores = R16
.def NibleBajo = R17
.def NibleAlto = R18

Main:
;Cargar de Número 1 
ldi ByteA0,0b00100011
ldi ByteA1,0b01110000
ldi ByteA2,0b11111111
ldi ByteA3,0b00000000
ldi SignoA,0b00100000

;Cargar de Número 2
ldi ByteB0,0b00000101
ldi ByteB1,0b11000000
ldi ByteB2,0b01110001
ldi ByteB3,0b00111000
ldi SignoB,0b00100000
;Cargar en Cero los registros del Contador (Respuesta)
ldi Contador0,0b00000000
ldi Contador1,0b00000000
ldi Contador2,0b00000000
ldi Contador3,0b00000000
;Aux Zero para sumar el carry en caso de existir
ldi Zero,0b00000000

rjmp Verificar_Mayor_Numero

Verificar_Mayor_Numero:
CP ByteA3,ByteB3
BREQ Verificar_Byte2
BRLO CargarNible
rjmp SumarContador

Verificar_Byte2:
CP ByteA2,ByteB2
BREQ Verificar_Byte1
BRLO CargarNible
rjmp SumarContador

Verificar_Byte1:
CP ByteA1,ByteB1
BREQ Verificar_Byte0
BRLO CargarNible
rjmp SumarContador

Verificar_Byte0:
CP ByteA0,ByteB0
BREQ SumarContador
BRLO CargarNible
rjmp SumarContador

SumarContador:
CLC ; Pone en bajo la bandera de carry C=0
ADIW Contador0,1 ; Suma uno al contador primer Byte de cada número
ADC Contador1,Zero 
ADC Contador2,Zero
ADC Contador3,Zero
rjmp Restar

Restar:
SUB ByteA0,ByteB0 ; Se realiza una resta simple del primer Byte de cada número
SUB ByteA1,ByteB1 ; Se realiza una resta simple del Segundo Byte de cada número
SUB ByteA2,ByteB2 ; Se realiza una resta simple del Tercero Byte de cada número
SUB ByteA3,ByteB3 ; Se realiza una resta simple del Cuarto Byte de cada número
rjmp Verificar_Mayor_Numero

CargarNible:
ldi NibleBajo,0b00001111
ldi NibleAlto,0b11110000
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
out PORTB,Contador0
OUT PORTD,Contador0
rjmp Imprimir

ImprimirByte1:
out PORTB,Contador1
OUT PORTD,Contador1
rjmp Imprimir

ImprimirByte2:
out PORTB,Contador2
OUT PORTD,Contador2
rjmp Imprimir

ImprimirByte3:
OUT PORTD,Contador3
out PORTB,Contador3
rjmp Imprimir
