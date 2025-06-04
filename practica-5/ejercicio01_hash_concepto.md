# ¿Qué es el Hashing (o Dispersión)? 📌

## Concepto

El **hashing** (también llamado **dispersión**) es una técnica utilizada para almacenar y buscar datos de forma rápida y eficiente. Consiste en aplicar una **función de dispersión** (o **función hash**) a una **clave**, es decir, un dato que identifica de forma única un registro (como un número de documento).

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
