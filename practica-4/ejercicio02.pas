{2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.
a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.
c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.
e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?
f. Suponga que desea buscar los alumnos que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?}

// inciso a 
program ejercicio02; 
const
    M = ; // orden del arbol
type
    alumno = record
        nombre: string;
        apellido: string;
        dni: integer;
        legajo: integer;
        anioIngreso: integer;
    end;
    nodo = record
        cant_claves: integer;   // cantidad actual de claves
        claves: array[1..M-1] of longint;  // DNI
        enlaces: array[1..M-1] of integer;  // NRR del archivo de alumnos
        hijos: array[1..M] of integer;  // NRR de los hijos (archivo índice)
    end;
    TArchivoDatos = file of alumno;
    arbolB = file of nodo;
var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolB;
    
// inciso b 
{  
N = 512 (tamaño del nodo)
A = 8 (cada clave + enlace = 4 bytes DNI + 4 bytes NRR del alumno)
B = 4 (cada hijo = un entero que indica NRR del nodo hijo)
C = 4 (campo cant_claves)

    N = (M-1) * A + (M-1) * A + M * B + C
    512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
    512 = 4M - 4 + 4M - 4 + 4M + 4
    512 = 12M - 4
    512 + 4 = 12M
    516 / 12 = M
    M = 43
    
El orden del arbol B es de 43.
}

// inciso c 
{ 
¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?  
Significa que entran más claves por nodo, por lo tanto:
El árbol tiene menos niveles (menor altura).
Se accede más rápido (menos lecturas de disco).
Es más eficiente que en el ejercicio 1 (donde M era más chico porque guardábamos toda la info en el nodo).
} 

// inciso d 
{ 
Proceso para buscar el alumno con el DNI 12345678 usando el índice definido en este punto: 

1. Comenzás desde la raíz del índice (árbol B).

2. Buscás en el nodo actual si el DNI 12345678 está entre las claves.

3. Si está → usás el enlace asociado (NRR) para leer directamente al alumno en el archivo de alumnos.

4. Si no está → seguís el hijo correspondiente al rango y repetís desde ese nodo.

5. Repetís el proceso hasta encontrarlo o llegar a un nodo hoja sin éxito.
} 

// inciso e 
{ 
¿Y si quiero buscar por legajo? ¿Sirve este índice?
No sirve si querés buscar por legajo, porque el árbol está ordenado por DNI, no por legajo.

Tenés dos opciones:

1- Recorrer todo el archivo de alumnos para buscar el legajo (búsqueda secuencial).

2- Crear un segundo índice (otro árbol B) que ordene por legajo y apunte también al NRR de los alumnos.

Conclusión: Si querés búsquedas rápidas por más de un campo (como legajo y DNI), necesitás un índice por cada campo.
}  

// inciso f
{ 
Búsqueda por rango de DNI (ej: entre 40000000 y 45000000)
Un árbol B sí permite buscar por rangos, pero hay un detalle importante:
Tenés que recorrer todos los nodos hoja que contienen DNIs en ese rango.
El árbol te lleva al primer DNI mayor o igual a 40000000, pero luego tenés que:
Leer secuencialmente los nodos siguientes (hacia la derecha),
Mientras los DNIs estén dentro del rango.

El problema:
El árbol B no es secuencialmente encadenado entre hojas (a diferencia del árbol B+).
Entonces, recorrer nodos hoja en orden puede requerir más saltos o cálculos.
Una solución mejor: 
Usar un árbol B+, donde las hojas están enlazadas y permiten recorridos por rango más eficientemente.
} 
