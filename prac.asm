.MODEL SMALL
.RADIX 16
.STACK
;; PILA
.DATA
;; VARIABLES
nueva_linea         db  0a,"$"
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
diagonal_simbolo    db  '/'
dos_puntos_simbolo  db ':'
comas_simbolo        db ",,,"
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
count_mostrar_prod_consola  dw  00
    ;; REPORTE HTML
str_html_inicio  db '<html><head><title>Reportes</title></head><body style="display: flex; justify-content: center; align-items: center;">'
str_html_inicio_fecha db '<table style="border-collapse: collapse; margin: 25px 0; font-size: 1em; font-family: sans-serif; min-width: 80vw; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);"><tr style="background-color: maroon; color: #ffffff; text-align: middle;"><td colspan="4">'
str_html_inicio_fecha_abc db '<table style="border-collapse: collapse; margin: 25px 0; font-size: 1em; font-family: sans-serif; min-width: 80vw; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);"><tr style="background-color: maroon; color: #ffffff; text-align: middle;"><td colspan="2">'
str_html_fin_fecha db '</td></tr>'
str_html_encabezado_tabla_catalogo db '<tr style="background-color: coral; color: #ffffff; text-align: middle;"><td>Codigo</td><td>Descripcion</td><td>Precio</td><td>Unidades</td></tr>'
str_html_encabezado_tabla_abc db '<tr style="background-color: coral; color: #ffffff; text-align: middle;"><td>Letra</td><td>Cantidad</td></tr>' ; 109d ; 6d
str_html_inicio_fila db "<tr>"
str_html_inicio_columna db "<td>"
str_html_fin_columna db "</td>"
str_html_fin_fila db "</tr>"
str_html_fin     db "</table></body></html>"
str_nombre_reporte_catalogo db "CATALG.HTM",00
str_nombre_reporte_sin_existencias db "FALTA.HTM",00
str_nombre_reporte_abc db "ABC.HTM",00
handle_reporte_catalogo dw  0000
handle_reporte_sin_existencia dw  0000
handle_reporte_abc dw  0000

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
str_titulo_prod_que_desea_hacer db    "Enter para continuar... q para salir...",0a,"$"
str_pedir_codigo    db    "Codigo: ","$"
str_pedir_nombre    db    "Nombre: ","$"
str_pedir_precio    db    "Precio: ","$"
str_pedir_unidad    db    "Unidades: ","$"

; para buscar y eliminar
estruct_prod_codigo_temporal    db  05 dup(0)
puntero_buscar_producto_cod     dw  0000

; Reporte abc
count_ceros     dw 00
str_count_ceros    db "0"
count_unos      dw 00
str_count_unos db "1"
count_dos       dw 00
str_count_dos  db "2"
count_tres      dw 00
str_count_tres db "3"
count_cuatro    dw 00
str_count_cuatro   db "4"
count_cinco     dw 00
str_count_cinco    db "5"
count_seis      dw 00
str_count_seis db "6"
count_siete     dw 00
str_count_siete    db "7"
count_ocho      dw 00
str_count_ocho db "8"
count_nueve     dw 00
str_count_nueve    db "9"
count_a         dw 00
str_count_a    db "A"
count_b         dw 00
str_count_b    db "B"
count_c         dw 00
str_count_c    db "C"
count_d         dw 00
str_count_d    db "D"
count_e         dw 00
str_count_e    db "E"
count_f         dw 00
str_count_f    db "F"
count_g         dw 00
str_count_g    db "G"
count_h         dw 00
str_count_h    db "H"
count_i         dw 00
str_count_i    db "I"
count_j         dw 00
str_count_j    db "J"
count_k         dw 00
str_count_k    db "K"
count_l         dw 00
str_count_l    db "L"
count_m         dw 00
str_count_m    db "M"
count_n         dw 00
str_count_n    db "N"
count_o         dw 00
str_count_o    db "O"
count_p         dw 00
str_count_p    db "P"
count_q         dw 00
str_count_q    db "Q"
count_r         dw 00
str_count_r    db "R"
count_s         dw 00
str_count_s    db "S"
count_t         dw 00
str_count_t    db "T"
count_u         dw 00
str_count_u    db "U"
count_v         dw 00
str_count_v    db "V"
count_w         dw 00
str_count_w    db "W"
count_x         dw 00
str_count_x    db "X"
count_y         dw 00
str_count_y    db "Y"
count_z         dw 00
str_count_z    db "Z"

prueba_descrip    db "aja";
;; anio, mes, dia
anio_actual dw 0000
mes_actual db ?
dia_actual db ?
hora_actual db ?
minuto_actual db ?
anio_actual_cadena db 5 dup(0)
mes_actual_cadena db 3 dup(0)
dia_actual_cadena db 3 dup(0)
hora_actual_cadena db 3 dup(0)
minuto_actual_cadena db 3 dup(0)

aux_convert dw  00

.CODE
.STARTUP
;; CODIGO
inicio:

    ; call obtener_hora_minutos
    ; jmp fin
;; ---------------------------------------------------------- ACCESO ------------------------------------------------------------------
; prueba:
;     mov di, offset prueba_descrip
;     mov bl, [di]
;     cmp bl, 'a'
;     je aument
;     jmp fin

    ; inc count_ceros
    ; inc count_ceros
    ; inc count_ceros
    ; inc count_ceros
    ; mov ax, [count_ceros]
    ; call convertir_numero_a_cadena
    ; mov dx, offset numero_ya_en_cadena
    ; mov ah, 09
    ; int 21
    ; jmp fin
; aument:
;     inc count_ceros
;     mov ax, [count_ceros]
;     call convertir_numero_a_cadena
;     mov dx, offset numero_ya_en_cadena
;     mov ah, 09
;     int 21
;     jmp fin

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
    je generar_reporte_abc 
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

        ;; mostrar productos, de 5 en 5
    inc count_mostrar_prod_consola
    cmp [count_mostrar_prod_consola], 05
    je que_desea_hacer

    jmp ciclo_mostrar_pconsola

que_desea_hacer:
    call print_nueva_linea
    mov dx, offset str_titulo_prod_que_desea_hacer
    mov ah, 09
    int 21
    call print_nueva_linea
    ;; Leer entrada, 1 caracter
    mov ah, 08
    int 21
    cmp al, 0d ; enter
    je seguir_mostrando
    cmp al, 71 ; q
    je fin_mostrar_productos
    jmp que_desea_hacer

seguir_mostrando:
    call print_nueva_linea
    mov count_mostrar_prod_consola, 00 ; reiniciamos contador nuevamente
    jmp ciclo_mostrar_pconsola

fin_mostrar_productos:

    mov count_mostrar_prod_consola, 00 ; reiniciamos contador nuevamente

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

        ;; fecha-hora
    call obtener_anio_mes_dia

    call obtener_hora_minutos

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset dia_actual_cadena
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset mes_actual_cadena
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 04 ; 4d
    mov dx, offset anio_actual_cadena
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 03 ; 1d
    mov dx, offset comas_simbolo
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset hora_actual_cadena
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset dos_puntos_simbolo
    int 21

    mov bx, [handle_reporte_catalogo]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset minuto_actual_cadena
    int 21
        ;; fin fecha-hora

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

        ;; fecha-hora
    call obtener_anio_mes_dia

    call obtener_hora_minutos

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset dia_actual_cadena
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset mes_actual_cadena
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 04 ; 4d
    mov dx, offset anio_actual_cadena
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 03 ; 1d
    mov dx, offset comas_simbolo
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset hora_actual_cadena
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset dos_puntos_simbolo
    int 21

    mov bx, [handle_reporte_sin_existencia]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset minuto_actual_cadena
    int 21
        ;; fin fecha-hora

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

generar_reporte_abc:
    
    call limpiar_valores_reporte_abc

        ; crear archivo
    mov ah, 3c
    mov cx, 0000
    mov dx, offset str_nombre_reporte_abc
    int 21
    mov [handle_reporte_abc], ax
        ; escribimos en archivo
    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 75 ; 117d
    mov dx, offset str_html_inicio
    int 21
        ; escribimos en archivo
    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 00f8 ; 248d
    mov dx, offset str_html_inicio_fecha_abc
    int 21

        ;; fecha-hora
    call obtener_anio_mes_dia

    call obtener_hora_minutos

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset dia_actual_cadena
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset mes_actual_cadena
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset diagonal_simbolo
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 04 ; 4d
    mov dx, offset anio_actual_cadena
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 03 ; 1d
    mov dx, offset comas_simbolo
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset hora_actual_cadena
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 01 ; 1d
    mov dx, offset dos_puntos_simbolo
    int 21

    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 02 ; 2d
    mov dx, offset minuto_actual_cadena
    int 21
        ;; fin fecha-hora

        ; escribimos en archivo
    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov ch, 00
    mov cl, 0a ; 10d
    mov dx, offset str_html_fin_fecha
    int 21

        ; escribimos en archivo
    mov bx, [handle_reporte_abc]
    mov ah, 40
    mov cx, 006d ; 109d
    mov dx, offset str_html_encabezado_tabla_abc ; es la misma para este
    int 21

        ; abrimos archivo productos
    mov al, 02
    mov ah, 3d
    mov dx, offset str_nombre_arch_prod
    int 21
    jc error_generar_rep_abc ; si no existe archivo
    mov [handle_productos], ax
    jmp ciclo_generar_reporte_abc

error_generar_rep_abc:
        ; cerrar archivo
    mov bx, [handle_reporte_abc]
    mov ah, 3e
    int 21
    jmp menu_principal

ciclo_generar_reporte_abc:
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
    je generar_filas_reporte_abc

        ;; valido si es producto valido
    mov al, 00
    cmp [estruct_prod_codigo], al
    je ciclo_generar_reporte_abc

    call incrementar_valores_reporte_abc ; aumento contador segun caracter

    jmp ciclo_generar_reporte_abc

generar_filas_reporte_abc:

    ; ---------------------- 0------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_ceros
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_ceros]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 1------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_unos
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_unos]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 2------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_dos
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_dos]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 3------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_tres
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_tres]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 4------------------------;;

    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_cuatro
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_cuatro]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 5------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_cinco
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_cinco]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 6------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_seis
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_seis]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 7------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_siete
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_siete]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 8------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_ocho
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_ocho]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- 9------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_nueve
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_nueve]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- A------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_a
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_a]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- B------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_b
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_b]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- C------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_c
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_c]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- D------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_d
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_d]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- E------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_e
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_e]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- F------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_f
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_f]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- G------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_g
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_g]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- H------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_h
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_h]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- I------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_i
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_i]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- J------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_j
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_j]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- K------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_k
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_k]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- L------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_l
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_l]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- M------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_m
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_m]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- N------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_n
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_n]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- O------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_o
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_o]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- P------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_p
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_p]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- Q------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_q
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_q]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- R------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_r
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_r]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- S------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_s
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_s]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- T------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_t
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_t]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- U------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_u
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_u]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- V------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_v
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_v]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- W------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_w
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_w]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- X------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_x
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_x]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- Y------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_y
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_y]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- Z------------------------;;
    call abrir_fila_reporte_abc ; <tr>

    call abrir_columna_reporte_abc ; <td>

    mov bx, [handle_reporte_abc]
    mov cx, 0001
    mov dx, offset str_count_z
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call abrir_columna_reporte_abc ; <td>

        ; escribimos valor
    mov bx, [count_z]
    mov [aux_convert], bx
    call convertir_todos_ceros_o_normal_general
    
    mov bx, [handle_reporte_abc]
    mov cx, 0005
    mov dx, offset numero_ya_en_cadena
    mov ah, 40
    int 21

    call cerrar_columna_reporte_abc ; </td>

    call cerrar_fila_reporte_abc ; </tr>

    ; ---------------------- FIN ------------------------;;

    mov bx, [handle_reporte_abc]
    mov cx, 16 ; 22d
    mov dx, offset str_html_fin
    mov ah, 40
    int 21

        ; cerrar chivo
    mov bx, [handle_reporte_abc]
    mov ah, 3e
    int 21

        ; cerrar chivo productos
    mov bx, [handle_productos]
    mov ah, 3e
    int 21

    jmp menu_principal


abrir_fila_reporte_abc proc
    mov bx, [handle_reporte_abc] ; <tr>
    mov ah, 40
    mov cx, 0004
    mov dx, offset str_html_inicio_fila
    int 21
    ret
abrir_fila_reporte_abc endp

cerrar_fila_reporte_abc proc
    mov bx, [handle_reporte_abc] ; </tr>
    mov ah, 40
    mov cx, 0005
    mov dx, offset str_html_fin_fila
    int 21
    ret
cerrar_fila_reporte_abc endp

abrir_columna_reporte_abc proc
    mov bx, [handle_reporte_abc] ; <td>
    mov cx, 0004
    mov dx, offset str_html_inicio_columna
    mov ah, 40
    int 21
    ret
abrir_columna_reporte_abc endp

cerrar_columna_reporte_abc proc
    mov bx, [handle_reporte_abc] ; </td>
    mov cx, 0005
    mov dx, offset str_html_fin_columna
    mov ah, 40
    int 21
    ret
cerrar_columna_reporte_abc endp

limpiar_valores_reporte_abc proc

    mov count_ceros, 00 
    mov count_unos, 00  
    mov count_dos, 00   
    mov count_tres, 00  
    mov count_cuatro, 00
    mov count_cinco, 00 
    mov count_seis, 00  
    mov count_siete, 00 
    mov count_ocho, 00  
    mov count_nueve, 00 
    mov count_a, 00     
    mov count_b, 00     
    mov count_c, 00     
    mov count_d, 00     
    mov count_e, 00     
    mov count_f, 00     
    mov count_g, 00     
    mov count_h, 00     
    mov count_i, 00     
    mov count_j, 00     
    mov count_k, 00     
    mov count_l, 00     
    mov count_m, 00     
    mov count_n, 00     
    mov count_o, 00     
    mov count_p, 00     
    mov count_q, 00     
    mov count_r, 00     
    mov count_s, 00     
    mov count_t, 00     
    mov count_u, 00     
    mov count_v, 00     
    mov count_w, 00     
    mov count_x, 00     
    mov count_y, 00     
    mov count_z, 00
    ret    

limpiar_valores_reporte_abc endp

incrementar_valores_reporte_abc proc

    mov di, offset estruct_prod_descrip
    mov bl, [di]

    cmp bl, '0'
    je inc_cero
    cmp bl, '1'
    je inc_uno
    cmp bl, '2'
    je inc_dos
    cmp bl, '3'
    je inc_tres
    cmp bl, '4'
    je inc_cuatro
    cmp bl, '5'
    je inc_cinco
    cmp bl, '6'
    je inc_seis
    cmp bl, '7'
    je inc_siete
    cmp bl, '8'
    je inc_ocho
    cmp bl, '9'
    je inc_nueve
    cmp bl, 'a'
    je inc_a
    cmp bl, 'A'
    je inc_a
    cmp bl, 'b'
    je inc_b
    cmp bl, 'B'
    je inc_b
    cmp bl, 'c'
    je inc_c
    cmp bl, 'C'
    je inc_c
    cmp bl, 'd'
    je inc_d
    cmp bl, 'D'
    je inc_d
    cmp bl, 'e'
    je inc_e
    cmp bl, 'E'
    je inc_e
    cmp bl, 'D'
    je inc_d
    cmp bl, 'e'
    je inc_e
    cmp bl, 'E'
    je inc_e
    cmp bl, 'f'
    je inc_f
    cmp bl, 'F'
    je inc_f
    cmp bl, 'g'
    je inc_g
    cmp bl, 'G'
    je inc_g
    cmp bl, 'h'
    je inc_h
    cmp bl, 'H'
    je inc_h
    cmp bl, 'i'
    je inc_i
    cmp bl, 'I'
    je inc_i
    cmp bl, 'j'
    je inc_j
    cmp bl, 'J'
    je inc_j
    cmp bl, 'k'
    je inc_k
    cmp bl, 'K'
    je inc_k
    cmp bl, 'l'
    je inc_l
    cmp bl, 'L'
    je inc_l
    cmp bl, 'm'
    je inc_m
    cmp bl, 'M'
    je inc_m
    cmp bl, 'n'
    je inc_n
    cmp bl, 'N'
    je inc_n
    cmp bl, 'o'
    je inc_o
    cmp bl, 'O'
    je inc_o
    cmp bl, 'p'
    je inc_p
    cmp bl, 'P'
    je inc_p
    cmp bl, 'q'
    je inc_q
    cmp bl, 'Q'
    je inc_q
    cmp bl, 'r'
    je inc_r
    cmp bl, 'R'
    je inc_r
    cmp bl, 's'
    je inc_s
    cmp bl, 'S'
    je inc_s
    cmp bl, 't'
    je inc_t
    cmp bl, 'T'
    je inc_t
    cmp bl, 'u'
    je inc_u
    cmp bl, 'U'
    je inc_u
    cmp bl, 'v'
    je inc_v
    cmp bl, 'V'
    je inc_v
    cmp bl, 'w'
    je inc_w
    cmp bl, 'W'
    je inc_w
    cmp bl, 'x'
    je inc_x
    cmp bl, 'X'
    je inc_x
    cmp bl, 'y'
    je inc_y
    cmp bl, 'Y'
    je inc_y
    cmp bl, 'z'
    je inc_z
    cmp bl, 'Z'
    je inc_z

    inc_cero:
        inc count_ceros
        jmp salir_de_incremento

    inc_uno:
        inc count_unos
        jmp salir_de_incremento

    inc_dos:
        inc count_dos
        jmp salir_de_incremento

    inc_tres:
        inc count_tres
        jmp salir_de_incremento

    inc_cuatro:
        inc count_cuatro
        jmp salir_de_incremento

    inc_cinco:
        inc count_cinco
        jmp salir_de_incremento

    inc_seis:
        inc count_seis
        jmp salir_de_incremento

    inc_siete:
        inc count_siete
        jmp salir_de_incremento

    inc_ocho:
        inc count_ocho
        jmp salir_de_incremento

    inc_nueve:
        inc count_nueve
        jmp salir_de_incremento

    inc_a:
        inc count_a
        jmp salir_de_incremento

    inc_b:
        inc count_b
        jmp salir_de_incremento

    inc_c:
        inc count_c
        jmp salir_de_incremento

    inc_d:
        inc count_d
        jmp salir_de_incremento

    inc_e:
        inc count_e
        jmp salir_de_incremento

    inc_f:
        inc count_f
        jmp salir_de_incremento

    inc_g:
        inc count_g
        jmp salir_de_incremento

    inc_h:
        inc count_h
        jmp salir_de_incremento

    inc_i:
        inc count_i
        jmp salir_de_incremento

    inc_j:
        inc count_j
        jmp salir_de_incremento

    inc_k:
        inc count_k
        jmp salir_de_incremento

    inc_l:
        inc count_l
        jmp salir_de_incremento

    inc_m:
        inc count_m
        jmp salir_de_incremento

    inc_n:
        inc count_n
        jmp salir_de_incremento

    inc_o:
        inc count_o
        jmp salir_de_incremento

    inc_p:
        inc count_p
        jmp salir_de_incremento

    inc_q:
        inc count_q
        jmp salir_de_incremento

    inc_r:
        inc count_r
        jmp salir_de_incremento

    inc_s:
        inc count_s
        jmp salir_de_incremento

    inc_t:
        inc count_t
        jmp salir_de_incremento

    inc_u:
        inc count_u
        jmp salir_de_incremento

    inc_v:
        inc count_v
        jmp salir_de_incremento

    inc_w:
        inc count_w
        jmp salir_de_incremento

    inc_x:
        inc count_x
        jmp salir_de_incremento

    inc_y:
        inc count_y
        jmp salir_de_incremento

    inc_z:
        inc count_z
        jmp salir_de_incremento

    salir_de_incremento:
        ret
    ; prueba:
    ;     mov di, offset prueba_descrip
    ;     mov bl, [di]
    ;     cmp bl, 'a'
    ;     je aument
    ;     jmp fin

        ; inc count_ceros
        ; inc count_ceros
        ; inc count_ceros
        ; inc count_ceros
        ; mov ax, [count_ceros]
        ; call convertir_numero_a_cadena
        ; mov dx, offset numero_ya_en_cadena
        ; mov ah, 09
        ; int 21
        ; jmp fin
    ; aument:
    ;     inc count_ceros
    ;     mov ax, [count_ceros]
    ;     call convertir_numero_a_cadena
    ;     mov dx, offset numero_ya_en_cadena
    ;     mov ah, 09
    ;     int 21
    ;     jmp fin
incrementar_valores_reporte_abc endp

convertir_todos_ceros_o_normal_general proc

     ;; validamos
    cmp [aux_convert], 00
    je con_todo_cero3
    jmp con_normal3

    con_todo_cero3:
        call convertir_a_cadena_todos_ceros ; numero_ya_en_cadena tiene todos 0
        jmp  cont3

    con_normal3:
        mov ax, [aux_convert]
        call convertir_numero_a_cadena ; numero_ya_en_cadena tiene el valor convertido
        jmp cont3

    cont3:
        ret

convertir_todos_ceros_o_normal_general endp

convertir_todos_ceros_o_normal_unidades proc

        ;; validamos
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

obtener_anio_mes_dia proc

    ; DL = day
    ; DH = month
    ; CX = year
    ; FLUJO:
        ; ax = ah concat al -> ax = 0000, al = dia actual -> ax quedaria algo asi -> ax= 0002 = ah|al
        ; numero_ya_en_cadena devuelve por ejemplo 00024, nos desplazamos para obtener 24 nada mas

    mov ah, 2a
    int 21
    mov dia_actual, dl
    mov mes_actual, dh
    mov anio_actual, cx

        ; sumamos 1 al dia; para que 1 = domingo
    ; mov ax, 0000
    ; mov al, dia_actual
    ; mov bx, 0001
    ; add ax, bx
    ; mov [dia_actual], al

        ; convirtiendo dia
    mov ax, 0000
    mov al, dia_actual
    call convertir_numero_a_cadena

        ; guardando dia
    mov si, offset dia_actual_cadena
    mov di, offset numero_ya_en_cadena
    
    inc di ; segunda posicion
    inc di ; tercera posicion
    inc di ; cuarta posicion
    mov al, [di]
    mov [si], al
    inc di  ; quinta posicion
    inc si  ; segunda posicion
    mov al, [di]
    mov [si], al

        ; convirtiendo mes
    mov ax, 0000
    mov al, mes_actual
    call convertir_numero_a_cadena
        ; guardando dia
    mov si, offset mes_actual_cadena
    mov di, offset numero_ya_en_cadena

    inc di ; segunda posicion
    inc di ; tercera posicion
    inc di ; cuarta posicion
    mov al, [di]
    mov [si], al
    inc di  ; quinta posicion
    inc si  ; segunda posicion
    mov al, [di]
    mov [si], al

        ; conviertiendo anio
    mov ax, [anio_actual]
    call convertir_numero_a_cadena
        ; guardnado anio
    mov si, offset anio_actual_cadena
    mov di, offset numero_ya_en_cadena

    inc di ; segunda posicion
    mov al, [di]
    mov [si], al
    inc di  ; tercera posicion
    inc si  ; segunda posicion
    mov al, [di]
    mov [si], al
    inc di  ; cuarta posicion
    inc si  ; tercera posicion
    mov al, [di]
    mov [si], al
    inc di  ; quinta posicion
    inc si  ; cuarta posicion
    mov al, [di]
    mov [si], al
    
    ret

obtener_anio_mes_dia endp

obtener_hora_minutos proc

    ; CH = horas
    ; CL = minutos
    ; DH = segundos

    mov ah, 2c
    int 21
    mov hora_actual, ch
    mov minuto_actual, cl

        ; convirtiendo hora
    mov ax, 0000
    mov al, hora_actual
    call convertir_numero_a_cadena

        ; guardando hora
    mov si, offset hora_actual_cadena
    mov di, offset numero_ya_en_cadena
    
    inc di ; segunda posicion
    inc di ; tercera posicion
    inc di ; cuarta posicion
    mov al, [di]
    mov [si], al
    inc di  ; quinta posicion
    inc si  ; segunda posicion
    mov al, [di]
    mov [si], al

        ; convirtiendo minuto
    mov ax, 0000
    mov al, minuto_actual
    call convertir_numero_a_cadena

        ; guardando minuto
    mov si, offset minuto_actual_cadena
    mov di, offset numero_ya_en_cadena

    inc di ; segunda posicion
    inc di ; tercera posicion
    inc di ; cuarta posicion
    mov al, [di]
    mov [si], al
    inc di  ; quinta posicion
    inc si  ; segunda posicion
    mov al, [di]
    mov [si], al
    
    ret

obtener_hora_minutos endp


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
    mov DI, offset minuto_actual_cadena ; <-- cambiar aqui
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
            mov DX, offset minuto_actual_cadena ; <-- cambiar aqui
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
