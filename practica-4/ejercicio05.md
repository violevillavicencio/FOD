# 📚 Conceptos clave en Árboles B y B+

Este documento define y explica algunos conceptos fundamentales relacionados con la inserción y eliminación de claves en estructuras de árbol B y B+.

---

## 🔺 Overflow

El **overflow** ocurre cuando, al insertar una clave en un nodo, este supera el número máximo permitido de claves (M−1 en un árbol de orden M).  
Cuando hay overflow, el nodo debe dividirse (split) en dos nodos, y una clave debe promocionarse al nodo padre.

---

## 🔻 Underflow

El **underflow** ocurre cuando, al eliminar una clave, un nodo queda con **menos claves que el mínimo permitido** (generalmente ⌈M/2⌉ − 1 claves).  
Esto puede romper las reglas del árbol, por lo que debe resolverse mediante redistribución o fusión.

---

## 🔁 Redistribución

La **redistribución** consiste en **tomar una clave de un nodo hermano adyacente** (izquierdo o derecho) que tenga claves de más, y mover una clave del nodo padre para equilibrar la cantidad de claves entre los nodos.

### 🟢 ¿Cuándo se aplica?

Se aplica cuando ocurre un **underflow** y **el hermano adyacente tiene más del mínimo de claves permitido**, lo que permite "prestar" una clave.

---

## 🔗 Fusión (o concatenación)

La **fusión** (o concatenación) se aplica cuando un nodo con underflow **no puede redistribuir** (porque sus hermanos no tienen claves para prestar).  
Se fusiona el nodo con su hermano adyacente, y se baja una clave del padre para unirlos.

### 🔴 ¿Cuándo se aplica?

Se aplica cuando **no es posible redistribuir**. Se combinan los contenidos de ambos nodos y se ajustan las claves del padre.  
Si el padre queda con underflow por esta operación, el problema puede **propagarse hacia arriba**.

---

## 🧠 Conclusión

- **Overflow** se resuelve con división y promoción.
- **Underflow** se intenta resolver primero con redistribución.
- Si no se puede redistribuir, se hace **fusión**, que puede afectar a niveles superiores del árbol.

---
