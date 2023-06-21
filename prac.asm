.MODEL SMALL
.RADIX 16
.STACK
;; PILA
.DATA
;; VARIABLES
nueva_linea  db      0a,"$"
contador_global dw  0
    ;; ENCABEZADO
usac        db      "Universidad de San Carlos de Guatemala",0a,"$" ;; 0a -> nueva linea
facultad    db      "Facultad de Ingenieria",0a,"$"
escuela     db      "Escuela de vacaciones",0a,"$"
curso       db      "Arquitectura de Computadoras y Ensambladores 1",0a,"$"
nombre      db      "Nombre: Christopher Alexander Acajabon Gudiel",0a,"$"
carnet      db      "Carnet: 201404278",0a,"$"
    ;; ACCESO
archivo_acceso          db  "PRA2.CNF",00 ;; 00 -> caracter nulo, lo pide el archivo (cadena ASCIZ)
str_error_acceso_arch   db  "Archivo no encontrado",0a,"$"
str_error_acceso_cont   db  "Error estructura o credenciales",0a,"$"
handle_acceso           dw  0000 ;; para guardar puntero archivo abierto
buffer_acceso_leido     db  43  dup (0),"$" ; 57d $ -> indica cuando voy a parar
str_credenciales        db  "credenciales"
str_nombre_acceso       db  "cgudiel"
str_clave_acceso        db  "201404278"
buffer_leido_actual     db  43   dup (0) ; 57d, buffer donde estara el nombre y password extraidos del archivo
contador_buffer_bia     dw  0 ; para limpiar el buffer_leido_actual
cont_actual_caracer     dw 0 ; indice para saber desde donde voy a ler del buffer_acceso_leido
comillas            db '"'
corchete_abre       db '['
corchete_cierre     db ']'

.CODE
.STARTUP
;; CODIGO
inicio:

;; ---------------------------------------------------------- ACCESO ------------------------------------------------------------------
call acceso

acceso proc

    call encabezado

        ;; abrir archivo
    mov al, 02
    mov dx, offset archivo_acceso
    mov ah, 3d
    int 21
    jc eti_error_archivo_acceso ; si cf = 1 hay error
    mov [handle_acceso], ax ;; guardamos handles del archivo abierto

        ;; lectura de archivo
    mov bx, [handle_acceso]
    mov cx, 38 ; 56d bytes
    mov dx, offset buffer_acceso_leido
    mov ah, 3f
    int 21
    jc eti_error_archivo_acceso

        ;; extraemos parte de [credenciales]
    mov cont_actual_caracer, 0
    call limpiar_buffer_leido_actual
    mov di, offset corchete_abre
    mov si, offset corchete_cierre
    call extraer_contenido_entre_caracteres
        ;; comparamos nombre credenciales
    mov si, offset buffer_leido_actual
    mov di, offset str_credenciales
    mov cx, 000ch ;; 12d, cantidad de caracteres a comparar
    call comparar_cadenas
    cmp dl, 0ff
    jne eti_error_cred_acceso
        ;; imprimir literal 'credenciales'
    ; mov dx, offset buffer_leido_actual
    ; mov ah, 09
    ; int 21

        ;; extraemos nombre
    inc cont_actual_caracer
    call limpiar_buffer_leido_actual
    mov di, offset comillas
    mov si, offset comillas
    call extraer_contenido_entre_caracteres
        ;; comparamos nombre
    mov si, offset buffer_leido_actual
    mov di, offset str_nombre_acceso
    mov cx, 0007 ;; cantidad de caracteres a comparar
    call comparar_cadenas
    cmp dl, 0ff
    jne eti_error_cred_acceso
        ;; imprimir nombre
    ; mov dx, offset buffer_leido_actual
    ; mov ah, 09
    ; int 21

        ;; extraemos clave
    inc cont_actual_caracer
    call limpiar_buffer_leido_actual
    mov di, offset comillas
    mov si, offset comillas
    call extraer_contenido_entre_caracteres
        ;; comparamos clave
    mov si, offset buffer_leido_actual
    mov di, offset str_clave_acceso
    mov cx, 0009
    call comparar_cadenas
    cmp dl, 0ff
    jne eti_error_cred_acceso
        ;; imprimir clave
    ; mov dx, offset buffer_leido_actual
    ; mov ah, 09
    ; int 21

        ;; cerrar archivo, bx esta el handle_acceso
    mov bx, [handle_acceso]
    mov ah, 3e
    int 21

    jmp fin    
acceso endp

limpiar_buffer_leido_actual proc
    mov contador_buffer_bia, 0
    begin_clear:
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], 0
        inc contador_buffer_bia
        cmp contador_buffer_bia, 43 ; 57d
        jne begin_clear

    mov contador_buffer_bia, 0
    ret
limpiar_buffer_leido_actual endp

extraer_contenido_entre_caracteres proc
    ;; ENTRADA -> "nombre" -> para extraer 'nombre' primer caracter es ", segundo caracter es "
        ;; DI -> primer caracter
        ;; SI -> segundo caracter
    buscar_comilla:
        mov bx, cont_actual_caracer
        mov al, buffer_acceso_leido[bx]
        cmp al, [di] ;; caracter donde empezar la extraccion
        jne siguiente_caracter ;; si no es caracter donde empezar extraccion avanza al siguiente caracer
        inc cont_actual_caracer ;; si llega aca, encontro comilla, pasa al metodo de abajo

    guardar_caracter_extraido:
        mov bx, cont_actual_caracer
        mov al, buffer_acceso_leido[bx]
        cmp al, [si] ;; caracter donde termina la extraccion
        je fin_extraccion ;; si es caracter donde termina extraccion, fin extraccion
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], al ;; guardamos caracter
        inc contador_buffer_bia
        inc cont_actual_caracer
        jmp guardar_caracter_extraido ;; avanza al siguiente caracter

    siguiente_caracter:
        inc cont_actual_caracer
        mov bx, cont_actual_caracer
        cmp buffer_acceso_leido[bx], 24 ; $ hex h ***********
        jne buscar_comilla ; si no es fin de cadena, siguiente caracter

    fin_extraccion:
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], 24 ; $ hex
        ret

extraer_contenido_entre_caracteres endp

imprimir_estructura proc
    mov DI, offset buffer_acceso_leido
    ciclo_buscar_posicion_null:
            mov AL, [DI]
            cmp AL, 00
            je poner_dolar_al_final
            inc DI
            jmp ciclo_buscar_posicion_null
    poner_dolar_al_final:
            mov AL, 24  ;; agregar dolar al final
            mov [DI], AL
            ;; imprimir normal
            mov DX, offset buffer_acceso_leido
            mov AH, 09
            int 21
            mov DX, offset nueva_linea
            mov AH, 09
            int 21
            ret    
    imprimir_estructura endp

eti_error_archivo_acceso:
    mov dx, offset str_error_acceso_arch
    mov ah, 09
    int 21
    jmp fin

eti_error_cred_acceso:
    mov dx, offset str_error_acceso_cont
    mov ah, 09
    int 21
    jmp fin

;; ---------------------------------------------------------- ENCABEZADO ------------------------------------------------------------------

    ;; ENCABEZADO
encabezado proc
    mov dx, offset usac
    mov ah, 09 ;; print string
    int 21
    mov dx, offset facultad
    mov ah, 09
    int 21
    mov dx, offset escuela
    mov ah, 09
    int 21
    mov dx, offset curso
    mov ah, 09
    int 21
    mov dx, offset nueva_linea
    mov ah, 09
    int 21
    mov dx, offset nombre
    mov ah, 09
    int 21
    mov dx, offset carnet
    mov ah, 09
    int 21
    ret    
encabezado endp

comparar_cadenas proc
    ;; ENTRADA
        ;; SI -> direccion de cadena 1
        ;; DI -> direccion de cadena 2
        ;; CX -> tamano maximo
    ;; SALIDA
        ;; DL -> 00 si no son iguales
        ;;    -> 0ff si son iguales

    ciclo_cadenas_iguales:
        mov al, [si]
        cmp [di], al
        jne no_iguales
        inc di
        inc si
        loop ciclo_cadenas_iguales ;; el loop baja en 1 automaticamente, segun lo que tenga cx
        mov dl, 0ff ;; son iguales
        ret
    no_iguales:
        mov dl, 00 ;; no son iguales
        ret
comparar_cadenas endp

fin:
.EXIT
END
