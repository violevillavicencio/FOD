program ejercicio2;

type
    localidad = record
        codigo: integer;
        mesa: integer;
        cant: integer;
    end;

    archivo = file of localidad;

{ Carga los datos desde archivo.txt al archivo binario original }
procedure cargarArchivo(var arc: archivo);
var
    txt: text;
    l: localidad;
begin
    assign(txt, 'archivo.txt');
    reset(txt);

    assign(arc, 'ArchivoMaestro');
    rewrite(arc);

    while not eof(txt) do
    begin
        with l do
        begin
            readln(txt, codigo, mesa, cant);
            write(arc, l);
        end;
    end;

    writeln('Archivo maestro generado.');
    close(txt);
    close(arc);
end;

{ Realiza el procesamiento sin modificar el archivo original }
procedure corteDeControl(var arc: archivo; var arcAux: archivo; var cantTotal: integer);
var
    l, aux: localidad;
    encontrado: boolean;
begin
    reset(arc);
    assign(arcAux, 'ArchivoAuxiliar');
    rewrite(arcAux);
    cantTotal := 0;

    while not eof(arc) do
    begin
        read(arc, l);
        encontrado := false;
        seek(arcAux, 0);

        while (not eof(arcAux)) and (not encontrado) do
        begin
            read(arcAux, aux);
            if aux.codigo = l.codigo then
                encontrado := true;
        end;

        if encontrado then
        begin
            aux.cant := aux.cant + l.cant;
            seek(arcAux, filepos(arcAux) - 1);
            write(arcAux, aux);
        end
        else
        begin
            // Copiar solo código y votos (ignoramos el número de mesa para el auxiliar)
            aux.codigo := l.codigo;
            aux.cant := l.cant;
            write(arcAux, aux);
        end;

        cantTotal := cantTotal + l.cant;
    end;

    close(arc);
    close(arcAux);
end;

{ Imprime el archivo auxiliar con los totales por localidad }
procedure imprimirArchivo(var arc: archivo; cantTotal: integer);
var
    l: localidad;
begin
    reset(arc);
    writeln('Codigo de Localidad         Total de Votos');
    writeln('---------------------       ----------------');

    while not eof(arc) do
    begin
        read(arc, l);
        writeln(l.codigo:10, '              ', l.cant);
    end;

    writeln('Total General de Votos: ', cantTotal);
    close(arc);
end;

{ Programa principal }
var
    arc, arcAux: archivo;
    cantTotal: integer;
begin
    cargarArchivo(arc);
    corteDeControl(arc, arcAux, cantTotal);
    imprimirArchivo(arcAux, cantTotal);
end.
