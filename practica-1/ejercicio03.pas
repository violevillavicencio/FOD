Program ejercicio3; 
type
    empleados = record 
        nro: integer; 
        apellido: string; 
        nombre: string; 
        edad: integer; 
        dni: LongInt; 
    end; 
    
    archivo_empleados = file of empleados; 
    
    procedure leerEmpleado(var e: empleados); 
    begin
        writeln('ingrese apellido:');
        readln(e.apellido); 
        if (e.apellido <> 'fin') then begin
            writeln('ingrese nombre: '); 
            readln(e.nombre); 
            writeln('ingrese nro empleado: '); 
            readln(e.nro); 
            writeln('ingrese edad: '); 
            readln(e.edad);
            writeln('ingrese dni: '); 
            readln(e.dni); 
        end; 
    end; 
    
    procedure imprimirEmpleado(e: empleados); 
    begin 
        writeln(e.apellido); 
        writeln(e.nombre); 
        writeln(e.nro); 
        writeln(e.edad);
        writeln(e.dni); 
    end; 
    
    procedure cargarArchivo(var a: archivo_empleados);
    var
        e: empleados; nombre_fisico: string; 
    begin
        writeln('ingrese nombre del archivo: '); 
        readln(nombre_fisico);
        assign(a,nombre_fisico);
        rewrite(a); 
        leerEmpleado(e);
        while (e.apellido <> 'fin') do begin 
            write(a, e); 
            leerEmpleado(e);
        end; 
        close(a);
    end; 
    
    procedure listarPorNombre(var a: archivo_empleados); 
    var 
        criterio: string; e: empleados; 
    begin 
        writeln('ingrese nombre o apellido a buscar: '); 
        readln(criterio); 
        reset(a);   
        while(not EOF(a)) do begin 
            read(a, e); 
            if (e.nombre = criterio) or (e.apellido = criterio) then 
                imprimirEmpleado(e); 
        end; 
        close(a); 
    end; 
    
    procedure listarTodos(var a: archivo_empleados); 
    var 
        e: empleados; 
    begin 
        reset(a); 
        while(not EOF(a)) do begin 
            read(a, e); 
            imprimirEmpleado(e); 
        end; 
        close(a); 
    end; 
    
    procedure listarMayores70(var a: archivo_empleados); 
    var 
        e: empleados; 
    begin
        reset(a); 
        while(not EOF(a)) do begin 
            read(a, e); 
            if (e.edad > 70) then 
                imprimirEmpleado(e); 
        end; 
        close(a); 
    end; 
    
var 
    a: archivo_empleados; 
    opc: integer; 
begin 
    cargarArchivo(a);  
    listarPorNombre(a); 
    listarTodos(a); 
    listarMayores70(a); 
end. 
    
