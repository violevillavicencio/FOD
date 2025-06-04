
# 📌 3. Sinónimo, Colisión y Desborde en Hashing

En el contexto del uso de funciones de dispersión para almacenamiento en archivos o estructuras como tablas hash, es importante entender los siguientes conceptos:

---

## 🔁 Sinónimo

Un **sinónimo** ocurre cuando **dos claves diferentes** son transformadas por la función de hash en **la misma dirección de almacenamiento**.

- Es decir, son claves distintas, pero su valor hash coincide.
- **Ejemplo:**  
  Clave A y Clave B → ambas se almacenan en la posición 5.

---

## ⚠️ Colisión

Una **colisión** sucede cuando **se intenta almacenar un nuevo registro en una dirección que ya está ocupada** por otro registro.

- Se debe aplicar alguna técnica de resolución de colisiones (como encadenamiento, sondeo lineal, etc.).
- **Relación con sinónimos:** Las colisiones son consecuencia directa de los sinónimos.

---

## 🚫 Desborde (Overflow)

El **desborde** ocurre cuando **no hay espacio disponible** para almacenar un nuevo registro en la dirección calculada por la función de dispersión **ni en las alternativas previstas** (por ejemplo, en la lista encadenada o en espacios alternativos).

- Es una **situación crítica**, ya que impide insertar el nuevo registro.

---

## ✅ ¿Cuándo ocurre una colisión sin que haya desborde?

Para que una **colisión no cause un desborde**, debe **existir espacio disponible** donde colocar el nuevo registro, aunque la dirección directa ya esté ocupada.

- Por ejemplo, si la función de dispersión asigna una dirección ocupada, pero hay espacio en una lista encadenada o en otra ubicación asociada, el sistema puede **resolver la colisión sin desbordar**.

> Es esencial contar con una estrategia de manejo de colisiones y un espacio auxiliar adecuado para evitar el desborde.

---

