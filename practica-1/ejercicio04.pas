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
    
    procedure agregarEmpleados(var a: archivo_empleados); 
    var 
        eActual, e: empleados; existe: boolean; 
    begin 
        reset(a);
        leerEmpleado(e);
        while (e.apellido <> 'fin') do begin 
            existe:= false; 
            seek(a, 0);     //me posiciono al inicio  
            while(not EOF(a) and (existe = false)) do begin 
                read(a, eActual); 
                if(e.nro = eActual.nro) then 
                    existe:= true; 
            end; 
            if(existe = false) then begin 
                seek(a,fileSize(a));    //me posiciono al final para agregar el nuevo empleado
                write(a, e);  
            end
            else 
                writeln('el numero de empleado ya se encuentra cargado');
            leerEmpleado(e); 
        end; 
        close(a); 
    end;
    
    procedure modificarEdadEmpleado(var a: archivo_empleados); 
    var 
        encontre: boolean; nro, edad: integer; e: empleados; 
    begin 
        encontre:= false; 
        writeln('ingrese numero de empleado a modificarle la edad '); 
        readln(nro); 
        reset(a); 
        while (not EOF(a) and (encontre = false)) do begin 
            read(a, e); 
            if (e.nro = nro) then begin 
                encontre:= true; 
                writeln('ingrese la nueva edad '); 
                readln(edad); 
                e.edad:= edad;
                seek(a, filePos(a)-1); // me posiciono una pos anterior a la actual ya que el read avanza el puntero  
                write(a, e); 
            end; 
        end; 
        if (encontre) then 
            writeln('Se modifico la edad')
        else 
            writeln('No se encontro empleado con el numero ingresado');
        close(a); 
    end; 
    
    procedure exportar1(var a: archivo_empleados); 
    var 
        archivo_texto: text; 
        e: empleados; 
    begin 
        assign(archivo_texto, 'todos_empleados.txt'); 
        rewrite(archivo_texto); // creo archivo de texto 
        reset(a); // abro archivo binario 
        while (not EOF(a)) do begin 
            read(a, e); 
            with e do writeln(archivo_texto, nro, ' ', apellido, ' ' , nombre, ' ' , edad, ' ', dni); // escribo en el archivo_texto todos los campos
        end; 
        close(a);
        close(archivo_texto);
    end;
    
    procedure exportar2(var a: archivo_empleados); 
    var
        archivo_texto: text; 
        e: empleados; 
    begin 
        assign(archivo_texto, 'faltaDNIEmpleado.txt'); 
        rewrite(archivo_texto);
        reset(a); 
        while (not EOF(a)) do begin 
            read(a, e); 
            if (e.dni = 00) then 
                with e do writeln(archivo_texto,  nro, ' ', apellido, ' ' , nombre, ' ' , edad, ' ', dni);
        end; 
        close(a);
        close(archivo_texto);
    end; 
    
var 
    a: archivo_empleados; 
    opc: integer; 
begin 
    repeat 
        writeln('---------------MENU---------------'); 
        writeln('1. crear archivo de empleados (PRIMERA OPCION OBLIGATORIA) ');
        writeln('2. listar por nombre o apellido ');
        writeln('3. listar todos los empleados'); 
        writeln('4. listar por mayores de 70' ); 
        writeln('5. añadir empleados' ); 
        writeln('6. modificar edad del empleado ');
        writeln('7. exportar todos los empleados a archivo de texto '); 
        writeln('8. exportar los empleados con dni 00 a archivo de texto '); 
        readln(opc);
        case opc of 
            0: writeln('saliendo..');
            1: cargarArchivo(a);  
            2: listarPorNombre(a); 
            3: listarTodos(a); 
            4: listarMayores70(a); 
            5: agregarEmpleados(a);
            6: modificarEdadEmpleado(a); 
            7: exportar1(a); 
            8: exportar2(a); 
        end;
    until(opc = 0);
end. 
