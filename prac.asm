.MODEL SMALL
.RADIX 16
.STACK
;; PILA
.DATA
;; VARIABLES
nueva_linea  db      0a,"$"
    ;; ENCABEZADO
usac        db      "Universidad de San Carlos de Guatemala",0a,"$" ;; 0a -> nueva linea
facultad    db      "Facultad de Ingenieria",0a,"$"
escuela     db      "Escuela de vacaciones",0a,"$"
curso       db      "Arquitectura de Computadoras y Ensambladores 1",0a,"$"
nombre      db      "Nombre: Christopher Alexander Acajabon Gudiel",0a,"$"
carnet      db      "Carnet: 201404278",0a,"$"
    ;; ACCESO
archivo_acceso      db  "PRA2.CNF",00 ;; 00 -> caracter nulo, lo pide el archivo (cadena ASCIZ)
error_acceso        db  "Archivo no encontrado o error de credenciales",0a,"$"
handle_acceso       dw  0000 ;; para guardar puntero archivo abierto
buffer_acceso_leido db  43  dup (0),"$" ; 57d $ -> indica cuando voy a parar
nombre_acceso       db  "cgudiel"
clave_acceso        db  "201404278"
buffer_leido_actual db  43   dup (0) ; 57d, buffer donde estara el nombre y password extraidos del archivo
contador_buffer_bia     dw  0 ; para limpiar el buffer_leido_actual
contador_actual_comilla  dw 0 ; indice para saber desde donde voy a ler del buffer_acceso_leido
comillas            db '"'

.CODE
.STARTUP
;; CODIGO
inicio:

call acceso

acceso proc
        ;; abrir archivo
    mov al, 02
    mov dx, offset archivo_acceso
    mov ah, 3d
    int 21
    jc eti_error_acceso ; si cf = 1 hay error
    mov [handle_acceso], ax ;; guardamos handles del archivo abierto

        ;; lectura de archivo
    mov bx, [handle_acceso]
    mov cx, 38 ; 56d bytes
    mov dx, offset buffer_acceso_leido
    mov ah, 3f
    int 21
    jc eti_error_acceso

    mov contador_actual_comilla, 0
    call limpiar_buffer_leido_actual
    call extraer_contenido_comillas

    mov dx, offset buffer_leido_actual
    mov ah, 09
    int 21

    inc contador_actual_comilla
    call limpiar_buffer_leido_actual
    call extraer_contenido_comillas

    mov dx, offset buffer_leido_actual
    mov ah, 09
    int 21


        ; imprimir archivo
    ; call imprimir_estructura

        ;; cerrar archivo, bx ya esta en handle_acceso
    ; mov bx, [handle_acceso]
    ; mov ah, 3e
    ; int 21

    call encabezado
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

extraer_contenido_comillas proc

    buscar_comilla:
        mov bx, contador_actual_comilla
        mov al, buffer_acceso_leido[bx]
        cmp al, comillas
        jne siguiente_caracter ;; si no es comilla avanza al siguiente caracer
        inc contador_actual_comilla ;; si llega aca, encontro comilla, pasa al metodo de abajo

    guardar_caracteres_entre_comillas:
        mov bx, contador_actual_comilla
        mov al, buffer_acceso_leido[bx]
        cmp al, comillas
        je fin_extraccion ;; si es comilla, fin extraccion
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], al ;; guardamos caracter
        inc contador_buffer_bia
        inc contador_actual_comilla
        jmp guardar_caracteres_entre_comillas ;; avanza al siguiente caracter

    siguiente_caracter:
        inc contador_actual_comilla
        mov bx, contador_actual_comilla
        cmp buffer_acceso_leido[bx], 24 ; $ hex h ***********
        jne buscar_comilla ; si no es fin de cadena, siguiente caracter

    fin_extraccion:
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], 24 ; $ hex
        ret

extraer_contenido_comillas endp


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

    eti_error_acceso:
        mov dx, offset error_acceso
        mov ah, 09
        int 21
        jmp fin

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
fin:
.EXIT
END
