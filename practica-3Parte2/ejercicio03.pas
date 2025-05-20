{3. Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar unprocedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
o inclusive, en diferentes máquinas.}

program ejercicio3;
const
    dimf = 5;
type
    info = record
        cod: integer;
        fecha: string[10];  // formato: 'dd/mm/yyyy'
        tiempo: real;
    end;

    arc = file of info;
    vecDetalles = array[1..dimf] of arc;

procedure merge(var mae: arc; var v: vecDetalles);
var
    i: integer;
    regDet, aux: info;
    encontrado: boolean;
begin
    assign(mae, 'ArchivoMaestro.dat');
    rewrite(mae);  // Se crea vacío al inicio
    close(mae);

    for i := 1 to dimf do begin
        reset(v[i]);
        while not eof(v[i]) do begin
            read(v[i], regDet);

            reset(mae);
            encontrado := false;

            while not eof(mae) and not encontrado do begin
                read(mae, aux);
                if (aux.cod = regDet.cod) and (aux.fecha = regDet.fecha) then begin
                    aux.tiempo := aux.tiempo + regDet.tiempo;
                    seek(mae, filepos(mae) - 1);
                    write(mae, aux);
                    encontrado := true;
                end;
            end;

            if not encontrado then begin
                seek(mae, filesize(mae));  // Ir al final para escribir nuevo
                write(mae, regDet);
            end;

            close(mae);
        end;
        close(v[i]);
    end;
end;

procedure mostrarMaestro(var mae: arc);
var
    reg: info;
begin
    reset(mae);
    writeln('Archivo Maestro generado:');
    while not eof(mae) do begin
        read(mae, reg);
        writeln('Cod: ', reg.cod, ' Fecha: ', reg.fecha, ' Tiempo total: ', reg.tiempo:0:2);
    end;
    close(mae);
end;

var
    mae: arc;
    v: vecDetalles;
    i: integer;
    nombre: string;
begin
    // Abrimos los 5 archivos detalle (deben existir previamente)
    for i := 1 to dimf do begin
        str(i, nombre);
        assign(v[i], 'detalle' + nombre + '.dat');
    end;
    merge(mae, v);         // Genera el archivo maestro
    mostrarMaestro(mae);   // Muestra el contenido generado
end.
