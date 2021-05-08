// Se desea modelar usando mailboxes la atención de un peaje de n cajas a vehículos.
//Los autos deberán darle al cajero el número de tarjeta de crédito y este le devolverá un número de
//ticket para lo cual contará con la función:
//function pago(nro_de_tarjeta : in integer): integer
//Los autos deberán elegir la caja con menor cantidad de autos en cola. Solo se podrá implementar una
//tarea auxiliar (Admin).
//El programa principal ejecutará el siguiente código:


program peaje
    var mutexNoColados : mutex of NIL
        type tmensaje = RECORD OF
                lugar: integer
                acción: {ENTRAR, SALIR}
                nroTarjeta: integer
                ticket : comprobante;

        operacionAuto : mailbox of mensaje;
        caja array 1..N of mailbox of tmensaje;
        mtxCajaDisponible : array 1..N of mailbox of NIL;
        m : tmensaje;


    procedure Admin();
        var cantAutosEnCaja : array 1..N of integer
    begin
        for i := 0 to N do
            cantAutosEnCaja[i] := 0;
        send(mtxExclusividadAdmin);
        while (true) do
            receive(operacionAuto, m);//bloqueante
            if (m.accion === ENTRAR) then begin
                menor := MAX_INT;
                for i := 0 to cantAutosEnCaja do
                    if (cantAutosEnCaja[i] < menor) then begin
                        menor := cantAutosEnCaja[i];
                    end;
                cantAutosEnCaja[i]++;
                m.lugar = i;
                send(operacionAuto,m);
            else if ((m.accion === SALIR) then
                cantAutosEnCaja[m.lugar]--;
            end;
        end;
    end;

    procedure Auto(nro_tarjetaM);
    begin
        receive(mutexNoColados);
        m.accion = ENTRAR;
        receive(mtxExclusividadAdmin);//dialogo exclusivo entre admin y auto (no se cuela nadie)
        //se debe mutuoexcluír porque espero una respuesta por parte del admin y no quiero que la lea otro
        send(operacionAuto, m);//no bloqueante
        receive(operacionAuto,m);//bloqueante
        send(mtxExclusividadAdmin);

        m.nroTarjeta = nro_tarjetaM;

        receive(mtxCajaDisponible[id]);//mutex para que la caja quede solo para el auto (P)
        send(caja[m.lugar], m);
        receive(caja[m.lugar], m);
        ticket := m.ticket;
        send(mtxCajaDisponible[id]);
        m.accion = SALIR;

        //receive(mtxExclusividadAdmin); 
        //no se tiene por qué mutuoexcluír porque no espero una respuesta por parte del admin
        send(operacionAuto, m);
        //send(mtxExclusividadAdmin);
        send(mutexNoColados);
    end;

    procedure Caja(id);
    begin
        send(mtxCajaDisponible[id]);
        while (true) do
            receive(caja[id], mensaje);//Llamada desde un auto a esta caja
            ticket := pago(mensaje.nro_de_tarjeta);
            mensaje.ticket = ticket;
            send(caja[id], mensaje);//envio del ticket al auto
        end;
    end;

begin
    send(mutexNoColados);
    cobegin
        Admin
        Auto(nro_tarjeta1)
        ...
        Auto(nro_tarjetaM)
        Caja(1)
       ...
        Caja(n)
    coend
end        