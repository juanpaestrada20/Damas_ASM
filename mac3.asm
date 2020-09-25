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

printLine macro array
	LOCAL RECORRER, ROJAS, BLANCAS , NEGRO ,BLANCO , SALIR, REINAB, REINAR, AUMENTAR
	PUSH SI ; guardo en el stack para no perder datos
	PUSH AX ; guardo en el stack lo que tenga en ax
		xor si,si ; limpio el indice
		xor cx,cx ; limpio el contador
		mov cx, '0'

		RECORRER:
		cmp cx,'8'
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
			print fr
			jmp AUMENTAR
		BLANCAS:
			print fb
			jmp AUMENTAR	
		REINAR:
			print rr
			jmp AUMENTAR
		REINAB:
			print rb
			jmp AUMENTAR
		BLANCO:
			print sf
			jmp AUMENTAR
		AUMENTAR:
			inc si ; incrementar el indice de la pila
			inc cx ; incrementar el contador
			jmp RECORRER
		SALIR:
			print salto

	POP AX
	POP SI
endm

printTable macro
	print separador
	print f8
	printLine line8
	print separador
	print f7
	printLine line7
	print separador
	print f6
	printLine line6
	print separador
	print f5
	printLine line5
	print separador
	print f4
	printLine line4
	print separador
	print f3
	printLine line3
	print separador
	print f2
	printLine line2
	print separador
	print f1
	printLine line1
	print separador
	print letters
endm
	
getDate macro
	MOV AH,2AH
	INT 21H
	MOV AH,2CH
	INT 21H
endm

createFile macro buffer, handle
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	mov handle,ax
	jc ErrorCrear
endm

writeFile macro numbytes,buffer,handle
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
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

closeFile macro handle
	mov ah,3eh
	mov handle,bx
	int 21h
endm

getTexto macro buffer
	PUSH SI
	PUSH AX

	xor si,si
	CONTINUE:
		getChar
		cmp al,0dh
		je FIN
		mov buffer[si],al
		inc si
		jmp CONTINUE

	FIN:
		mov al,'$'
		mov buffer[si],al

	POP AX
	POP SI
endm

openFile macro ruta, handle
	mov ah,3dh
	mov al,10b
	lea dx,ruta
	int 21h
	mov handle,ax
	jc ErrorAbrir
endm
