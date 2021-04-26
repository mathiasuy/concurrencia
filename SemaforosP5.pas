// avanzo_cinta() : Avanza la cinta un paso (muy pequeño).
//llenar_botella() : Llena la botella de líquido (finaliza cuando está llena).
//pongo_tapa() : Comienza la acción de tapado (finaliza cuando la tapa queda colocada). Y de las siguientes funciones:
//puedo_llenar() : Devuelve TRUE si hay un envase bajo la estación de llenado.
//puedo_tapar() : Ídem para la estación de tapado


//Seccion Critica: Cinta Transportadora libre de operacion (tapado)

program Ejercicio4S
var tapando: semapfore;

procedure llenado
    while (true) do
        if (puedo_llenar()) then
            llenar_botella();
        end;    
        p(tapando);
        avanzo_cinta();
        v(tapando);  
    end while;  
begin
    
end;

procedure tapado
begin
    while (true) do
        if (puedo_tapar()) then
            p(tapando);
            pongo_tapa();  
            v(tapando);  

        end;
    end while;    
end;

begin
    init(tapando,1);
    cobegin
        llenado
        tapado
    coend
end;

______________________________________________

program Ejercicio4M
listoTapar: condition;

Monitor Cinta

procedure avanzar()
    avanzo_cinta();
end;

procedure tapar()
    pongo_tapa();
end;

procedure llenado
begin
    while (true) do
        if (puedo_llenar()) then
            llenar_botella();
        end;
        Cinta.avanzar();    
    end while;  
end;

procedure tapado
begin
    while (true) do
        if (puedo_tapar()) then
            Cinta.tapar();
        end;
    end while;    
end;

begin
    init(tapando,1);
    cobegin
        llenado
        tapado
    coend
end;

______________________________________________

// lectores escritores

program Ejercicio7
var mutexHayBarco, mutexHayAuto, try: semapfore;
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
    cruzarBarco();
    v(cruceUnico);

    p(mutexHayBarco);
    cantBarcos := cantBarcos - 1;
    if cantBarcos = 0 then
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

    end while;    
end;

begin
    init(mutexHayBarco,1);
    init(mutexHayAuto,1);
    init(try,1);
    hayBarco = false;
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