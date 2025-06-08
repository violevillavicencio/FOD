program parcial; 
const 
    valorAlto = 9999; 
type 
    fecha = record
        dia: integer;
        mes: integer;
        año: integer;
    end;
    prestamo = record
        sucursal: integer; 
        dni_empleado: longInt; 
        num_prestamo: integer; 
        fecha: fecha; 
        monto: real; 
    end; 
    
    archivo_prestamos = file of prestamo; 
    
    archivo_texto = text; 
    
    procedure leer(var a: archivo_prestamos; var p:prestamo); 
    begin 
        if (not eof(a)) then 
            read(a,p)
        else 
            p.sucursal:= valorAlto; 
    end; 
    
    procedure generarInforme(var arch: archivo_prestamos; var txt: archivo_texto); 
    var 
        p: prestamo; 
        sucursalActual, añoActual: integer;
        dniActual: longInt; 
        ventasXsucursal: integer; 
        montoXsucursal: real; 
        ventasXaño: integer; 
        montoXaño: real; 
        ventas_empleado: integer; 
        monto_empleado: real; 
        ventas_empresa: integer; 
        monto_empresa: real; 
    begin 
        assign(arch, 'archivo_prestamos.dat'); 
        reset(arch); // abro el archivo existente
        assign(txt, 'archivo_prestamos.txt'); 
        rewrite(txt); // creo el de carga
        writeln(txt, 'Informe de ventas de la empresa');
        leer(arch,p);
        ventas_empresa:= 0; 
        monto_empresa:= 0; 
        while (p.sucursal <> valorAlto) do begin 
            sucursalActual:= p.sucursal; 
            writeln(txt, 'Sucursal:' , sucursalActual); 
            ventasXsucursal:= 0; 
            montoXsucursal:= 0; 
            
            while(p.sucursal = sucursalActual) do begin
                dniActual:= p.dni_empleado; 
                writeln(txt,    'Empleado: DNI', dniActual);
                ventas_empleado:= 0; 
                monto_empleado:= 0; 
    
                
                while(p.sucursal = sucursalActual) and (p.dni_empleado = dniActual) do begin 
                    añoActual:= extraerAño(p.fecha); 
                    ventasXaño:= 0; 
                    montoXaño:= 0; 
                    
                    while(p.sucursal = sucursalActual) and (p.dni_empleado = dniActual) and (extraerAño(p.fecha) = añoActual) do begin 
                       ventasXaño:= ventasXaño + 1; 
                       montoXaño:=  montoXaño + p.monto; 
                       leer(arch, p);
                    end; 
                    
                    writeln(txt, 'Año: ', añoActual);
                    writeln(txt, 'Cantidad de ventas: ', ventasXaño, '   Monto de ventas: ', montoXaño:0:2);
                    ventas_empleado := ventas_empleado + ventasXaño;
                    monto_empleado := monto_empleado + montoXaño;
                end; 
                
                writeln(txt, 'Totales del empleado -> Ventas: ', ventas_empleado, '  Monto: ', monto_empleado:0:2);
                writeln(txt, '');   
                ventasXsucursal := ventasXsucursal + ventas_empleado;
                montoXsucursal := montoXsucursal + monto_empleado;
            end;

            writeln(txt, 'Totales de la sucursal -> Ventas: ', ventasXsucursal, '  Monto: ', montoXsucursal:0:2);
            ventasEmpresa := ventasEmpresa + ventasXsucursal;
            montoEmpresa := montoEmpresa + montoXsucursal;
        end;

        writeln(txt, '');
        writeln(txt, 'Resumen total de la empresa:');
        writeln(txt, 'Total de ventas: ', ventasEmpresa);
        writeln(txt, 'Monto total vendido: ', montoEmpresa:0:2);
        
        close(arch);
        close(txt);
    end;
    
var 
    arch: archivo_prestamos; texto: archivo_texto; 
begin 
    generarInforme(arch, texto); 
end. 
