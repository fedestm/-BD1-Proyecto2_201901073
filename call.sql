/*4 carreras y area común*/
call addCarrera('AreaComun');
call addCarrera('Sistemas');
call addCarrera('Electrica');
call addCarrera('Industrial');
call addCarrera('Mecanica');


call addEstudiante(201901073, 'Federico', 'Zet', '2001-03-02', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 2);
call addEstudiante(201901074, 'Eduardo', 'Perez', '2001-03-02', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 3);

call addDocente(19903232, 'Luis', 'Espino', '1985-02-12', 'espino@gmail.com', 43231267, 'Guatemala', 56434342343);
call addDocente(19903233, 'Miguel', 'Cancinos', '1985-02-12', 'espino@a.com', 43231267, 'Guatemala', 56434342343);


call addCurso(774, 'Sistemas de Bases de Datos 1', 150, 5, 1, 2);
call addCurso(101, 'Mate 1', 0, 5, 1, 2);



call addCursoHabilitado(774, '1S', 19903232, 110, 'A');
call addCursoHabilitado(101, '1S', 19903232, 110, 'B');
call addCursoHabilitado(101, '1S', 19903232, 110, 'C');
call addCursoHabilitado(101, '1S', 19903232, 110, 'D');
call addCursoHabilitado(101, '1S', 19903232, 110, 'E');



call addHorarioCursoHabilitado(1, 1, '8:00-8:50');
call addHorarioCursoHabilitado(1, 2, '8:00-8:50');

call addAsignacionCurso(17, 201901073);

call addCurso(107, 'Inter 1', 0, 10, 1, 2);
call addCursoHabilitado(107, '1S', 19903232, 110, 'A');

call addAsignacionCurso(7, 201901073);

call addAsignacionCurso(7, 201901080);
call addAsignacionCurso(7, 201901081);
call addAsignacionCurso(7, 201901082);
call addAsignacionCurso(7, 201901083);

call addDesasignacionCurso(7, 201901083);

call addNotaCurso(7, 201901073, 36);
call addNotaCurso(7, 201901080, 40);
call addNotaCurso(7, 201901081, 71);
call addNotaCurso(7, 201901082, 62);

call addActasCurso(7);