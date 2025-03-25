Program ejercicio2; 
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
		while(num <> 30000)do begin 
			write(a,num);
			readln(num);
		end; 
		close(a);
	end; 
	
	procedure procesarArchivo(var a: archivo_numeros);
	var 
		num, menores,total,suma: integer; 
		promedio: real; 
	begin 
		menores:= 0; 
		reset(a);
		while(not EOF(a)) do begin
			readln(a,num);
			if(num < 1500)then 
				menores:= menores + 1; 
			suma:= suma + num; 
			total:= total + 1; 
			writeln(num); // listo el contenido del archivo 
		end; 
		writeln('la cantidad de numeros menores de 1500 es de: ', menores);
		promedio:= suma / total; 
		writeln('el promedio de los numeros ingresados es de: ', promedio); 
		close(a);
	end;
	
var 
	a: archivo_numeros; 
begin 
	crearArchivo(a); 
	procesarArchivo(a);
end.
