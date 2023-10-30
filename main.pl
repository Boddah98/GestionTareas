menu_principal :- write('\n-> Menu principal\n'),
        write('   1. Gestion de personas\n'),
        write('   2. Gestion de proyectos\n'),
        write('   3. Gestion de tareas\n'),
        write('   4. Buscar tareas libres\n'),
        write('   5. Recomendar persona\n'),
        write('   6. Asignar tarea\n'),
        write('   7. Cerrar tarea\n'),
        write('   8. Estadisticas\n'),
        write('   9. Salir\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_menu_principal(Opcion).

ejecutar_menu_principal(Opcion) :- Opcion == 1, gestion_personas, menu_principal;
        Opcion == 2, gestion_proyectos, menu_principal;
        Opcion == 3, gestion_tareas, menu_principal;
        Opcion == 4, buscar_tareas, menu_principal;
        Opcion == 5, recomendar_persona, menu_principal;
        Opcion == 6, asignar_tarea, menu_principal;
        Opcion == 7, cerrar_tarea, menu_principal;
        Opcion == 8, estadisticas, menu_principal;
        Opcion == 9, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), menu_principal.

gestion_personas :- write('\n-> Menu gestion de personas\n'),
        write('   1. Agregar persona\n'),
        write('   2. Mostrar tareas asignadas a cada persona\n'),
        write('   3. Volver\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_gestion_personas(Opcion).

ejecutar_gestion_personas(Opcion) :- Opcion == 1, menu_guardar_persona, menu_principal;
        Opcion == 2, mostrar_personas, menu_principal;
        Opcion == 3, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), gestion_personas.

menu_guardar_persona :-
    write('\n-> Agregar Persona\n'),
    write('Ingrese el nombre: '), read(Nombre),
    write('Ingrese el puesto: '), read(Puesto),
    write('Ingrese el costo por tarea: '), read(CostoTarea),
    write('Ingrese el rating: '), read(Rating),
    recibir_tareas([], Tareas),  % Inicialmente, la lista de tareas está vacía
    % Llama a guardar_persona/5 con los datos recopilados
    guardar_persona(Nombre, Puesto, CostoTarea, Rating, Tareas),
    write('\nPersona guardada con exito.\n').

recibir_tareas(TareasActuales, TareasFinales) :-
    write('\nSeleccione las tareas que puede realizar esta persona:\n'),
    write('1. Requerimientos\n'),
    write('2. Diseno\n'),
    write('3. Desarrollo\n'),
    write('4. QA\n'),
    write('5. Fullstack\n'),
    write('6. Frontend\n'),
    write('7. Backend\n'),
    write('8. Administracion\n'),
    write('9. Finalizar lista de tareas\n'),
    write('Por favor ingrese una opcion: '), read(Opcion),
    (
        Opcion >= 1, Opcion =< 8 ->  % Verifica si la opción es válida
        obtener_tarea(Opcion, Tarea),
        agregar_tarea(TareasActuales, Tarea, NuevasTareas),
        recibir_tareas(NuevasTareas, TareasFinales)
    ;
        Opcion == 9 ->  % El usuario selecciona "Salir"
        TareasFinales = TareasActuales  % Termina y la lista de tareas es la actual
    ;
        write('Opción no valida. Por favor seleccione una opción valida.\n'),
        recibir_tareas(TareasActuales, TareasFinales)
    ).

obtener_tarea(1, 'requerimientos').
obtener_tarea(2, 'diseño').
obtener_tarea(3, 'desarrollo').
obtener_tarea(4, 'qa').
obtener_tarea(5, 'fullstack').
obtener_tarea(6, 'frontend').
obtener_tarea(7, 'backend').
obtener_tarea(8, 'administracion').

agregar_tarea(TareasActuales, Tarea, NuevasTareas) :-
    append(TareasActuales, [Tarea], NuevasTareas).

guardar_persona(Nombre, Puesto, CostoTarea, Rating, Tareas) :-
    open('personas.txt', append, File),
    write(File, Nombre), write(File, ','),
    write(File, Puesto), write(File, ','),
    write(File, CostoTarea), write(File, ','),
    write(File, Rating), nl(File),  % Agrega un salto de línea después de los datos de la persona
    guardar_tareas(File, Tareas),
    close(File).

guardar_tareas(File, Tareas) :-
    atomic_list_concat(Tareas, ',', TareasString),  % Convierte la lista en una cadena
    write(File, TareasString), nl(File).  % Escribe la cadena de tareas en la siguiente línea

cargar_personas :-
    (   exists_file('personas.txt')
    ->  open('personas.txt', read, File),
        cargar_personas_desde_archivo(File),
        close(File)
    ;   write('El archivo personas.txt no existe.'), nl
    ).

cargar_personas_desde_archivo(File) :-
    (   read_line_to_string(File, Line),
        Line \== end_of_file
    ->  procesar_persona(Line, File),
        cargar_personas_desde_archivo(File)
    ;   true
    ).

procesar_persona(Line, File) :-
    atomic_list_concat([Nombre, Puesto, CostoTarea, Rating], ',', Line),
    leer_tareas(File, Tareas),
    assert(persona(Nombre, Puesto, CostoTarea, Rating, Tareas)).

leer_tareas(File, Tareas) :-
    read_line_to_string(File, Line),
    (   Line \== end_of_file, Line \== ''
    ->  atomic_list_concat(Tareas, ',', Line)
    ;   Tareas = []
    ).

mostrar_personas :-
    persona(Nombre, Puesto, CostoTarea, Rating, Tareas),
    write('Nombre: '), write(Nombre), nl,
    write('Puesto: '), write(Puesto), nl,
    write('Costo por Tarea: '), write(CostoTarea), nl,
    write('Rating: '), write(Rating), nl,
    write('Tipos de Tareas: '), write(Tareas), nl,
    nl,
    fail.

gestion_proyectos :- write('Has seleccionado la opción 2 (Gestión de proyectos).\n').
gestion_tareas :- write('Has seleccionado la opción 3 (Gestión de tareas).\n').
buscar_tareas :- write('Has seleccionado la opción 4 (Buscar tareas libres).\n').
recomendar_persona :- write('Has seleccionado la opción 5 (Recomendar persona).\n').
asignar_tarea :- write('Has seleccionado la opción 6 (Asignar tarea).\n').
cerrar_tarea :- write('Has seleccionado la opción 7 (Cerrar tarea).\n').
estadisticas :- write('Has seleccionado la opción 8 (Estadísticas).\n').