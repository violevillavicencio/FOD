{
8. Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de 
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente 
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad 
total de kilos de yerba consumidos históricamente. 
Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de 
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad 
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede 
contener información de una o varias provincias, y una misma provincia puede aparecer 
cero, una o más veces en distintos archivos de relevamiento. 
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de 
provincia. 
Se desea realizar un programa que actualice el archivo maestro en base a la nueva 
información de consumo de yerba. Además, se debe informar en pantalla aquellas 
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000 
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante 
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas. 
}
program ejercicio8;
const 
    valorAlto = 9999; 
    cant_detalles = 16; 
type 
    rango_vector = 1..cant_detalles; 
    
    reg_maestro = record 
        codigo_prov: integer; 
        nombre_prov: string[30]; 
        habitantes: integer; 
        consumo_historico: integer; 
    end; 
    
    reg_detalle = record
        codigo_prov: integer; 
        yerba_consumida: integer; 
    end; 
    
    maestro = file of reg_maestro; 
    detalle = file of reg_detalle; 
    
    detalles = array [rango_vector] of detalle; 
    registros = array [rango_vector] of reg_detalle; 
        
    procedure leer(var d: detalle; var r: reg_detalle); 
    begin 
        if not eof(d) then 
            read(d, r)
        else 
            r.codigo_prov := valorAlto; 
    end; 
    
    procedure leerM(var m: maestro ; var r: reg_maestro); 
    begin 
        if not eof(m) then 
            read(m, r)
        else 
            r.codigo_prov := valorAlto; 
    end; 
    
    procedure minimo(var dets: detalles; var regs: registros; var min: reg_detalle); 
    var 
        i, pos: rango_vector; 
    begin
        min.codigo_prov := valorAlto; 
        for i := 1 to cant_detalles do begin 
            if regs[i].codigo_prov < min.codigo_prov then begin 
                min := regs[i]; 
                pos := i; 
            end; 
        end; 
        if min.codigo_prov <> valorAlto then 
            leer(dets[pos], regs[pos]); 
    end; 
    
    procedure actualizarMaestro(var mae: maestro; var dets: detalles); 
    var 
        i: integer; regm: reg_maestro; regs: registros; 
        min: reg_detalle; 
        yerba_prov: integer; 
    begin  
        // Abrir archivos detalle
        for i := 1 to cant_detalles do begin 
            assign(dets[i], 'detalle' + IntToStr(i)); 
            reset(dets[i]); 
            leer(dets[i], regs[i]); 
        end; 
    
        assign(mae, 'maestro'); 
        reset(mae); 
        leerM(mae, regm); 
        
        while (regm.codigo_prov <> valorAlto) do begin
            yerba_prov := 0;  
            minimo(dets, regs, min); 
            while (regm.codigo_prov = min.codigo_prov) do begin 
                yerba_prov := yerba_prov + min.yerba_consumida; 
                minimo(dets, regs, min); 
            end; 
    
            regm.consumo_historico := regm.consumo_historico + yerba_prov; 
    
            if (regm.consumo_historico > 10000) then begin 
                writeln('Código: ', regm.codigo_prov, ' - Nombre: ', regm.nombre_prov); 
                writeln('Promedio de yerba por habitante: ', regm.consumo_historico / regm.habitantes:0:2);
            end; 
    
            // Reposicionar para sobrescribir el registro en archivo
            seek(mae, filepos(mae) - 1); 
            write(mae, regm); 
            
            leerM(mae, regm); 
        end;  
    
        // Cerrar archivos
        for i := 1 to cant_detalles do
            close(dets[i]);
        close(mae);
    end;  
var 
    mae: maestro; dets: detalles; 
begin
    actualizarMaestro(mae, dets); 
end.
