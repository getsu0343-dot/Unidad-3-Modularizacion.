; Alumno: Alexis Serrano Salomon
; Práctica: Manejo de cadena vacia
; Descripción: pide una cadena de texto al usuario y cuenta cuantos caracteres tiene usando un procedimiento aparte. Si le dan puro Enter (longitud 0), avisa que esta vacia y la vuelve a pedir.

INCLUDE Irvine32.inc

TAM_MAX EQU 100   ; limite maximo de caracteres que vamos a aceptar

.data
    txtIngreso   BYTE "Ingresa un texto: ", 0
    txtVacio     BYTE "Error: no escribiste nada, intenta otra vez.", 0
    txtTotal     BYTE "Total de caracteres: ", 0
    txtResultado BYTE "Texto guardado: ", 0
    cadenaEntrada BYTE TAM_MAX+1 DUP(0) ; espacio en memoria para guardar lo que tecleen mas el cero del final

.code
main PROC

Capturar:
    ; mostramos el mensaje para pedir el texto
    mov  edx, OFFSET txtIngreso
    call WriteString

    ; preparamos los registros y leemos lo que escriba el usuario
    mov  edx, OFFSET cadenaEntrada
    mov  ecx, TAM_MAX
    call ReadString

    ; mandamos la direccion de la cadena al esi para que el procedimiento la cuente
    mov  esi, OFFSET cadenaEntrada
    call ContarCaracteres       ; nos regresa el total de letras en el eax

    ; checamos si el contador quedo en cero (o sea, que nomas le dio Enter)
    cmp  eax, 0
    jne  Imprimir         ; si si escribio algo, brincamos a mostrar los datos

    ; si estaba vacia, le tiramos el aviso y regresamos a pedirla de nuevo
    mov  edx, OFFSET txtVacio
    call WriteString
    call Crlf
    jmp  Capturar

Imprimir:
    ; imprimimos cuantos caracteres tuvo la cadena (el numero sigue guardado en eax)
    mov  edx, OFFSET txtTotal
    call WriteString
    call WriteDec
    call Crlf

    ; mostramos el texto tal cual quedo guardado
    mov  edx, OFFSET txtResultado
    call WriteString
    mov  edx, OFFSET cadenaEntrada
    call WriteString
    call Crlf

    exit
main ENDP

; ...
; Procedimiento: ContarCaracteres
; Entrada: ESI = direccion de la cadena
; Salida : EAX = cantidad de caracteres (sin contar el nulo)
; ...
ContarCaracteres PROC
    push esi         ; respaldamos el esi en la pila para regresarlo intacto al final
    mov  eax, 0             ; iniciamos el contador de caracteres en cero

CicloConteo:
    cmp  BYTE PTR [esi], 0  ; revisamos si ya topamos con el cero que marca el fin de la cadena
    je   TerminarConteo    ; si ya llegamos al final, nos salimos del ciclo

    inc  eax               ; sumamos 1 al contador de letras
    inc  esi            ; avanzamos al siguiente caracter
    jmp  CicloConteo     ; repetimos la vuelta

TerminarConteo:
    pop  esi    ; sacamos el valor original del esi de la pila
    ret
ContarCaracteres ENDP

END main