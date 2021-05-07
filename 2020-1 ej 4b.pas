//Se quiere defnir un sistema que permita modelar el ingreso de docentes y estudiantes al local de una muestra de parciales. 
//Por la situaci´on sanitaria no pueden ingresar m´as de 20 personas al local. 
//Las personas entrar´an en orden de llegada al local. Pero:
//i para q ue ingresen estudiantes tiene q ue haber al menos un docente dentro del local
//ii en caso de tener personas esperando fuera tendr´an prioridad para el ingreso a la sala los docentes
//iii en caso q ue un docente se q uiera retirar debe considerar q ue mientas haya estudiantes en el salon debe quedar al menos un docente.

//Implemente con monitores la realidad anterior. Dispone de las funciones:
//MuestroParciales() : Procedimiento de los docentes que modela la tarea de mostrar parciales. Una vez concluida la ejecuci´on de la funci´on el docente se retira del sal´on.
//RevisoParcial() : Procedimiento de los estudiantes, para revisar el parcial. Una vez concluida la ejecuci´on de la funci´on el estudiante se retira del sal´on.

//Nota: no es necesario modelar las interacciones docentes- estudiante durante la muestra.

Monitor Salón
var cantDocentes, cantAlumnos, cantDocentesEsperando : integer;

    procedure ingresarAlumno();
    begin
        if (cantDocentes == 0 || cantAlumnos + cantDocentes = 20) then begin
            esperaAlumno.wait();
        end;
        cantAlumnos++;
    end;

    procedure salirAlumno();
    begin
        cantAlumnos--;
        if (cantDocentesEsperando > 0) then begin
             esperaDocenteEntrar.signal();
        else
            esperaAlumno.signal();
        end;
        if (cantAlumnos == 0) then begin
            esperaDocenteSalir.signal();
        end;
    end;

    procedure salirDocente();
    begin
        if (cantDocentes == 1 and cantAlumnos > 0) then begin
            esperaDocenteSalir.wait();
        end;
        cantDocentes--;
        if (cantDocentesEsperando > 0) then begin
             esperaDocenteEntrar.signal();
        else if (cantDocentes > 0) then
            esperaAlumno.signal();
        end;
    end;

    procedure ingresarDocente();
    begin
        if (cantDocentes + cantAlumnos = 20) then begin
            cantDocentesEsperando++;
            esperaDocenteEntrar.wait();
            cantDocentesEsperando--;
        end;
        esperaDocenteSalir.signal();
        cantDocentes++;
        if (cantDocentes + cantAlumnos < 20) then begin
            esperaAlumno.signal();
        end
    end;

end

procedure docente(params);
begin
    salon.ingresarDocente();
    MuestroParciales() 
    salon.salirDocente();
end;

procedure alumno(params);
begin
    salon.ingresarAlumno();
    RevisoParcial();
    salon.salirAlumno();
end;