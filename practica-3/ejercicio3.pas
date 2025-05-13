{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario}
program ejercicio3;
type
    novela = record
        codigo: integer;
        genero: string;
        nombre: string;
        duracion: real;
        director: string;
        precio: real;
    end;
    archivo = file of novela;
    
    procedure leerNovela(var n: novela);
    begin
        writeln('Ingrese codigo de la novela (-1 para finalizar):');
        readln(n.codigo);
        if(n.codigo <> -1) then begin
            writeln('Ingrese el genero de la novela:');
            readln(n.genero);
            writeln('Ingrese el nombre de la novela:');
            readln(n.nombre);
            writeln('Ingrese la duracion de la novela:');
            readln(n.duracion);
            writeln('Ingrese el director de la novela:');
            readln(n.director);
            writeln('Ingrese el precio de la novela:');
            readln(n.precio);
        end;
    end;
    
    procedure crearArchivo(var arc: archivo);
    var
        n: novela;
        nombre: string;
    begin
        writeln('Ingrese el nombre del archivo:');
        readln(nombre);
        assign(arc, nombre);
        rewrite(arc);
        n.codigo := 0; // simulo cabecera, pongo el codigo en 0 
        write(arc, n);
        leerNovela(n);
        while(n.codigo <> -1) do begin
            write(arc, n);
            leerNovela(n);
        end;
        close(arc);
    end;

    procedure alta(var arc: archivo);
    var
        regNovela, cabecera: novela;
        nombre: string;
    begin
        writeln('Ingrese el nombre del archivo:');
        readln(nombre);
        assign(arc, nombre);
        reset(arc);
        read(arc, cabecera); // leo el primer registro del archivo (cabecera)
        leerNovela(regNovela); // leo una nueva novela 
        if(cabecera.codigo = 0) then begin  // si es 0 me indica que no hay lugares para reutilizar
            seek(arc, filesize(arc)); // me posiciono al final del archivo 
            write(arc, regNovela);  // escribo la nueva novela 
        end else begin  // si no es 0, me indica que hay espacio libre 
            seek(arc, cabecera.codigo*-1); // me paro en la posicion a reutilizar 
            read(arc, cabecera);  // leo la cabecera
            seek(arc, filepos(arc)-1);  //me posiciono en la cabecera 
            write(arc, regNovela); // escribo la nueva novela 
            seek(arc, 0);  // voy a la primer posicion del archivo (lugar de la cabecera)
            write(arc, cabecera); // actualizo la cabecera
        end;
        close(arc);
    end;
    
    procedure modificarNovela(var arc: archivo);
    var
        n: novela;
        cod: integer;
        encontre: boolean;
        pos: integer;
        nombre: string;
    begin
        writeln('Ingrese el nombre del archivo:');
        readln(nombre);
        assign(arc, nombre);
        encontre := false;
        reset(arc);
        writeln('Ingrese el codigo de novela a modificar:');
        readln(cod);
        while(not eof(arc) and (not encontre)) do begin
            pos := filepos(arc);
            read(arc, n);
            if(n.codigo = cod) then begin
                encontre := true;
                writeln('Ingrese los nuevos datos de la novela:');
                n.codigo := cod;
                writeln('Genero:');
                readln(n.genero);
                writeln('Nombre:');
                readln(n.nombre);
                writeln('Duracion:');
                readln(n.duracion);
                writeln('Director:');
                readln(n.director);
                writeln('Precio:');
                readln(n.precio);
                seek(arc, pos);
                write(arc, n);
            end;
        end;
        if(encontre) then
            writeln('Se modifico la novela con codigo ', cod)
        else
            writeln('No se encontro la novela con codigo ', cod);
        close(arc);
    end;
    
    procedure baja(var arc: archivo);
    var
        regNovela, cabecera: novela;
        cod, pos: integer;
        nombre: string;
        encontrado: boolean;
    begin
        writeln('Ingrese el nombre del archivo:');
        readln(nombre);
        assign(arc, nombre);
        reset(arc);
        read(arc, cabecera); // Leo el primer registro del archivo, que es la cabecera
        writeln('Ingrese el código de la novela a eliminar:');
        readln(cod); 
    
        encontrado := false;
        // Recorro el archivo desde la posición 1 en adelante (porque 0 es la cabecera)
        while (not eof(arc)) and (not encontrado) do begin
            pos := filepos(arc);  // Guardo la posición actual
            read(arc, regNovela); // Leo el registro actual
            
            if (regNovela.codigo = cod) then begin
                encontrado := true;
                seek(arc, pos); // Me posiciono en la posición donde estaba la novela a eliminar
                write(arc, cabecera); // En esa posición escribo el contenido de la cabecera actual
                cabecera.codigo := -pos; // Actualizo la cabecera: ahora el nuevo espacio libre es esta posición eliminada
                seek(arc, 0); // Vuelvo a la posición 0 (cabecera del archivo) y la actualizo
                write(arc, cabecera);
                writeln('Novela eliminada');
            end;
            
        end;
    
        if (not encontrado) then
            writeln('No se encontró una novela con ese código.');
            
        close(arc);
    end;

    
    procedure pasarTxt(var arc: archivo);
    var
        txt: text;
        n: novela;
        nombre: string;
    begin
        writeln('Ingrese el nombre del archivo binario:');
        readln(nombre);
        assign(arc, nombre);
        reset(arc);
        assign(txt, 'novelas.txt');
        rewrite(txt);
        while(not eof(arc)) do begin
            read(arc, n);
            if(n.codigo < 1) then
                writeln(txt, 'BORRADO - Codigo=', n.codigo)
            else
                writeln(txt, 'Codigo=', n.codigo, ' Genero=', n.genero, ' Nombre=', n.nombre,
                        ' Duracion=', n.duracion:0:2, ' Director=', n.director, ' Precio=', n.precio:0:2);
        end;
        close(arc);
        close(txt);
        writeln('Archivo novelas.txt generado.');
    end;
    
    procedure menu();
    var
        arc: archivo;
        opcion: integer;
    begin
        repeat
            writeln;
            writeln('MENU DE OPCIONES');
            writeln('1. Crear el archivo');
            writeln('2. Dar de alta una novela');
            writeln('3. Modificar los datos de una novela');
            writeln('4. Eliminar una novela');
            writeln('5. Listar en un archivo de texto todas las novelas (incluye borradas)');
            writeln('6. Salir');
            readln(opcion);
            case opcion of
                1: crearArchivo(arc);
                2: alta(arc);
                3: modificarNovela(arc);
                4: baja(arc);
                5: pasarTxt(arc);
                6: writeln('Saliendo del programa...');
            else
                writeln('Opcion invalida');
            end;
        until opcion = 6;
    end;
begin
    menu;
end.
