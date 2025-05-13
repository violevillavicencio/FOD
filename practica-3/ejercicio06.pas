program ej6;
type    
    prenda = record
        cod: integer;
        descripcion: string;
        colores: string;
        tipo: string;
        stock: integer;
        precio_unitario: real;
    end;

    archivo_prendas = file of prenda;
    archivo_codigos = file of integer;

// Baja lógica: pone el stock en negativo para las prendas obsoletas
// El archivo maestro no esta ordenado
procedure realizarBajaLogica(var maestro: archivo_prendas; var codigos_obsoletos: archivo_codigos);
var
    codigo: integer;
    p: prenda;
begin
    reset(maestro);
    reset(codigos_obsoletos);
    
    while not eof(codigos_obsoletos) do begin
        read(codigos_obsoletos, codigo);
        seek(maestro, 0); // Vuelve al inicio para buscar cada código

        while not eof(maestro) do begin
            read(maestro, p);
            if (p.cod = codigo) then begin
                p.stock := -1; // Marca baja lógica
                seek(maestro, filepos(maestro) - 1);
                write(maestro, p);
                break; // Salta a siguiente código obsoleto
            end;
        end;
        
    end;
    
    close(maestro);
    close(codigos_obsoletos);
end;

// Baja física: copia solo prendas no borradas a archivo nuevo
procedure compactarMaestro(var maestro: archivo_prendas);
var
    auxiliar: archivo_prendas;
    p: prenda;
begin
    assign(auxiliar, 'ArchivoAuxiliar');
    reset(maestro);
    rewrite(auxiliar);

    while not eof(maestro) do begin
        read(maestro, p);
        if p.stock >= 0 then // Solo prendas válidas
            write(auxiliar, p);
    end;

    close(maestro);
    close(auxiliar);

    rename(maestro, 'ArchivoViejo'); 
    rename(auxiliar, 'ArchivoMaestro'); // Renombra el auxiliar
end;

// Muestra las prendas del archivo maestro
procedure mostrarMaestro(var maestro: archivo_prendas);
var
    p: prenda;
begin
    reset(maestro);
    while not eof(maestro) do begin
        read(maestro, p);
        writeln('Código: ', p.cod, ', Descripción: ', p.descripcion,
                ', Tipo: ', p.tipo, ', Colores: ', p.colores,
                ', Stock: ', p.stock, ', Precio: ', p.precio_unitario:0:2);
    end;
    close(maestro);
end;

var
    maestro: archivo_prendas;
    codigos_obsoletos: archivo_codigos;

begin
    assign(maestro, 'ArchivoMaestro');
    assign(codigos_obsoletos, 'ArchivoObsoletas');

    writeln('Archivo original:');
    mostrarMaestro(maestro);

    writeln('Baja lógica');
    realizarBajaLogica(maestro, codigos_obsoletos);
    writeln('Archivo luego de baja lógica:');
    mostrarMaestro(maestro);

    writeln('Compactación (baja física)');
    compactarMaestro(maestro);
    writeln('Archivo luego de baja física:');
    mostrarMaestro(maestro);
end.
