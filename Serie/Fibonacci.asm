;
; fibonacci.asm
;
; Created: 24/09/2018 9:13:53 a. m.
; Author : Alexis
;
	
.def AL = r16  ;Registro valor dirección Memoria  Low
.def AH = r17  ;Registro valor dirección Memoria  high
; Se definen dos registros como numl (nible bajo) y numh (nible algo) de un número de 2 Bytes
.def numl= r18 ; F(n-1) low
.def numh= r19 ; F(n-1) high
.def aux1=r24
.def aux2=r25
.def n_datos= r20 ;Número de valores a mostrar de la Serie Fibonacci de 1-n
.def fl =r21	; F(n-2) low
.def fh =r22	; F(n-2) high
.def answer= r23  ;Respuesta de la serie
;.def Cero= r26
;.def Uno=r27
start:
	ldi n_datos,0x14 ; Se carga Número a mostar de la Serie en 20 valores
	ldi numl,0x01 ; Se carga numl con el valor de Fibonacci(1) 
	ldi numh,0x00 ; Se carga numl con el valor de Fibonacci(0)
	ldi fl,0x00   ; Se carga numl con el valor de Fibonacci(0) 
	ldi fh,0x00   ; Se carga numl con el valor de Fibonacci(0)
	ldi answer,0x00 ;Se carga el valor de la respuesta de la serie en 0
	ldi AL,0x00
	ldi AH,0x00
;	ldi Cero,0x00
;	ldi Uno,0x01

fibonacci:
	mov answer,numh      ;Se mueve valor de numh a answer para ser escrito en EEPROM
	rcall EEPROM_write	 ;Llamado relativo a EEPROM_write para escribir valor en EEPROM
	inc AL	 ;Incrementar valor de AL (Direccion de memoria bajo)
	mov answer,numl		;Se mueve valor de numl a answer para ser escrito en EEPROM
	rcall EEPROM_write	;Llamado relativo a EEPROM_write para escribir valor en EEPROM
	inc AL ;Incrementar valor de AL (Direccion de memoria bajo)
	mov aux1,numl	;Se almacena temporalmente el F(n-1) low
	mov aux2,numh	;Se almacena temporalmente el F(n-1) high
	add numl,fl		  ; F(n) = F(n-1)+F(n-2)
	adc numh,fh
	mov fl,aux1     ;Se pasa el F(n-1) a fl que pasara a ser el F(n-2)
	mov fh,aux2     ;Se pasa el F(n-1) a fh que pasara a ser el F(n-2)
	dec n_datos     ;Decrementar el contador de datos
	cpi n_datos,0   ;Se verifica sí el número de datos ya es 0 (cero)
	breq fin
	brne fibonacci

;Incrementar:
	;add AL,Uno
	;adc	AH,Cero
	;ret

EEPROM_write:
	; Wait for completion of previous write
	sbic EECR,EEPE
	rjmp EEPROM_write
	; Set up address (r18:r17) in address register
	out EEARH, AH ;r17
	out EEARL, AL ;r18
	; Write data (answer) to Data Register
	out EEDR,answer
	; Write logical one to EEMPE
	sbi EECR,EEMPE
	; Start eeprom write by setting EEPE
	sbi EECR,EEPE
	ret ;Regresar a subrutina

fin:
rjmp fin
