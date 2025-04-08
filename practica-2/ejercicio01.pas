program ejercicio1; 
const 
    valor_alto = 9999; 
type 
    empleado = record 
        codigo: integer; 
        nombre: string; 
        monto: real; 
    end; 
    
    compacto = record
        codigo: integer; 
        monto_total: real; 
    end; 
    
    archivo_empleados = file of empleado; 
    
    archivo_compacto = file of compacto; 
    
    procedure leer(var aE: archivo_empleados; var e: empleado); 
    begin
        if (not eof(aE)) then
            read(aE,e) 
        else 
            e.codigo:= valor_alto; 
    end; 
    
    procedure crearArchivo(var aE:archivo_empleados; var aC: archivo_compacto ); 
    var 
        e: empleado; c: compacto; codigo_actual: integer; 
    begin
        assign(aC,'archivo compacto'); 
        rewrite(aC); // creo el archivo compacto 
        reset(aE); // abro el archivo con info 
        leer(aE,e);
        while(e.codigo <> valor_alto) do begin 
            codigo_actual:= e.codigo; 
            c.monto_total:= 0; 
            while(e.codigo = codigo_actual) do begin 
                c.monto_total:= c.monto_total + e.monto; 
                leer(aE, e); 
            end; 
            c.codigo:= codigo_actual; 
            write(aC,c); 
        end; 
        close(aC); 
        close(aE); 
    end; 
var 
    aC: archivo_compacto; aE: archivo_empleados; 
begin
    assign(aE,'archivo empleados');
    crearArchivo(aE,aC); 
end.
