; Materia  : Lenguajes de Interfaz
; Practica : Manejo de pila manual
; Alumno   : Fernando Gastelum Verduzco
; Horario  : 10:00 a 11:00 am
; Docente  : Dr. Jose Luis Medina Jimenez
; Programa : Pide una base y una altura, las envia por la pila a
;            CalcularArea y muestra el area. Despues comprueba que ESP
;            quedo igual que antes de los PUSH y que EBX conserva su valor.

INCLUDE Irvine32.inc

.data
msgBase     BYTE "Escribe la base: ",0
msgAltura   BYTE "Escribe la altura: ",0
msgArea     BYTE "Area = ",0
msgEspAntes BYTE "ESP antes de los PUSH       : ",0
msgEspDesp  BYTE "ESP despues de la llamada   : ",0
msgEquil    BYTE "Pila equilibrada (ESP igual): ",0
msgEbx      BYTE "EBX conservado (00012345)   : ",0
msgSi       BYTE "SI",0
msgNo       BYTE "NO",0
numBase     DWORD ?             ; base capturada
numAltura   DWORD ?             ; altura capturada
espAntes    DWORD ?             ; ESP guardado antes de armar la llamada

.code
main PROC
    mov  ebx, 12345h            ; valor de prueba para ver si el procedimiento conserva EBX

    mov  edx, OFFSET msgBase
    call WriteString            ; pide la base
    call ReadDec                ; EAX = base (entero sin signo)
    mov  numBase, eax           ; guarda la base en memoria

    mov  edx, OFFSET msgAltura
    call WriteString            ; pide la altura
    call ReadDec                ; EAX = altura
    mov  numAltura, eax         ; guarda la altura en memoria

    mov  espAntes, esp          ; guarda ESP antes de colocar los argumentos

    push numBase                ; argumento 1: base, quedara en [EBP+12] dentro del procedimiento
    push numAltura              ; argumento 2: altura, quedara en [EBP+8]
    call CalcularArea           ; EAX = area; el procedimiento retira los 8 bytes con RET 8

    mov  edx, OFFSET msgArea
    call WriteString            ; texto del resultado
    call WriteDec               ; muestra EAX (el area)
    call Crlf

    mov  edx, OFFSET msgEspAntes
    call WriteString
    mov  eax, espAntes          ; EAX = ESP guardado antes de los PUSH
    call WriteHex               ; lo muestra en hexadecimal
    call Crlf

    mov  edx, OFFSET msgEspDesp
    call WriteString
    mov  eax, esp               ; EAX = ESP actual, despues de la llamada
    call WriteHex
    call Crlf

    mov  edx, OFFSET msgEquil
    call WriteString
    cmp  esp, espAntes          ; la pila esta equilibrada si ESP vale lo mismo que antes
    jne  PilaMal
    mov  edx, OFFSET msgSi
    jmp  MostrarPila
PilaMal:
    mov  edx, OFFSET msgNo
MostrarPila:
    call WriteString            ; muestra SI o NO
    call Crlf

    mov  edx, OFFSET msgEbx
    call WriteString
    cmp  ebx, 12345h            ; EBX debe seguir valiendo lo mismo
    jne  EbxMal
    mov  edx, OFFSET msgSi
    jmp  MostrarEbx
EbxMal:
    mov  edx, OFFSET msgNo
MostrarEbx:
    call WriteString            ; muestra SI o NO
    call Crlf
    exit                        ; termina el programa
main ENDP

; multiplica base por altura; recibe los dos valores por la pila y deja el area en EAX
CalcularArea PROC
    push ebp                    ; guarda el EBP de quien llamo
    mov  ebp, esp               ; EBP queda fijo: [EBP] = EBP guardado, [EBP+4] = retorno
    push ebx                    ; conserva EBX porque se usa dentro del procedimiento
    mov  eax, [ebp+12]          ; EAX = base (primer argumento colocado)
    mov  ebx, [ebp+8]           ; EBX = altura (segundo argumento colocado)
    imul eax, ebx               ; EAX = base * altura
    pop  ebx                    ; recupera EBX
    pop  ebp                    ; recupera EBP; la cima vuelve a tener la direccion de retorno
    ret  8                      ; regresa y retira los 8 bytes de argumentos de la pila
CalcularArea ENDP

END main
