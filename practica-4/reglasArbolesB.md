# 📘 Reglas para Altas y Bajas en Árboles B (Resumen Práctico)

Este documento resume las reglas y pasos a seguir para realizar **altas (inserciones)** y **bajas (eliminaciones)** en un **Árbol B de orden M**, incluyendo cómo manejar **overflow** y **underflow**.

---

## 🌳 Propiedades del Árbol B de orden M

- Cada nodo puede tener **como máximo M hijos** (y M−1 claves).
- La **raíz**:
  - Si es única, puede no tener hijos.
  - Si tiene hijos, debe tener **al menos 2**.
- Todos los nodos (salvo la raíz) deben tener al menos **⌈M/2⌉ − 1 claves**.
- Todos los nodos hoja están al mismo nivel (el árbol está balanceado).
- Las claves dentro de cada nodo están **ordenadas**.
- Las claves separan rangos de los subárboles hijos.

---

## ✅ Reglas para Altas (Inserciones)

### 🔢 Pasos a seguir:

1. Buscar el nodo hoja donde debe insertarse la clave.
2. Insertar la clave en orden dentro del nodo.
3. Verificar si ocurre **overflow** (más de M−1 claves en un nodo):
   - ❌ No → Fin.
   - ✅ Sí → Continuar con el tratamiento de overflow.

### ⚠️ Tratamiento del Overflow:

1. **Dividir el nodo** en dos mitades:
   - La **clave del medio** sube al nodo padre.
   - Las mitades quedan en dos nodos separados.
2. Insertar la clave media en el padre:
   - Si hay lugar → insertar y ajustar enlaces.
   - Si no → se genera overflow en el padre → repetir el proceso.
3. Si la **raíz** se divide → se crea una nueva raíz → el árbol crece en altura.

---

## 🗑️ Reglas para Bajas (Eliminaciones)

### 🔢 Pasos a seguir:

1. Buscar la clave a eliminar.
2. Si está en un nodo **hoja** → eliminar directamente.
3. Si está en un nodo **interno**:
   - Reemplazar por la **menor clave del subárbol derecho** (o mayor del izquierdo).
   - Eliminar esa clave en la hoja correspondiente.
4. Verificar si ocurre **underflow** (menos de ⌈M/2⌉ − 1 claves en un nodo):
   - ❌ No → Fin.
   - ✅ Sí → Continuar con el tratamiento de underflow.

### ⚠️ Tratamiento del Underflow:

1. **Intentar redistribuir** con un hermano adyacente (si tiene más de ⌈M/2⌉ − 1 claves):
   - Ajustar claves del nodo y del padre.
2. Si no es posible redistribuir, **fusionar** con un hermano:
   - Combinar ambos nodos + clave del padre.
   - El padre pierde una clave → puede propagar el underflow hacia arriba.
   - Si la raíz queda sin claves → eliminarla → el árbol baja de altura.

---

## 🔁 Políticas para Resolver el Underflow

| Política                    | Acciones en orden de intento |
|----------------------------|-------------------------------|
| **Izquierda**              | Redistribuir ↦ Fusionar con hermano izquierdo |
| **Derecha**                | Redistribuir ↦ Fusionar con hermano derecho  |
| **Izquierda o derecha**    | Intentar izquierda → derecha → fusionar con izquierda |
| **Derecha o izquierda**    | Intentar derecha → izquierda → fusionar con derecha |

> 🔸 Si el nodo está en un **extremo**, se actúa solo con el hermano disponible.

---

## 📌 Casos Especiales

- **Overflow** puede propagarse hasta la raíz → se incrementa la altura del árbol.
- **Underflow** puede propagarse hasta la raíz → se reduce la altura del árbol.
- Todas las acciones mantienen el árbol balanceado y ordenado.

---

## ✍️ Autor

Reglas basadas en material de clase y ejemplos prácticos del curso de **Fundamentos de Organización de Datos**.

---
