program ejemplo;

const
	valor_alto = 'ZZZ'; // Marca de fin de archivo

type
	nombre = string[30];

	reg_venta = record
		vendedor: integer;
		monto: real;
		sucursal: nombre;
		ciudad: nombre;
		provincia: nombre;
	end;

	ventas = file of reg_venta;

var
	reg: reg_venta;
	archivo: ventas;
	total, totProv, totCiudad, totSuc: real;
	prov, ciudad, sucursal: nombre;

{---------------------------------------------------------
	Lee un registro o asigna valor_alto a la provincia si se terminó
---------------------------------------------------------}
procedure leer(var archivo: ventas; var dato: reg_venta);
begin
	if not eof(archivo) then
		read(archivo, dato)
	else
		dato.provincia := valor_alto;
end;

{---------------------------------------------------------
	Programa principal: Corte de control multinivel
---------------------------------------------------------}
begin
	assign(archivo, 'archivo_ventas');
	reset(archivo);
	leer(archivo, reg);
	total := 0;

	// Nivel 1: Corte por provincia
	while reg.provincia <> valor_alto do begin
		prov := reg.provincia;
		writeln('Provincia: ', prov);
		totProv := 0;

		// Nivel 2: Corte por ciudad
		while reg.provincia = prov do begin
			ciudad := reg.ciudad;
			writeln('  Ciudad: ', ciudad);
			totCiudad := 0;

			// Nivel 3: Corte por sucursal
			while (reg.provincia = prov) and (reg.ciudad = ciudad) do begin
				sucursal := reg.sucursal;
				writeln('    Sucursal: ', sucursal);
				totSuc := 0;

				// Nivel 4: Lectura de vendedores en esa sucursal
				while (reg.provincia = prov) and (reg.ciudad = ciudad) and (reg.sucursal = sucursal) do begin
					write('      Vendedor: ', reg.vendedor, ' - Monto: $');
					writeln(reg.monto:0:2);
					totSuc := totSuc + reg.monto;
					leer(archivo, reg);
				end;

				// Total por sucursal
				writeln('    Total Sucursal: $', totSuc:0:2);
				totCiudad := totCiudad + totSuc;
			end;

			// Total por ciudad
			writeln('  Total Ciudad: $', totCiudad:0:2);
			totProv := totProv + totCiudad;
		end;

		// Total por provincia
		writeln('Total Provincia: $', totProv:0:2);
		writeln('-----------------------------------------');
		total := total + totProv;
	end;

	// Total general de la empresa
	writeln('Total Empresa: $', total:0:2);
	close(archivo);
end.
