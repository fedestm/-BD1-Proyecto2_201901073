use portalnotas;

call addCarrera('AreaComun');
call addCarrera('Sistemas');

call addEstudiante(201901073, 'Estudiante', 'Uno', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);
call addEstudiante(201901074, 'Estudiante', 'Dos', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);
call addEstudiante(201901075, 'Estudiante', 'Tres', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);
call addEstudiante(201901076, 'Estudiante', 'Cuatro', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);
call addEstudiante(201901077, 'Estudiante', 'Cinco', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);

call addDocente(19903232, 'Luis', 'Espino', '1985-02-12', 'espino@gmail.com', 43231267, 'Guatemala', 56434342343);
call addDocente(19903233, 'Miguel', 'Cancinos', '1985-02-12', 'espino@a.com', 43231267, 'Guatemala', 56434342343);


call addCurso(774, 'Sistemas de Bases de Datos 1', 150, 5, 1, 2);
call addCurso(101, 'Mate 1', 0, 5, 1, 2);

call addCursoHabilitado(101, '1S', 19903232, 110, 'A');

call addHorarioCursoHabilitado(1, 1, '8:00-8:50');
call addHorarioCursoHabilitado(1, 2, '8:00-8:50');

call addAsignacionCurso(101, '1S', 'A', 201901073);
call addAsignacionCurso(101, '1S', 'A', 201901074);
call addAsignacionCurso(101, '1S', 'A', 201901075);
call addAsignacionCurso(101, '1S', 'A', 201901076);
call addAsignacionCurso(101, '1S', 'A', 201901077);

call addDesasignacionCurso(101, '1S', 'A', 201901077);

call addNotaCurso(101, '1S', 'A', 201901073, 60.7);
call addNotaCurso(101, '1S', 'A', 201901074, 52);
call addNotaCurso(101, '1S', 'A', 201901075, 92);
call addNotaCurso(101, '1S', 'A', 201901076, 60.49);

call addActasCurso(101, '1S', 'A');