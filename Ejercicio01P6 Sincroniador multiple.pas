//Se desea implementar una nueva primitiva de sincronización que denominaremos sincronizador
//múltiple, que provee la facilidad de intercambio de información. Esta primitiva brindará las siguientes operaciones:
//• enviar_sinc_mult(cant_destinos: in integer, mensaje: in TMensaje);
// recibir_sinc_mult (mensaje: out TMensaje);
//Ambas operaciones son bloqueantes, hasta que la cantidad de procesos que esperan en recibir_sinc_mult coinci-
//da con el valor cant_destinos de enviar_sinc_mult. De esta forma, tanto recibir_sinc_mult como enviar_sinc_mult
//culminan sincrónicamente en ocasión de la aceptación del mensaje por parte de todos los receptores. Las invo-
//caciones a enviar_sinc_mult se deben resolver de forma FIFO.
//Se pide implementar la primitiva sincronizador múltiple utilizando monitores.

program ej1Mailbox

var 
    confirmarRecepcion : mailbox of NIL
    estoyListo : mailbox of NIL
    tmensaje : mailbox of TMensaje;

procedure recibir_sinc_mult(mensaje: out TMensaje)
begin
    send(estoyListo);
    mensaje := recv(tmensaje, mensaje);
    send(confirmarRecepcion);
end;


procedure enviar_sinc_mult(cant_destinos: in integer, mensaje: in TMensaje);
begin
    recev(mutex)//P
    for i := 0 to cant_destinos do
        rcv(estoyListo);

    for i := 0 to cant_destinos do
        send(tmensaje, mensaje);

    for i := 0 to cant_destinos do
        rcv(confirmarRecepcion);
    send(mutex)//P
end;
'


