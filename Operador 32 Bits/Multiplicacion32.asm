.include "./m328Pdef.inc"

.def ByteA0 = R16
.def ByteA1 = R17
.def ByteA2 = R18
.def ByteA3 = R19
.def SignoA = R3
.def Zero= R24
.def ByteB0 = R20
.def ByteB1 = R21
.def ByteB2 = R22
.def ByteB3 = R23
.def SignoB = R4
.def Result1 = R25
.def Result2 = R26
.def Result3 = R27
.def Result4 = R28
.def Result5 = R29
.def Result6 = R30
.def Result7 = R31
.def Result8 = R16
.def Pulsadores = R24
.def NibleBajo = R17
.def NibleAlto = R18
.def MulHigh = R1 //Resultado de multiplicacion 1
.def MulLow = R0 //Resultado de multiplicacion 2

Main:
;Cargar de Número 1 
;01101011|01010111|00110011|11100011
ldi ByteA0,0b11100011
ldi ByteA1,0b00110011
ldi ByteA2,0b01010111
ldi ByteA3,0b01101011
lds SignoA,0b00100000

;Cargar de Número 2
;01010101|11110000|10110110|11010101
ldi ByteB0,0b11010101
ldi ByteB1,0b10110110
ldi ByteB2,0b11110000
ldi ByteB3,0b01010101
lds SignoB,0b00100000
ldi Zero,0b00000000

ldi Result1,0b00000000
ldi Result2,0b00000000
ldi Result3,0b00000000
ldi Result4,0b00000000
ldi Result5,0b00000000
ldi Result6,0b00000000
ldi Result7,0b00000000
lds Result8,0b00000000
rjmp Validar_Signo

Validar_Signo:
CP SignoA,SignoB 
BREQ SignoP
BRNE SignoN

SignoP:
SET
BLD SignoA,4
rjmp Multiplicar

SignoN:
CLT
BLD SignoA,4
rjmp Multiplicar

Multiplicar:
MUL ByteA0,ByteB0 
MOV Result1,MulLow
MOV Result2,MulHigh

MUL ByteA0,ByteB1
ADD Result2,MulLow
ADC Result3,MulHigh

MUL ByteA1,ByteB0
ADD Result2,MulLow
ADC Result3,MulHigh
ADC Result4,Zero

MUL ByteA0,ByteB2
ADD Result3,MulLow
ADC Result4,MulHigh
ADC Result5,Zero

MUL ByteA1,ByteB1
ADD Result3,MulLow
ADC Result4,MulHigh
ADC Result5,Zero

MUL ByteA2,ByteB0
ADD Result3,MulLow
ADC Result4,MulHigh
ADC Result5,Zero
ADC Result6,Zero

MUL ByteA0,ByteB3
ADD Result4,MulLow
ADC Result5,MulHigh
ADC Result6,Zero

MUL ByteA1,ByteB2
ADD Result4,MulLow
ADC Result5,MulHigh
ADC Result6,Zero

MUL ByteA2,ByteB1
ADD Result4,MulLow
ADC Result5,MulHigh
ADC Result6,Zero

MUL ByteA3,ByteB0
ADD Result4,MulLow
ADC Result5,MulHigh
ADC Result6,Zero
ADC Result7,Zero 

CLR ByteA0
MUL ByteA1,ByteB3
ADD Result5,MulLow
ADC Result6,MulHigh
ADC Result7,Zero
ADC Result8,Zero

MUL ByteA2,ByteB2
ADD Result5,MulLow
ADC Result6,MulHigh
ADC Result7,Zero
ADC Result8,Zero

MUL ByteA3,ByteB1
ADD Result5,MulLow
ADC Result6,MulHigh
ADC Result7,Zero
ADC Result8,Zero

MUL ByteA2,ByteB3
ADD Result6,MulLow
ADC Result7,MulHigh
ADC Result8,Zero

MUL ByteA3,ByteB2
ADD Result6,MulLow
ADC Result7,MulHigh
ADC Result8,Zero

MUL ByteA3,ByteB3
ADD Result7,MulLow
ADC Result8,MulHigh

ldi NibleBajo,0b00001111
ldi NibleAlto,0b11110000 
rjmp Imprimir

Imprimir:
out DDRB,NibleBajo
OUT DDRD,NibleAlto
rjmp N_Alto

N_Alto:
out DDRB,NibleBajo
OUT DDRD,NibleAlto
IN Pulsadores,PinC ; Lectura Port C Input Pins 
CPI Pulsadores,1  
BREQ ImprimirByte5 ; imprimir el registro correspondiente
CPI Pulsadores,2
BREQ ImprimirByte6
CPI Pulsadores,4
BREQ ImprimirByte7
CPI Pulsadores,8
BREQ ImprimirByte8
CPI Pulsadores,0b00010000
BREQ N_Bajo
rjmp N_Alto

N_Bajo:
out DDRB,NibleBajo
OUT DDRD,NibleAlto
IN Pulsadores,PinC ; Lectura Port C Input Pins 
CPI Pulsadores,1  ; Compara si el registro pulsadores es igual a 1,2,4 o 8 y procede a
BREQ ImprimirByte1 ; imprimir el registro correspondiente
CPI Pulsadores,2
BREQ ImprimirByte2
CPI Pulsadores,4
BREQ ImprimirByte3
CPI Pulsadores,8
BREQ ImprimirByte4
CPI Pulsadores,0b00010000
BREQ N_Alto
rjmp N_Bajo

ImprimirByte1:
out PORTB,Result1
OUT PORTD,Result1
rjmp N_Bajo

ImprimirByte2:
out PORTB,Result2
OUT PORTD,Result2
rjmp N_Bajo

ImprimirByte3:
out PORTB,Result3
OUT PORTD,Result3
rjmp N_Bajo

ImprimirByte4:
out PORTB,Result4
OUT PORTD,Result4
rjmp N_Bajo

ImprimirByte5:
out PORTB,Result5
OUT PORTD,Result5
rjmp N_Alto

ImprimirByte6:
out PORTB,Result6
OUT PORTD,Result6
rjmp N_Alto

ImprimirByte7:
out PORTB,Result7
OUT PORTD,Result7
rjmp N_Alto

ImprimirByte8:
out PORTB,Result8
OUT PORTD,Result8
rjmp N_Alto
