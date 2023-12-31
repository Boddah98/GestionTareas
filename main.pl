%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Función que carga el estado de la última base de conocimiento registrada.
iniciar :-
    cargar_personas,
    cargar_proyectos,
    cargar_tareas,
    menu_principal.

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción:Función encargada de crear el menú principal y mantenerlo en ciclo.
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

recomendar_persona :- write('Has seleccionado la opción 5 (Recomendar persona).\n').
asignar_tarea :- write('Has seleccionado la opción 6 (Asignar tarea).\n').
cerrar_tarea :- write('Has seleccionado la opción 7 (Cerrar tarea).\n').
estadisticas :- write('Has seleccionado la opción 8 (Estadísticas).\n').

%Entradas: Recibe la opción que selecciono el usuario.
%Salidas: Un booleano.
%Descripción: Función que se encarga de ejecutar la opción seleccionada por el usuario.
ejecutar_menu_principal(Opcion) :- Opcion == 1, gestion_personas, menu_principal;
        Opcion == 2, gestion_proyectos, menu_principal;
        Opcion == 3, gestion_tareas, menu_principal;
        Opcion == 4, buscar_tareas_libres, menu_principal;
        Opcion == 5, recomendar_persona, menu_principal;
        Opcion == 6, asignar_tarea, menu_principal;
        Opcion == 7, cerrar_tarea, menu_principal;
        Opcion == 8, estadisticas, menu_principal;
        Opcion == 9, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), menu_principal.

%########################################################################################Apartado de gestión de PERSONAS

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Menú que habilita las opciones disponibles para la gestión de personas
gestion_personas :- write('\n-> Menu gestion de personas\n'),
        write('   1. Agregar persona\n'),
        write('   2. Mostrar tareas asignadas a cada persona\n'),
        write('   3. Volver\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_gestion_personas(Opcion).

ejecutar_gestion_personas(Opcion) :- Opcion == 1, menu_guardar_persona;
        Opcion == 2, mostrar_tareas_asignadas_a_personas;
        Opcion == 3, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), gestion_personas.

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Función que despliega el menú para agregar personas nuevas.
menu_guardar_persona :-
    write('\n-> Agregar Persona nueva\n'),
    write('Ingrese el nombre: '), read(Nombre),
    write('Ingrese el puesto: '), read(Puesto),
    write('Ingrese el costo por tarea: '), read(CostoTarea),
    write('Ingrese el rating: '), read(Rating),
    recibir_tareas([], Tareas),  % Inicialmente, la lista de tareas está vacía
    % Llama a guardar_persona/5 con los datos recopilados
    guardar_persona(Nombre, Puesto, CostoTarea, Rating, Tareas),
    write('\nPersona guardada con exito.\n').

%Entradas: Lista de tareas actuales y lista de tareas final(una vez que se termino todo el ciclo correctamente).
%Salidas: Un booleano.
%Descripción:funcion que se encargra de crear un menu en ciclo, en donde se introducen las tareas que puede realizar esta persona.
recibir_tareas(TareasActuales, TareasFinales) :-
    write('\nSeleccione las tareas que puede realizar esta persona:\n'),
    write('   1. Requerimientos\n'),
    write('   2. Diseno\n'),
    write('   3. Desarrollo\n'),
    write('   4. QA\n'),
    write('   5. Fullstack\n'),
    write('   6. Frontend\n'),
    write('   7. Backend\n'),
    write('   8. Administracion\n'),
    write('   9. Finalizar lista de tareas\n'),
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
        write('Opcion no valida. Por favor seleccione una opcion valida.\n'),
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

%Entradas: Lista de tareas actuales, la tarea que se desea agregar y la lista de tareas post-append.
%Salidas: Un booleano.
%Descripción:Función basica para hacer append a las lista de tareas
agregar_tarea(TareasActuales, Tarea, NuevasTareas) :-
    append(TareasActuales, [Tarea], NuevasTareas).

%Entradas: Los atributos de la persona a guardar.
%Salidas: Un booleano.
%Descripción: Función que escribe en el archivo de texto los atributos de la persona.
guardar_persona(Nombre, Puesto, CostoTarea, Rating, Tareas) :-
    open('Personas.txt', append, File),
    write(File, Nombre), write(File, ','),
    write(File, Puesto), write(File, ','),
    write(File, CostoTarea), write(File, ','),
    write(File, Rating), nl(File),  % Agrega un salto de línea después de los datos de la persona
    guardar_tareas(File, Tareas),
    close(File).
    assert(persona(Nombre, Puesto, CostoTarea, Rating, Tareas)).

%Entradas: El archivo en donde se guardará la tarea y la tarea a guardar.
%Salidas: Un booleano.
%Descripción: Funcion que se encarga de guardar las tareas de una persona.
guardar_tareas(File, Tareas) :-
    atomic_list_concat(Tareas, ',', TareasString),  % Convierte la lista en una cadena
    write(File, TareasString), nl(File).  % Escribe la cadena de tareas en la siguiente línea

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Función que lee el archivo txt de personas y los introduce en la base de conocimiento.
cargar_personas :-
    (   exists_file('Personas.txt')
    ->  open('Personas.txt', read, File),
        cargar_personas_desde_archivo(File),
        close(File)
    ;   write('El archivo Personas.txt no existe.'), nl
    ).

%Entradas: El archivo txt de personas.
%Salidas: Un booleano.
%Descripción: Función auxiliar de cargar personas que lee las lineas.
cargar_personas_desde_archivo(File) :-
    (   read_line_to_string(File, Line),
        Line \== end_of_file
    ->  procesar_persona(Line, File),
        cargar_personas_desde_archivo(File)
    ;   true
    ).

%Entradas: La linea leida y el  txt.
%Salidas: Un booleano.
%Descripción: Función que procesa las lineas leidas.
procesar_persona(Line, File) :-
    atomic_list_concat([Nombre, Puesto, CostoTarea, Rating], ',', Line),
    leer_tareas(File, Tareas),
    assert(persona(Nombre, Puesto, CostoTarea, Rating, Tareas)).

%Entradas: El txt y las Tareas que este contiene.
%Salidas: Un booleano.
%Descripción: Función que lee el archivo txt de personas y los introduce en la base de conocimiento.
leer_tareas(File, Tareas) :-
    read_line_to_string(File, Line),
    (   Line \== end_of_file, Line \== ''
    ->  atomic_list_concat(Tareas, ',', Line)
    ;   Tareas = []
    ).

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Función que imprime a todas las personas en la base de conocimiento.
mostrar_personas :-
    persona(Nombre, Puesto, CostoTarea, Rating, Tareas),
    write('Nombre: '), write(Nombre), nl,
    write('Puesto: '), write(Puesto), nl,
    write('Costo por Tarea: '), write(CostoTarea), nl,
    write('Rating: '), write(Rating), nl,
    write('Tipos de Tareas: '), write(Tareas), nl,
    nl,
    fail.

%Entradas: No posee.
%Salidas: Un booleano.
%Descripción: Función que muestra las tareas asignadas especificamente a.
mostrar_tareas_asignadas_a_personas :-
    findall(Persona, persona(Persona, _, _, _, _), Personas),
    mostrar_tareas_asignadas(Personas).

mostrar_tareas_asignadas([]).
mostrar_tareas_asignadas([Persona|RestoPersonas]) :-
    format('\n-> Tareas asignadas a ~w:~n', [Persona]),
    tareas_asignadas_a_persona(Persona),
    mostrar_tareas_asignadas(RestoPersonas).

tareas_asignadas_a_persona(Persona) :-
    tarea(Proyecto, Nombre, _, Estado, Persona, _),
    format('Proyecto: ~w, Tarea: ~w, Estado: ~w~n', [Proyecto, Nombre, Estado]),
    fail.
tareas_asignadas_a_persona(_).

%#################################################################################Apartado de gestión de PROYECTOS

gestion_proyectos :- write('\n-> Menu gestion de proyectos\n'),
        write('   1. Agregar proyecto nuevo\n'),
        write('   2. Mostrar informacion de los proyectos\n'),
        write('   3. Volver\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_gestion_proyectos(Opcion).

ejecutar_gestion_proyectos(Opcion) :- Opcion == 1, menu_guardar_proyecto;
        Opcion == 2, mostrar_proyectos;
        Opcion == 3, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), gestion_proyectos.

menu_guardar_proyecto :-
    write('\n-> Agregar Proyecto nuevo\n'),
    write('Ingrese el nombre del proyecto: '), read(Nombre),
    write('Ingrese el nombre de la empresa: '), read(Empresa),
    write('Ingrese el presupuesto del proyecto: '), read(Presupuesto),
    obtener_fecha('Fecha de inicio (YYYY-MM-DD): ', FechaInicio),
    obtener_fecha('Fecha de fin (YYYY-MM-DD): ', FechaFin),
    guardar_proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin),
    write('\nProyecto guardado con exito.\n').

obtener_fecha(Mensaje, Fecha) :-
    repeat,
    write(Mensaje), read(Entrada),
    (validar_formato_fecha(Entrada) -> parsear_fecha(Entrada, Fecha) ; write('Formato de fecha incorrecto. Intente de nuevo.\n'), fail).

validar_formato_fecha(Entrada) :-
    split_string(Entrada, "-", "", [Anio, Mes, Dia]),
    atom_length(Anio, 4),
    atom_length(Mes, 2),
    atom_length(Dia, 2),
    atom_number(Anio, _),
    atom_number(Mes, _),
    atom_number(Dia, _).

parsear_fecha(Entrada, Fecha) :-
    split_string(Entrada, "-", "", [Anio, Mes, Dia]),
    atom_number(Anio, AnioNumero),
    atom_number(Mes, MesNumero),
    atom_number(Dia, DiaNumero),
    Fecha = date(AnioNumero, MesNumero, DiaNumero).

guardar_proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin) :-
    date(Y1, M1, D1) = FechaInicio,
    date(Y2, M2, D2) = FechaFin,
    open('Proyectos.txt', append, File),
    format(File, '~w,~w,~w,~w-~w-~w,~w-~w-~w~n', [Nombre, Empresa, Presupuesto, Y1, M1, D1, Y2, M2, D2]),
    close(File).
    assert(proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin)).

cargar_proyectos :-
    (exists_file('Proyectos.txt')
    ->  open('Proyectos.txt', read, File),
        cargar_proyectos_desde_archivo(File),
        close(File)
    ;   write('El archivo Proyectos.txt no existe.'), nl
    ).

cargar_proyectos_desde_archivo(File) :-
    read_line_to_string(File, Line),
    (Line \== end_of_file
    ->  procesar_linea_proyecto(Line),
        cargar_proyectos_desde_archivo(File)
    ;   true
    ).

procesar_linea_proyecto(Line) :-
    split_string(Line, ",", " ,\t\n", [Nombre, Empresa, Presupuesto, FechaInicioStr, FechaFinStr]),
    parsear_fecha(FechaInicioStr, FechaInicio),
    parsear_fecha(FechaFinStr, FechaFin),
    assert(proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin)).

mostrar_proyectos :-
    findall(proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin), proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin), Proyectos),
    mostrar_lista_proyectos(Proyectos).

mostrar_lista_proyectos([]).
mostrar_lista_proyectos([proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin) | Resto]) :-
    write('Nombre: '), write(Nombre), nl,
    write('Empresa: '), write(Empresa), nl,
    write('Presupuesto: '), write(Presupuesto), nl,
    write('Fecha de Inicio: '), write(FechaInicio), nl,
    write('Fecha de Fin: '), write(FechaFin), nl,
    nl,
    mostrar_lista_proyectos(Resto).

%#################################################################################Apartado de gestión de TAREAS

gestion_tareas :- write('\n-> Menu gestion de tareas\n'),
        write('   1. Agregar tarea\n'),
        write('   2. Mostrar tareas\n'),
        write('   3. Volver\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_gestion_tareas(Opcion).

ejecutar_gestion_tareas(Opcion) :- Opcion == 1, menu_guardar_tarea;
        Opcion == 2, mostrar_tareas;
        Opcion == 3, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), gestion_tareas.

menu_guardar_tarea :-
    % Mostrar proyectos disponibles
    findall(NombreProyecto, proyecto(NombreProyecto, _, _, _, _), Proyectos),
    length(Proyectos, NumProyectos),
    (NumProyectos > 0
    ->  write('\n-> Agregar Tarea nueva\n'),
        write('Proyectos disponibles:\n'),
        listar_proyectos(Proyectos, 1),
        write('Seleccione un proyecto: '), read(Seleccion),
        (Seleccion >= 1, Seleccion =< NumProyectos
        ->  nth1(Seleccion, Proyectos, ProyectoSeleccionado),
            write('Ingrese el nombre de la tarea: '), read(NombreTarea),
            recibir_tarea(TareaString),  % Llama a recibir_tarea para obtener el nombre de la tarea
            atom_string(Tipo, TareaString),  % Convierte el nombre de la tarea a un átomo
            Estado = 'pendiente',
            Persona = 'no asignada',
            FechaCierre = 'no asignada',
            Tarea = tarea(ProyectoSeleccionado, NombreTarea, Tipo, Estado, Persona, FechaCierre),
            % Llama a una función para guardar la tarea o realizar la lógica deseada
            guardar_tarea(Tarea),
            write('\nTarea guardada con exito.\n')
        ;   write('Selección de proyecto inválida. Intente de nuevo.\n')
        )
    ;   write('No hay proyectos disponibles. Agregue un proyecto antes de crear una tarea.\n')
    ).

listar_proyectos([], _).
listar_proyectos([Proyecto | Resto], Numero) :-
    write(Numero), write('. '), write(Proyecto), nl,
    NuevoNumero is Numero + 1,
    listar_proyectos(Resto, NuevoNumero).

recibir_tarea(Tarea) :-
    write('\nSeleccione el tipo de la tarea:\n'),
    write('   1. Requerimientos\n'),
    write('   2. Diseno\n'),
    write('   3. Desarrollo\n'),
    write('   4. QA\n'),
    write('   5. Fullstack\n'),
    write('   6. Frontend\n'),
    write('   7. Backend\n'),
    write('   8. Administracion\n'),
    write('Por favor ingrese una opcion: '), read(Opcion),
    (
        Opcion >= 1, Opcion =< 8 ->  % Verifica si la opción es válida
        obtener_tarea(Opcion, TareaString), % Obtiene el nombre de la tarea
        atom_string(Tarea, TareaString) % Convierte el nombre de la tarea a un string
    ;
        write('Opcion no válida. Por favor seleccione una opcion válida.\n'),
        recibir_tarea(Tarea)  % Llama de nuevo para seleccionar una tarea válida
    ).

guardar_tarea(Tarea) :-
    open('Tareas.txt', append, File),
    Tarea = tarea(Proyecto, Nombre, Tipo, Estado, Persona, FechaCierre),
    write(File, Proyecto), write(File, ','),
    write(File, Nombre), write(File, ','),
    write(File, Tipo), write(File, ','),
    write(File, Estado), write(File, ','),
    write(File, Persona), write(File, ','),
    write(File, FechaCierre), nl(File),  % Agrega un salto de línea después de los datos de la tarea
    close(File).
    assert(tarea(Proyecto, Nombre, Tipo, Estado, Persona, Fecha)).

cargar_tareas :-
    (   exists_file('tareas.txt')
    ->  open('tareas.txt', read, File),
        cargar_tareas_desde_archivo(File),
        close(File)
    ;   write('El archivo tareas.txt no existe.'), nl
    ).

cargar_tareas_desde_archivo(File) :-
    read_line_to_string(File, Line),
    (   Line \== end_of_file
    ->  procesar_linea_tarea(Line),
        cargar_tareas_desde_archivo(File)
    ;   true
    ).

procesar_linea_tarea(Line) :-
    split_string(Line, ",", " ,\t\n", [Proyecto, Nombre, Tipo, EstadoAtom, PersonaAtom, Fecha]),
    atom_string(Estado, EstadoAtom),
    atom_string(Persona, PersonaAtom),
    assert(tarea(Proyecto, Nombre, Tipo, Estado, Persona, Fecha)).

mostrar_tareas :-
    write('Tareas en la base de conocimiento:\n'),
    tarea(Proyecto, Nombre, Tipo, Estado, Persona, Fecha),
    format('Proyecto: ~w\n', [Proyecto]),
    format('Nombre: ~w\n', [Nombre]),
    format('Tipo: ~w\n', [Tipo]),
    format('Estado: ~w\n', [Estado]),
    format('Persona asignada: ~w\n', [Persona]),
    format('Fecha de cierre: ~w\n', [Fecha]),
    nl,
    fail.  % Esto fallará para que imprima todas las tareas

%############################################################################################ Funcionalidad 4

buscar_tareas_libres :- write('\n-> Menu buscar tareas libres\n'),
        write('   1. Buscar todas las tareas libres\n'),
        write('   2. Mostrar tareas libres para persona\n'),
        write('   3. Volver\n'),
        write('Por favor seleccione una opcion: '), read(Opcion),
        ejecutar_buscar_tareas_libres(Opcion).

ejecutar_buscar_tareas_libres(Opcion) :- Opcion == 1, mostrar_tareas_pendientes;
        Opcion == 2, menu_solicitar_persona;
        Opcion == 3, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), buscar_tareas_libres.

mostrar_tareas_pendientes :-
    findall(tarea(Proyecto, Nombre, Tipo, Estado, Persona, Fecha), tarea(Proyecto, Nombre, Tipo, 'pendiente', Persona, Fecha), Tareas),
    imprimir_todas_las_tareas(Tareas).

imprimir_todas_las_tareas(Tareas) :-
    foreach(member(tarea(Proyecto, Nombre, Tipo, _, Persona, Fecha), Tareas),
        format('Proyecto: ~w~nNombre: ~w~nTipo: ~w~nEstado: ~w~nPersona: ~w~nFecha: ~w~n~n', [Proyecto, Nombre, Tipo, 'pendiente', Persona, Fecha])
    ).

tareas_que_puede_desarrollar(Persona) :-
    persona(Persona, _, _, _, TiposDeTareas),
    findall(tarea(Proyecto, Nombre, Tipo, Estado, Persona, Fecha), tarea(Proyecto, Nombre, Tipo, 'pendiente', Persona, Fecha), Tareas),
    filter_tareas_por_tipos(TiposDeTareas, Tareas, TareasFiltradas),
    imprimir_todas_las_tareas(TareasFiltradas).

filter_tareas_por_tipos([], Tareas, Tareas).
filter_tareas_por_tipos([Tipo | RestoTipos], Tareas, TareasFiltradas) :-
    include(tarea_con_tipo(Tipo), Tareas, TareasConTipo),
    filter_tareas_por_tipos(RestoTipos, Tareas, TareasRestantes),
    append(TareasConTipo, TareasRestantes, TareasFiltradas).

tarea_con_tipo(Tipo, tarea(_, _, Tipo, _, _, _)).

menu_solicitar_persona :-
    write('Ingrese el nombre de la persona: '), read(NombrePersona),
    write('\nTareas que '), write(NombrePersona), write(' puede desarrollar:\n'),
    tareas_que_puede_desarrollar(NombrePersona),
    nl.