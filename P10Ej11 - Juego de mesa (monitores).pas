//Se desea modelar con monitores el siguiente juego de mesa. Del juego forman parte N jugadores y un jefe de mesa. 
//Los jugadores pueden mover sus fichas todos al mismo tiempo siempre y cuando el jefe de mesa no esté reordenando el tablero, 
//lo cual hará cada vez que termine de pensar sus cambios. 
//Esto implica que el jefe de mesa debe esperar a que la mesa quede libre de jugadores antes de reordenar el tablero.
//El jefe de mesa además de la función de reordenar el tablero, dejará cartas con instrucciones respecto al compor-
//tamiento que debe tomar el jugador en caso que el jefe de mesa este esperando para reordenar el tablero. 

//Hay 2 tipos de cartas, una que indica que se debe esperar a que el jefe de mesa reordene el tablero para poder jugar, y
//otra que le permite jugar antes del reordenamiento de fichas.

//El jugador debe sacar una carta cada vez que quiera jugar y el jefe de mesa esté esperando para reordenar el tablero.

// Solamente una persona (jugador/jefe de mesa) podrá tener acceso al mazo de cartas en cada momento.

//En caso que no queden cartas en la mesa el jugador deberá esperar que el jefe de mesa reordene el tablero.
//Asimismo, el mazo nunca puede tener más de 10 cartas apiladas. El jefe de mesa deberá poder hacer las 2 funciones
//a la vez (pensar reordenamiento y reordenar con elegir carta y colocarla en mazo

//Se dispone de las siguiente funciones que son ejecutadas por los jugadores:
//• pensar_jugada(), sacar_carta_de_mazo():Carta, jugar()
//Se dispone de las siguientes funciones que serán ejecutadas por el Jefe de Mesa:
//• pensar_reordenamiento(), reordenar_tablero(), elegir_proxima_carta():Carta, colocar_carta_en_mazo(Carta)

//Notas: • Carta se modela con un enumerado [ESPERAR,JUGAR]
//• No se pueden usar tareas auxiliares pero si se puede representar a los actores con más de un proceso


jefe puede:
- Reordenar tablero
- Colocar cartas en mazo
- pensar reordenamiento
- esperar a que jugadores terminen su turno


program Juego;

    var carta : [ESPERAR, JUGAR];

    Monitor Tablero;
        var cantidadJugadoresEnTablero, cantidadJugadoresEsperandoEntrar : integer;
         llamarJefePAraColocarCartas, jugador : conditional;
        
        procedure reordenarTablero(carta in : {JUGAR, ESPERAR});
        begin
            llamarJefePAraColocarCartas.wait();
            pensar_reordenamiento(), 
            reordenar_tablero();
            jugador.signal();
        end;

        procedure puedoJugar(carta in : {JUGAR, ESPERAR});
        begin
            if (carta == ESPERAR) then
                cantidadJugadoresEsperandoEntrar++;
                jugador.wait();
                if (cantidadJugadoresEsperandoEntrar > 0) then
                    cantidadJugadoresEsperandoEntrar--;
                    jugador.signal();
                end;
            end;
            cantidadJugadoresEnTablero++;
        end;

        procedure finDeTurnoJugar(params);
        begin
            cantidadJugadoresEnTablero--;
            if (cantidadJugadoresEnTablero == 0) then
                llamarJefePAraColocarCartas.signal();
            end;
        end;

    BEGIN
        cantidadJugadoresEsperandoEntrar := 0;
        cantidadJugadoresEnTablero := 0;
    END;

    Monitor Mazo;
        var cantidadCartasEnMazo : integer;
            jugador, colocarCartas : condition;

        procedure colocarCartas();
            var carta : {JUGAR, ESPERA};
        begin
            for i := cantidadCartasEnMazo to 10 do
            begin
                carta := elegir_proxima_carta();
                colocar_carta_en_mazo(carta);
                cantidadCartasEnMazo++;
            end;
            colocarCartas.wait();
            jugador.signal();
        end;

        procedure sacarCarta(carta out : Carta);
        begin
            if (cantidadCartasEnMazo == 0) then
                colocarCartas.signal();
                jugador.wait();
            end;
            sacar_carta_de_mazo(carta);
            cantidadCartasEnMazo--;
        end;

    BEGIN
        cantidadCartasEnMazo := 10;
    END;

    procedure jugador(params);
    begin
        while(true) begin
            carta := Mazo.sacarCarta(carta);
            Tablero.puedoJugar(carta);
            Mazo.puedoJugar(carta);
            pensar_jugada();
            jugar();
        end;
    end;

    procedure jefeDeTablero(params);
    begin
        while(true) begin
            reordenarTablero();
        end;
    end;

    procedure jefeDeMazo(params);
    begin
        while(true) begin
            Mazo.colocarCartas();
        end;
    end;

begin
    cobegin
        jefeDeMesa();
        jugador();
        jugador();
        jugador();
        jugador();
        ...
        jugador();
    coend
end;