# 🌳 Reglas para Árboles B+ (Resumen práctico)

Este documento resume las **reglas, pasos y características clave** del funcionamiento de un **Árbol B+**, estructura muy usada para acceso indizado eficiente y recorrido secuencial rápido en archivos grandes.

---

## 📘 ¿Qué es un Árbol B+?

Un **Árbol B+** es una mejora del árbol B que:
- Conserva el **acceso indizado** por clave.
- Agrega un **recorrido secuencial eficiente** mediante enlaces entre hojas.

### Estructura:
- Los **nodos internos** (índice) solo contienen **claves guía y punteros**.
- Los **nodos hojas** contienen **los datos reales** o referencias a ellos.
- Las **hojas están enlazadas entre sí** como una lista ordenada.

---

## ✅ Propiedades de los Árboles B+

- Cada nodo (página) puede tener **como máximo M hijos**.
- Los nodos internos (excepto la raíz) tienen entre ⌈M/2⌉ y M hijos.
- La **raíz** tiene al menos 2 hijos (si no es hoja).
- **Todas las hojas están al mismo nivel**.
- Un nodo interno con **K descendientes tiene K−1 claves**.
- **Los nodos hoja contienen todos los datos** y están **enlazados** secuencialmente.
- **Los nodos no terminales no contienen datos**, solo claves guía y punteros.

---

## 🔍 Búsqueda en Árbol B+

- Comienza en la raíz, comparando claves guía.
- Se desciende por los punteros hasta llegar a una **hoja**.
- **Todas las claves están en las hojas**, por lo que siempre se baja hasta el último nivel.
- En la hoja se encuentra el dato o el puntero al dato.

---

## 🟩 Reglas para **Altas (Inserción)**

### Paso a paso:

1. Buscar el nodo hoja donde insertar la clave.
2. Insertar la clave en orden.
3. ¿El nodo hoja tiene overflow (más de M−1 claves)?
   - ❌ No → Termina.
   - ✅ Sí → Dividir el nodo hoja.

### ¿Cómo se resuelve el **overflow**?

1. Dividir el nodo en dos partes casi iguales.
2. Copiar la **clave del medio o la menor de las mayores** al nodo padre (clave guía).
3. Crear un nuevo nodo y actualizar punteros de hojas y del padre.
4. Si el padre tiene overflow → repetir el proceso recursivamente.
5. Si se divide la raíz → crear una nueva raíz → el árbol **crece en altura**.

📝 *Nota: la copia de la clave solo ocurre si el overflow es en una hoja.*

---

## 🟥 Reglas para **Bajas (Eliminación)**

### Paso a paso:

1. Buscar la clave en las **hojas** (todas las claves están allí).
2. Eliminar la clave de la hoja.
3. ¿El nodo hoja queda con al menos ⌈M/2⌉ − 1 claves?
   - ✅ Sí → Termina.
   - ❌ No → Se produce **underflow**.

---

### ¿Cómo se resuelve el **underflow**?

#### 🔁 Redistribución

- Se intenta tomar claves del hermano adyacente.
- Se ajustan claves guía del padre si es necesario.

#### 🔗 Fusión (si no se puede redistribuir)

- Se fusiona el nodo con su hermano.
- Se elimina una clave guía del padre.
- Puede propagarse el underflow hacia arriba.
- Si la raíz queda sin claves → se elimina → **el árbol disminuye en altura**.

---

## 🔄 Políticas para resolver underflow

| Política                   | Proceso                                                               |
|---------------------------|------------------------------------------------------------------------|
| Izquierda                 | Intentar redistribuir o fusionar con hermano izquierdo                 |
| Derecha                   | Intentar redistribuir o fusionar con hermano derecho                  |
| Izquierda o derecha       | Intentar izquierda, luego derecha, si no se puede: fusionar con izquierda |
| Derecha o izquierda       | Intentar derecha, luego izquierda, si no se puede: fusionar con derecha |

> 🔸 Si el nodo es extremo, se intenta con el único hermano que tenga.

---

## 🎯 Ventajas del Árbol B+ respecto al B

- Las claves **solo se almacenan en las hojas**, lo que permite:
  - **Más claves por nodo** → árbol más bajo.
  - **Acceso más eficiente** por rango (gracias al enlace secuencial entre hojas).
- **Separación clara entre índice y datos**.
- Las operaciones de búsqueda y recorrido **son más predecibles y rápidas**.
- Ideal para **bases de datos** y **sistemas de archivos grandes**.

---

## ✍️ Autor

Resumen basado en material de clase de **Fundamentos de Organización de Datos** – UNLP – Facultad de Informática.

---
