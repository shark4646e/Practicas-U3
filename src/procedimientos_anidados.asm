; Materia  : Lenguajes de Interfaz
; Practica : Procedimientos anidados
; Alumno   : Fernando Gastelum Verduzco
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; Programa : main llama a MostrarReporte, este llama a MostrarEncabezado
;            y este a MostrarSeparador. Cada procedimiento avisa cuando
;            entra y cuando sale para ver el orden de los regresos.

INCLUDE Irvine32.inc

.data
; mensajes que muestra cada procedimiento al entrar y al salir
msgEntraReporte BYTE "Entra a MostrarReporte",0
msgEntraEnc     BYTE "Entra a MostrarEncabezado",0
msgEntraSep     BYTE "Entra a MostrarSeparador",0
msgSaleSep      BYTE "Sale de MostrarSeparador",0
msgSaleEnc      BYTE "Sale de MostrarEncabezado",0
msgSaleReporte  BYTE "Sale de MostrarReporte",0
; contenido propio de cada procedimiento
linea           BYTE "----------------------",0
titulo          BYTE "REPORTE DE PRUEBA",0
cuerpo          BYTE "Cuerpo del reporte",0
msgFin          BYTE "Fin del programa",0

.code
main PROC
    call MostrarReporte         ; nivel 1: CALL guarda en la pila el retorno hacia main
    mov  edx, OFFSET msgFin     ; al regresar, main continua en la instruccion siguiente al CALL
    call WriteString            ; muestra el mensaje final
    call Crlf                   ; salto de linea
    exit                        ; termina el programa
main ENDP

; procedimiento de nivel 1: arma el reporte y llama al encabezado
MostrarReporte PROC
    mov  edx, OFFSET msgEntraReporte
    call WriteString            ; avisa que entro
    call Crlf
    call MostrarEncabezado      ; nivel 2: se guarda otro retorno encima del anterior
    mov  edx, OFFSET cuerpo
    call WriteString            ; muestra el cuerpo cuando el encabezado ya termino
    call Crlf
    mov  edx, OFFSET msgSaleReporte
    call WriteString            ; avisa que va a salir
    call Crlf
    ret                         ; toma de la cima el retorno hacia main
MostrarReporte ENDP

; procedimiento de nivel 2: muestra el titulo entre dos separadores
MostrarEncabezado PROC
    mov  edx, OFFSET msgEntraEnc
    call WriteString            ; avisa que entro
    call Crlf
    call MostrarSeparador       ; nivel 3: tercer retorno guardado en la pila
    mov  edx, OFFSET titulo
    call WriteString            ; muestra el titulo
    call Crlf
    mov  edx, OFFSET msgSaleEnc
    call WriteString            ; avisa que va a salir
    call Crlf
    ret                         ; toma de la cima el retorno hacia MostrarReporte
MostrarEncabezado ENDP

; procedimiento de nivel 3: escribe una linea de guiones
MostrarSeparador PROC
    mov  edx, OFFSET msgEntraSep
    call WriteString            ; avisa que entro
    call Crlf
    mov  edx, OFFSET linea
    call WriteString            ; escribe la linea de guiones
    call Crlf
    mov  edx, OFFSET msgSaleSep
    call WriteString            ; avisa que va a salir
    call Crlf
    ret                         ; toma de la cima el retorno hacia MostrarEncabezado
MostrarSeparador ENDP

END main
