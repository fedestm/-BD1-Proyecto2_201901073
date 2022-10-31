#   Carreras
call addCarrera('Area Comun');
call addCarrera('Sistemas');
call addCarrera('Electrica');
call addCarrera('Civil');
call addCarrera('Mecanica');

#   Docentes
call addDocente(19903232, 'Luis', 'Espino', '1985-02-12', 'espino@gmail.com', 43231267, 'Guatemala', 1643434234398);
call addDocente(19903233, 'Miguel', 'Cancinos', '1990-11-9', 'cancinos_22@gmail.com', 32658974, 'Guatemala', 20953241569);
call addDocente(19903234, 'Alvaro', 'Diaz', '1991-06-24', 'juandiaz@gmail.com', 65784123, 'Guatemala', 210256887881);
call addDocente(19903235, 'Glenda', 'Garcia', '1980-03-17', 'glenda_G838@gmail.com', 24568712, 'Guatemala', 200256887881);
call addDocente(19903236, 'Bertha', 'Molina', '1975-06-24', 'bertha_ff@gmail.com', 63231267, 'Guatemala', 180256887881);

#   Sistemas
call addEstudiante(201901073, 'Federico', 'Zet', '2001-02-19', 'co32121@gmail.com', 25674589, 'Guatemala', 31459974501110, 2);
call addEstudiante(201901074, 'Luis', 'Dos', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 2);
call addEstudiante(201901075, 'Alejandro', 'Tres', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 2);
call addEstudiante(201901076, 'Pedro', 'Cuatro', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 2);
#   Electrica
call addEstudiante(201901077, 'Noel', 'Cinco', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 3);
call addEstudiante(201901078, 'Ricardo', 'Zet', '2001-02-19', 'co32121@gmail.com', 25674589, 'Guatemala', 31459974501110, 3);
call addEstudiante(201901079, 'Daniel', 'Dos', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 3);
#   Civil
call addEstudiante(201901080, 'Carlos', 'Tres', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 4);
call addEstudiante(201901081, 'Diego', 'Cuatro', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 4);
call addEstudiante(201901082, 'Alvaro', 'Cinco', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 31459974501110, 4);
#   Mecanica
call addEstudiante(201901083, 'Estudiante', 'Seis', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 5);
call addEstudiante(201901084, 'Estudiante', 'Siete', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 5);
call addEstudiante(201901085, 'Estudiante', 'Ocho', '2001-02-19', 'correo@gmail.com', 23431243, 'Guatemala', 40459923501110, 5);


#Area Comun
#Cursos
call addCurso(17, 'Humanistica 1', 0, 4, 1, 1);
call addCurso(101, 'Mate 1', 0, 7, 1, 1);
call addCurso(348, 'Quimica General', 0, 3, 1, 1);
call addCurso(6, 'Idioma Tecnico', 0, 2, 0, 1);
call addCurso(39, 'Deportes 1', 0, 2, 0, 1);
call addCurso(103, 'Mate 2', 0, 7, 0, 1);

#SISTEMAS
#Cursos
call addCurso(770, 'IPC 1', 30, 4, 1, 2);
call addCurso(795, 'Logica de Sistemas', 30, 2, 1, 2);
call addCurso(771, 'IPC 2', 50, 5, 1, 2);
call addCurso(796, 'Lenguajes Formales', 50, 3, 1, 2);
call addCurso(772, 'Estructura de Datos', 90, 5, 1, 2);

#ELECTRICA
#Cursos
call addCurso(769, 'IPC', 7, 5, 1, 3);
call addCurso(991, 'Lenguajes Aplicados', 12, 5, 1, 3);
call addCurso(204, 'Circuitos Electricos', 90, 7, 1, 3);
call addCurso(210, 'Teoria Electromagnetica', 110, 6, 1, 3);
call addCurso(462, 'Electronica Basica', 110, 6, 1, 3);

#CIVIL
#Cursos
call addCurso(349, 'Quimica Civil', 3, 5, 1, 4);
call addCurso(74, 'Dibujo Constructivo', 4, 5, 1, 4);
call addCurso(30, 'Geografia', 30, 4, 1, 4);
call addCurso(80, 'Topografia', 50, 7, 1, 4);
call addCurso(450, 'Geologia', 50, 4, 1, 4);

#MECANICA
#Cursos
call addCurso(73, 'Dibujo Tecnico', 3, 7, 1, 5);
call addCurso(250, 'Mecanica de Fluidos', 90, 5, 1, 5);
call addCurso(170, 'Mecanica Analitica 1', 50, 4, 1, 5);
call addCurso(172, 'Mecanica Analitica 2', 90, 5, 1, 5);
call addCurso(84, 'Topografia 3', 110, 6, 1, 5);

call addCursoHabilitado(103, '1S', 19903232, 110, 'B');
call addCursoHabilitado(103, '1S', 19903232, 110, 'a');

call addAsignacionCurso(103, '1S', 'A', 201901073);
call addAsignacionCurso(103, '1S', 'A', 201901074);
call addAsignacionCurso(103, '1S', 'A', 201901075);
call addAsignacionCurso(103, '1S', 'A', 201901076);
call addAsignacionCurso(103, '1S', 'A', 201901077);

call addNotaCurso(103, '1S', 'A', 201901073, -60.7);
call addNotaCurso(103, '1S', 'A', 201901074, 60.7);
call addNotaCurso(103, '1S', 'A', 201901077, 100);

call addNotaCurso(103, '1S', 'A', 201901083, 20);

call addDesasignacionCurso(103, '1S', 'A', 201901075);

call addActasCurso(103, '1S', 'A');

call consultarPensum(2);
call consultarEstudiantesAsignados(103, '1S', 2022, 'A');
call consultarDocente(19903232);
call consultarEstudiantesAsignados(103, '1S', 2022, 'A');
call consultarAprobacion(103, '1S', 2022, 'A');
call consultarActas(103);
call consultarTasaDesasignacion(103, '1S', 2022, 'A');