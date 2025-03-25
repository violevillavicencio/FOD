program ejercicio5;
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
    while(opcion <> 5) do
        begin
            case opcion of
                1: crearArchivo(arc, carga);
                2: listarCelularesMenosStock(arc);
                3: listarCelularesMismaDesc(arc);
                4: exportarTexto(arc, carga);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
            writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
            writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
            writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
            writeln('Opcion 5: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
        end;
end.
