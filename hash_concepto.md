
# ¿Qué es el Hashing (o Dispersión)? 📌

## Concepto

El **hashing** (también llamado **dispersión**) es una técnica utilizada para almacenar y buscar datos de forma rápida y eficiente. Consiste en aplicar una **función de dispersión** (o **función hash**) a una **clave**, es decir, un dato que identifica de forma única un registro (como un número de documento o un nombre).

Esta función transforma la clave en un **número** (llamado **valor hash**), que indica una posición en la que se debe guardar o buscar ese dato. La función actúa como un "traductor" que **mapea** la clave a una dirección física de almacenamiento.  
> 🔁 *Mapear* significa **asociar** una clave con una posición específica dentro de una estructura de almacenamiento, como si fuera una traducción.

---

## Relación con Archivos 📂

En archivos (por ejemplo, archivos de datos en disco), el hashing se usa para:

- Acceder rápidamente a un registro a partir de su clave.
- Organizar los datos de modo eficiente.
- Evitar búsquedas secuenciales.
- Facilitar inserciones y actualizaciones.

Esto se aplica principalmente en **archivos de acceso directo** o **aleatorio**, donde se puede calcular directamente la posición donde se guardará o se encontrará el dato.

---

## Ejemplo Simple ✏️

Supongamos que estamos guardando información de estudiantes, usando su **DNI** como clave.

1. Definimos una función hash simple:  
   ```plaintext
   hash(clave) = clave % 10
   ```
   (Es decir, tomamos el **resto** de dividir el DNI por 10).

2. Tenemos este DNI:  
   ```plaintext
   DNI = 43829156
   ```

3. Aplicamos la función hash:  
   ```plaintext
   43829156 % 10 = 6
   ```

4. Entonces, guardamos el registro en la **posición 6** del archivo.

Para buscar ese registro más tarde, solo aplicamos nuevamente la función hash al DNI y vamos directamente a esa posición.

---

## ¿Qué pasa si hay colisiones? ⚠️

Si otro estudiante tiene el DNI:

```plaintext
DNI = 40123456
```

Al aplicar la misma función:

```plaintext
40123456 % 10 = 6
```

Ambos DNIs se **mapean** a la misma posición (**6**), lo cual se llama una **colisión**.

### ¿Cómo se resuelven?
Existen técnicas para manejar colisiones, como:

- **Encadenamiento**: guardar una lista de registros en cada posición.
- **Dirección abierta**: buscar otra posición libre usando una regla (por ejemplo, lineal o cuadrática).

---

> 💡 **Resumen**: El hashing permite transformar una clave en una dirección de almacenamiento usando una función, haciendo más rápido el acceso y la organización de datos en archivos.
