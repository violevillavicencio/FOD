{
La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web 
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se 
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día, 
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado 
por los siguientes criterios: año, mes, día e idUsuario. 
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará 
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato 
mostrado a continuación:  

Año : --- 
      Mes:-- 1 
            día:-- 1 
                    idUsuario 1   Tiempo Total de acceso en el dia 1 mes 1  
                    --------                    
                    idUsuario N    Tiempo total de acceso en el dia 1 mes 1  
            Tiempo total acceso dia 1 mes 1   
------------- 
            día N 
                    idUsuario 1   Tiempo Total de acceso en el dia N mes 1  
                    --------                    
                    idUsuario N    Tiempo total de acceso en el dia N mes 1  
            Tiempo total acceso dia N mes 1 
       Total tiempo de acceso mes 1 
------ 
       Mes 12 
            día 1 
                   idUsuario 1   Tiempo Total de acceso en el dia 1 mes 12  
                   --------                    
                    idUsuario N    Tiempo total de acceso en el dia 1 mes 12  
            Tiempo total acceso dia 1 mes 12   
 ------------- 
            día N 
                    idUsuario 1   Tiempo Total de acceso en el dia N mes 12                     
                    --------                    
                    idUsuario N    Tiempo total de acceso en el dia N mes 12 
                    
Tiempo total acceso dia N mes 12 
Total tiempo de acceso mes 12 
Total tiempo de acceso año 

Se deberá tener en cuenta las siguientes aclaraciones: 
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado. 
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año 
no encontrado”. 
● Debe definir las estructuras de datos necesarias.  
● El recorrido del archivo debe realizarse una única vez procesando sólo la información 
necesaria.    
}

program ejercicio12;
const
	valorAlto = 9999;
type
	rango_mes = 1..12;
	rango_dia = 1..31;

	reg_accesos = record
		anio: integer;
		mes: rango_mes;
		dia: rango_dia;
		idUsuario: integer;
		tiempo_acceso: real;
	end;

	archivo_accesos = file of reg_accesos;
    
    procedure leer(var a: archivo_accesos; var r: reg_accesos);
    begin
    	if not eof(a) then
    		read(a, r)
    	else
    		r.anio := valorAlto;
    end;
    
    procedure informe(var a: archivo_accesos);
    var
    	reg: reg_accesos;
    	anio_buscado, anioActual, mesActual, diaActual, usuarioActual: integer;
    	totalAnio, totalMes, totalDia, totalUsuario: real;
    	encontre: boolean;
    begin
    	assign(a, 'archivo_accesos');
    	reset(a);
    	leer(a, reg);
    	
    	writeln('Ingrese el año sobre el cual desea realizar el informe: ');
    	readln(anio_buscado);
    	encontre := false;
    
    	while (reg.anio <> valorAlto) and (not encontre) do begin
    		anioActual := reg.anio;
    
    		if (anioActual = anio_buscado) then begin
    			encontre := true;
    			totalAnio := 0;
    			writeln('Año: ', anioActual);
    
    			while (reg.anio = anio_buscado) do begin
    				mesActual := reg.mes;
    				totalMes := 0;
    				writeln('	Mes: ', mesActual);
    
    				while (reg.anio = anio_buscado) and (reg.mes = mesActual) do begin
    					diaActual := reg.dia;
    					totalDia := 0;
    					writeln('		Día: ', diaActual);
    
    					while (reg.anio = anio_buscado) and (reg.mes = mesActual) and (reg.dia = diaActual) do begin
    						usuarioActual := reg.idUsuario;
    						totalUsuario := 0;
    
    						while (reg.anio = anio_buscado) and (reg.mes = mesActual) and
    						      (reg.dia = diaActual) and (reg.idUsuario = usuarioActual) do begin
    							totalUsuario := totalUsuario + reg.tiempo_acceso;
    							leer(a, reg);
    						end;
    
    						writeln('			idUsuario ', usuarioActual, '- Tiempo Total Acceso: ', totalUsuario);
    						totalDia := totalDia + totalUsuario;
    					end;
    
    					writeln('		Tiempo total acceso día ', diaActual, ' mes ', mesActual, ': ', totalDia);
    					totalMes := totalMes + totalDia;
    				end;
    
    				writeln('	Tiempo total acceso mes ', mesActual, ': ', totalMes);
    				totalAnio := totalAnio + totalMes;
    			end;
    
    			writeln('Tiempo total de acceso en el año ', anio_buscado, ': ', totalAnio);
    		end
    		else
    			while (reg.anio = anioActual) do
    				leer(a, reg); // saltar años que no coinciden
    	end;
    	
    	if (not encontre) then
    		writeln('Año no encontrado.');
    
    	close(a);
    end;

var
	archivo: archivo_accesos;
begin
	informe(archivo);
end.
