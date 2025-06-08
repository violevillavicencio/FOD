program parcial2;
const 
    valorAlto = 9999;
type 
    partidos = record 
        codigo_equipo: integer; 
        nombre_equipo: string; 
        anio: integer; 
        codigo_torneo: integer; 
        codigo_rival: integer; 
        goles_contra: integer;  
        goles_favor: integer; 
        puntos_obtenidos: integer; 
    end; 
    
    archivo_partidos = file of partidos; 

procedure leer (var arch: archivo_partidos; var p: partidos); 
begin 
    if not eof(arch) then 
        read(arch, p)
    else 
        p.anio := valorAlto;
end; 

procedure maximo(equipo, puntos: integer; var equipoMax, puntosMax, max: integer);
begin
    if puntos > max then begin
        max := puntos;
        equipoMax := equipo;
        puntosMax := puntos;
    end;
end;

procedure informar(var arch: archivo_partidos); 
var 
    p: partidos; 
    anioActual, torneoActual, equipoActual: integer; 
    total_goles_favor, total_goles_contra, diferencia, ganados, perdidos, empatados, totalpuntos: integer; 
    puntosMax, max, equipoMax: integer; 
begin 
    assign(arch, 'archivo_partidos.dat'); 
    reset(arch); 
    writeln('Informe resumen por equipo del futbol Argentino'); 
    leer(arch, p); 
    while (p.anio <> valorAlto) do begin 
        anioActual := p.anio; 
        writeln('Año ', anioActual); 
        while (p.anio = anioActual) do begin 
            torneoActual := p.codigo_torneo; 
            writeln('cod_torneo ', torneoActual);
            max := -1;
            while (p.anio = anioActual) and (p.codigo_torneo = torneoActual) do begin 
                equipoActual := p.codigo_equipo; 
                writeln('codigo_equipo ', equipoActual, ' nombre_equipo ', p.nombre_equipo); 
                total_goles_favor := 0; 
                total_goles_contra := 0;
                empatados := 0; 
                perdidos := 0;
                ganados := 0; 
                totalpuntos := 0; 
                while (p.anio = anioActual) and (p.codigo_torneo = torneoActual) and (p.codigo_equipo = equipoActual) do begin      
                    total_goles_favor := total_goles_favor + p.goles_favor; 
                    total_goles_contra := total_goles_contra + p.goles_contra; 
                    if (p.puntos_obtenidos = 1) then 
                        empatados := empatados + 1
                    else if (p.puntos_obtenidos = 0) then 
                        perdidos := perdidos + 1 
                    else if (p.puntos_obtenidos = 3) then 
                        ganados := ganados + 1; 
                    totalpuntos := totalpuntos + p.puntos_obtenidos; 
                    leer(arch, p); 
                end; 
                writeln('cantidad total de goles a favor ', total_goles_favor); 
                writeln('cantidad total de goles en contra ', total_goles_contra); 
                diferencia := total_goles_favor - total_goles_contra; 
                writeln('diferencia de gol ', diferencia); 
                writeln('cantidad de partidos ganados ', ganados);
                writeln('cantidad de partidos empatados ', empatados);
                writeln('cantidad de partidos perdidos ', perdidos);
                writeln('cantidad total de puntos en el torneo ', totalpuntos); 
                maximo(equipoActual, totalpuntos, equipoMax, puntosMax, max);
            end; 
            writeln('El equipo ', equipoMax, ' fue campeón del torneo ', torneoActual, ' del año ', anioActual); 
        end; 
    end; 
    close(arch); 
end;

var 
    arch: archivo_partidos; 
begin 
    informar(arch); 
end.
