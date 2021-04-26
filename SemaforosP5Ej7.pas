// lectores escritores

program Ejercicio7
var mutexHayBarco, mutexHayAuto, try, mutexPuente, avisarBajarPuente, avisarPuenteBajo: semapfore;
var hayBarco: boolean; 
var cantBarcos, cantAutos: integer;

procedure barco
begin   
    p(mutexHayBarco);
    cantBarcos++;
    if (cantBarcos = 1) then
        p(try);
    end;
    v(mutexHayBarco);

    p(cruceUnico);
    // Si el puente esta bajo Avisar que el puente se tiene que subir
    p(mutexPuente);
    if (bajo) then
        v(avisarSubirPuente);
        p(avisarPuenteArriba);     
    end; 
    v(mutexPuente); 
    cruzarBarco();
    v(cruceUnico);

    p(mutexHayBarco);
    cantBarcos := cantBarcos - 1;
    if cantBarcos = 0 then
        // Avisar que el puente se tiene que baje
        v(avisarBajarPuente); 
        p(avisarPuenteBajo); //espero a que el puente se baje
        v(try);
    end if
    v(mutexHayBarco);
end;

procedure auto
begin
    p(try);
    P(mutexHayAuto);
    cantAutos := cantAutos + 1;
    if cantAutos = 1 then
        p(cruceUnico);
    end if
    v(mutexHayAuto);
    v(try);

    cruzarAuto();

    p(mutexHayAuto);
    cantAutos := cantAutos - 1;
    if cantAutos = 0 then
        V(cruceUnico);
    end if
    V(mutexHayAuto);
end;

procedure puente
begin
    while (true) do
        p(mutexPuente);
        if (bajo) then  
            v(mutexPuente);
            p(avisarSubirPuente);
            subirPuente();
            v(avisarPuenteArriba); 
            p(mutexPuente);
            bajo = false;
            v(mutexPuente);
        else //Alto
            v(mutexPuente);
            p(avisarBajarPuente);
            bajarPuente();
            v(avisarPuenteBajo); 
            p(mutexPuente);
            bajo = true;
            v(mutexPuente);     
       end; 
    end while;    
end;

begin
    init(mutexHayBarco,1);
    init(mutexHayAuto,1);
    init(mutexPuente,1);
    init(try,1);
    init(avisarBajarPuente,0);
    init(avisarPuenteBajo,0);
    hayBarco = false;
    bajo = true;
    cantBarcos = cantAutos = 0;
    cobegin
        puente;
        barco;
        ...
        barco;
        auto;
        ...
        auto;
    coend
end;
