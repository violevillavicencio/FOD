program ejercicio4y5;

type
    reg_flor = record
        nombre: string[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

{ Procedimiento para leer una flor desde teclado }
procedure leerFlor(var f: reg_flor);
begin
    writeln('Ingrese el codigo de flor');
    readln(f.codigo);
    if (f.codigo <> -1) then
    begin
        writeln('Ingrese el nombre de flor');
        readln(f.nombre);
    end;
end;

{ Procedimiento para crear el archivo con una cabecera y varias flores }
procedure crearArchivo(var arc: tArchFlores);
var
    f: reg_flor;
begin
    assign(arc, 'ArchivoFlores');
    rewrite(arc); // creo archivo nuevo

    // Escribo la cabecera: código = 0 indica que no hay eliminados
    f.codigo := 0;
    f.nombre := 'Cabecera';
    write(arc, f);

    leerFlor(f);
    while (f.codigo <> -1) do
    begin
        write(arc, f); // agrego flor al archivo
        leerFlor(f);
    end;

    close(arc);
end;

{ Agrega una flor al archivo, reutilizando espacio si hay registros eliminados }
procedure agregarFlor(var a: tArchFlores; nombre: string; codigo: integer);
var
    f, cabecera: reg_flor;
begin
    reset(a); // abro archivo para lectura/escritura

    read(a, cabecera); // leo la cabecera
    f.nombre := nombre;
    f.codigo := codigo;

    if (cabecera.codigo = 0) then
    begin
        // No hay espacio libre, escribo al final
        seek(a, filesize(a));
        write(a, f);
    end
    else
    begin
        // Hay espacio libre: reutilizo el registro eliminado
        seek(a, cabecera.codigo * -1); // me posiciono en el registro libre
        read(a, cabecera);             // leo lo que haya ahí (puntero al siguiente eliminado)
        seek(a, filepos(a) - 1);       // vuelvo atrás una posición
        write(a, f);                   // escribo la nueva flor

        // Actualizo la cabecera con el nuevo tope de pila
        seek(a, 0);
        write(a, cabecera);
    end;

    writeln('Se realizo un alta de la flor con codigo ', f.codigo);
    close(a);
end;

{ Elimina una flor del archivo, apilando el registro como espacio libre }
procedure eliminarFlor(var arc: tArchFlores; flor: reg_flor);
var
    f, cabecera: reg_flor;
    ok: boolean;
begin
    ok := false;
    reset(arc); // abro archivo

    read(arc, cabecera); // leo la cabecera

    while (not eof(arc)) and (not ok) do
    begin
        read(arc, f);
        if (f.codigo = flor.codigo) then
        begin
            ok := true;
            seek(arc, filepos(arc) - 1); // vuelvo a la posición donde estaba la flor
            write(arc, cabecera);        // sobreescribo con la cabecera actual (apilo)

            // Actualizo cabecera con la nueva posición libre
            cabecera.codigo := (filepos(arc) - 1) * -1;
            seek(arc, 0);
            write(arc, cabecera);
        end;
    end;

    close(arc);

    if (ok) then
        writeln('Se elimino la flor con codigo ', flor.codigo)
    else
        writeln('No se encontro la flor con codigo ', flor.codigo);
end;

{ Lista el contenido del archivo, omitiendo las flores eliminadas }
procedure imprimirArchivo(var arc: tArchFlores);
var
    f: reg_flor;
begin
    reset(arc); // abro archivo

    while (not eof(arc)) do
    begin
        read(arc, f);
        if (f.codigo > 0) then // omito flores eliminadas y cabecera
            writeln('Codigo=', f.codigo, ' Nombre=', f.nombre);
    end;

    close(arc);
end;

{ Programa principal }
var
    arc: tArchFlores;
    f: reg_flor;
begin
    crearArchivo(arc);          // creo el archivo con datos
    imprimirArchivo(arc);       // imprimo contenido

    agregarFlor(arc, 'Margarita', 10); // agrego flor
    imprimirArchivo(arc);              // imprimo contenido

    f.codigo := 10;            // preparo flor a eliminar
    eliminarFlor(arc, f);      // elimino flor
    imprimirArchivo(arc);      // imprimo contenido

    agregarFlor(arc, 'Rosa', 20); // agrego otra flor
    imprimirArchivo(arc);         // imprimo contenido
end.
