Se cuenta con un archivo maestro con los articulos de una cadena de venta de indumentaria. De cada
articulo se almacena: codigo de articulo, nombre, descripcion, talle, color, stock disponible, stock
minimo y precio del articulo.

Se recibe diariamente un archivo detalle de cada una de las 15 sucursales de la cadena. Se debe realizar
el procedimiento que recibe los 15 detalles y actualiza el stock del archivo maestro. La informacion que
se recibe en los detalles es: codigo de articulo y cantidad vendida. 
Nota: todos los archivos se encuentan ordenados por codigo de articulo. En cada detalle puede venir 0 o N
registros de un determinado articulo.

program ejercicioExtra;
const 
    dimF = 15; 
    valorAlto = 9999; 
type 
    articulo = record
        codigo: integer;
        nombre: String[50];
        descripcion: String[50];
        talle: String[4];
        color: String[50];
        stock: integer;
        stockMin: integer;
        precio: real;
    end;
    
    venta = record
        codigo: integer;
        cantVen: integer;
    end;
    
    maestro = file of articulo;
    detalle = file of venta;
    
    // Vector de archivos de detalle, uno por sucursal
    vec_Detalles = array[1..dimF] of detalle;
    
    // Vector paralelo que almacena el registro actual leído de cada archivo detalle
    vec_Ventas = array[1..dimF] of venta; 

// Lee un registro del detalle, o carga valorAlto si se terminó el archivo
procedure leer(var d: detalle; var reg: venta); 
begin 
    if (not eof(d)) then 
        read(d,reg)
    else 
        reg.codigo := valorAlto; 
end; 

// Busca el menor código entre los registros actuales de los 15 archivos detalle
procedure minimo(var detalles: vec_Detalles; var ventas: vec_Ventas; var min: venta);
var 
    i, pos: integer; 
begin 
    min.codigo := valorAlto; 
    for i := 1 to dimF do begin 
        if (ventas[i].codigo < min.codigo) then begin 
            min := ventas[i]; 
            pos := i; 
        end; 
    end;
    // Si se encontró un mínimo válido, leer el siguiente registro del mismo archivo
    if (min.codigo <> valorAlto) then 
        leer(detalles[pos], ventas[pos]);
end; 

// Actualiza el archivo maestro restando las ventas acumuladas por artículo
procedure actualizarMaestro(var mae: maestro; var detalles: vec_Detalles); 
var 
    min: venta; 
    actual: venta; 
    a: articulo; 
    ventas: vec_Ventas; 
    totalVendido: integer; 
    i: integer; 
begin 
    // Abrimos todos los archivos detalle y leemos el primer registro de cada uno
    for i := 1 to dimF do begin 
        assign(detalles[i], 'detalle' + IntToStr(i)); 
        reset(detalles[i]); 
        leer(detalles[i], ventas[i]); 
    end; 
    
    reset(mae); 
    read(mae, a);
    
    minimo(detalles, ventas, min); 
    while (min.codigo <> valorAlto) do begin 
        actual := min; 
        totalVendido := 0;

        // Acumulamos todas las ventas del mismo artículo (puede estar repetido en varios archivos)
        while (min.codigo = actual.codigo) do begin 
            totalVendido := totalVendido + min.cantVen; 
            minimo(detalles, ventas, min); 
        end; 

        // Buscamos el artículo correspondiente en el maestro
        while (a.codigo <> actual.codigo) do 
            read(mae, a); 

        a.stock := a.stock - totalVendido; 

        // Volvemos una posición atrás para sobreescribir el registro correcto
        seek(mae, filepos(mae) - 1); 
        write(mae, a); 
    end; 
    close(mae); 
    // Cerramos todos los archivos detalle
    for i := 1 to dimF do 
        close(detalles[i]); 
end;

var
    mae: maestro;
    vd: vec_Detalles;
begin
    assign(mae, 'articulos');
    actualizarMaestro(mae, vd);
end.
