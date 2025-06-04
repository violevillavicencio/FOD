
# 📌 2. ¿Qué es una función de dispersión?

Una **función de dispersión** (también llamada **función hash**) es un algoritmo que toma una **clave de entrada** (como un número, cadena de texto, etc.) y la transforma en un **número entero**, llamado **valor hash** o **índice**.

Este valor se usa como una **posición dentro de una estructura de almacenamiento** (como una tabla hash o un archivo), permitiendo guardar y buscar datos de forma rápida y eficiente.

> Su objetivo principal es **distribuir uniformemente** las claves en el espacio de almacenamiento para evitar colisiones (cuando dos claves se asignan al mismo índice).

---

## 🧮 Ejemplos de funciones de dispersión

A continuación, se presentan tres funciones de dispersión comunes con una breve explicación de su funcionamiento:

---

### 1. Función del módulo

**Fórmula:**  
```plaintext
h(clave) = clave % m
```

- **Descripción:** Se toma la clave (un número entero) y se calcula el **resto** de dividirla por `m`, que suele ser el tamaño de la tabla.
- **Ejemplo:**  
  Si `clave = 43829156` y `m = 10` →  
  `h(43829156) = 43829156 % 10 = 6`  
  → Se almacena en la posición 6.

- **Ventaja:** Muy fácil de implementar.
- **Desventaja:** Puede generar muchas colisiones si las claves no están bien distribuidas.

---

### 2. Función de la multiplicación

**Fórmula:**  
```plaintext
h(clave) = ⌊m × ((clave × A) % 1)⌋
```

- Donde:
  - `A` es una constante real entre 0 y 1 (por ejemplo, `A = 0.618033`).
  - `m` es el tamaño de la tabla.
  - `% 1` extrae la parte **decimal** del producto.

- **Descripción:** Multiplica la clave por una constante, toma la parte fraccionaria y la multiplica por `m`, luego se redondea hacia abajo.
- **Ventaja:** Distribuye mejor las claves, incluso si las entradas no están bien repartidas.
- **Desventaja:** Más costosa de calcular que el módulo.

---

### 3. Función de la suma de caracteres (para cadenas)

**Fórmula:**  
```plaintext
h(cadena) = (suma de los códigos ASCII de los caracteres) % m
```

- **Descripción:** Para una cadena de texto, se suman los valores ASCII de cada carácter, y luego se aplica el módulo.
- **Ejemplo:**
  - Cadena: `"ABC"`  
    ASCII: `65 + 66 + 67 = 198`  
    Si `m = 10` → `198 % 10 = 8`

- **Ventaja:** Simple para claves tipo texto.
- **Desventaja:** Puede generar muchas colisiones si muchas cadenas tienen los mismos caracteres en distinto orden.

---

## ✅ Conclusión

Una buena función de dispersión debe:

- Ser fácil de calcular.
- Distribuir uniformemente las claves.
- Minimizar colisiones.

Elegir la función adecuada depende del tipo de datos que se vayan a manejar y del tamaño del almacenamiento.
