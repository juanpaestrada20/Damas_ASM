;===============SECCION DE MACROS ===========================
include mac3
;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encab db 0ah,0dh, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh,'FACULTAD DE INGENIERIA',0ah,0dh,'CIENCIAS Y SISTEMAS',0ah,0dh,'ARQUITECTURA DE COMPUTADORES 1',0ah,0dh,'$'
datos db 0ah,0dh, 'NOMBRE: JUAN PABLO ESTRADA ALEMAN', 0ah,0dh,'CARNET: 201800709',0ah,0dh,'SECCION: A',0ah,0dh,'$'
menu db 0ah,0dh, '1) Iniciar Juego', 0ah,0dh,'2) Cargar Juego',0ah,0dh,'3) Salir',0ah,0dh,'$'
;msm1 db 0ah,0dh,'FUNCION ABRIR',0ah,0dh,'$'
;msm2 db 0ah,0dh,'FUNCION CREAR',0ah,0dh,'$'
;msm3 db 0ah,0dh,'FUNCION ESCRIBIR',0ah,0dh,'$'
;msmError1 db 0ah,0dh,'Error al abrir archivo','$'
;msmError2 db 0ah,0dh,'Error al leer archivo','$'
;msmError3 db 0ah,0dh,'Error al crear archivo','$'
;msmError4 db 0ah,0dh,'Error al Escribir archivo','$'
;texto db 0ah,0dh,'Arquitectura de computadores y ensambladores 1','$'
;rutaArchivo db 100 dup('$')
;bufferLectura db 100 dup('$')
;bufferEscritura db 200 dup('$')
;handleFichero dw ?
.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print encab
			print datos
			print menu
			getChar
			cmp al,49
			je JUGAR
			cmp al,50
			je CARGAR
			cmp al,51
			je SALIR
			jmp Menu
		SALIR: 
			MOV ah,4ch 
			int 21h
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end