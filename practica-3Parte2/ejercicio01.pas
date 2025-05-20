{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}
program ejercicio1;
type
    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stock: integer;
        stockMin: integer;
    end;
    venta = record
        codigo: integer;
        cant: integer;
    end;
    maestro = file of producto;
    detalle = file of venta;


{ Caso a: cada producto puede ser actualizado por 0, 1 o más registros del detalle }
procedure actualizarA(var mae: maestro; var det: detalle);
var
    v: venta;
    p: producto;
    cantActual: integer;
begin
    reset(mae);
    reset(det);
    while not eof(mae) do begin
        read(mae, p);
        cantActual := 0;

        while not eof(det) do begin
            read(det, v);
            if (v.codigo = p.codigo) then
                cantActual := cantActual + v.cant;
        end;
        seek(det, 0);  // Volver al principio para el próximo producto
        
        if (cantActual > 0) then begin
            p.stock := p.stock - cantActual;
            seek(mae, filepos(mae) - 1);
            write(mae, p);
        end;
    end;
    close(mae);
    close(det);
end;

{ Caso b: cada producto puede ser actualizado por 0 o 1 registro del detalle }
procedure actualizarB(var mae: maestro; var det: detalle);
var
    v: venta;
    p: producto;
    encontrado: boolean;
begin
    reset(mae);
    reset(det);

    while not eof(det) do begin
        read(det, v);
        seek(mae, 0);
        encontrado := false;

        while (not eof(mae)) and (not encontrado) do begin
            read(mae, p);
            if (p.codigo = v.codigo) then begin
                p.stock := p.stock - v.cant;
                seek(mae, filepos(mae) - 1);
                write(mae, p);
                encontrado := true;
            end;
        end;
    end;
    close(mae);
    close(det);
end;

var
    mae: maestro;
    det: detalle;
    cargaMae, cargaDet: text;
begin
    assign(cargaMae, 'maestro.txt');
    assign(cargaDet, 'detalle.txt');
    actualizarA(mae, det);   // Caso general (0, 1 o más ventas por producto)
    actualizarB(mae, det); // Caso máximo 1 venta por producto
end.
