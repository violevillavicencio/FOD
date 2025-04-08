program ejercicio3; 
type 
    datos = record
        provincia: string[30]; 
        alfabetizados:integer; 
        encuestados: integer; 
    end; 
    
    censo = record
        provincia: string[30]; 
        codigo_localidad: integer; 
        alfabetizados: integer; 
        encuestados: integer; 
    end; 
    
    maestro = file of datos; 
    
    detalle2 = file of censo; 
    
    detalle1 = file of censo; 
    
