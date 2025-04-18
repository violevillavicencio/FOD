{
3. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del 
mismo (información guardada acerca de los movimientos que ocurren en el server) que se 
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información: 
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el 
servidor de correo genera un archivo con la siguiente información: nro_usuario, 
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los 
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se 
sabe que un usuario puede enviar cero, uno o más mails por día. 
a. Realice el procedimiento necesario para actualizar la información del log en un 
día particular. Defina las estructuras de datos que utilice su procedimiento. 
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo 
detalle de un día determinado: 
nro_usuarioX…………..cantidadMensajesEnviados 

nro_usuarioX+n………..cantidadMensajesEnviados 
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que 
existen en el sistema. Considere la implementación de esta opción de las 
siguientes maneras: 
i- Como un procedimiento separado del punto a). 
ii- En el mismo procedimiento de actualización del punto a). Qué cambios 
se requieren en el procedimiento del punto a) para realizar el informe en 
el mismo recorrido? 
}

program ejercicio13;
const
	valorAlto = 9999;
type
	str30 = string[30];
 
	reg_log = record
		nro_usuario: integer;
		nombreUsuario: str30;
		nombre: str30;
		apellido: str30;
		cantidadMailEnviados: integer;
	end;

	reg_detalle = record
		nro_usuario: integer;
		cuentaDestino: str30;
		cuerpoMensaje: string[255];
	end;

	maestro = file of reg_log;
	detalle = file of reg_detalle;

    procedure leer(var d: detalle; var r: reg_detalle);
    begin
    	if not eof(d) then
    		read(d, r)
    	else
    		r.nro_usuario := valorAlto;
    end;

    {Punto a) Actualiza el archivo maestro 
	  sumando cantidad de mensajes enviados por usuario}
    procedure actualizarLog(var mae: maestro; var det: detalle);
    var
    	regm: reg_log;
    	regd: reg_detalle;
    	actual_usuario: integer;
    	cantMensajes: integer;
    begin
    	reset(mae);
    	reset(det);
    
    	read(mae, regm);
    	leer(det, regd);
    
    	while (regd.nro_usuario <> valorAlto) do begin
    		actual_usuario := regd.nro_usuario;
    		cantMensajes := 0;
    
    		// Acumula mensajes para un usuario
    		while (regd.nro_usuario = actual_usuario) do begin
    			cantMensajes := cantMensajes + 1;
    			leer(det, regd);
    		end;
    
    		// Avanza el maestro hasta encontrar el usuario
    		while (regm.nro_usuario < actual_usuario) do
    			read(mae, regm);
    
    		// Actualiza el campo acumulado
    		if (regm.nro_usuario = actual_usuario) then begin
    			regm.cantidadMailEnviados := regm.cantidadMailEnviados + cantMensajes;
    			seek(mae, filepos(mae) - 1);
    			write(mae, regm);
    		end;
    	end;
    
    	close(mae);
    	close(det);
    end;

    {Punto b-i) Genera un archivo de texto con la cantidad de mails por usuario 
    Debe recorrer todos los usuarios del sistema}
    procedure generarInforme(var mae: maestro; var det: detalle; var txt: text);
    var
    	regm: reg_log;
    	regd: reg_detalle;
    	actual_usuario, cantMensajes: integer;
    begin
    	reset(mae);
    	reset(det);
    	rewrite(txt);
    
    	leer(det, regd);
    
    	while not eof(mae) do begin
    		read(mae, regm);
    		actual_usuario := regm.nro_usuario;
    		cantMensajes := 0;
    
    		// Salta usuarios en el detalle que no están en el maestro
    		while regd.nro_usuario < actual_usuario do
    			leer(det, regd);
    
    		// Cuenta cantidad de mensajes enviados por ese usuario
    		while regd.nro_usuario = actual_usuario do begin
    			cantMensajes := cantMensajes + 1;
    			leer(det, regd);
    		end;
    
    		writeln(txt, 'Usuario ', actual_usuario, ': ', cantMensajes, ' mensajes enviados');
    	end;
    
    	close(mae);
    	close(det);
    	close(txt);
    end;


var
	mae: maestro;
	det: detalle;
	txt: text;
begin
	assign(mae, '/var/log/logmail.dat');
	assign(det, 'detalle_diario.dat');
	assign(txt, 'informe_diario.txt');

	actualizarLog(mae, det);
	generarInforme(mae, det, txt);
end.

{
	Punto a + b-ii) Actualiza el archivo maestro
	y escribe el informe en un archivo de texto
	en un solo recorrido
  
  procedure actualizarYGenerarInforme(var mae: maestro; var det: detalle; var txt: text);
  var
  	regm: reg_log;
  	regd: reg_detalle;
  	actual_usuario, cantMensajes: integer;
  begin
  	reset(mae);
  	reset(det);
  	rewrite(txt);
  
  	read(mae, regm);
  	leer(det, regd);
  
  	while not eof(mae) do begin
  		actual_usuario := regm.nro_usuario;
  		cantMensajes := 0;
  
  		// Salta usuarios del detalle que no están en el maestro
  		while regd.nro_usuario < actual_usuario do
  			leer(det, regd);
  
  		// Cuenta mensajes del usuario actual
  		while regd.nro_usuario = actual_usuario do begin
  			cantMensajes := cantMensajes + 1;
  			leer(det, regd);
  		end;
  
  		// Actualiza el maestro
  		regm.cantidadMailEnviados := regm.cantidadMailEnviados + cantMensajes;
  		seek(mae, filepos(mae) - 1);
  		write(mae, regm);
  
  		// Escribe en el informe
  		writeln(txt, 'Usuario ', actual_usuario, ': ', cantMensajes, ' mensajes enviados');
  
  		// Lee el siguiente registro del maestro
  		if not eof(mae) then
  			read(mae, regm);
  	end;
  
  	close(mae);
  	close(det);
  	close(txt);
  end;
}
