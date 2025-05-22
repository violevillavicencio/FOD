{3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la propiedad de 
acceso indexado a los registros del archivo de datos por alguna clave, pero permiten además un 
recorrido secuencial rápido. Al igual que en el ejercicio 2, considere que por un lado se tiene el 
archivo que contiene la información de los alumnos de la Facultad de Informática (archivo de 
datos no ordenado) y por otro lado se tiene un índice al archivo de datos, pero en este caso el 
índice se  estructura como un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. 
Resuelva los siguientes incisos: 
a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se encuentran 
en los nodos internos y que elementos se encuentran en los nodos hojas? 
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por qué? 
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de alumnos y su 
índice (árbol B+). Por simplicidad, suponga que todos los nodos del árbol B+ (nodos internos y 
nodos hojas) tienen el mismo tamaño 
4 
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI específico 
haciendo uso de la estructura auxiliar (índice) que se organiza como un árbol B+. ¿Qué 
diferencia encuentra respecto a la búsqueda en un índice estructurado como un árbol B? 
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI en el 
rango entre 40000000 y 45000000, apoyando la búsqueda en un índice organizado como un 
árbol B+. ¿Qué ventajas encuentra respecto a este tipo de búsquedas en un árbol B?}

// inciso a 
{
¿Cómo se organizan los elementos (claves) en un árbol B+?
En un árbol B+ las claves se almacenan en todos los niveles, pero:
Los nodos internos (no hojas) no contienen datos reales, solo claves guía y punteros a hijos.
Los nodos hoja contienen todas las claves reales, y cada una está asociada a un puntero o posición al registro en el archivo de datos.
}

// inciso b 
{
¿Qué característica distintiva presentan los nodos hoja de un árbol B+? ¿Por qué?
Los nodos hoja del árbol B+ están enlazados entre sí formando una lista ordenada.
Para permitir recorridos secuenciales rápidos (por ejemplo, listar alumnos ordenados por DNI o buscar por rangos).
No hace falta volver a la raíz para pasar al siguiente dato → se navega de hoja a hoja.
}

// inciso c 
program ejercicio03;
const
    M = ;// orden del arbol
type
 alumno = record
        nombre: string[50];
        apellido: string[50];
        dni: integer;
        legajo: integer;
        anioIngreso: integer;
    end;

    TArchivoDatos = file of alumno;

    nodo = record
        esHoja: boolean;                          // ¿Es hoja o no?
        cant_claves: integer;                     // Cantidad de claves en el nodo
        claves: array[1..M-1] of longint;         // DNIs (claves)
        enlaces: array[1..M-1] of integer;        // NRR del archivo de datos (solo si es hoja)
        hijos: array[1..M] of integer;            // NRRs de hijos (solo si NO es hoja)
        sig: integer;                             // Siguiente hoja (si es hoja)
    end;
    
    arbolBMas = file of nodo;
var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolBMas;
    
// inciso d 
{
¿Cómo se busca un alumno con DNI específico usando un árbol B+?
Se empieza desde la raíz del árbol B+.
Se comparan las claves guía hasta decidir a qué hijo descender.
Se repite este proceso hasta llegar a un nodo hoja.
En el nodo hoja se busca el DNI exacto.
Si se encuentra, se usa el puntero (NRR) para leer el alumno en el archivo de datos.

¿En qué se diferencia de un árbol B?
En el árbol B, la clave podría estar en un nodo interno o en una hoja.
En el árbol B+ todas las claves están en las hojas, así que la búsqueda siempre baja hasta el final.
Esto simplifica la búsqueda y uniformiza el acceso.
}

// inciso e 
{
¿Cómo se busca un rango de DNIs (ej. entre 40000000 y 45000000) usando un árbol B+?
Se busca en el árbol B+ el primer nodo hoja que contiene el primer DNI del rango.
Una vez ubicado ese nodo, se recorre secuencialmente hoja por hoja usando los punteros sigHoja.
Se siguen leyendo claves hasta que se supera el rango máximo (45000000).
El árbol B+ mejora el rendimiento en búsquedas secuenciales
y por rango al tener todas las claves en las hojas enlazadas, separando claramente el índice de los datos y simplificando la navegación.
}
