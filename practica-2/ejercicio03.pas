program ejercicio3;
const
    valorAlto = 'zzz';
type
    datos = record
        provincia: string[30];
        alfabetizados: integer;
        encuestados: integer;
    end;

    censo = record
        provincia: string[30];
        codigo_localidad: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;

    maestro = file of datos;
    detalle = file of censo;

procedure leer(var d: detalle; var r: censo);
begin
    if not eof(d) then
        read(d, r)
    else
        r.provincia := valorAlto;
end;

procedure minimo(var d1, d2: detalle; var r1, r2, min: censo);
begin
    if r1.provincia <= r2.provincia then begin
        min := r1;
        leer(d1, r1);
    end
    else begin
        min := r2;
        leer(d2, r2);
    end;
end;

procedure actualizarMaestro(var mae: maestro; var d1, d2: detalle);
var
    d: datos;
    r1, r2, min, actual: censo;
    totalAlfabetizados, totalEncuestados: integer;
begin
    reset(mae);
    reset(d1);
    reset(d2);
    
    read(mae, d);
    leer(d1, r1);
    leer(d2, r2);
    
    minimo(d1, d2, r1, r2, min);
      
    while (min.provincia <> valorAlto) do begin
        actual := min;
        totalAlfabetizados := 0;
        totalEncuestados := 0;

        // Acumular datos de todas las localidades de la misma provincia
        while (min.provincia = actual.provincia) do begin
            totalAlfabetizados := totalAlfabetizados + min.alfabetizados;
            totalEncuestados := totalEncuestados + min.encuestados;
            minimo(d1, d2, r1, r2, min);
        end;

        // Avanzar en el maestro hasta encontrar la provincia correspondiente
        while (d.provincia <> actual.provincia) do
            read(mae, d);

        d.alfabetizados := d.alfabetizados + totalAlfabetizados;
        d.encuestados := d.encuestados + totalEncuestados;
        seek(mae, filePos(mae) - 1);
        write(mae, d);
        
        if(not eof(mae))then
            read(mae, d);
    end;
    close(mae);
    close(d1);
    close(d2);
end;

var
    d1, d2: detalle;
    mae: maestro;
begin
    assign(mae, 'maestro');
    assign(d1, 'detalle1');
    assign(d2, 'detalle2');
    actualizarMaestro(mae, d1, d2);
end.
