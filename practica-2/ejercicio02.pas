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

    procedure actualizarMaestro(var mae: archivo_maestro; var det: archivo_detalle);
    var
        p: producto;
        v: venta;
        codActual, total: integer;
    begin
        reset(mae);
        reset(det);

        leerDetalle(det, v);
        read(mae, p); 

        while (v.codigo <> valor_alto) do begin
            codActual := v.codigo; 
            total := 0; 
            
            while (v.codigo = codActual) do begin 
                total := total + v.cantidad; 
                leerDetalle(det, v); 
            end; 
            
            while (p.codigo <> codActual) do 
                read(mae, p); 
                
            p.stock_actual := p.stock_actual - total; 
                
            seek(mae, filepos(mae) - 1);
            write(mae, p);
            
            read(mae, p); 
        end;

        close(mae);
        close(det);
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
