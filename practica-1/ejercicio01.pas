Program ejercicio1; 
type 
	archivo_numeros = file of integer; 
		
	procedure crearArchivo(var a: archivo_numeros); 
	var 
		nombre_fisico: string; num:integer;
	begin 
		writeln('ingrese nombre del archivo a crear:'); 
		readln(nombre_fisico);
		assign(a, nombre_fisico);
		rewrite(a);
		readln(num);
		while ( num <> 30000) do begin 
			write(a,num);
			readln(num);
		end; 
		close(a);
	end; 
	
var 
	a: archivo_numeros; 
begin 
	crearArchivo(a); 
end.
