; Alumno: Alexis Serrano Salomon
; Práctica: Procedimientos anidados
; Descripción: ejemplo de llamadas en cadena (anidadas): main manda llamar a ImprimirInforme, este llama a ImprimirTitulo, y ese ultimo a ImprimirLinea. Cada quien avisa cuando entra y cuando sale para ver en que orden se va apilando y regresando todo.

INCLUDE Irvine32.inc

.data
    ; mensajes de control para ver el orden en que entran y salen los procedimientos
    txtInicioInforme  BYTE "--> Entrando a ImprimirInforme", 0
    txtInicioTitulo   BYTE "--> Entrando a ImprimirTitulo", 0
    txtInicioLinea    BYTE "--> Entrando a ImprimirLinea", 0
    txtFinLinea       BYTE "<-- Saliendo de ImprimirLinea", 0
    txtFinTitulo      BYTE "<-- Saliendo de ImprimirTitulo", 0
    txtFinInforme     BYTE "<-- Saliendo de ImprimirInforme", 0

    ; textos que va a imprimir cada nivel del reporte
    borde             BYTE "======================", 0
    encabezado        BYTE "INFORME DE RESULTADOS", 0
    contenido         BYTE "Contenido principal del informe", 0
    txtTerminado      BYTE "Programa finalizado con exito.", 0

.code
main PROC
    ; aqui se guarda en la pila el regreso al main
    call ImprimirInforme

    ; cuando ya regresaron todos los procedimientos, seguimos aqui
    mov  edx, OFFSET txtTerminado
    call WriteString
    call Crlf

    exit
main ENDP

; ...
; Nivel 1: ImprimirInforme
; Avisa que entro, brinca al titulo, imprime el contenido y sale
; ...
ImprimirInforme PROC
    mov  edx, OFFSET txtInicioInforme
    call WriteString
    call Crlf

    ; llamamos al segundo nivel para que se meta otra direccion de retorno encima de la del main
    call ImprimirTitulo

    ; esto se imprime hasta que ImprimirTitulo haya terminado todo su show
    mov  edx, OFFSET contenido
    call WriteString
    call Crlf

    mov  edx, OFFSET txtFinInforme
    call WriteString
    call Crlf

    ret  ; sacamos de la pila la direccion para volver al main
ImprimirInforme ENDP

; ..
; Nivel 2: ImprimirTitulo
; Avisa que entro, brinca a la linea, imprime el encabezado y sale
; ...
ImprimirTitulo PROC
    mov  edx, OFFSET txtInicioTitulo
    call WriteString
    call Crlf

    ; llamamos al tercer nivel (ya van tres direcciones de retorno apiladas)
    call ImprimirLinea

    ; el encabezado sale justo despues de que se dibuje la linea de iguales
    mov  edx, OFFSET encabezado
    call WriteString
    call Crlf

    mov  edx, OFFSET txtFinTitulo
    call WriteString
    call Crlf

    ret     ; sacamos de la pila la direccion para volver a ImprimirInforme
ImprimirTitulo ENDP

; ...
; Nivel 3: ImprimirLinea
; El nivel mas profundo: entra, dibuja la linea y se regresa sin llamar a nadie mas
; ...
ImprimirLinea PROC
    mov  edx, OFFSET txtInicioLinea
    call WriteString
    call Crlf

    mov  edx, OFFSET borde
    call WriteString
    call Crlf

    mov  edx, OFFSET txtFinLinea
    call WriteString
    call Crlf

    ret  ; sacamos la direccion de la cima pa regresar a ImprimirTitulo
ImprimirLinea ENDP

END main