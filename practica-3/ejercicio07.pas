program ejercicio7;
const 
    CORTE = 0;
type
    aves = record
        codigo: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;

    archivoAves = file of aves;

    procedure realizarBajaLogica(var archivo: archivoAves; codigoABorrar: integer);
    var
        ave: aves;
        encontrada: boolean;
    begin
        reset(archivo);
        encontrada := false;
        while (not eof(archivo)) and (not encontrada) do begin
            read(archivo, ave);
            if (ave.codigo = codigoABorrar) then begin
                encontrada := true;
                ave.codigo := -1;
                seek(archivo, filepos(archivo) - 1);
                write(archivo, ave);
            end;
        end;
        if not encontrada then
            writeln('No se encontró especie con código ', codigoABorrar);
        close(archivo);
    end;

    procedure compactarArchivo(var arc: archivo_aves);
    var
        a, ultimo: aves;
        i, tam: integer;
    begin
        reset(arc);
        tam := filesize(arc);
        i := 0;  
        while (i < tam) do begin
            seek(arc, i);
            read(arc, a);
            if (a.codigo < 0) then begin
                // Buscar último válido
                repeat
                    tam := tam - 1;
                    seek(arc, tam);
                    read(arc, ultimo);
                until (ultimo.codigo >= 0) or (i >= tam); // Último válido o ya se cruzaron
                if (i < tam) then begin
                    seek(arc, i);
                    write(arc, ultimo);
                end;
            end else
                i := i + 1;
        end;
        // Truncar una sola vez
        seek(arc, tam);
        truncate(arc);
        close(arc);
    end;

var
    archivo: archivoAves;
    codigoABorrar: integer;
begin
    assign(archivo, 'ArchivoAves');
    writeln('Ingrese el código de especie a eliminar (', CORTE, ' para terminar):');
    readln(codigoABorrar);
    while (codigoABorrar <> CORTE) do begin
        realizarBajaLogica(archivo, codigoABorrar);
        readln(codigoABorrar);
    end;
    writeln('Compactando archivo (baja física)...');
    compactarArchivo(archivo);
    writeln('Archivo compactado correctamente.');
end.
