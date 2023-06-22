.MODEL SMALL
.RADIX 16
.STACK
;; PILA
.DATA
;; VARIABLES
nueva_linea         db  0a,"$"
contador_global     dw  0
str_elegir_opcion   db  "Elija una opcion:",0a,"$"
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
str_cred_correctas      db  "Credenciales correctas, enter para continuar",0a,"$"
handle_acceso           dw  0000 ;; para guardar puntero archivo abierto
buffer_acceso_leido     db  99  dup (0),"$" ; 153d $ -> indica cuando voy a parar
str_credenciales        db  "credenciales"
str_usuario_lit         db  "usuario="
str_clave_lit           db  "clave="
str_nombre_acceso       db  "cgudiel"
str_clave_acceso        db  "201404278"
buffer_leido_actual     db  99   dup (0) ; 153d, buffer donde estara el nombre y password extraidos del archivo
contador_buffer_bia     dw  0 ; para limpiar el buffer_leido_actual
cont_actual_caracer     dw 0 ; indice para saber desde donde voy a ler del buffer_acceso_leido
comillas            db '"'
corchete_abre       db '['
corchete_cierre     db ']'
igual_simbolo       db  '='
    ;; MENU PRINCIPAL
str_menu_princ          db  "---Menu Principal---",0a,"$"
str_menu_princ_prod     db  "(P)roductos",0a,"$"
str_menu_princ_vent     db  "(V)entas",0a,"$"
str_menu_princ_repo     db  "(R)eportes",0a,"$"
    ;; MENU PRODUCTOS
str_menu_prod          db  "---Menu Productos---",0a,"$"
str_menu_prod_ingre    db  "(I)ngresar producto",0a,"$"
str_menu_prod_borra    db  "(B)orrar producto",0a,"$"
str_menu_prod_mostr    db  "(M)ostrar productos",0a,"$"
str_nombre_arch_prod   db   "PROD.BIN",00
handle_productos       dw   0000
    ;; ESTRUCTURA PRODUCTOS
estruct_prod_codigo    db 05 dup(0)
estruct_prod_descrip   db 21 dup(0) ; 33d
estruct_prod_precio    dw 0000
estruct_prod_unidads   dw 0000

;; primer byte, longitud maxima de entrada, segundo byte, el segundo byte contiene la longitud real de la línea anterior, 
;; al devolver el segundo byte contienen la longitud real, el tercer byte y los subsiguientes contienen la línea de entrada
; buffer_producto     db 21, 00, 21 dup (0) ; 33d -> otra forma de declarar
buffer_producto     db 21, 00 
                    db 21 dup (0) ; 33d
str_titulo_prod     db    "-PRODUCTOS-",0a,"$"
str_pedir_codigo    db    "Codigo: ","$"
str_pedir_nombre    db    "Nombre: ","$"
str_pedir_precio    db    "Precio: ","$"
str_pedir_unidad    db    "Unidades: ","$"



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
    mov cx, 99 ; 153d bytes
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
    mov dx, offset buffer_leido_actual
    mov ah, 09
    int 21
    call print_nueva_linea

        ;; extraemos palabra ya sea 'usuario=' o 'clave='
    call limpiar_buffer_leido_actual
    mov di, offset corchete_cierre
    mov si, offset comillas
    call extraer_contenido_entre_caracteres
        ;; imprimimos que encontro
    ; mov dx, offset buffer_leido_actual
    ; mov ah, 09
    ; int 21    
    ; call print_nueva_linea

        ;; comparamos si es campo 'usuario='
    mov si, offset buffer_leido_actual
    mov di, offset str_usuario_lit
    mov cx, 0007 ;; cantidad de caracteres a comparar
    call comparar_cadenas
    cmp dl, 0ff
    je es_campo_usuario

        ;; comparamos si es campo 'clave='
    mov si, offset buffer_leido_actual
    mov di, offset str_clave_lit
    mov cx, 0005 ;; cantidad de caracteres a comparar
    call comparar_cadenas
    cmp dl, 0ff
    je es_campo_clave

    jmp eti_error_cred_acceso ; ni usuario ni clave

    es_campo_usuario:
            ;; extraemos nombre
        ; inc cont_actual_caracer
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
        ; call print_nueva_linea

            ;; extraemos 'clave='
        call limpiar_buffer_leido_actual
        mov di, offset comillas
        mov si, offset comillas
        call extraer_contenido_entre_caracteres
            ;; imprimimos que encontro
        ; mov dx, offset buffer_leido_actual
        ; mov ah, 09
        ; int 21
        ; call print_nueva_linea

        ;; extraemos clave
        ; inc cont_actual_caracer
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
        ; call print_nueva_linea
        jmp ingresar_a_sistema
         
    es_campo_clave:
           ;; extraemos clave
        ; inc cont_actual_caracer
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
        ; call print_nueva_linea

        ;; extraemos 'nombre='
        call limpiar_buffer_leido_actual
        mov di, offset comillas
        mov si, offset comillas
        call extraer_contenido_entre_caracteres
            ;; imprimimos que encontro
        ; mov dx, offset buffer_leido_actual
        ; mov ah, 09
        ; int 21
        ; call print_nueva_linea

        ;; extraemos nombre
        ; inc cont_actual_caracer
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
        ; call print_nueva_linea
        jmp ingresar_a_sistema

    ingresar_a_sistema: 

            ;; cerrar archivo, bx esta el handle_acceso
        mov bx, [handle_acceso]
        mov ah, 3e
        int 21

        call print_nueva_linea

        mov dx, offset str_cred_correctas
        mov ah, 09
        int 21

        es_enter:
            mov ah, 08
            int 21
            cmp al, 0d ; enter 
            je menu_principal
            jmp es_enter    
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
        cmp al, 20 ;; espacio (ignoramos)
        je ignorar_caracteres
        cmp al, 0a ;; nueva linea (ignoramos)
        je ignorar_caracteres
        cmp al, 0d ;; retorno de carro (ignoramos)
        je ignorar_caracteres
        mov bx, contador_buffer_bia
        mov buffer_leido_actual[bx], al ;; guardamos caracter
        inc contador_buffer_bia
        inc cont_actual_caracer
        jmp guardar_caracter_extraido ;; avanza al siguiente caracter

    ignorar_caracteres:
        inc cont_actual_caracer
        jmp guardar_caracter_extraido

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

;; ---------------------------------------------------------- MENU PRINCIPAL ------------------------------------------------------------------
menu_principal:

    call print_nueva_linea

        ;; Mostrar Menú
    mov dx, offset str_menu_princ
    mov ah, 09
    int 21
    mov dx, offset str_menu_princ_prod
    mov ah, 09
    int 21
    mov dx, offset str_menu_princ_vent
    mov ah, 09
    int 21
    mov dx, offset str_menu_princ_repo
    mov ah, 09
    int 21
    mov dx, offset str_elegir_opcion
    mov ah, 09
    int 21

        ;; Leer entrada, 1 caracter
    mov ah, 08
    int 21
        ;; AL = esta el caracter leido
    cmp al, 70 ; p minúscula
    je menu_productos
    cmp al, 76 ; v minúscula
    je fin 
    cmp al, 72 ; r minúscula
    je fin 
    jmp menu_principal

menu_productos:
    call print_nueva_linea

        ;; Mostrar Menú
    mov dx, offset str_menu_prod
    mov ah, 09
    int 21
    mov dx, offset str_menu_prod_ingre
    mov ah, 09
    int 21
    mov dx, offset str_menu_prod_borra
    mov ah, 09
    int 21
    mov dx, offset str_menu_prod_mostr
    mov ah, 09
    int 21
    mov dx, offset str_elegir_opcion
    mov ah, 09
    int 21

        ;; Leer entrada, 1 caracter
    mov ah, 08
    int 21
        ;; AL = esta el caracter leido
    cmp al, 69 ; i minúscula
    je ingresar_producto
    cmp al, 62 ; b minúscula
    je fin 
    cmp al, 6d ; m minúscula
    je fin 
    jmp menu_productos

ingresar_producto:
    call print_nueva_linea
    mov dx, offset str_titulo_prod
    mov ah, 09
    int 21
    call print_nueva_linea
pedir_codigo_prod:
    mov dx, offset str_pedir_codigo
    mov ah, 09
    int 21

    call print_nueva_linea

    mov dx, offset buffer_producto ;; int -> buffered keyboard input
    mov ah, 0a
    int 21

    call print_nueva_linea
        ;; verificar que el codigo no este vacio
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 00
    je pedir_codigo_prod

        ;; verificar caraceres
    mov di, offset buffer_producto
    inc di
    mov ch, 00
    mov cl, [di] ; tamano leido
    inc di ; contenido de bufer
    call validar_codigo_prod
    cmp dl, 0ff
    jne pedir_codigo_prod
    
    ;; verificar tamanio menor a 4
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 04
    ja pedir_codigo_prod ;; si es mayor que 4
    
    call copiar_codigo_producto

    call print_nueva_linea
    call imprimir_estructura
    jmp fin
    


validar_codigo_prod proc
    ;; ENTRADA
        ;; DI -> direccion de cadena, este caso buffer lecturas
        ;; CX -> tamanio
    ;; SALIDA
        ;; DL -> 00 no valido
        ;;    -> 0ff si es validio  

    ;;  numeros estan de 0-9 -> 30-39; letras estan de A-Z -> 41-5A
    verificar_si_es_letra:
        mov al, [di]
            ; validar que sea fin de cadena
        cmp al, 'A'
        jb varificar_si_es_numero ; si es menor, puede que sea numero
        cmp al, 'Z'
        ja caracter_invalido ; si es mayor, ya no puede ser numero
        inc di ; si llega aqui, estan entre [A-Z]
        loop verificar_si_es_letra
        jmp fin_validar
    
    varificar_si_es_numero:
        cmp al, '0'
        jb caracter_invalido ; si es menor
        cmp al, '9'
        ja caracter_invalido ; si es mayor, ya no puede ser letra
        inc di ; si llega aqui, esta entre [0-9]
        loop verificar_si_es_letra
        jmp fin_validar
    
    caracter_invalido:
        mov dl, 00 ;; entrada invalida
        ret

    fin_validar:
        mov dl, 0ff ; son iguales
        ret
    
validar_codigo_prod endp

copiar_codigo_producto proc
    codigo_aceptado:
        mov si, offset estruct_prod_codigo
        mov di, offset buffer_producto
        inc di
        mov ch, 00
        mov cl, [di]
        inc di ;; posicion del contenido del buffer

    copiar_codigo_aceptado:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_codigo_aceptado
        call print_nueva_linea
        ret
copiar_codigo_producto endp

print_nueva_linea proc
    mov dx, offset nueva_linea
    mov ah, 09
    int 21
    ret
print_nueva_linea endp

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

imprimir_estructura proc
    mov DI, offset estruct_prod_codigo ; <-- cambiar aqui
    ciclo_buscar_posicion_null:
            mov AL, [DI]
            cmp AL, 00 ; para cuando encuenra 0
            je poner_dolar_al_final
            inc DI
            jmp ciclo_buscar_posicion_null
    poner_dolar_al_final:
            mov AL, 24  ;; agregar dolar al final
            mov [DI], AL
            ;; imprimir normal
            mov DX, offset estruct_prod_codigo ; <-- cambiar aqui
            mov AH, 09
            int 21
            mov DX, offset nueva_linea
            mov AH, 09
            int 21
            ret    
imprimir_estructura endp

fin:
.EXIT
END
