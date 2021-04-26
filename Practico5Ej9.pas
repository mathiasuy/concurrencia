//Ejercicio 9 (medio) 
//Se desea implementar una nueva primitiva de sincronización que denominaremos sincronizador múltiple, que provee la facilidad de intercambio de información. 
//Esta primitiva brindará las siguientes operaciones:
// • enviar_sinc_mult(cant_destinos: in integer, mensaje: in TMensaje);
// • recibir_sinc_mult (mensaje: out TMensaje);
//Ambas operaciones son bloqueantes, 
//hasta que la cantidad de procesos que esperan en recibir_sinc_mult coincida con el valor cant_destinos de enviar_sinc_mult.
//De esta forma, tanto recibir_sinc_mult como enviar_sinc_mult culminan sincrónicamente en ocasión de la aceptación del mensaje por parte de todos los receptores. 
// Las invocaciones a enviar_sinc_mult se deben resolver de forma FIFO.
//Se pide implementar la primitiva sincronizador múltiple utilizando monitores.

Program sinc_mult

    Monitor monitorDelSincronizador
        var destinatariosConfirmados : integer;
            cantDestinatarios : integer;
            esperarReceptor : condition;

        //se bloquea hasta que lleguen los mensajes a todos los destinatariosConfirmados
        procedure enviar_sinc_mult(cant_destinos: in integer, mensaje: in TMensaje)
        begin
            cantDestinatarios := cant_destinos;
            enviarMensaje(cant_destinos, mensaje);
            for i := 1 to cant_destinos do
                receptorTieneAlgoParaRecibir.signal();
            end for
            esperaReceptorFinal.wait();
        end;

        procedure recibir_sinc_mult(mensaje: out TMensaje)
        begin
            receptorTieneAlgoParaRecibir.wait();
            recibirMensaje(mensaje);

            destinatariosConfirmados++;
            if (destinatariosConfirmados < cantDestinatarios) then
                esperarReceptor.wait();
            else
                for i := 1 to cantDestinatarios-1 do
                    esperarReceptor.signal();
                end for
                esperaReceptorFinal.signal();
            end;

        end;

    BEGIN 
        destinatariosConfirmados := 0;

    END;

    procedure emisor(cant_destinos: in integer, mensaje: in TMensaje)
    begin
        cant_destinos
        monitorDelSincronizador.enviar_sinc_mult(cant_destinos, mensaje);
    end;


    procedure receptor(mensaje: out TMensaje);
    begin
        recibir_sinc_mult(mensaje);
    end;

begin
    emisor();
    receptor();
    receptor();
    receptor();
    ....
    receptor();
    receptor();
end;