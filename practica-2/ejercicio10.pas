{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por  
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de 
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa. 
Presentar en pantalla un listado como se muestra a continuación: 

Código de Provincia 
Código de Localidad                
................................                  
................................                  
Total de Votos Provincia: ____ 
Código de Provincia 
Código de Localidad                
................................                  
Total de Votos Provincia: ___ 
Total de Votos 
...................... 
...................... 
Total de Votos 
...................... 
………………………………………………………….. 
Total General de Votos: ___ 

NOTA: La información está ordenada por código de provincia y código de localidad. 
}
program ejercicio10;
const
	valorAlto = 9999;
type
    reg_voto = record
  	  cod_provincia: integer;
  		cod_localidad: integer;
  		num_mesa: integer;
  		votos: integer;
  	end;

    archivo_votos = file of reg_voto;
    
    procedure leer(var f: archivo_votos; var r: reg_voto);
    begin
    	if not eof(f) then
    		read(f, r)
    	else
    		r.cod_provincia := valorAlto;
    end;
    
    procedure corteDeControl(var arch: archivo_votos);
    var
    	reg: reg_voto;
    	actual_prov, actual_loc: integer;
    	total_prov, total_general, total_loc: integer;
    begin
    	reset(arch);
    	leer(arch, reg);
    	total_general := 0;
    
    	while (reg.cod_provincia <> valorAlto) do begin
    		actual_prov := reg.cod_provincia;
    		writeln('Código de Provincia: ', actual_prov);
    		total_prov := 0;
    
    		while (reg.cod_provincia = actual_prov) do begin
    			actual_loc := reg.cod_localidad;
    			writeln('Código de Localidad: ', actual_loc);
    			total_loc := 0;
    
    		    while (reg.cod_provincia = actual_prov) and (reg.cod_localidad = actual_loc) do begin
      				writeln('................................');
      				writeln('Mesa ', reg.num_mesa, ' - Votos: ', reg.votos);
      				total_loc := total_loc + reg.votos;
      				leer(arch, reg);
    			  end;
    
    			  total_prov := total_prov + total_loc;
    		end;
    
    		writeln('Total de Votos Provincia: ', total_prov);
    		writeln;
    		total_general := total_general + total_prov;
    	end;
    
    	writeln('…………………………………………………………..');
    	writeln('Total General de Votos: ', total_general);
    	close(arch);
    end;

var
	arch: archivo_votos;
begin
	assign(arch, 'votos.dat');
	corteDeControl(arch);
end.
