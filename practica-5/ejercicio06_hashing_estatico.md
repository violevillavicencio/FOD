# 📌 6. Explique brevemente cómo funcionan las siguientes técnicas de resolución dedesbordes que se pueden utilizar en hashing estático.

- **Saturación progresiva:** cuando se completa el nodo, se busca el próximo hasta encontrar uno libre.

- **Saturación progresiva encadenada:** es similar a la saturación progresiva, pero los registros de saturación 
se encadenan y no ocupan necesariamente posiciones contiguas.

- **Saturación progresiva encadenada con área de desborde separada:** no utiliza nodos de direcciones para los overflows, éstos van a nodos especiales.

- **Dispersión doble:** las técnicas de saturación tienden a agrupar en zonas contiguas y generan búsquedas largas 
cuando la densidad tiende a uno. La solución de esta técnica de resolución de colisiones es almacenar los registros 
de overflow en zonas no relacionadas, aplicándoles una segunda función de hash a la llave, el cual se suma a la dirección original 
tantas veces como sea necesario hasta encontrar una dirección con espacio.
