{ 
Se tiene información en un archivo de las horas extras realizadas por los empleados de una 
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento, 
división, número de empleado, categoría y cantidad de horas extras realizadas por el 
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por 
división y, por último, por número de empleado. Presentar en pantalla un listado con el 
siguiente formato: 

Departamento 
División 
Número de Empleado    Total de Hs.   Importe a cobrar 
......                                
......                                
..........               
..........               
Total de horas división:  ____ 
.........    
.........    
Monto total por división: ____ 
                                                    
División  
     ................. 
Total horas departamento: ____ 
Monto total departamento: ____ 

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al 
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía 
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número 
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la 
posición del valor coincidente con el número de categoría. 
}
program ejercicio11;
const
	valorAlto = 'ZZZ';
	cantCategorias = 15;
type
	str10 = string[10];
	str30 = string[30];

	reg_hora = record
		departamento: str30;
		division: str30;
		num_empleado: integer;
		categoria: 1..cantCategorias;
		horas: integer;
	end;

	archivo_horas = file of reg_hora;

	// para el archivo de texto: número de categoría y valor de hora
	reg_valor_hora = record
		categoria: integer;
		valor_hora: real;
	end;

	valoresHoras = array[1..cantCategorias] of real;
    
    procedure leer(var f: archivo_horas; var r: reg_hora);
    begin
    	if not eof(f) then
    		read(f, r)
    	else
    		r.departamento := valorAlto;
    end;
    
    {Carga el arreglo con los valores de horas extras por categoría
    desde un archivo de texto con líneas: categoria valor}
    procedure cargarValoresHoras(var arr: valoresHoras);
    var
    	txt: text;
    	cat: integer;
    	val: real;
    begin
    	assign(txt, 'valores_horas.txt');
    	reset(txt);
    	while not eof(txt) do begin
    		readln(txt, cat, val);
    		arr[cat] := val;
    	end;
    	close(txt);
    end;

    
    //Procesa el archivo de horas y presenta el reporte
    procedure corteDeControl(var arch: archivo_horas; valores: valoresHoras);
    var
    	reg: reg_hora;
    	actDepto, actDiv: str30;
    	total_div_hs, total_div_monto: integer;
    	total_depto_hs, total_depto_monto: integer;
    	importe: real;
    begin
    	reset(arch);
    	leer(arch, reg);
    
    	while (reg.departamento <> valorAlto) do begin
    		actDepto := reg.departamento;
    		writeln('Departamento: ', actDepto);
    		total_depto_hs := 0;
    		total_depto_monto := 0;
    
    		while (reg.departamento = actDepto) do begin
    			actDiv := reg.division;
    			writeln('División: ', actDiv);
    			total_div_hs := 0;
    			total_div_monto := 0;
    
    			while (reg.departamento = actDepto) and (reg.division = actDiv) do begin
    				write('Número de Empleado: ', reg.num_empleado:5);
    				write('   Total de Hs: ', reg.horas:3);
    
    				importe := reg.horas * valores[reg.categoria];
    				write('   Importe a cobrar: $', importe:0:2);
    				writeln;
    				writeln('................................................');
    
    				total_div_hs := total_div_hs + reg.horas;
    				total_div_monto := total_div_monto + round(importe);
    				leer(arch, reg);
    			end;
    
    			writeln('Total de horas división: ', total_div_hs);
    			writeln('Monto total por división: $', total_div_monto);
    			writeln;
    
    			total_depto_hs := total_depto_hs + total_div_hs;
    			total_depto_monto := total_depto_monto + total_div_monto;
    		end;
    
    		writeln('Total horas departamento: ', total_depto_hs);
    		writeln('Monto total departamento: $', total_depto_monto);
    		writeln('----------------------------------------------------------');
    	end;
    
    	close(arch);
    end;

var
	arch: archivo_horas;
	valores: valoresHoras;
begin
	cargarValoresHoras(valores);
	assign(arch, 'horasExtras.dat');
	corteDeControl(arch, valores);
end.
