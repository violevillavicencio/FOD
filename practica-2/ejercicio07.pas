program ejercicio7;
const
    valorAlto = 9999;
type
    reg_maestro = record
        codigo_alumno: integer;
        apellido: string[30];
        nombre: string[30];
        cursadas_aprobadas: integer;
        finales_aprobados: integer;
    end;

    cursada = record
        codigo_alumno: integer;
        codigo_materia: integer;
        anio: integer;
        aprobada: boolean;
    end;

    rango_nota = 1..10;
    final = record
        codigo_alumno: integer;
        codigo_materia: integer;
        fecha: string[10];
        nota: rango_nota;
    end;
    
    maestro = file of reg_maestro;
    
    detCurs = file of cursada;
    
    detFinal = file of final;
    
    procedure leerCurs(var d: detCurs; var r: cursada);
    begin
      if not eof(d) then
        read(d, r)
      else
        r.codigo_alumno := valorAlto;
    end;
    
    procedure leerFin(var d: detFinal; var r: final);
    begin
      if not eof(d) then
        read(d, r)
      else
        r.codigo_alumno := valorAlto;
    end;
    
    function minCodigo(rC: cursada; rF: final): integer;
    begin
        if (rC.codigo_alumno < rF.codigo_alumno) then
            minCodigo := rC.codigo_alumno
        else
            minCodigo := rF.codigo_alumno;
    end;
    
    procedure actualizarMaestro(var mae: maestro; var dC: detCurs; var dF: detFinal); 
    var 
        regm: reg_maestro;
        rC: cursada;
        rF: final;
        codActual: integer;
        cntCurs, cntFin: integer;
    begin
        {-- 1) Abrir archivos --}
        assign(mae, 'maestro.dat');
        reset(mae);
        
        assign(dC, 'detalleCursadas.dat');
        reset(dC);
      
        assign(dF, 'detalleFinales.dat');
        reset(dF);

        {-- 2) Leer primer registro de cada detalle --}
        leerCurs(dC, rC);
        leerFin(dF, rF);

        {-- 3) Merge por código de alumno --}
        while (rC.codigo_alumno <> valorAlto) or (rF.codigo_alumno <> valorAlto) do begin
            // Determino el siguiente código de alumno a procesar
            codActual := minCodigo(rC, rF);
            cntCurs := 0;
            cntFin  := 0;

            // Acumulo todas las cursadas aprobadas para codActual
            while (rC.codigo_alumno = codActual) do begin
                if (rC.aprobada) then
                    cntCurs := cntCurs + 1;
                leerCurs(dC, rC);
            end;

            // Acumulo todos los finales aprobados (nota>=4) para codActual
            while (rF.codigo_alumno = codActual) do begin
                if (rF.nota >= 4) then
                    cntFin := cntFin + 1;
                leerFin(dF, rF);
            end;
    
            {-- 4) Actualizar maestro para codActual --}
            // Reposiciono al inicio y busco el alumno
            read(mae, regm);
            while (regm.codigo_alumno <> codActual) do
                read(mae, regm);
    
            // Incremento los contadores en el maestro
            regm.cursadas_aprobadas := regm.cursadas_aprobadas + cntCurs;
            regm.finales_aprobados  := regm.finales_aprobados  + cntFin;
    
            // Escribo de vuelta en el maestro
            seek(mae, FilePos(mae) - 1);
            write(mae, regm);
        end;

        {-- 5) Cerrar archivos --}
        close(mae);
        close(dC);
        close(dF);
    end;
var 
    mae: maestro; d1: detCurs; d2: detFinal; 
begin 
    actualizarMaestro(mae,d1,d2);
end.
