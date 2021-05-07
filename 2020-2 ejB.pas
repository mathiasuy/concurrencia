// Se quiere desarrollar un software que permita distribuir el trabajo entre dos grupos de TI, desarrollo y verificación. 
//Los integrantes del grupo de desarrollo implementan módulos de software y en la medida que culminan dejan los módulos para su verificación. 
//El grupo de verificación valida, en la medida que tenga módulos disponible, los módulos. 
//Por reglas de la empresa no se puede tener más de 20 módulos disponibles para verificar. 
//En caso de llegar a esta situación, el jefe pasará todos los módulos disponibles a un centro dedicado a la temática y esta es su única tarea. 
//El software además, debe llevar los indicadores de producción, cuántos módulos se implementaron, cuántos se validaron positivamente, 
//cuántos negativamente y cuantos se pasaron al centro especializado.

//Se dispone de los siguientes procedimientos y funciones:

//implementar() : Función de los desarrolladores, devuelve un módulo.
//MLPV(m) : Procedimiento que inserta el módulo m en la estructura de módulos listos para verificar.
//verificar(m) : Función que verifica el módulo m. Devuelve verdadero si se valido el módulo y falso en caso contrario.
//obtener() : Función que devuelve el primer módulo disponible para verificar. Si no hay módulos la función falla.
//a_centro(m) : Procedimiento invocado por el jefe que entrega al centro especializado el módulo m a verificar.

//Se pide: implemente con monitores la realidad anterior. Debe incluir los procedimientos Desarrollador, Tester y Jefe. 
//Además debe implementar una función que retorne cada uno de los indicadores en el orden definido en la letra


Monitor modulos
    var cantidadModulos, implementados, positivos, negativos, centroEspecializado : integer;
        insertarModulo  : conditional;
        jefe  : conditional;

    procedure insertarModulo(m);
    begin
        implementados++;
        if (cantidadModulos == 20) then
            jefe.signal();
            insertarModulo.wait();
        end
        cantidadModulos++;
        MLPV(m);
        esperaTester.signal();
    end;

    procedure tomarParaVerificarModulo(out mout : Modulo);
    begin
        if (cantidadModulos <= 0) then
            esperaTester.wait();
        end;
        mout := obtener();
        cantidadModulos--;
    end;    

    procedure actualizarResultados(in resutltado : Modulo);
    begin
        if (resultado) then
            positivos++;
        else
            negativos++;
        end;        
    end;    

    procedure ACentro();
    begin
        jefe.wait();
        for i := 0 to 20 do
            m := obtener();
            a_centro(m);
            centroEspecializado++;
            cantidadModulos--;
        end;
        insertarModulo.signal();
    end;    

begin
    cantidadModulos := 0;
end;

procedure desarrollador();
begin
    while (true) do begin
    	m := implementar();
        modulos.insertarModulo(m);
    end;
end;


procedure tester();
begin
    while (true) do begin
        modulos.tomarParaVerificarModulo(m);
        resultado := verificar(m);
        modulos.actualizarResultados(resultado);
    end;
end;


procedure jefe();
begin
    while (true) do begin
        ACentro();
    end;
end;