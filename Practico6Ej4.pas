//Se desea modelar utilizando mailboxes el siguiente problema:
//El taller mecánico “Boxes” tiene capacidad para 20 vehículos en sus instalaciones. 
//La entrada de los usuarios a las instalaciones debe ser estrictamente en orden de llegada 
//(la solución no debe permitir bajo ningún concepto “colados”).
//El usuario debe ser atendido por el primer mecánico libre de los 5 con que cuenta el taller. 
//El mecánico, una vez terminado el arreglo, le indicará a la caja el monto a cobrar por el arreglo.
//El cliente recibirá de la caja el monto a pagar.
//Se dispone de las siguientes funciones:
//• arreglar_auto():integer
//Invocada por un mecánico para arreglar el auto. Retorna el costo del arreglo.
//• pagar_arreglo(Monto)
//Invocada por el usuario para pagar el monto que le fue indicado por la caja.
//Nota:
//• Se prohíbe expresamente el busy-waiting.
//• Se debe explicitar la semántica de las primitivas de mailbox utilizadas.
//• Tener cuidado de que el socio pague el importe correcto del arreglo a la caja.

program TallerBoxes
var
    pagoCompletado: mailbox of NIL;
    type tmensaje = RECORD OF
            monto : integer;
            lugar : integer;
    disponibleParaPagar : mailbox of tmensaje;
    disponibleParaAtender : mailbox of integer;
    pagar : array 1..20 of mailbox of integer;//of monto
    lugaresLibres : mailbox of integer;

    mtxLlegadaVehiculo : mailbox of NIL;

procedure mecanico(nroMecanico);
var lugar : integer;
    mensaje : tmensaje;
begin
    while (true) do
        mensaje.lugar := receive(disponibleParaAtender, lugar);//bloqueante
        mensaje.monto := arreglar_auto();
        send(disponibleParaPagar, mensaje);
    end;
end;

procedure cliente();
var lugar, monto : integer;
begin
    receive(mtxLlegadaVehiculo);
    lugar := receive(lugaresLibres);
    send(disponibleParaAtender, lugar);
    send(mtxLlegadaVehiculo);
    monto := receive(pagar[lugar]);
    pagar_arreglo(monto);
    send(pagoCompletado);
    send(lugaresLibres, lugar);
end;

procedure caja();
var mensaje : tmensaje;
begin
    while (true) do
        mensaje := receive(disponibleParaPagar);
        send(pagar[mensaje.lugar], mensaje.monto);
        receive(pagoCompletado);
    end;
end;

begin
    for i := 1 to 20 do
        send(lugaresLibres, i);
    send(mtxLlegadaVehiculo);
    cobegin
      Mecanico;
      Mecanico;
      Mecanico;
      Mecanico;
      Mecanico;
      Caja;
      Vehiculo;
      ...
      Vehiculo;
    coend;
end;