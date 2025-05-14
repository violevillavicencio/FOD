program ejercicio7;
const
    CORTE = 500000; 
type
    Ave = record
        codigo: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;

    ArchivoAves = file of Ave;

  // Muestra todo el contenido del archivo
  procedure imprimirArchivo(var archivo: ArchivoAves);
  var
      ave: Ave;
  begin
      reset(archivo);
      while not eof(archivo) do
      begin
          read(archivo, ave);
          writeln('Código: ', ave.codigo, ' | Nombre: ', ave.nombre, 
                  ' | Familia: ', ave.familia, ' | Zona: ', ave.zona);
      end;
      close(archivo);
  end;
  
  // Marca con código -1 las especies a eliminar (baja lógica)
  procedure realizarBajaLogica(var archivo: ArchivoAves);
  var
      codigoABorrar: integer;
      ave: Ave;
      encontrada: boolean;
  begin
      reset(archivo);
      writeln('Ingrese el código de especie a eliminar (', CORTE, ' para terminar):');
      readln(codigoABorrar);
  
      while codigoABorrar <> CORTE do
      begin
          encontrada := false;
          seek(archivo, 0);  // Reinicia búsqueda en archivo
          while (not eof(archivo)) and (not encontrada) do
          begin
              read(archivo, ave);
              if ave.codigo = codigoABorrar then begin
                  ave.codigo := -1; // Marca como eliminada
                  seek(archivo, filepos(archivo) - 1);
                  write(archivo, ave);
                  encontrada := true;
              end;
          end;
  
          if not encontrada then
              writeln('No se encontró especie con código ', codigoABorrar);
  
          writeln('Ingrese otro código a eliminar (', CORTE, ' para terminar):');
          readln(codigoABorrar);
      end;
  
      close(archivo);
  end;
  
  // Compacta el archivo eliminando físicamente los registros marcados
  procedure compactarArchivo(var archivo: ArchivoAves);
  var
      aveActual, aveUltima: Ave;
      posicionActual: integer;
  begin
      reset(archivo);
      while not eof(archivo) do begin
          posicionActual := filepos(archivo);
          read(archivo, aveActual);
  
          if aveActual.codigo = -1 then  // Registro marcado para borrar
          begin
              seek(archivo, filesize(archivo) - 1); // Ir al último registro
              read(archivo, aveUltima);
  
              // Elimina del final registros marcados, si los hay
              while (aveUltima.codigo = -1) and (filesize(archivo) > 0) do begin
                  seek(archivo, filesize(archivo) - 1);
                  truncate(archivo);
                  if filesize(archivo) > 0 then
                  begin
                      seek(archivo, filesize(archivo) - 1);
                      read(archivo, aveUltima);
                  end;
              end;
  
              // Si todavía hay registros válidos, reemplazamos el marcado
              if posicionActual < filesize(archivo) then
              begin
                  seek(archivo, posicionActual - 1);
                  write(archivo, aveUltima);
                  seek(archivo, filesize(archivo) - 1);
                  truncate(archivo);
                  seek(archivo, posicionActual - 1); // Vuelve para seguir leyendo bien
              end;
          end;
      end;
      close(archivo);
  end;

var
    archivo: ArchivoAves;
begin
    assign(archivo, 'ArchivoAves');

    writeln('Contenido original del archivo:');
    imprimirArchivo(archivo);

    writeln('--- Iniciando baja lógica ---');
    realizarBajaLogica(archivo);

    writeln('Contenido tras baja lógica:');
    imprimirArchivo(archivo);

    writeln('--- Compactando archivo (baja física) ---');
    compactarArchivo(archivo);

    writeln('Contenido final tras compactación:');
    imprimirArchivo(archivo);
end.
