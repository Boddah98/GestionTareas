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
        ejecutar(Opcion).

ejecutar(Opcion) :- Opcion == 1, gestion_personas, menu_principal;
        Opcion == 2, gestion_proyectos, menu_principal;
        Opcion == 3, gestion_tareas, menu_principal;
        Opcion == 4, buscar_tareas, menu_principal;
        Opcion == 5, recomendar_persona, menu_principal;
        Opcion == 6, asignar_tarea, menu_principal;
        Opcion == 7, cerrar_tarea, menu_principal;
        Opcion == 8, estadisticas, menu_principal;
        Opcion == 9, true;
        write('\nError: Por favor ingrese una opcion valida.\n'), menu_principal.

gestion_personas :- write('Has seleccionado la opción 1 (Gestión de personas).\n').
gestion_proyectos :- write('Has seleccionado la opción 2 (Gestión de proyectos).\n').
gestion_tareas :- write('Has seleccionado la opción 3 (Gestión de tareas).\n').
buscar_tareas :- write('Has seleccionado la opción 4 (Buscar tareas libres).\n').
recomendar_persona :- write('Has seleccionado la opción 5 (Recomendar persona).\n').
asignar_tarea :- write('Has seleccionado la opción 6 (Asignar tarea).\n').
cerrar_tarea :- write('Has seleccionado la opción 7 (Cerrar tarea).\n').
estadisticas :- write('Has seleccionado la opción 8 (Estadísticas).\n').