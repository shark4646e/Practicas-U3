# Lenguajes de Interfaz: Unidad 3, Modularización

Tres programas en MASM x86 con Irvine32, uno por cada tema: procedimientos anidados, cadena vacía y manejo de pila manual.

## Datos generales

| | |
|---|---|
| Materia | Lenguajes de Interfaz |
| Alumno | Fernando Gastelum Verduzco |
| Institución | Instituto Tecnológico de Culiacán |
| Docente | Dr. José Luis Medina Jiménez |
| Horario | [escribe tu horario] |
| Periodo | Agosto a diciembre de 2026 |
| Entorno | Visual Studio 2022, MASM x86, Irvine32 |

## Índice de códigos

| # | Práctica | Archivo |
|---|---|---|
| 1 | Procedimientos anidados | [`src/procedimientos_anidados.asm`](src/procedimientos_anidados.asm) |
| 2 | Cadena vacía | [`src/cadena_vacia.asm`](src/cadena_vacia.asm) |
| 3 | Pila manual | [`src/pila_manual.asm`](src/pila_manual.asm) |

## Estructura del repositorio

```
lenguajes-de-interfaz-unidad3/
├── README.md
├── .gitignore
└── src/
    ├── procedimientos_anidados.asm
    ├── cadena_vacia.asm
    └── pila_manual.asm
```

## Cómo compilar y ejecutar

Se abre un proyecto de consola de Visual Studio 2022 configurado para MASM con Irvine32 (el mismo que se usa en clase), se agrega el `.asm` que se quiera probar, se compila y se ejecuta sin depurar con Ctrl+F5. Solo debe haber un `.asm` con `main` activo por proyecto.

## 1. Procedimientos anidados (`procedimientos_anidados.asm`)

### Qué hace

`main` llama a `MostrarReporte`, que llama a `MostrarEncabezado`, que a su vez llama a `MostrarSeparador`. Cada procedimiento imprime un mensaje al entrar y otro al salir, así se ve el orden en que se ejecutan las llamadas y en que regresan.

### Qué se comprobó

Salida obtenida:

```
Entra a MostrarReporte
Entra a MostrarEncabezado
Entra a MostrarSeparador
----------------------
Sale de MostrarSeparador
REPORTE DE PRUEBA
Sale de MostrarEncabezado
Cuerpo del reporte
Sale de MostrarReporte
Fin del programa
```

- Los mensajes "Entra" salen de afuera hacia adentro y los "Sale" en el orden contrario. Cada `CALL` guarda su propia dirección de retorno y `RET` recupera siempre la más reciente.
- Cada procedimiento continúa justo donde llamó al otro, y `main` llega a mostrar "Fin del programa", así que el último `RET` volvió a la dirección correcta.
- El programa termina sin errores, por lo que la pila quedó equilibrada.

## 2. Cadena vacía (`cadena_vacia.asm`)

### Qué hace

Pide una cadena y la manda a `LongitudCadena`, que cuenta los caracteres hasta el terminador nulo y devuelve el total en `EAX`. Si el total es 0, avisa que la cadena está vacía y vuelve a pedirla. Si es mayor que 0, muestra la longitud y la cadena capturada.

### Qué se comprobó

| Entrada | Resultado |
|---|---|
| Solo Enter | Muestra "La cadena esta vacia, intenta de nuevo." y vuelve a pedir |
| Enter dos veces seguidas | El aviso aparece dos veces y el programa sigue pidiendo |
| `hola` | Longitud de la cadena: 4 |
| Tres espacios | Longitud de la cadena: 3 |

- Con solo Enter, `ReadString` deja el terminador nulo en el primer byte del buffer, así que `LongitudCadena` termina de inmediato y devuelve 0.
- Una cadena de espacios no se considera vacía, porque los espacios son caracteres y se cuentan.
- `ESI` conserva su valor después de llamar al procedimiento, porque se guarda con `PUSH` y se recupera con `POP`.

## 3. Pila manual (`pila_manual.asm`)

### Qué hace

Pide una base y una altura, las coloca en la pila con `PUSH` y llama a `CalcularArea`. El procedimiento lee los argumentos con `EBP`, multiplica y devuelve el área en `EAX`. Antes de regresar recupera con `POP` lo que guardó y retira los argumentos con `RET 8`. Al volver, `main` muestra el área y comprueba que la pila quedó equilibrada y que `EBX` no cambió.

Marco de pila dentro de `CalcularArea`, de direcciones altas a bajas:

```
[EBP+12]  base         (primer argumento)
[EBP+8]   altura       (segundo argumento)
[EBP+4]   dirección de retorno
[EBP]     EBP del llamador
[EBP-4]   EBX guardado   <- ESP
```

### Qué se comprobó

Ejemplo con base 5 y altura 3 (la dirección de `ESP` cambia en cada ejecución, lo que importa es que las dos coincidan):

```
Escribe la base: 5
Escribe la altura: 3
Area = 15
ESP antes de los PUSH       : 0019FF74
ESP despues de la llamada   : 0019FF74
Pila equilibrada (ESP igual): SI
EBX conservado (00012345)   : SI
```

| Base | Altura | Área mostrada |
|---|---|---|
| 5 | 3 | 15 |
| 7 | 7 | 49 |
| 0 | 9 | 0 |

- `ESP` vale lo mismo antes de los `PUSH` y después de la llamada: los dos `PUSH` de los argumentos se compensan con el `RET 8`, y los `PUSH` y `POP` de `EBP` y `EBX` también quedan parejos.
- La base está en `[EBP+12]` y la altura en `[EBP+8]`, porque la altura se colocó al final.
- `EBX` conserva `12345h` después de la llamada gracias al `PUSH EBX` y `POP EBX` dentro del procedimiento.
