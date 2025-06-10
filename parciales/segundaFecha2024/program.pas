program parcial;
const
    cantDetalles = 30;
    valorAlto = 9999;
type
    rmaestro = record
        cod_municipio: integer;
        nom_municipio: string;
        casos_positivos: integer;
    end;

    maestro = file of rmaestro;

    rdetalle = record
        cod_municipio: integer;
        casos_positivos: integer;
    end;

    detalle = file of rdetalle;

    registros = array[1..cantDetalles] of rdetalle;
    detalles = array[1..cantDetalles] of detalle;

procedure leer(var d: detalle; var rd: rdetalle);
begin
    if (not eof(d)) then
        read(d, rd)
    else
        rd.cod_municipio := valorAlto;
end;

procedure minimo(var dets: detalles; var regs: registros; var min: rdetalle);
var
    i, pos: integer;
begin
    min.cod_municipio := valorAlto;
    for i := 1 to cantDetalles do
        if (regs[i].cod_municipio < min.cod_municipio) then begin
            min := regs[i];
            pos := i;
        end;
    if (min.cod_municipio <> valorAlto) then
        leer(dets[pos], regs[pos]);
end;

procedure actualizarEinformar(var mae: maestro; var dets: detalles);
var
    regs: registros;
    rmae: rmaestro;
    min: rdetalle;
    i, total_positivos: integer;
begin
    for i := 1 to cantDetalles do begin
        reset(dets[i]);
        leer(dets[i], regs[i]);
    end;

    reset(mae);
    minimo(dets, regs, min);
    while not eof(mae) do begin
        read(mae, rmae);
        total_positivos := 0;
        while (min.cod_municipio = rmae.cod_municipio) do begin
            total_positivos := total_positivos + min.casos_positivos;
            minimo(dets, regs, min);
        end;
        
        if (total_positivos > 0) then begin
            rmae.casos_positivos := rmae.casos_positivos + total_positivos;
            seek(mae, filepos(mae) - 1);
            write(mae, rmae);
        end; 
        
        if (rmae.casos_positivos > 15) then
            writeln('Municipio código: ', rmae.cod_municipio, ' - Nombre: ', rmae.nom_municipio, ' supera los 15 casos positivos');
    end;

    close(mae);
    for i := 1 to cantDetalles do
        close(dets[i]);
end;

var
    i: integer;
    nombrefisico: string;
    mae: maestro;
    dets: detalles;
begin
    writeln('Ingrese el nombre del archivo maestro:');
    readln(nombrefisico);
    assign(mae, nombrefisico);

    for i := 1 to cantDetalles do begin
        writeln('Ingrese el nombre del archivo detalle ', i, ':');
        readln(nombrefisico);
        assign(dets[i], nombrefisico);
    end;

    actualizarEinformar(mae, dets);
end.
