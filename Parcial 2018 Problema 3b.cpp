procedure consumidor()
{
    while (true)
    {
        P(contenidoEnBuffer);
        P(mtxBuffer);
        elem = sacarDelBuffer();
        V(mtxBuffer);
        V(lugarLibreEnBuffer);
        consumir(elem);
    }
}

procedure productor()
{
    while (true)
    {
        elem = producir();
        P(lugarLibreEnBuffer);
        P(mtxBuffer);
        guardarEnBuffer(elem);
        V(mtxBuffer);
        V(contenidoEnBuffer);
    }
}

main {
    init(mtxBuffer, 1);
    init(contenidoEnBuffer, 0);
    init(lugarLibreEnBuffer, TAM_BUFFER);
    cobegin
        productor(); productor();
        consumidor(); consumidor();
    coend
}