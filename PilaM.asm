; Alumno: Alexis Serrano Salomon
; Práctica: Manejo de pila manual
; Descripción: pedimos la base y la altura, las metemos a mano a la pila para mandarlas a un procedimiento que saca el area, y al final checamos que el puntero de la pila (ESP) y el registro EBX hayan quedado intactos.

INCLUDE Irvine32.inc

.data
    txtBase       BYTE "Ingresa la base: ", 0
    txtAltura     BYTE "Ingresa la altura: ", 0
    txtResultado  BYTE "El area es = ", 0
    txtPilaAntes  BYTE "ESP antes de meter datos    : ", 0
    txtPilaDesp   BYTE "ESP despues de la llamada   : ", 0
    txtBalance    BYTE "Pila equilibrada (ESP igual): ", 0
    txtRegistro   BYTE "EBX intacto (00098765)      : ", 0
    txtSi         BYTE "SI", 0
    txtNo         BYTE "NO", 0

    valBase       DWORD ?        ; aqui guardamos la base que teclee el usuario
    valAltura     DWORD ?      ; aqui guardamos la altura
    pilaInicial   DWORD ?       ; respaldo de como estaba el ESP antes de moverle

.code
main PROC
    ; le ponemos un valor de prueba al ebx para comprobar al final que el procedimiento no lo echo a perder
    mov  ebx, 98765h

    ; pedimos y leemos la base
    mov  edx, OFFSET txtBase
    call WriteString
    call ReadDec      ; el numero leido cae directo en eax
    mov  valBase, eax

    ; pedimos y leemos la altura
    mov  edx, OFFSET txtAltura
    call WriteString
    call ReadDec
    mov  valAltura, eax

    ; guardamos la direccion actual de la pila antes de empezar a aventarle parametros
    mov  pilaInicial, esp

    ; empujamos los dos argumentos a la pila antes de brincar al procedimiento
    push valBase       ; primer dato (adentro va a quedar en [ebp+12])
    push valAltura         ; segundo dato (va a quedar en [ebp+8])
    call ObtenerArea     ; el resultado regresa en eax y el ret 8 limpia estos dos push

    ; imprimimos el area calculada
    mov  edx, OFFSET txtResultado
    call WriteString
    call WriteDec
    call Crlf

    ; mostramos como estaba el ESP antes de los push
    mov  edx, OFFSET txtPilaAntes
    call WriteString
    mov  eax, pilaInicial
    call WriteHex
    call Crlf

    ; mostramos como quedo el ESP ahorita que ya regresamos
    mov  edx, OFFSET txtPilaDesp
    call WriteString
    mov  eax, esp
    call WriteHex
    call Crlf

    ; comparamos si la pila quedo exactamente igual que al principio
    mov  edx, OFFSET txtBalance
    call WriteString
    cmp  esp, pilaInicial
    jne  ErrorPila                      ; si no cuadran, brincamos a decir que NO
    mov  edx, OFFSET txtSi
    jmp  ImprimirPila

ErrorPila:
    mov  edx, OFFSET txtNo

ImprimirPila:
    call WriteString
    call Crlf

    ; ahora revisamos si el ebx sigue teniendo el 98765h intacto
    mov  edx, OFFSET txtRegistro
    call WriteString
    cmp  ebx, 98765h
    jne  ErrorEbx                       ; si cambio, brincamos a decir que NO
    mov  edx, OFFSET txtSi
    jmp  ImprimirEbx

ErrorEbx:
    mov  edx, OFFSET txtNo

ImprimirEbx:
    call WriteString
    call Crlf

    exit
main ENDP

; ...
; Procedimiento: ObtenerArea
; Entrada: base y altura en la pila
; Salida : EAX = base * altura
; Nota   : respalda EBX y limpia los 8 bytes de parametros con RET 8
; ...
ObtenerArea PROC
    push ebp          ; guardamos el ebp anterior del main
    mov  ebp, esp   ; fijamos nuestro marco de pila pa leer los datos sin perdernos
    push ebx      ; respaldamos ebx en la pila porque lo vamos a ocupar aqui abajo

    mov  eax, [ebp+12]       ; jalamos la base
    mov  ebx, [ebp+8]            ; jalamos la altura
    imul eax, ebx            ; multiplicamos base por altura (queda en eax)

    pop  ebx          ; devolvemos el ebx a su valor original
    pop  ebp        ; restauramos el ebp del main
    ret  8        ; regresamos al main y de pasada borramos los 8 bytes de los 2 parametros
ObtenerArea ENDP

END main