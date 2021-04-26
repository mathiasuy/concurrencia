// 6 comensales simultáneos
// N canibales
//Cuando un comensal quiere comer, come de la marmita, a menos que no haya suficiente comida para él. 
//Si no hay suficiente comida en la marmita, el caníbal despierta al cocinero y espera a que el cocinero 
//haya rellenado la marmita con la carne de los misioneros capturados (no debe haber notificaciones repetidas)
//Para rellenar la marmita el cocinero debe esperar a que todos los comensales que se encuentran actualmente
//comiendo terminen. El cocinero, por su parte, vuelve a dormir cuando ha rellenado la marmita. Consideraciones:
//No podrán entrar nuevos comensales a la marmita cuando el cocinero está rellenando o esperando para rellenar.

Monitor marmita
var lugaresDisponibles : integer;
    esperaCanibal      : condition;
    rellenando  : boolean;
    cocineroCocinando : boolean;
    cocineroDuerme : condition;
begin

    procedure ingresoCocinero();
    begin
        cocineroDuerme.wait();
        if (cantidadCanibalesComiendo > 0) then
            cocineroCocinando = true;
            esperaCocinero.wait();
        end;
        //rellenando := true;
        Rellenar();
        cocineroCocinando = false;
        esperaComidaCanibal.signal();
    end;

    procedure ingresoCanibal();
    begin
        if (cantidadCanibalesComiendo == 6 or cocineroCocinando) then
            esperaCanibal.wait();
        end;
        if not (Hay_suficiente_comida()) then
            cocineroDuerme.signal();
            esperaComidaCanibal.wait();
        end;
        cantidadCanibalesComiendo++;
        if (cantidadCanibalesComiendo < 6) then 
            esperaCanibal.signal();
        end;
    end;

    procedure salirCanibal();
    begin
        cantidadCanibalesComiendo--;
        if (cantidadCanibalesComiendo == 0 and cocineroCocinando) then
            esperaCocinero.signal();
        else
            esperaCanibal.signal();
        end;
    end;
begin
    cantidadCanibalesComiendo := 0;
    cocineroBloqueao = false;
end
End monitor//



procedure cocinero();
begin
    wihle (true)
    begin
        marmita.ingresoCocinero();
    end;
end;



procedure canibal();
begin
    wihle (true)
    begin
        marmita.ingresoCanibal();
        Comer();
        marmita.salirCanibal();
        Ocio();
    end;
end;

begin
    cocinero();
    canibal();
    canibal();
    canibal();
    ..
    canibal();
end;