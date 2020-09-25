;===============SECCION DE MACROS ===========================
include mac3.asm
;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encab db 0ah,0dh, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES 1',0ah,0dh,'$'
datos db 0ah,0dh, 'NOMBRE: JUAN PABLO ESTRADA ALEMAN', 0ah,0dh,'CARNET: 201800709',0ah,0dh,'SECCION: A',0ah,0dh,'$'
men db 0ah,0dh, '1) Iniciar Juego', 0ah,0dh,'2) Cargar Juego',0ah,0dh,'3) Salir',0ah,0dh,'$'
salto db 0ah, 0dh , '$' ; salto de linea
;Definincion de matriz inicial de juego
; 000b espacio en blanco
; 111b espacio en negro
; 001b ficha roja
; 011b ficha roja reina
; 010b ficha blanca
; 110b ficha blanca reina
; tablero inical 
line8 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b
line7 db 000b, 001b, 000b, 001b, 000b, 001b, 000b, 001b
line6 db 001b, 000b, 001b, 000b, 001b, 000b, 001b, 000b
line5 db 000b, 111b, 000b, 111b, 000b, 111b, 000b, 111b
line4 db 111b, 000b, 111b, 000b, 111b, 000b, 111b, 000b
line3 db 010b, 000b, 010b, 000b, 010b, 000b, 010b, 000b
line2 db 000b, 010b, 000b, 010b, 000b, 010b, 000b, 010b
line1 db 010b, 000b, 010b, 000b, 010b, 000b, 010b, 000b

f8 db '8 |', '$'
f7 db '7 |', '$'
f6 db '6 |', '$'
f5 db '5 |', '$'
f4 db '4 |', '$'
f3 db '3 |', '$'
f2 db '2 |', '$'
f1 db '1 |', '$'
separador db '  -------------------------', 0ah,0dh, '$'
letters db   '   A  B  C  D  E  F  G  H', 0ah,0dh, '$'
fb db 'FB|', '$'
fr db 'FR|', '$'
rb db 'RB|', '$'
rr db 'RR|', '$'
sf db '  |', '$'

;=========================== REPORTE HTML ===========================

msmCreado db 'Reporte HTML creado', '$'
rutaHtml db 'reporte.txt', 00
headerHtml db '<html lang="es"> <head>  <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0">  <title>Estado Tablero</title> </head> <body>', '$'
titleHtml db '<h1 text-align: center;>'
tituloHtml db '24/09/2020 - 10:58:56 PM' 
titleHtml2 db '</h1>'
tableHtml db '<table class="table" border="collapse" >'
rowHtml db ' <tr>'
FichaRHtml  db '<td style="background:  #973a29;"> <image src="red.png" height=></image> </td>'
FichaBHtml  db '<td style="background:  #973a29;"> <image src="white.png"></image> </td>'
FichaRRHtml db '<td style="background:  #973a29;"> <image src="CoronaN.png"></image> </td>'
FichaRBHmtl db '<td style="background:  #973a29;"> <image src="CoronaB.png"></image> </td>'
SpaceBlanco db '<td style="background:  #fffdd0;"></td>'
SpaceNegro  db '<td style="background:  #b35110;"></td>'
rowHtml2 db '</tr>'
txtTableF db '</table>'

finalHtml db '</body> </html>'

;msm1 db 0ah,0dh,'FUNCION ABRIR',0ah,0dh,'$'
;msm2 db 0ah,0dh,'FUNCION CREAR',0ah,0dh,'$'
msm3 db 0ah,0dh,'CREANDO ARCHIVO',0ah,0dh,'$'
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
;msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
msmError4 db 0ah,0dh,'Error al Escribir archivo','$'
rutaArchivo db 100 dup('$')
bufferLectura db 100 dup('$')
bufferEscritura db 200 dup('$')
handleFichero dw ?
.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
			MOV dx,@data
			MOV ds,dx 
		Menu:
			print encab
			print datos
			print men
			getChar
			cmp al,49
			je JUGAR
			cmp al,50
			je CARGAR
			cmp al,51
			je SALIR
			jmp Menu
        JUGAR:
			print salto
			printTable 
			jmp CREAR
        CARGAR:
		SALIR: 
			MOV ah,4ch 
			int 21h
		CREAR:
			createFile rutaHtml, handleFichero
			jmp ESCRIBIR
		ESCRIBIR:
			print msm3
			openFile rutaHtml, handleFichero
			getText bufferEscritura
		    writeFile SIZEOF bufferEscritura, bufferEscritura,handleFichero
			closeFile handleFichero
			print msmCreado
			getChar
			jmp Menu
		ErrorCrear:
	    	print msmError3
	    	getChar
	    	jmp Menu
		ErrorEscribir:
	    	print msmError4
	    	getChar
	    	jmp Menu
		ErrorAbrir:
	    	print msmError1
	    	getChar
	    	jmp Menu
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end