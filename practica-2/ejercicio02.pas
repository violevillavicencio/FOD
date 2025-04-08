program ejercicio2; 
const
    valor_alto = 9999;
type
    producto = record
        codigo: integer;
        nombre: string[30];
        precio: real;
        stock_actual: integer;
        stock_minimo: integer;
    end;

    venta = record
        codigo: integer;
        cantidad: integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of venta;

    procedure leerDetalle(var ad: archivo_detalle; var v: venta);
    begin
        if not eof(ad) then
            read(ad, v)
        else
            v.codigo := valor_alto;
    end;
    
    procedure actualizarMaestro(var am: archivo_maestro; var ad: archivo_detalle);
    var
        p: producto;
        v: venta;
    begin
        reset(am);
        reset(ad);
    
        leerDetalle(ad, v);
        while v.codigo <> valor_alto do begin
            // Busco el producto en el maestro
            read(am, p);
            while p.codigo <> v.codigo do
                read(am, p);
            
            // Mientras haya ventas del mismo producto
            while (v.codigo = p.codigo) do begin
                p.stock_actual := p.stock_actual - v.cantidad;
                leerDetalle(ad, v);
            end;
    
            // Vuelvo atrás una posición en el maestro y actualizo
            seek(am, filepos(am) - 1);
            write(am, p);
        end;
        
        close(am);
        close(ad);
    end;
    
    procedure generarStockMinimo(var am: archivo_maestro);
    var
        p: producto;
        txt: text;
    begin
        assign(txt, 'stock_minimo.txt');
        rewrite(txt);
        reset(am);
        while not eof(am) do begin
            read(am, p);
            if p.stock_actual < p.stock_minimo then
                writeln(txt, p.codigo, ' ', p.nombre, ' STOCK ACTUAL: ', p.stock_actual, ' MÍNIMO: ', p.stock_minimo);
        end;
        close(am);
        close(txt);
    end;
var
    am: archivo_maestro;
    ad: archivo_detalle;
begin
    assign(am, 'maestro.dat');
    assign(ad, 'detalle.dat');
    actualizarMaestro(am, ad);
    generarStockMinimo(am);
end.
