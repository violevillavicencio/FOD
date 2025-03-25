  program ejercicio6;
type
    celular = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        marca: string;
        precio: real;
        stockMin: integer;
        stock: integer;
    end;
    
    archivo = file of celular;
    
    procedure imprimirCelular(c: celular);
    begin
        with c do
            writeln('Codigo=', codigo, ' Nombre=', nombre, ' Descripcion=', descripcion, ' Marca=', marca, ' Precio=', precio:0:2, ' StockMin=', stockMin, ' Stock=', stock);
    end;
    
    procedure crearArchivo(var arc: archivo; var carga: text);
    var
        cel: celular;
        nombre: string;
    begin
        writeln('Ingrese un nombre del archivo a crear');
        readln(nombre);
        assign(arc, nombre);
        reset(carga);
        rewrite(arc);
        while(not eof(carga)) do
            begin
                with cel do 
                    begin
                        readln(carga, codigo, precio, marca);
                        readln(carga, stock, stockMin, descripcion);
                        readln(carga, nombre);
                        write(arc, cel);
                    end;
            end;
        close(arc);
        close(carga);
    end;
    
    procedure listarCelularesMenosStock(var arc: archivo);
    var
        c: celular;
    begin
        reset(arc);
        while(not eof(arc)) do
            begin
                read(arc, c);
                if(c.stock < c.stockMin) then
                    imprimirCelular(c);
            end;
        close(arc);
    end;
    
    procedure listarCelularesMismaDesc(var arc: archivo);
    var
        c: celular;
        descripcion: string;
    begin
        reset(arc);
        writeln('Ingrese una descripcion');
        readln(descripcion);
        while(not eof(arc)) do
            begin
                read(arc, c);
                if(descripcion = c.descripcion) then
                    imprimirCelular(c);
            end;
        close(arc);
    end;
    
    // exportar a un archivo de texto el archivo binario que teniamos respetando el orden de los campos
    procedure exportarTexto(var arc: archivo; var carga: text);
    var
        c: celular;
    begin
        reset(arc);
        rewrite(carga);
        while(not eof(arc)) do
            begin
                read(arc, c);
                with c do
                    begin
                        writeln(carga, codigo, ' ', precio:0:2,' ',marca);
                        writeln(carga, stock, ' ', stockMin,' ',descripcion);
                        writeln(carga, ' ', nombre);
                    end;
            end;
        close(carga);
        close(arc);
    end;
    
    procedure leerCelular(var c: celular);
    begin
        writeln('Ingrese el codigo del celular');
        readln(c.codigo);
        if(c.codigo <> 0) then begin
            writeln('Ingrese el nombre del celular');
            readln(c.nombre);
            writeln('Ingrese la descripcion del celular'); 
            readln(c.descripcion);
            writeln('Ingrese la marca del celular');
            readln(c.marca);
            writeln('Ingrese el precio del celular');
            readln(c.precio);
            writeln('Ingrese el stock minimo del celular');
            readln(c.stockMin);
            writeln('Ingrese el stock del celular');
            readln(c.stock);
        end;
    end;
    
    procedure agregarCelular( var a: archivo); 
    var 
        c, cActual: celular; encontre: boolean; 
    begin 
        reset(a); 
        encontre:= false; 
        leerCelular(c); 
        while (not EOF(a) and (encontre = false)) do begin 
            read(a, cActual); 
            if (c.nombre = cActual.nombre) then 
                encontre:= true; 
        end; 
        if (encontre) then 
            writeln('el celular que queres agregar ya se encuentra en el archivo')
        else 
            seek(a, fileSize(a)); // me posiciono al final 
            write(a, c); // escribo en la ultima posicion 
    end; 
    
    procedure modificarStock(var a: archivo);
    var
        nombre: string; encontre: boolean; stock: integer; 
        c: celular; 
    begin
        readln(nombre);
        reset(a); 
        encontre:= false; 
        while(not EOF(a) and (encontre = false)) do begin
            read(a, c); 
            if(c.nombre = nombre) then begin 
                encontre:= true; 
                readln(stock);
                c.stock:= stock; 
                seek(a, filePos(a)-1); 
                write(a, c); 
            end; 
        end; 
        if (encontre) then 
            writeln('se actualizo el stock con exito')
        else 
            writeln('el celular que queres Modificar no se encuentra en el archivo'); 
    end; 
    
    procedure exportarSinStockTexto(var a: archivo); 
    var 
        c: celular; arch_texto: text; 
    begin 
        assign(arch_texto,'sinStock.txt');
        rewrite(arch_texto); 
        reset(a); 
        while(not EOF(a)) do begin 
            read(a, c); 
            if (c.stock = 0) then begin
                with c do begin 
                    writeln(arch_texto, codigo,' ', precio, '', marca);
                    writeln(arch_texto, stock, '', stockMin, '', descripcion); 
                    writeln(arch_texto, nombre); 
                end; 
            end; 
        end; 
        close(a); 
        close(arch_texto); 
    end;
    
var
    arc: archivo;
    carga: text;
    opcion: integer; 
begin
    assign(carga, 'celulares.txt');
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
    writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
    writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
    writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
    writeln('Opcion 5: Salir del menu y terminar la ejecucion del programa');
    readln(opcion);
    while(opcion <> 5) do begin
        case opcion of
            1: crearArchivo(arc, carga);
            2: listarCelularesMenosStock(arc);
            3: listarCelularesMismaDesc(arc);
            4: exportarTexto(arc, carga);
            5: agregarCelular(arc); 
            6: modificarStock(arc); 
            7: exportarSinStockTexto(arc); 
        else
            writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
        end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
            writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
            writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
            writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
            writeln('Opcion 5: Agregar celular al final' ); 
            writeln('Opcion 6: Modificar Stock'); 
            writeln('Opcion 7: Exportar el archivo de celulares sin stock a un texto sinStock.txt'); 
            writeln('Opcion 8: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
    end;
end.
