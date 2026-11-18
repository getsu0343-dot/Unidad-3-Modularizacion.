; Alumno: Alexis Serrano Salomon
; Práctica: Macros
; Descripción: un ejemplo sencillo para ver la diferencia entre usar una macro para imprimir mensajes con salto de linea y aventarse todas las instrucciones a mano cada vez que ocupamos mostrar algo.

INCLUDE Irvine32.inc           

; ...
; Macro: ImprimirTexto
; Descripción: agarra cualquier cadena que le pasemos por parametro, la imprime en pantalla y baja un renglon.
; ...

ImprimirTexto MACRO cadena
    mov  edx, OFFSET cadena    ; cargamos la direccion de la cadena al edx
    call WriteString        ; imprimimos hasta topar con el cero del final
    call Crlf      ; damos el salto de linea
ENDM

.data
    msgUno BYTE "QUE ONDA PLEBES, LISTOS PARA ASM?", 0
    msgDos BYTE "HOY NOS TOCA REVISAR EL TEMA DE MACROS.", 0

.code
main PROC
    ; --- FORMA 1: USANDO LA MACRO ---
    ; mucho mas limpio y rapido, nomas mandamos llamar la macro y le pasamos el mensaje
    ImprimirTexto msgUno
    ImprimirTexto msgDos

    ; --- FORMA 2: A MANO SIN MACRO---
    ; hace exactamente lo mismo pero tenemos que repetir todo por cada mensaje
    mov  edx, OFFSET msgUno
    call WriteString
    call Crlf

    mov  edx, OFFSET msgDos
    call WriteString
    call Crlf

    exit     ; salimos del programa y le regresamos el control a Windows
main ENDP

END main