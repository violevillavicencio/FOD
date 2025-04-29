{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados. }

program ejercicio4;
type
    empleado = record
        numero: integer;
        apellido: string[20];
        nombre: string[15];
        edad: integer;
        dni: integer;
    end;
    
    archivo = file of empleado;

procedure eliminarEmpleado(var arc: archivo);
var
    cod: integer;
    ultEmp, e: empleado;
begin
    reset(arc);
    writeln('Ingrese el codigo del empleado a eliminar');
    readln(cod);
    seek(arc, fileSize(arc)-1);
    read(arc, ultEmp);
    seek(arc, 0);
    read(arc, e);
    while(not eof(arc) and (e.numero <> cod)) do
        read(arc, e);
    if(e.numero = cod) then begin
            seek(arc, filePos(arc)-1);      // Volver a la posición del registro encontrado
            write(arc, ultEmp);            // Escribir sobre él el último registro
            seek(arc, fileSize(arc)-1);    // Ir a la última posición (que ahora está duplicada)
            truncate(arc);                 // Eliminar el último registro
            writeln('Se encontro el empleado con codigo', cod , ' y se realizo la baja correctamente');
    end
    else
        writeln('No se encontro el empleado con codigo ', cod , ' y no se realizo ninguna baja');
    close(arc);
end;
var 
    arc : archivo; 
begin
    eliminarEmpleado(arc); 
end.
