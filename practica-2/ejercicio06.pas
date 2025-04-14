{
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid 
para el ministerio de salud de la provincia de buenos aires. 
Diariamente se reciben archivos provenientes de los distintos municipios, la información 
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de 
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos 
fallecidos. 
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, 
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos 
nuevos, cantidad de recuperados y cantidad de fallecidos. 
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles 
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de 
localidad y código de cepa.  
Para la actualización se debe proceder de la siguiente manera:  
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle. 
2. Idem anterior para los recuperados. 
3. Los casos activos se actualizan con el valor recibido en el detalle. 
4. Idem anterior para los casos nuevos hallados. 
Realice las declaraciones necesarias, el programa principal y los procedimientos que 
requiera para la actualización solicitada e informe cantidad de localidades con más de 50 
casos activos (las localidades pueden o no haber sido actualizadas).
}
program ejercicio6; 
const 
    valorAlto = 9999;
    dimF = 10; 
type 
    rango = 1..dimF; 
    reg_detalle = record 
        codigo_localidad: integer; 
        codigo_cepa: integer; 
        casos_activos: integer; 
        casos_nuevos: integer; 
        recuperados: integer; 
        fallecidos: integer; 
    end; 
    
    reg_maestro = record 
        codigo_localidad: integer; 
        noombre_localidad: string[30]; 
        codigo_cepa: integer; 
        nombre_cepa: string[30]; 
        casos_activos: integer; 
        casos_nuevos: integer; 
        recuperados: integer; 
        fallecidos: integer; 
    end; 
    
    detalle = file of reg_detalle; 
    
    detalles = array [rango] of detalle; 
    
    registros = array [rango] of reg_detalle; 
    
    maestro = file of reg_maestro;
    
    procedure leer(var d: detalle; var r: reg_detalle); 
    begin 
        if (not eof(d)) then 
            read(d,r) 
        else 
            r.codigo_localidad:= valorAlto;
    end; 
        
    procedure minimo(var dets: detalles; var regs: registros; var min: reg_detalle); 
    var 
        i, pos: rango; 
    begin     
        min.codigo_localidad:= valorAlto; 
        min.codigo_cepa:= valorAlto; 
        for i:= 1 to dimF do begin 
            if (regs[i].codigo_localidad < min.codigo_localidad) 
            or ((regs[i].codigo_localidad = min.codigo_localidad) and (regs[i].codigo_cepa < min.codigo_cepa)) then begin
                min:= regs[i]; 
                pos:= i; 
            end; 
        end; 
        // Avanzo en el archivo detalle de donde saqué el mínimo
        if (min.codigo_localidad <> valorAlto) then 
            leer(dets[pos], regs[pos]);
    end; 
    
    procedure actualizarMaestro(var mae: maestro; var detalles: detalles); 
    var 
        min,actual: reg_detalle; 
        regm: reg_maestro; 
        regs: registros; 
        total_fallecidos, total_recuperados, activos, nuevos,i: integer; 
    begin
        // 1) Abrir todos los detalles y leer el primer registro
        for i:= 1 to dimF do begin
            assign(detalles[i],'detalle'); 
            reset(detalles[i]); 
            leer(detalles[i], regs[i]); 
        end; 
        
        // 2) Abrir maestro
        reset(mae); 
        read(mae, regm); 
        
        // 3) Inicializar merge
        minimo(detalles, regs, min); 
        
        // 4) Procesar todos los registros de detalle
        while (min.codigo_localidad <> valorAlto) do begin 
            actual:= min; 
            total_fallecidos:= 0; 
            total_recuperados:= 0; 
            activos:= 0; 
            nuevos:= 0;
            // Acumulo todos los registros que coinciden en localidad+cepa
            while (min.codigo_localidad = actual.codigo_localidad) and (min.codigo_cepa = actual.codigo_cepa) do begin 
                total_fallecidos:= total_fallecidos + min.fallecidos; 
                total_recuperados:= total_recuperados + min.recuperados; 
                activos:= min.casos_activos; 
                nuevos:= min.casos_nuevos; 
                minimo(detalles, regs, min); 
            end; 
            
            // 5) Buscar el registro exacto en el maestro
            while (min.codigo_localidad <> regm.codigo_localidad)
                and (min.codigo_cepa <> regm.codigo_cepa) do
                read(mae, regm);
            
            // 6) Actualizar 
            regm.fallecidos:= total_fallecidos; 
            regm.recuperados:= total_recuperados; 
            regm.casos_activos:= activos; 
            regm.casos_nuevos:= nuevos; 
            
            // 7) Escribir actualizacion en maestro 
            seek(mae,filepos(mae)-1); 
            write(mae,regm); 
        end; 
        // 8) Cerrar archivos
        close(mae); 
        
        for i:= 1 to dimF do 
            close(detalles[i])
    end; 

    procedure contarActivos(var mae: maestro); 
    var
        contador: integer; 
        regm: reg_maestro; 
    begin 
        contador:= 0; 
        reset(mae); 
        while(not eof(mae)) do begin 
            read(mae,regm); 
            if (regm.casos_activos > 50) then
                contador:= contador + 1; 
        end; 
        writeln('Localidades con >50 casos activos: ', contador);
        close(mae);
    end; 
var 
    mae: maestro; 
    dets: detalles; 
begin
    assign(mae, 'maestro.dat'); 
    actualizarMaestro(mae, dets); 
    contarActivos(mae); 
end. 
