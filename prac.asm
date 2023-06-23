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
separador_print_consol  db  "====================",0a,"$"
    ;; MENU PRINCIPAL
str_menu_princ          db  "---Menu Principal---",0a,"$"
str_menu_princ_prod     db  "(P)roductos",0a,"$"
str_menu_princ_vent     db  "(V)entas",0a,"$"
str_menu_princ_repo     db  "(R)eportes",0a,"$"
    ;; MENU PRODUCTOS
str_menu_prod          db  "---MENU PRODUCTOS---",0a,"$"
str_menu_prod_ingre    db  "(I)ngresar producto",0a,"$"
str_menu_prod_borra    db  "(B)orrar producto",0a,"$"
str_menu_prod_mostr    db  "(M)ostrar productos",0a,"$"
str_nombre_arch_prod   db   "PROD.BIN",00
handle_productos       dw   0000
    ;; MENU REPORTES
str_menu_reporte       db  "---MENU REPORTES---",0a,"$"
str_menu_reporte_cat   db   "(1) Catalogo completo",0a,"$"
str_menu_reporte_abc   db   "(2) Alfabetico de productos",0a,"$"
str_menu_reporte_vent  db   "(3) Ventas",0a,"$"
str_menu_reporte_exis  db   "(4) Sin existencias",0a,"$"
    ;; ESTRUCTURA PRODUCTOS
estruct_prod_codigo    db 05 dup(0)
estruct_prod_descrip   db 21 dup(0) ; 33d
estruct_prod_precio    db 05 dup (0)
estruct_prod_unidads   db 05 dup (0)
num_precio_prod        dw  0000
num_unidades_prod      dw  0000
ceros_relleno_para_eliminar     db 2c dup(0) ; 44d -> 4 + 32 + 4 + 4
    ;; REPORTE HTML
str_html_inicio  db '<html><head><title>Catalogo</title></head><body style="display: flex; justify-content: center; align-items: center;">'
str_html_inicio_fecha db '<table style="border-collapse: collapse; margin: 25px 0; font-size: 1em; font-family: sans-serif; min-width: 80vw; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);"><tr style="background-color: maroon; color: #ffffff; text-align: middle;"><td colspan="4">'
str_html_fin_fecha db '</td></tr>'
str_html_encabezado_tabla_catalogo db '<tr style="background-color: coral; color: #ffffff; text-align: middle;"><td>Codigo</td><td>Descripcion</td><td>Precio</td><td>Unidades</td></tr>'
str_html_inicio_fila db "<tr>"
str_html_inicio_columna db "<td>"
str_html_fin_columna db "</td>"
str_html_fin_fila db "</tr>"
str_html_fin     db "</table></body></html>"
str_nombre_reporte_catalogo db "CATALG.HTM",00
str_nombre_reporte_sin_existencias db "FALTA.HTM",00
handle_reporte_catalogo dw  0000
handle_reporte_sin_existencia dw  0000

numero_ya_en_cadena db 05 dup (30)

;; primer byte, longitud maxima de entrada 
;; segundo byte contienen la longitud real
;; tercer byte y los subsiguientes contienen la entrada
; buffer_producto     db 21, 00, 21 dup (0) ; 33d -> otra forma de declarar
buffer_producto     db 21, 00 
                    db 21 dup (0) ; 33d
str_titulo_prod_ingresar db    "-INGRESAR PRODUCTO-",0a,"$"
str_titulo_prod_eliminar db    "-ELIMINAR PRODUCTO-",0a,"$"
str_titulo_prod_eliminado db    "-PRODUCTO ELIMINADO-",0a,"$"
str_titulo_prod_no_se_encontro db    "-NO SE ENCONTRO PRODUCTO-",0a,"$"
str_pedir_codigo    db    "Codigo: ","$"
str_pedir_nombre    db    "Nombre: ","$"
str_pedir_precio    db    "Precio: ","$"
str_pedir_unidad    db    "Unidades: ","$"

; para buscar y eliminar
estruct_prod_codigo_temporal    db  05 dup(0)
puntero_buscar_producto_cod     dw  0000

;; anio, mes, dia
anio_actual dw 0000
mes_actual db ?
dia_actual db ?
di_actual_cadena db 3 dup('$');

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
    je menu_reportes 
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
    je eliminar_producto 
    cmp al, 6d ; m minúscula
    je mostrar_productos 
    jmp menu_principal

menu_reportes:
    call print_nueva_linea

        ;; Mostrar Menú
    mov dx, offset str_menu_reporte
    mov ah, 09
    int 21
    mov dx, offset str_menu_reporte_cat
    mov ah, 09
    int 21
    mov dx, offset str_menu_reporte_abc
    mov ah, 09
    int 21
    mov dx, offset str_menu_reporte_vent
    mov ah, 09
    int 21
    mov dx, offset str_menu_reporte_exis
    mov ah, 09
    int 21
    mov dx, offset str_elegir_opcion
    mov ah, 09
    int 21

        ;; Leer entrada, 1 caracter
    mov ah, 08
    int 21
        ;; AL = esta el caracter leido
    cmp al, 31 ; 1d
    je generar_reporte_catalogo
    cmp al, 32 ; 2d
    je fin 
    cmp al, 33 ; 3d
    je fin 
    cmp al, 34 ; 4d
    je generar_reporte_sin_existencias 
    jmp menu_principal

ingresar_producto:
    call print_nueva_linea
    mov dx, offset str_titulo_prod_ingresar
    mov ah, 09
    int 21
    call print_nueva_linea

pedir_codigo_prod:

    mov di, offset estruct_prod_codigo
    mov cx, 0004 ;
    call memset

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

    jmp pedir_nombre_producto

    ; call print_nueva_linea
    ; call imprimir_estructura
    ; jmp fin
    
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

pedir_nombre_producto:

    mov di, offset estruct_prod_descrip
    mov cx, 0021 ;
    call memset

    call print_nueva_linea
    mov dx, offset str_pedir_nombre
    mov ah, 09
    int 21

    call print_nueva_linea

    mov dx, offset buffer_producto ;; int -> buffered keyboard input
    mov ah, 0a
    int 21

    call print_nueva_linea
        ;; verificar que el nombre no este vacio
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 00
    je pedir_nombre_producto

        ;; verificar caraceres
    mov di, offset buffer_producto
    inc di
    mov ch, 00
    mov cl, [di] ; tamano leido
    inc di ; contenido de bufer
    call validar_nombre_prod
    cmp dl, 0ff
    jne pedir_nombre_producto
    
    ;; verificar tamanio menor a 33
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 20 ; 32d
    ja pedir_nombre_producto ;; si es mayor que 32
    
    call copiar_nombre_producto

    ; call imprimir_estructura

    jmp pedir_precio_producto

validar_nombre_prod proc
    ;; ENTRADA
        ;; DI -> direccion de cadena, este caso buffer lecturas
        ;; CX -> tamanio
    ;; SALIDA
        ;; DL -> 00 no valido
        ;;    -> 0ff si es validio  

    ;;  numeros estan de ! -> 21 // , -> 2c // . -> 2e // 0-9 -> 30-39 // A-Z -> 41-5A // a-z -> 61-7a

    verificar_si_es_signo:
        mov al, [di]
        cmp al, '!'
        je es_signo_admitible
        cmp al, ','
        je es_signo_admitible
        cmp al, '.'
        je es_signo_admitible
        jmp verificar_si_es_letra_min ; no es simbolo admitible

    es_signo_admitible:
        inc di
        loop verificar_si_es_signo

    verificar_si_es_letra_min:
        ; mov al, [di]
            ; validar que sea fin de cadena
        cmp al, 'a'
        jb verificar_si_es_letra_may ; si es menor, puede que sea letra mayuscula
        cmp al, 'z'
        ja caracter_invalido_pn ; si es mayor, ya no puede ser ninguno de los posibles
        inc di ; si llega aqui, estan entre [a-z]
        loop verificar_si_es_signo
        jmp fin_validar_pn

    verificar_si_es_letra_may:
        ; mov al, [di]
            ; validar que sea fin de cadena
        cmp al, 'A'
        jb varificar_si_es_numero_pn ; si es menor, puede que sea numero
        cmp al, 'Z'
        ja caracter_invalido_pn ; si es mayor, ya no puede ser numero
        inc di ; si llega aqui, estan entre [A-Z]
        loop verificar_si_es_signo
        jmp fin_validar_pn
    
    varificar_si_es_numero_pn:
        cmp al, '0'
        jb caracter_invalido_pn ; si es menor
        cmp al, '9'
        ja caracter_invalido_pn ; si es mayor, ya no puede ser letra
        inc di ; si llega aqui, esta entre [0-9]
        loop verificar_si_es_signo
        jmp fin_validar_pn
    
    caracter_invalido_pn:
        mov dl, 00 ;; entrada invalida
        ret

    fin_validar_pn:
        mov dl, 0ff ; son iguales
        ret
    
validar_nombre_prod endp

copiar_nombre_producto proc
    nombre_aceptado:
        mov si, offset estruct_prod_descrip
        mov di, offset buffer_producto
        inc di
        mov ch, 00
        mov cl, [di]
        inc di ;; posicion del contenido del buffer

    copiar_nombre_aceptado:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre_aceptado
        call print_nueva_linea
        ret
copiar_nombre_producto endp

pedir_precio_producto:

    call print_nueva_linea
    mov dx, offset str_pedir_precio
    mov ah, 09
    int 21

    call print_nueva_linea

    mov dx, offset buffer_producto ;; int -> buffered keyboard input
    mov ah, 0a
    int 21

    call print_nueva_linea

        ;; verificar que no este vacio
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 00
    je pedir_precio_producto

        ;; verificar caraceres
    mov di, offset buffer_producto
    inc di
    mov ch, 00
    mov cl, [di] ; tamano leido
    inc di ; contenido de bufer
    call validar_campo_numerico
    cmp dl, 0ff
    jne pedir_precio_producto
    
    ;; verificar tamanio menor a 6
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 05 ; 6d
    ja pedir_precio_producto ;; si es mayor que 5
    
    call copiar_precio_producto

        ;; convertimos
    mov di, offset estruct_prod_precio
    call convertir_cadena_a_numero
    mov [num_precio_prod], ax

        ;; limpiamos
    mov di, offset estruct_prod_precio
    mov cx, 0005
    call memset

    jmp pedir_unidades_producto

copiar_precio_producto proc
    precio_aceptado:
        mov si, offset estruct_prod_precio
        mov di, offset buffer_producto
        inc di
        mov ch, 00
        mov cl, [di]
        inc di ;; posicion del contenido del buffer

    copiar_precio_aceptado:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_precio_aceptado
        call print_nueva_linea
        ret
copiar_precio_producto endp

pedir_unidades_producto:

    call print_nueva_linea
    mov dx, offset str_pedir_unidad
    mov ah, 09
    int 21

    call print_nueva_linea

    mov dx, offset buffer_producto ;; int -> buffered keyboard input
    mov ah, 0a
    int 21

    call print_nueva_linea

        ;; verificar que no este vacio
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 00
    je pedir_unidades_producto

        ;; verificar caraceres
    mov di, offset buffer_producto
    inc di
    mov ch, 00
    mov cl, [di] ; tamano leido
    inc di ; contenido de bufer
    call validar_campo_numerico
    cmp dl, 0ff
    jne pedir_unidades_producto
    
    ;; verificar tamanio menor a 6
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 05 ; 6d
    ja pedir_unidades_producto ;; si es mayor que 5
    
    call copiar_unidades_producto

        ;; convertimos
    mov di, offset estruct_prod_unidads
    call convertir_cadena_a_numero
    mov [num_unidades_prod], ax

        ;; limpiamos
    mov di, offset estruct_prod_unidads
    mov cx, 0005
    call memset

    jmp existencia_archivo_producto ; empezar a guardar producto

copiar_unidades_producto proc
    unidad_aceptada:
        mov si, offset estruct_prod_unidads
        mov di, offset buffer_producto
        inc di
        mov ch, 00
        mov cl, [di]
        inc di ;; posicion del contenido del buffer

    copiar_unidad_aceptada:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_unidad_aceptada
        call print_nueva_linea
        ret
copiar_unidades_producto endp


validar_campo_numerico proc
    ;; ENTRADA
        ;; DI -> direccion de cadena, este caso buffer lecturas
        ;; CX -> tamanio
    ;; SALIDA
        ;; DL -> 00 no valido
        ;;    -> 0ff si es validio  

    ;;  numeros estan 0-9 -> 30-39

    varificar_si_es_numero_ppc:
        mov al, [di]
        cmp al, '0'
        jb caracter_invalido_ppc ; si es menor
        cmp al, '9'
        ja caracter_invalido_ppc ; si es mayor
        inc di ; si llega aqui, esta entre [0-9]
        loop varificar_si_es_numero_ppc
        jmp fin_validar_ppc
    
    caracter_invalido_ppc:
        mov dl, 00 ;; entrada invalida
        ret

    fin_validar_ppc:
        mov dl, 0ff ; son iguales
        ret
    
validar_campo_numerico endp

existencia_archivo_producto:
        ;; abrimos archivo
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21

    jc crear_archivo_producto ; no existe, entonces lo creamos
    jmp guardar_producto_en_archivo

crear_archivo_producto:
    mov cx, 0000
    mov dx, offset str_nombre_arch_prod
    mov ah, 3c
    int 21
    jmp guardar_producto_en_archivo

guardar_producto_en_archivo:
        ;; hasta aqui, archivo ya abierto
    mov [handle_productos], ax

        ;; vamos al final del archivo
    mov bx, [handle_productos]
    mov cx, 00
    mov dx, 00
    mov al, 02
    mov ah, 42
    int 21

        ;; escribimos en el archivo
    mov cx, 0004
    mov dx, offset estruct_prod_codigo
    mov ah, 40
    int 21

    mov cx, 20 ;; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 40
    int 21

    mov cx, 0004
    mov dx, offset num_precio_prod
    mov ah, 40
    int 21

    mov cx, 0004
    mov dx, offset num_unidades_prod
    mov ah, 40
    int 21

        ;; cerrar archivo
    mov ah, 3e
    int 21
    jmp menu_principal    


mostrar_productos:
    call print_nueva_linea

        ;; abrir archivo
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21
    jc menu_productos ; validar por si el archivo no existe
    mov [handle_productos], ax
    jmp ciclo_mostrar_pconsola

ciclo_mostrar_pconsola:
        ; leer archivo
    ; mov bx, [handle_productos]
    ; mov cx, 0024 ; 36d bytes, suma entre cod producto y descripcion
    ; mov dx, offset estruct_prod_codigo
    ; mov ah, 3f
    ; int 21
    
        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004 ; cantidad avanzar
    mov dx, offset estruct_prod_codigo
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0020 ; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_precio_prod
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_unidades_prod
    mov ah, 3f
    int 21

        ;; si se leyeron 0 bytes, se termino el archivo
    cmp ax, 0000
    je fin_mostrar_productos

        ;; valido por si en ese espacio hay producto eliminado
    mov al, 00
    cmp [estruct_prod_codigo], al
    je ciclo_mostrar_pconsola

        ;; separador entre cada producto
    mov dx, offset separador_print_consol
    mov AH, 09
    int 21
    call mostrar_codigo_producto_consola
    call mostrar_descripcion_producto_consola

    jmp ciclo_mostrar_pconsola

fin_mostrar_productos:
        ;; cerrar archivo
    mov bx, [handle_productos]
    mov ah, 3e
    int 21
        ;; pintar separador al final
    mov dx, offset separador_print_consol
    mov AH, 09
    int 21
    jmp menu_principal

mostrar_codigo_producto_consola proc
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
            call print_nueva_linea
            ret    
mostrar_codigo_producto_consola endp

mostrar_descripcion_producto_consola proc
    mov DI, offset estruct_prod_descrip ; <-- cambiar aqui
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
            mov DX, offset estruct_prod_descrip ; <-- cambiar aqui
            mov AH, 09
            int 21
            call print_nueva_linea
            ret    
mostrar_descripcion_producto_consola endp

eliminar_producto:
        ; limpiar o reiniciar puntero
    mov dx, 0000
    mov [puntero_buscar_producto_cod], dx
    call print_nueva_linea
        ; mostramos que es eliminar
    mov dx, offset str_titulo_prod_eliminar
    mov ah, 09
    int 21
    call print_nueva_linea
    jmp pedir_codigo_prod_eliminar

pedir_codigo_prod_eliminar:
    
    mov di, offset estruct_prod_codigo_temporal
    mov cx, 0004 ;
    call memset

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
    je pedir_codigo_prod_eliminar

        ;; verificar caraceres
    mov di, offset buffer_producto
    inc di
    mov ch, 00
    mov cl, [di] ; tamano leido
    inc di ; contenido de bufer
    call validar_codigo_prod
    cmp dl, 0ff
    jne pedir_codigo_prod_eliminar
    
    ;; verificar tamanio menor a 4
    mov di, offset buffer_producto
    inc di
    mov al, [di]
    cmp al, 04
    ja pedir_codigo_prod_eliminar ;; si es mayor que 4
    
    call copiar_codigo_producto_eliminar

        ;; abrir archivo
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21
    jc menu_productos ; validar por si el archivo no existe
    mov [handle_productos], ax

    jmp encontrar_producto_eliminar

encontrar_producto_eliminar:
        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004 ; cantidad avanzar
    mov dx, offset estruct_prod_codigo
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0020 ; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_precio_prod
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_unidades_prod
    mov ah, 3f
    int 21

        ;; si se leyeron 0 bytes, se termino el archivo
    cmp ax, 0000
    je fin_borrar_productos

        ;;
    mov dx, [puntero_buscar_producto_cod]
    add dx, 2c ; 44d estructuras -> 4 + 32 + 4 + 4 
    mov [puntero_buscar_producto_cod], dx

        ;; valido si es producto valido
    mov al, 00
    cmp [estruct_prod_codigo], al
    je encontrar_producto_eliminar

        ;; verificar codigo
    mov si, offset estruct_prod_codigo_temporal
    mov di, offset estruct_prod_codigo
    mov cx, 0004
    call comparar_cadenas
    cmp dl, 0ff
    je borrar_producto

    jmp encontrar_producto_eliminar

borrar_producto:
    mov dx, [puntero_buscar_producto_cod]
    sub dx, 2c ; 2a 46d ; resta
    mov cx, 0000
    mov bx, [handle_productos]
    mov al, 00
    mov ah, 42
    int 21
    ;;; puntero posicionado
    mov cx, 2c ; 2a 44d ; bytes escribir
    mov dx, offset ceros_relleno_para_eliminar
    mov ah, 40
    int 21
    
    ;; cerrar archivo
    mov bx, [handle_productos]
    mov ah, 3e
    int 21
    ;; print
    mov dx, offset str_titulo_prod_eliminado
    mov ah, 09
    int 21

    jmp menu_principal

fin_borrar_productos:
        ;; cerrar archivo
    mov bx, [handle_productos]
    mov ah, 3e
    int 21
        ;; print
    mov dx, offset str_titulo_prod_no_se_encontro
    mov ah, 09
    int 21
    jmp menu_principal

copiar_codigo_producto_eliminar proc
    codigo_aceptado_eli:
        mov si, offset estruct_prod_codigo_temporal
        mov di, offset buffer_producto
        inc di
        mov ch, 00
        mov cl, [di]
        inc di ;; posicion del contenido del buffer

    copiar_codigo_aceptado_eli:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_codigo_aceptado_eli
        call print_nueva_linea
        ret
copiar_codigo_producto_eliminar endp

generar_reporte_catalogo:
        ; crear archivo catalogo
    mov ah, 3c
    mov cx, 0000
    mov dx, offset str_nombre_reporte_catalogo
    int 21
    mov [handle_reporte_catalogo], ax
        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 75 ; 117d
    mov dx, offset str_html_inicio
    int 21
        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 00f8 ; 248d
    mov dx, offset str_html_inicio_fecha
    int 21

    ; aca fecha
    ; call obtener_anio_mes_dia
    ; mov bx, [handle_reporte_catalogo]
    ; mov ah, 40
    ; mov cx, 0005 ; 5d
    ; mov dx, offset dia_actual
    ; int 21

        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 0a ; 10d
    mov dx, offset str_html_fin_fecha
    int 21

        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov cx, 91 ; 145d
    mov dx, offset str_html_encabezado_tabla_catalogo
    int 21

        ; abrimos archivo productos
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21
    jc error_generar_catalogo ; si no existe archivo
    mov [handle_productos], ax
    jmp ciclo_generar_reporte_catalogo
    
obtener_anio_mes_dia proc

    ; DL = day
    ; DH = month
    ; CX = year

    mov ah, 2a
    int 21
    mov dia_actual, dl
    mov mes_actual, dh
    mov anio_actual, cx

    ; mov ax, [anio_actual]
    ; call convertir_numero_a_cadena

    ; mov ah, 09
    ; mov dx, offset dia_actual
    ; int 21

    jmp fin

    ret

obtener_anio_mes_dia endp

error_generar_catalogo:
        ; cerrar archivo catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 3e
    int 21
    jmp menu_principal

ciclo_generar_reporte_catalogo:
        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004 ; cantidad avanzar
    mov dx, offset estruct_prod_codigo
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0020 ; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_precio_prod
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_unidades_prod
    mov ah, 3f
    int 21

        ;; si se leyeron 0 bytes, se termino el archivo
    cmp ax, 0000
    je fin_generar_reporte_catalogo

        ;; valido si es producto valido
    mov al, 00
    cmp [estruct_prod_codigo], al
    je ciclo_generar_reporte_catalogo

        ;; verificar codigo
    call agregar_fila_reporte_catalogo

    jmp ciclo_generar_reporte_catalogo

fin_generar_reporte_catalogo:

    mov bx, [handle_reporte_catalogo] ; <td>
    mov cx, 16 ; 22d
    mov dx, offset str_html_fin
    mov ah, 40
    int 21

        ; cerrar chivo reporte_catalogo
    mov bx, [handle_reporte_catalogo]
    mov ah, 3e
    int 21

        ; cerrar chivo productos
    mov bx, [handle_productos]
    mov ah, 3e
    int 21

    jmp menu_principal

agregar_fila_reporte_catalogo proc
        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_catalogo] ; <tr>
    mov ah, 40
    mov cx, 0004
    ; mov ch, 00
    ; mov cl, 04 ; 4d
    mov dx, offset str_html_inicio_fila
    int 21

    mov bx, [handle_reporte_catalogo] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    mov bx, [handle_reporte_catalogo]
    mov cx, 0004
    mov dx, offset estruct_prod_codigo
    mov ah, 40
    int 21

    mov bx, [handle_reporte_catalogo] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_catalogo] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    mov bx, [handle_reporte_catalogo]
    mov cx, 20 ;; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 40
    int 21

    mov bx, [handle_reporte_catalogo] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_catalogo] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    ; mov ax, [num_precio_prod]
    ; call convertir_numero_a_cadena
    call convertir_todos_ceros_o_normal_precio

    mov bx, [handle_reporte_catalogo]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    mov bx, [handle_reporte_catalogo] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_catalogo] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    ; mov ax, [num_unidades_prod]
    ; call convertir_numero_a_cadena
    call convertir_todos_ceros_o_normal_unidades

    mov bx, [handle_reporte_catalogo]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    mov bx, [handle_reporte_catalogo] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_catalogo] ; </tr>
    mov ah, 40
    mov cx, 0005
    ; mov ch, 00
    ; mov cl, 04 ; 4d
    mov dx, offset str_html_fin_fila
    int 21

    ret

agregar_fila_reporte_catalogo endp

generar_reporte_sin_existencias:
        ; crear archivo
    mov ah, 3c
    mov cx, 0000
    mov dx, offset str_nombre_reporte_sin_existencias
    int 21
    mov [handle_reporte_sin_existencia], ax
        ; escribimos en archivo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 75 ; 117d
    mov dx, offset str_html_inicio
    int 21
        ; escribimos en archivo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 00f8 ; 248d
    mov dx, offset str_html_inicio_fecha
    int 21

    ; aca fecha
    ; call obtener_anio_mes_dia
    ; mov bx, [handle_reporte_sin_existencia]
    ; mov ah, 40
    ; mov cx, 0005 ; 5d
    ; mov dx, offset dia_actual
    ; int 21

        ; escribimos en archivo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 0a ; 10d
    mov dx, offset str_html_fin_fecha
    int 21

        ; escribimos en archivo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov cx, 91 ; 145d
    mov dx, offset str_html_encabezado_tabla_catalogo ; es la misma para este
    int 21

        ; abrimos archivo productos
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21
    jc error_generar_rep_sin_existencias ; si no existe archivo
    mov [handle_productos], ax
    jmp ciclo_generar_reporte_sin_existencia

error_generar_rep_sin_existencias:
        ; cerrar archivo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 3e
    int 21
    jmp menu_principal

ciclo_generar_reporte_sin_existencia:
        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004 ; cantidad avanzar
    mov dx, offset estruct_prod_codigo
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0020 ; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_precio_prod
    mov ah, 3f
    int 21

        ;; avanzar puntero
    mov bx, [handle_productos]
    mov cx, 0004
    mov dx, offset num_unidades_prod
    mov ah, 3f
    int 21

        ;; si se leyeron 0 bytes, se termino el archivo
    cmp ax, 0000
    je fin_generar_reporte_existencia

        ;; valido si es producto valido
    mov al, 00
    cmp [estruct_prod_codigo], al
    je ciclo_generar_reporte_sin_existencia

        ;; validamos que sean solo productos sin existencia
    cmp [num_unidades_prod], 00
    jne ciclo_generar_reporte_sin_existencia

        ;; agregar fila
    call agregar_fila_reporte_sin_existencia

    jmp ciclo_generar_reporte_sin_existencia

fin_generar_reporte_existencia:

    mov bx, [handle_reporte_sin_existencia] ; <td>
    mov cx, 16 ; 22d
    mov dx, offset str_html_fin
    mov ah, 40
    int 21

        ; cerrar chivo reporte_catalogo
    mov bx, [handle_reporte_sin_existencia]
    mov ah, 3e
    int 21

        ; cerrar chivo productos
    mov bx, [handle_productos]
    mov ah, 3e
    int 21

    jmp menu_principal

agregar_fila_reporte_sin_existencia proc
        ; escribimos en archivo catalogo
    mov bx, [handle_reporte_sin_existencia] ; <tr>
    mov ah, 40
    mov cx, 0004
    ; mov ch, 00
    ; mov cl, 04 ; 4d
    mov dx, offset str_html_inicio_fila
    int 21

    mov bx, [handle_reporte_sin_existencia] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    mov bx, [handle_reporte_sin_existencia]
    mov cx, 0004
    mov dx, offset estruct_prod_codigo
    mov ah, 40
    int 21

    mov bx, [handle_reporte_sin_existencia] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_sin_existencia] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    mov bx, [handle_reporte_sin_existencia]
    mov cx, 20 ;; 32d
    mov dx, offset estruct_prod_descrip
    mov ah, 40
    int 21

    mov bx, [handle_reporte_sin_existencia] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_sin_existencia] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    call convertir_todos_ceros_o_normal_precio
    
    mov bx, [handle_reporte_sin_existencia]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    mov bx, [handle_reporte_sin_existencia] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_sin_existencia] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21    

    ; mov ax, [num_unidades_prod]
    ; call convertir_numero_a_cadena
    call convertir_todos_ceros_o_normal_unidades

    mov bx, [handle_reporte_sin_existencia]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    mov bx, [handle_reporte_sin_existencia] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21       

    mov bx, [handle_reporte_sin_existencia] ; </tr>
    mov ah, 40
    mov cx, 0005
    ; mov ch, 00
    ; mov cl, 04 ; 4d
    mov dx, offset str_html_fin_fila
    int 21

    ret

agregar_fila_reporte_sin_existencia endp

convertir_todos_ceros_o_normal_precio proc

    ;; cuando tenia un valor de 0, se hacia la conversion con convertir_numero_a_cadena y genera un valor grande (el maximo)
    ;; ahora se valida si es 0, para mostrar el numero en pantalla

    cmp [num_precio_prod], 00
    je con_todo_cero
    jmp con_normal

    con_todo_cero:
        call convertir_a_cadena_todos_ceros ; numero_ya_en_cadena tiene todos 0
        jmp  cont1

    con_normal:
        mov ax, [num_precio_prod]
        call convertir_numero_a_cadena ; numero_ya_en_cadena tiene el valor convertido
        jmp cont1

    cont1:
        ret

convertir_todos_ceros_o_normal_precio endp

convertir_todos_ceros_o_normal_unidades proc

    ;; simplemente llena convertir_a_cadena_todos_ceros, con ceros
    cmp [num_unidades_prod], 00
    je con_todo_cero2
    jmp con_normal2

    con_todo_cero2:
        call convertir_a_cadena_todos_ceros ; numero_ya_en_cadena tiene todos 0
        jmp  cont2

    con_normal2:
        mov ax, [num_unidades_prod]
        call convertir_numero_a_cadena ; numero_ya_en_cadena tiene el valor convertido
        jmp cont2

    cont2:
        ret

convertir_todos_ceros_o_normal_unidades endp

convertir_a_cadena_todos_ceros proc

    mov di, offset numero_ya_en_cadena
    mov cx, 0005

    ciclo_cac:
        mov bl, 30 ; 0d
        mov [di], bl
        inc di
        loop ciclo_cac
        
    ret
convertir_a_cadena_todos_ceros endp

memset proc
    ;; ENTRADA
    ;;  DI -> direccion de cadena
    ;;  CX -> tamano de cadena
    ciclo_mbf:
        mov al, 00
        mov [di], al
        inc di
        loop ciclo_mbf
        ret
memset endp

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

convertir_cadena_a_numero proc

    ;; ENTRADA
        ;; DI -> direccion de cadena numeroca
    ;; SALIDA
        ;; AX -> numero convertido

    mov ax, 0000 ; inicializar salida
    mov cx, 0000 ; inicializar contador

    ;;;*****
    ; mov bl, [di]
    ; cmp bl, '0'
    ; je retorno_can
    ;;;****

    seguir_convirtiendo_can:
        mov bl, [di]
        cmp bl, 00
        je retorno_can
        sub bl, 30      ; bl es el valor numerico del caracter; 30 -> 48d, que es el 0 en ascii
        mov dx, 000a    ; 10d    
        mul dx          ; ax * dx -> dx:ax ;
        mov bh, 00
        add ax, bx
        inc di
        loop seguir_convirtiendo_can
        jmp retorno_can
    
    retorno_can:
        ret

    ;; EJEMPLO FLUJO, para un valor de 123
    ;;[31][32][33][00][00]
    ;;     ^
    ;;     |
    ;;     ----- DI
    ;;;;
    ;;AX = 0
    ;;10 * AX + 1  = 1
    ;;;;
    ;;AX = 1
    ;;10 * AX + 2  = 12
    ;;;;
    ;;AX = 12
    ;;10 * AX + 3  = 123
    ;;;;
convertir_cadena_a_numero endp

convertir_numero_a_cadena proc

    ;; ENTRADA:
        ;;  AX -> número a convertir    
    ;; SALIDA:
        ;;  [numero_ya_en_cadena] -> numero convertido en cadena
    
        ;; reset antes
    mov di, offset numero_ya_en_cadena
    mov cx, 0005
    ciclo_nye:
        mov bl, 30 ; 0d
        mov [di], bl
        inc di
        loop ciclo_nye

    mov cx, ax ; inializar contador
    mov di, offset numero_ya_en_cadena

    add di, 0004

    ciclo_convertir_a_cadena:
        mov bl, [di]
        inc bl
        mov [di], bl
        cmp bl, 3a ; 58d
        je aumentar_sig_dig_primera_vez
        loop ciclo_convertir_a_cadena
        jmp retorno_convertir_a_cadena

    aumentar_sig_dig_primera_vez:
        push di

    aumentar_sig_digito:
        mov bl, 30     ; poner en '0' el actual
		mov [di], bl
		dec di         ; puntero a la cadena
		mov bl, [di]
		inc bl
		mov [di], bl
		cmp bl, 3a ; 58d
		je aumentar_sig_digito
		pop DI         ; se recupera DI
		loop ciclo_convertir_a_cadena

    retorno_convertir_a_cadena:
        ret

convertir_numero_a_cadena endp


fin:
.EXIT
END
