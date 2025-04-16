program ejercicio9;
const
    valorAlto = 9999;
type
    str30 = string[30];

    reg_venta = record
        cod_cliente: integer;
        nombre: str30;
        apellido: str30;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    archivo_ventas = file of reg_venta;
    
    procedure leer(var f: archivo_ventas; var r: reg_venta);
    begin
      if not eof(f) then
        read(f, r)
      else
        r.cod_cliente := valorAlto;
    end;

    {Realiza el corte de control:
    Agrupa por cliente → año → mes,
    imprime subtotales y total general.}
    procedure corteDeControl(var arch: archivo_ventas);
    var
        reg: reg_venta;
        actual_cliente, actual_anio, actual_mes: integer;
        total_cliente, total_anio, total_mes, total_empresa: real;
    begin
        reset(arch);
        total_empresa := 0;
        leer(arch, reg);
    
        while (reg.cod_cliente <> valorAlto) do begin
            actual_cliente := reg.cod_cliente;
            writeln('Cliente: ', reg.cod_cliente, ' - ', reg.nombre, ' ', reg.apellido);
            total_cliente := 0;
    
            while (reg.cod_cliente = actual_cliente) do begin
                actual_anio := reg.anio;
                writeln('  Año: ', actual_anio);
                total_anio := 0;
    
                while (reg.cod_cliente = actual_cliente) and (reg.anio = actual_anio) do begin
                    actual_mes := reg.mes;
                    writeln('    Mes: ', actual_mes);
                    total_mes := 0;
    
                    while (reg.cod_cliente = actual_cliente) and (reg.anio = actual_anio) and (reg.mes = actual_mes) do begin
                        writeln('      Día: ', reg.dia, ' - Monto: $', reg.monto:0:2);
                        total_mes := total_mes + reg.monto;
                        leer(arch, reg);
                    end;
    
                    writeln('    Total mes ', actual_mes, ': $', total_mes:0:2);
                    total_anio := total_anio + total_mes;
                end;
    
                writeln('  Total año ', actual_anio, ': $', total_anio:0:2);
                total_cliente := total_cliente + total_anio;
            end;
    
            writeln('Total del cliente ', actual_cliente, ': $', total_cliente:0:2);
            writeln('------------------------------------------');
            total_empresa := total_empresa + total_cliente;
        end;
    
        writeln('TOTAL DE VENTAS DE LA EMPRESA: $', total_empresa:0:2);
        close(arch);
    end;
    
var
  arch: archivo_ventas;
begin
  assign(arch, 'ventas.dat');
  corteDeControl(arch);
end.
