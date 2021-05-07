//Implemente con monitores la solución al problema del productor-consumidor con buffer finito de
//tamaño N pero considerando que el buffer, cuando no tiene productos, devuelve un producto vacío.
//Además se desea saber la cantidad de ocasiones que se consume un producto vacío, para ello debe
//implementar también una función cuantosVacios() que devuelve la cantidad de productos vacíos
//consumidos al retorno de la función.
//Se dispone de los siguientes procedimientos auxiliares:

//producir():Producto Función, produce y devuelve un producto.
//consumir(Producto p) Procedimiento, consume el producto p.
//insertar(Producto p) Procedimiento, inserta el producto p en el buffer.
//obtener():Producto Función, devuelve el primer producto del buffer. En caso que el buffer esté vacío devuelve un producto vacío (que debe ser consumido.


Monitor buffer
    var bufferLleno : condition;
        contenidoEnBuffer, vacios : integer;
begin
    procedure insertar(in producto : Producto)
    begin
        if (contenidoEnBuffer == N) then begin
            bufferLleno.wait();
        end;
        insertar(producto);
        contenidoEnBuffer++;
    end;

    procedure quitar(out elemento : Producto)
    begin
        elemento = obtener();
        if (elemento == NIL) then 
            vacios++;
        else
            contenidoEnBuffer--;
            bufferLleno.signal();
        end;
    end;    

    procedure cuantosVacios(out _vacios : integer);
    begin
        vacios := _vacios;
    end;

end;

procedure productor(params);
begin
    while(true) do
        producto = producir();
        buffer.insertar(producto);
    end;
end;


procedure consumidr(params);
begin
    while(true) do
        buffer.quitar(elemento);
        consumir();
    end;
end;