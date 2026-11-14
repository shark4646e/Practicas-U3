; Materia  : Lenguajes de Interfaz
; Practica : Manejo de cadena vacia
; Alumno   : Fernando Gastelum Verduzco
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; Programa : Pide una cadena y cuenta sus caracteres con el procedimiento
;            LongitudCadena. Si la cadena esta vacia (longitud 0) avisa y
;            vuelve a pedirla; si no, muestra la longitud y la cadena.

INCLUDE Irvine32.inc

MAXLEN EQU 80                   ; maximo de caracteres que se aceptan

.data
msgPedir  BYTE "Escribe una cadena: ",0
msgVacia  BYTE "La cadena esta vacia, intenta de nuevo.",0
msgLong   BYTE "Longitud de la cadena: ",0
msgTexto  BYTE "Cadena capturada: ",0
buffer    BYTE MAXLEN+1 DUP(0)  ; espacio para la cadena mas el terminador nulo

.code
main PROC
Pedir:
    mov  edx, OFFSET msgPedir
    call WriteString            ; muestra la indicacion
    mov  edx, OFFSET buffer     ; EDX = direccion donde se guarda lo que se escriba
    mov  ecx, MAXLEN            ; ECX = maximo de caracteres a leer
    call ReadString             ; guarda la cadena y le agrega el terminador nulo
    mov  esi, OFFSET buffer     ; ESI = direccion de la cadena para el procedimiento
    call LongitudCadena         ; regresa en EAX el numero de caracteres
    cmp  eax, 0                 ; longitud 0 significa cadena vacia
    jne  Mostrar                ; si no es vacia, se muestra el resultado
    mov  edx, OFFSET msgVacia
    call WriteString            ; avisa que la cadena esta vacia
    call Crlf
    jmp  Pedir                  ; regresa a pedir otra cadena
Mostrar:
    mov  edx, OFFSET msgLong
    call WriteString            ; muestra el texto de la longitud
    call WriteDec               ; muestra el valor de EAX (la longitud)
    call Crlf
    mov  edx, OFFSET msgTexto
    call WriteString            ; muestra el texto de la cadena
    mov  edx, OFFSET buffer
    call WriteString            ; muestra la cadena capturada
    call Crlf
    exit                        ; termina el programa
main ENDP

; cuenta los caracteres de la cadena que empieza en ESI y deja el total en EAX
LongitudCadena PROC
    push esi                    ; guarda ESI porque el procedimiento lo va a mover
    mov  eax, 0                 ; el contador empieza en cero
Contar:
    cmp  BYTE PTR [esi], 0      ; llego al terminador nulo?
    je   Fin                    ; si es la cadena vacia, el primer byte ya es 0 y sale con EAX = 0
    inc  eax                    ; un caracter mas
    inc  esi                    ; pasa al siguiente caracter
    jmp  Contar                 ; repite hasta encontrar el nulo
Fin:
    pop  esi                    ; recupera ESI para que main lo encuentre igual
    ret                         ; regresa a main
LongitudCadena ENDP

END main
