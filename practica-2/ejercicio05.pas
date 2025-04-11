program ejercicio05;
const 
    valorAlto = 9999;
    dimF = 5;
type 
    rango_dia = 1..31; 
    rango_mes = 1..12; 
    rango_anio = 2025..2025; 

    reg_fecha = record 
        dia: rango_dia;
        mes: rango_mes; 
        anio: rango_anio; 
    end; 
    
    reg_d = record 
        cod_usuario: integer; 
        fecha: reg_fecha;
        tiempo_sesion: integer; 
    end;
    
    reg_m = record 
        cod_usuario: integer; 
        fecha: integer; 
        tiempo_total_de_sesiones_abiertas: integer;
    end; 
    
    detalle = file of reg_d; 
    
    maestro = file of reg_m;

    // Vectores para manejar múltiples archivos detalle y sus registros actuales
    vec_detalles = array[1..dimF] of detalle;
    vec_registros = array[1..dimF] of reg_d;

    function fechaToInt(f: reg_fecha): integer;
    begin
        fechaToInt := f.anio * 10000 + f.mes * 100 + f.dia; // Convierte una fecha compuesta a un número entero con formato aaaammdd
    end;
      
    procedure leer(var d: detalle; var r: reg_d);
    begin
        if not eof(d) then
            read(d, r)
        else
            r.cod_usuario := valorAlto;
    end;
    
    // Busca el mínimo (por cod_usuario y fecha) entre los registros actuales
    procedure minimo(var detalles: vec_detalles; var regs: vec_registros; var min: reg_d);
    var
      i, pos: integer;
    begin
      min.cod_usuario := valorAlto;
      min.fecha.anio := 9999;  
      min.fecha.mes := 12;
      min.fecha.dia := 31;
    
      for i := 1 to dimF do begin
        if (regs[i].cod_usuario < min.cod_usuario) or
           ((regs[i].cod_usuario = min.cod_usuario) and (fechaToInt(regs[i].fecha) < fechaToInt(min.fecha))) then begin
          min := regs[i];
          pos := i;
        end;
      end;
    
      if (min.cod_usuario <> valorAlto) then
        leer(detalles[pos], regs[pos]);
    end;

    
    procedure crearMaestro(var mae: maestro; var detalles: vec_detalles);
    var
        regs: vec_registros;
        min, actual: reg_d;
        i: integer;
        tiempo_total: integer;
        m: reg_m;
    begin
        // Abrimos todos los archivos detalle y leemos el primer registro de cada uno
        for i := 1 to dimF do begin
            assign(detalles[i], 'detalle' + IntToStr(i)); 
            reset(detalles[i]);
            leer(detalles[i], regs[i]);
        end;
    
        assign(mae, '/var/log/maestro');
        rewrite(mae);
    
        minimo(detalles, regs, min);
        while (min.cod_usuario <> valorAlto) do begin
            actual := min;
            tiempo_total := 0;
    
            // Acumulamos todas las sesiones del mismo usuario en la misma fecha
            while (min.cod_usuario = actual.cod_usuario) and (fechaToInt(min.fecha) = fechaToInt(actual.fecha)) do begin
                tiempo_total := tiempo_total + min.tiempo_sesion;
                minimo(detalles, regs, min);
            end;
    
            // Preparamos y escribimos el registro en el maestro
            m.cod_usuario := actual.cod_usuario;
            m.fecha := fechaToInt(actual.fecha);
            m.tiempo_total_de_sesiones_abiertas := tiempo_total;
            write(mae, m);
        end;
    
        close(mae);
        for i := 1 to dimF do
            close(detalles[i]);
    end;
var
    mae: maestro;
    vd: vec_detalles;
begin
    crearMaestro(mae, vd);
end.
