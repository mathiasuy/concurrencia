//Se tiene un controlador para entrar en una sala de servidores. A la sala entran a realizar
//mantenimiento tanto técnicos de software (TS) como de hardware (TH) y 
//sólo pueden entrar 5 personas al mismo tiempo. 
//los TH tienen prioridad para entrar por sobre los TS, sin embargo dentro de cada sub grupo no existe ningún orden especificado.

//Se pide: implemente utilizando semáforos el controlador descrito. Debe implementar las funciones
//TS y TH. Dispone de la función: realizar_mantenimiento()
program Sala;
var sala : semaphore;
    try : semaphore;
    cantTSEspera : integer;
    cantTHEspera : integer;
    totalAdentro : integer;

    procedure TS()
    begin
        p(mutex);
        if (totalAdentro == 5) then
            cantTSEspera++;
            v(mutex);
            p(esperaTS);
            p(mutex);
            cantTSEspera--;
            v(mutex);
        else
            v(mutex);
        end;
        totalAdentro++;

        p(sala);
        realizar_mantenimiento();
        v(sala);

        p(mutex);
        totalAdentro--;
        if (totalAdentro <= 5 && cantTHEspera > 0) then
            v (entrarTH)
        else if (totalAdentro <= 5) then
            v(entrarTS);
        end;
        v(mutex);
    end

    procedure TH()
    begin
        p(mutex);
        if (totalAdentro == 5) then
        begin
            cantTHEspera++;
            v(mutex);
            p(esperaTH);
            p(mutex);   
            cantTHEspera--;
            v(mutex);
        end;
        
        p(mutex);
        totalAdentro++;
        v(mutex);

        p(sala);
        realizar_mantenimiento();
        v(sala);

        p(mutex);
        totalAdentro--;
        if (totalAdentro <= 5 && cantTHEspera > 0) then
            v(mutex);
            v (entrarTH)
        else if (totalAdentro <= 5) then
            v(mutex);
            v(entrarTS);
        end;
    end

begin
    init (sala,5);
    init (esperaTH,0);

end




