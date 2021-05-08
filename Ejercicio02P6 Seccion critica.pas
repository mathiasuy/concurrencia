//En un ambiente concurrente se desea garantizar la mutua exclusión de una sección
//crítica y se dispone únicamente de las siguientes primitivas para la intercomunicación de procesos:
//1.    • send(tarea, mensaje) no bloqueante
//      • receive(mensaje) bloqueante
//2. Mejorar la solución anterior con las siguientes primitivas:
//      • send(tarea, mensaje) bloqueante
//      • receive(mensaje) bloqueante
// Nota: Se dispone de las funciones getpid() y getpid_admin_zona_critica().

program ejercicio2P6
mutex: mailbox of nil;

 procedure ejecutame(params);
 begin

    miPid := getpid();

    pidEnZonaCritica := getpid_admin_zona_critica();

    rcv(mutex);            
    //Sección crítica
    //Fin Sección crítica
    send (miPid,mutex);


 end;