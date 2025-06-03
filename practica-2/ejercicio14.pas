{
14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus 
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la 
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles 
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida 
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino 
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada 
uno del maestro. Se pide realizar los módulos necesarios para: 
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje 
sin asiento disponible. 
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que 
tengan menos de una cantidad específica de asientos disponibles. La misma debe 
ser ingresada por teclado. 
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}
program ejercicio14;
const
    valorAlto = 'zzz'; 
type
    str30 = string[30];
    strFechaHora = string[12]; // AAAAMMDDHHMM

    reg_maestro = record
        destino: str30;
        fechaHora: strFechaHora;
        asientos_disponibles: integer;
    end;

    reg_detalle = record
        destino: str30;
        fechaHora: strFechaHora;
        asientos_comprados: integer;
    end;

    maestro = file of reg_maestro;
    detalle = file of reg_detalle;

procedure leerDetalle(var d: detalle; var r: reg_detalle);
begin
    if not eof(d) then
        read(d, r)
    else
        r.destino := valorAlto;
end;

procedure leerMaestro(var m: maestro; var r: reg_maestro);
begin
    if not eof(m) then
        read(m, r)
    else
        r.destino := valorAlto;
end;

procedure minimo(var d1, d2: detalle; var r1, r2, min: reg_detalle);
begin
    if (r1.destino < r2.destino) or 
       ((r1.destino = r2.destino) and (r1.fechaHora <= r2.fechaHora)) then
    begin
        min := r1;
        leerDetalle(d1, r1);
    end
    else begin
        min := r2;
        leerDetalle(d2, r2);
    end;
end;

procedure actualizarMaestro(var mae: maestro; var d1, d2: detalle; umbral: integer);
var
    r1, r2, min: reg_detalle;
    regm: reg_maestro;
    clave_destino: str30;
    clave_fechaHora: strFechaHora;
    totalComprado: integer;
begin
    reset(mae);
    reset(d1); reset(d2);

    leerDetalle(d1, r1);
    leerDetalle(d2, r2);
    minimo(d1, d2, r1, r2, min);

    leerMaestro(mae, regm);

    while (regm.destino <> valorAlto) do begin
        // Coinciden clave del maestro y detalle
        while (min.destino <> valorAlto) and 
              (regm.destino = min.destino) and 
              (regm.fechaHora = min.fechaHora) do
        begin
            regm.asientos_disponibles := regm.asientos_disponibles - min.asientos_comprados;
            minimo(d1, d2, r1, r2, min); // Siguiente mínimo
        end;

        // Actualizo maestro
        seek(mae, filepos(mae)-1);
        write(mae, regm);

        // Informar si está por debajo del umbral
        if regm.asientos_disponibles < umbral then
            writeln('Destino: ', regm.destino, ' | FechaHora: ', regm.fechaHora, ' | Asientos: ', regm.asientos_disponibles);

        leerMaestro(mae, regm);
    end;

    close(mae);
    close(d1); close(d2);
end;

var
    mae: maestro;
    d1, d2: detalle;
    umbral: integer;
begin
    assign(mae, 'maestro.dat');
    assign(d1, 'detalle1.dat');
    assign(d2, 'detalle2.dat');

    write('Ingrese umbral de asientos disponibles: ');
    readln(umbral);

    actualizarMaestro(mae, d1, d2, umbral);
end.
