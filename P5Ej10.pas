// Esta cafetería dispone de una caja, 8 vendedores y 2 supervisores
//Los vendedores toman el pedido, cobran y elaboran el pedido de cada cliente. 
//Tienen orden de no dejar la caja sola, por lo que para poder ir a elaborar el pedido debe haber otro vendedor en el área de la caja.
// Por razones de espacio no puede haber más de 2 vendedores en el área de caja a la vez, de los cuales solo uno de ellos puede estar atendiendo. 
//Los vendedores solo toman pedidos cuando están en la caja. 
//Los vendedores deben atender a los clientes lo antes posible, no se debe hacer esperar a un cliente si la caja está libre

//Los vendedores le avisarán al grupo de supervisores cada 10 pedidos cobrados por ese vendedor. Los supervisores
//estarán esperando ser avisados para llenar la planilla. El primer supervisor libre recibirá el número de vendedor
//y con ese dato llenará la planilla.

//recibir_pedido(), cobrar_pedido(), elaborar_pedido(). Ejecutados por el vendedor.
//enviar_pedido_pagar_y_recibir_pedido(). Ejecutado por el cliente, retorna cuando el vendedor termina de elaborar el pedido.
//llenar_planilla(int nro_vendedor). Ejecutado por el supervisor actualiza la planilla de ventas.

program Cafeteria;
var 
    cajaRegistradora : semaphore;
    mtxVendedoresEnCaja : semaphore;
    hayVendedorEnEspera : boolean;
    solicitudIdVendor : integer;
    leerSolicitudIdVendedor : semaphore;
    escribirSolicitudIdVendedor : semaphore;

    vendedoresEnCaja : integer;

    procedure vendedor(nroVendedor : integer);
        var ventas : integer;
    begin
        ventas := 0;
        while (true) begin
            P(areaDeCaja);
            
            PmtxVendedoresEnCaja);
            vendedoresEnCaja++;
            if (hayVendedorEnEspera) begin
                v(esperoOtroVendedor);
                hayVendedorEnEspera := false;
            end;
            V(mtxVendedoresEnCaja);

            P(cajaRegistradora);
            P(llegoCliente);
            V(vendedorListo);
            recibir_pedido();
            cobrar_pedido();
            V(cajaRegistradora);

            P(mtxVendedoresEnCaja);
            if (vendedoresEnCaja == 1) begin    
                hayVendedorEnEspera := true;
                V(mtxVendedoresEnCaja);
                P(esperoOtroVendedor);
                P(mtxVendedoresEnCaja);
                vendedoresEnCaja--;
                V(mtxVendedoresEnCaja);
            else
                vendedoresEnCaja--;
                V(mtxVendedoresEnCaja);
            end;

            V(areaDeCaja);
            elaborar_pedido();
            ventas++;

            if (ventas==10) begin
                p(escribirSolicitudIdVendedor);
                solicitudIdVendor := nroVendedor;
                v(leerSolicitudIdVendedor);
                ventas = 0;
            end;

        end;
    end;

    procedure cliente();
    begin
        V(llegoCliente);
        P(vendedorListo);
        enviar_pedido_pagar_y_recibir_pedido();

    end;

    procedure supervisor();
    var idVendedor;
    begin
        while (true) begin
            P(leerSolicitudIdVendedor);
            idVendedor := solicitudIdVendor;
            P(escribirSolicitudIdVendedor);
            llenar_planilla(idVendedor);
        end;
    end;

begin
    init(cajaRegistradora, 2);
    init(esperoOtroVendedor, 0);
    init(mtxVendedoresEnCaja, 0);
    init(vendedorListo, 1);
    init(leerSolicitudIdVendedor, 0);
    init(escribirSolicitudIdVendedor, 0);
end;