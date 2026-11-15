
; Nombre:       Fernando Gastelum Verduzco
; Institucion:  Tecnologico Nacional de Mexico
;               Instituto Tecnologico de Culiacan
; Materia:      Lenguajes de Interfaz (10:00 - 11:00)
; Programa:     Uso de una macro para mostrar mensajes en pantalla
; Descripcion:  Define una macro que imprime una cadena seguida de un
;               salto de linea. Se usa dos veces y despues se repite
;               la misma salida sin macro para comparar ambos metodos.


INCLUDE Irvine32.inc           

; Macro MostrarMensaje
; Parametro: texto = etiqueta de la cadena que se quiere imprimir
; Carga la direccion de la cadena en EDX, la imprime y baja una linea

MostrarMensaje MACRO texto
    mov  edx, OFFSET texto      ; EDX apunta al inicio de la cadena
    call WriteString            ; Imprime la cadena terminada en 0
    call Crlf                   ; Salto de linea
ENDM

.data
    ; Cadenas terminadas en 0 (fin de cadena para WriteString)
    MensajeInicio BYTE "BIENVENIDO A LA CAFETERIA DEL TEC", 0
    MensajeFin    BYTE "GRACIAS POR TU VISITA, HASTA LUEGO", 0

.code
main PROC
    ; Primera parte: salida usando la macro
    MostrarMensaje MensajeInicio    ; Imprime el mensaje de bienvenida
    MostrarMensaje MensajeFin       ; Imprime el mensaje de despedida

    ; Segunda parte: la misma salida escrita a mano, sin macro
    mov  edx, OFFSET MensajeInicio  ; EDX apunta al mensaje de bienvenida
    call WriteString                ; Lo imprime
    call Crlf                       ; Salto de linea

    mov  edx, OFFSET MensajeFin     ; EDX apunta al mensaje de despedida
    call WriteString                ; Lo imprime
    call Crlf                       ; Salto de linea

    exit                            ; Termina el programa
main ENDP

END main
