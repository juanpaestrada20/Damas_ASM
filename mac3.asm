print macro cadena 
	LOCAL ETIQUETA 
	ETIQUETA: 
		MOV ah,09h 
		MOV dx,@data 
		MOV ds,dx 
		lea dx, cadena 
		int 21h
endm

getChar macro
	mov ah,01h
	int 21h
endm

; Imprimir tabla en consola 
printTable macro
	print separador ; imprimimos el separador
	print f8 ; imprimimos inicio fila 8
	printLine line8 ; imprimimos la fila 8
	print separador ; imprimimos el separador
	print f7 ; imprimimos inicio fila 7
	printLine line7 ; imprimimos la fila 7
	print separador ; imprimimos el separador
	print f6 ; imprimimos inicio fila 6
	printLine line6 ; imprimimos la fila 6
	print separador ; imprimimos el separador
	print f5 ; imprimimos inicio fila 5
	printLine line5 ; imprimimos la fila 5
	print separador ; imprimimos el separador
	print f4 ; imprimimos inicio fila 4
	printLine line4 ; imprimimos la fila 4
	print separador ; imprimimos el separador
	print f3 ; imprimimos inicio fila 3
	printLine line3 ; imprimimos la fila 3
	print separador ; imprimimos el separador
	print f2 ; imprimimos inicio fila 2
	printLine line2 ; imprimimos la fila 2
	print separador ; imprimimos el separador
	print f1 ; imprimimos inicio fila 1
	printLine line1 ; imprimimos la fila 1
	print separador ; imprimimos el separador
	print letters ; impirmimos las letras de las columnas
endm

; Imprimir filas
; array es la fila que contine las fichas
printLine macro array
	; Generamos las etiquedas de loop
	; RECORRER se recorre esparcio del arreglo para ver que contiene 
	; BLANCAS generamos el espacio de la ficha blanca
	; ROJAS generamos el espacio de la ficha roja
	; REINAB generamos el espacio de la ficha reina blanca
	; REINAR genereamos el espacio de la ficha de la reina roja
	; BLANCO generamos el espacio en blanco
	; NEGRO generamos el espacio negro
	; AUMENTAR aumeta el contador para la posicion del arreglo
	; SALIR finalizamos de generar la fila
	LOCAL RECORRER, ROJAS, BLANCAS , NEGRO ,BLANCO , SALIR, REINAB, REINAR, AUMENTAR
	PUSH SI ; guardo en el stack para no perder datos
	PUSH AX ; guardo en el stack lo que tenga en ax
		xor si,si ; limpio el indice
		xor cx,cx ; limpio el contador
		mov cx, '0'

		RECORRER:
			cmp cx,'8' ; si llegamos a 8 salir
			je SALIR
			mov dh, array[si] ; obtener la posision del areglo
			cmp dh, 001b
			je ROJAS ; impimir ficha roja
			cmp dh,010b
			je BLANCAS ; impimir ficha blanco
			cmp dh,011b
			je REINAR ; impimir ficha reina blanca
			cmp dh,110b
			je REINAB ; impimir ficha reina blanco
			cmp dh,000b
			je BLANCO ; impimir espacio blanco
			cmp dh, 111b 
			je BLANCO ; impimir espacio negro
			jmp SALIR

		ROJAS:
			print fr ; imprimimos ficha roja
			jmp AUMENTAR ; aumentamos el indice

		BLANCAS:
			print fb ; imprimimos ficha blanca
			jmp AUMENTAR ; aumentamos el indice	

		REINAR:
			print rr ; iumprimimos ficha reina roja
			jmp AUMENTAR ; aumentamos el indice

		REINAB:
			print rb ; imprimimos ficha riena blanca
			jmp AUMENTAR ; aumentamos el indice

		BLANCO:
			print sf ; imprimimos espacio en blanco
			jmp AUMENTAR ; aumentamos el indice

		AUMENTAR:
			inc si ; incrementar el indice de la pila
			inc cx ; incrementar el contador
			jmp RECORRER ; continuamos recorriendo

		SALIR:
			print salto ; imprimimos un salto de linea

	POP AX ; recuperamos lo de ax
	POP SI ; recuperamos lo de si
endm
	
getDate macro
	MOV AH,2AH
	INT 21H
	MOV AH,2CH
	INT 21H
endm

; Crea el archivo
; buffer es el nombre del archivo
; handle es el manejador del archivo
createFile macro buffer, handle
	mov ah,3ch ; genera el archivo
	mov cx,00h ; limpia cx
	lea dx,buffer ; le pone nombre al archivo creado
	int 21h	; Finaliza el proceso
	mov handle,ax ; 
	jc ErrorCrear ; error por si no se crea el archivo
endm

; Escritura de archivos
; numbytes es el tamaño de la cadena que queremos escribir
; buffer es la cadena que queremos escribir
; handle es el manejador de archivos
writeFile macro numbytes, buffer, handle
	mov ah, 40h ; Opercion escritura de archivo
	mov bx,handle  ; a bx le colocamos el manejador
    mov cx, numbytes ; colocamos de contador el tamaño de lo que se escribira
	lea dx,buffer ; lo guardamos en dx
	int 21h ; fin de opoeracion de escritura
	jc ErrorEscribir ; Error por si no se puede escribir en el archivo
endm

getText macro buffer
	PUSH SI
	PUSH AX
	xor si,si
	mov buffer,headerHtml
	jmp CONTINUE

	FIN:
	mov al,0ah
	mov buffer,al

	POP AX
	POP SI
endm

; Abre archivos
; ruta es la ruta del archivo que queramos abrir
; handle es para el manejador de archivos del programa
openFile macro ruta, handle
	mov ah,3dh ; operacion para abrir archivos
	mov al,10b ; operacion de escritura
	lea dx,ruta ; obtiene lo que tiene el archivo
	int 21h ; fin de operacion
	mov handle,ax ; limpia el handle
	jc ErrorAbrir ; error por si no puede abrir el archivo
endm

; Cerrar archivo
; handle es el manejador del archivo
closeFile macro handle
	mov ah,3eh ; Operacion de cierre de un archivo abierto
	mov handle,bx ; limpiar el manejador
	int 21h ; Fin de operacion
endm

; Macro que ayudara a generar el texto html
generateHtml macro
	getFecha date ; obtener la fecha
	getHora time ; obtener la hora
	createFile rutaHtml, handleFichero ; creamos el archivo
	openFile rutaHtml, handleFichero ; abrimos el archivo creado
	; A continuacion viene lo que es la escritura de todo el archivo
	; SIZEOF es para obtener el tamaño de la cadena que vamos a escribir en el archivo
	writeFile SIZEOF headerHtml, headerHtml, handleFichero ; enviamos el encabezado del html
	writeFile SIZEOF titleHtml, titleHtml, handleFichero ; enviamos la etiqueda de titulo del html
	writeFile SIZEOF date, date, handleFichero ; enviamos el titulo del html
	writeFile SIZEOF time, time, handleFichero ; enviamos el titulo del html
	writeFile SIZEOF titleHtml2, titleHtml2, handleFichero ; enviamos la etiqueda de cierre de titulo del html
	writeFile SIZEOF tableStart, tableStart, handleFichero ; enviamos la etiqueda de incio de tabla del html
	generateTable ; Generamos el tablero
	writeFile SIZEOF tableEnd, tableEnd, handleFichero ; enviamos la etiqueda de fin de tabla del html
	writeFile SIZEOF finalHtml, finalHtml, handleFichero ; enviamos la etiqueda de fin del html
	closeFile handleFichero ; Cerramos el archivo creaDO
endm

; Gnerador de tabla en html
generateTable macro
	; Generamos todas la filas
	generateRow line8
	generateRow line7
	generateRow line6
	generateRow line5
	generateRow line4
	generateRow line3
	generateRow line2
	generateRow line1
endm

; Generador de filas de tablero
; array es la final con posicion de las filas
generateRow macro array
	; Generamos las etiquedas de loop
	; COLUMNA se recorre esparcio del arreglo para ver que contiene 
	; FICHAB generamos el espacio de la ficha blanca
	; FICHAR generamos el espacio de la ficha roja
	; FICHARB generamos el espacio de la ficha reina blanca
	; FICHARR genereamos el espacio de la ficha de la reina roja
	; BLANCO generamos el espacio en blanco
	; NEGRO generamos el espacio negro
	; AUMENTAR aumeta el contador para la posicion del arreglo
	; SALIR finalizamos de generar la fila
	LOCAL COLUMNA, FICHAB,FICHAR, FICHARB, FICHARR, BLANCO, NEGRO, AUMENTAR, SALIR
	PUSH SI ; guardamos lo que tengamso en si
	PUSH AX ; guardamos lo que tengamos en ax

	xor si,si ; limpiamos si
	xor cx,cx ; limpiamos cx
	mov cx, 8 ; inicializamos el contador en 0
	writeFile SIZEOF rowStart, rowStart, handleFichero ; escribimos la etiqueda de inicio de fila de html

		COLUMNA:
			cmp si, 8 ; si llegamos a 8 salir
			je SALIR
			mov dh, array[si] ; guardamos lo que tiene array en la posicion 'si' y lo guardamos en dh
			cmp dh,000b ; vemos si es un espacioo en blanco
			je BLANCO ; generamos el espacio en blanco
			cmp dh,111b ; vemos si es un espacio en negro 
			je NEGRO ; generamos el espaico en negro
			cmp dh,001b ; vemos si es una ficha roja
			je FICHAR ; generamos la ficha roja
			cmp dh,011b ; vemos si es una ficha reina roja
			je FICHARR ; generamos la ficha reina roja
			cmp dh,010b ; vemos si es una ficha blanca
			je FICHAB ; generamos la ficha blanca
			cmp dh,110b ; vemos si es una ficha reina blanca
			je FICHARB ; generamos la ficha reina blanca

		BLANCO:
			writeFile SIZEOF SpaceBlanco, SpaceBlanco, handleFichero ; colocamos el espacio blanco en html
			jmp AUMENTAR ; aumentamos el indice

		NEGRO:
			writeFile SIZEOF SpaceNegro, SpaceNegro, handleFichero ; colocamos el espacio negro en html
			jmp AUMENTAR ; aumentamos el indice

		FICHAR:
			writeFile SIZEOF FichaRHtml, FichaRHtml, handleFichero ; colocamos la ficha roja en html
			jmp AUMENTAR ; aumentamos el indice

		FICHARR:
			writeFile SIZEOF FichaRRHtml, FichaRRHtml, handleFichero ; colocamos la reina roja en html
			jmp AUMENTAR ; aumentamos el indice

		FICHAB:
			writeFile SIZEOF FichaBHtml, FichaBHtml, handleFichero ; colocamos la ficha blanca en html
			jmp AUMENTAR ; aumentamos el indice

		FICHARB:
			writeFile SIZEOF FichaRBHmtl, FichaRBHmtl, handleFichero ; colocamos la reina blanca en html
			jmp AUMENTAR ; aumentamos el indice

		AUMENTAR:
			inc si ; incrementar el indice de la pila
			dec cx ; decrementar el contador
			jne COLUMNA ; continuamos recorriendo

		SALIR:
			writeFile SIZEOF rowEnd, rowEnd, handleFichero ; escribimos la etiqueta para finalizar la fila

	POP AX ; recuperamos lo que teniamos en ax
	POP AX ; recuperamos lo que teniamos en si

endm

; Obtener fecha
getFecha macro buffer
    xor ax, ax ; limpiar el registro ax
    xor bx, bx ; limpiar el registro bx
    mov ah, 2ah ; 
    int 21h

    mov di,0
    mov al,dl
    bcd buffer

    inc di           
    mov al, dh
    bcd buffer

    inc di                
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h 
    inc di 
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h  

endm

getHora macro buffer
    xor ax, ax
    xor bx, bx
    mov ah, 2ch
    int 21h

    mov di,0
    mov al, ch
    bcd buffer

    inc di  
    mov al, cl
    bcd buffer

    inc di
    mov al, dh
    bcd buffer
	
endm

bcd macro entrada     
    push dx
    xor dx,dx
    mov dl,al
    xor ax,ax
    mov bl,0ah
    mov al,dl
    div bl
    push ax
    add al,30h
    mov entrada[di], al        
    inc di

    pop ax
    add ah,30h
    mov entrada[di], ah
    inc  di
    pop dx

endm