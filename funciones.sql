/*Funciones Carrera*/

DELIMITER $$
    CREATE FUNCTION ValidarLetras(
    cadena varchar(100)
    )
    RETURNS BOOLEAN
    DETERMINISTIC
    BEGIN
    DECLARE valido BOOLEAN;
    IF (SELECT REGEXP_INSTR(cadena, '[^a-zA-Z ]') = 0) THEN
        SELECT TRUE INTO valido;
    ELSE
        SELECT FALSE INTO valido;
    end if;
    RETURN (valido);
END $$


DELIMITER $$
CREATE PROCEDURE addCarrera(
    IN nombre_in VARCHAR(100)
)
add_carrera:BEGIN

IF (NOT ValidarLetras(nombre_in)) THEN
    SELECT 'El nombre solo debe contener letras' AS ERROR;
    LEAVE add_carrera;
end if;

INSERT INTO carrera(nombre) VALUES (nombre_in);
SELECT CONCAT('Carrera ', nombre_in, ' registrado') AS MENSAJE;
END $$

/*              Estudiante              */
DELIMITER $$
CREATE FUNCTION ValidarCorreo(
    cadena varchar(100)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE  valido BOOLEAN;
IF (SELECT REGEXP_INSTR(cadena, '^[a-zA-Z0-9][+a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]*\\.[a-zA-Z]{2,4}$') = 1) THEN
    SELECT TRUE INTO valido;
ELSE
    SELECT FALSE INTO valido;
end if;
RETURN (valido);
END $$


DELIMITER $$
CREATE FUNCTION ExisteCarrera(
    idcarrera INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT 1 FROM carrera c WHERE c.idcarrera = idcarrera) INTO existe;
RETURN (existe);
END $$


DELIMITER $$
CREATE FUNCTION ExisteEstudiante(
    carnet BIGINT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT 1 FROM estudiante e WHERE e.carnet = carnet) INTO existe;
RETURN (existe);
END $$



DELIMITER $$
CREATE PROCEDURE addEstudiante(
    IN carnet_in BIGINT,
    IN nombres_in VARCHAR(100),
    IN apellidos_in VARCHAR(100),
    IN fecha_nac_in DATE,
    IN correo_in VARCHAR(100),
    IN telefono_in INT,
    IN direccion_in VARCHAR(250),
    IN dpi_in BIGINT,
    IN idcarrera_in INT
)
add_estudiante:BEGIN

IF (ExisteEstudiante(carnet_in)) THEN
    SELECT 'El estudiante ya existe' AS ERROR;
    LEAVE add_estudiante;
end if;

IF (NOT ExisteCarrera(idcarrera_in)) THEN
    SELECT 'La carrera no existe' AS ERROR;
    LEAVE add_estudiante;
end if;

IF (NOT ValidarLetras(nombres_in)) THEN
    SELECT 'El nombre solo debe contener letras' AS ERROR;
    LEAVE add_estudiante;
end if;
IF (NOT ValidarLetras(apellidos_in)) THEN
    SELECT 'El apellido solo debe contener letras' AS ERROR;
    LEAVE add_estudiante;
end if;
IF (NOT ValidarCorreo(correo_in)) THEN
    SELECT 'El formato del correo no es valido' AS ERROR;
    LEAVE add_estudiante;
end if;

INSERT INTO estudiante(carnet, nombres, apellidos, fecha_nac, correo, telefono, direccion, dpi, creditos, fecha_creacion, carrera_idcarrera) VALUES
(carnet_in, nombres_in, apellidos_in, fecha_nac_in, correo_in, telefono_in, direccion_in, dpi_in, 0, SYSDATE(), idcarrera_in);
SELECT CONCAT('Estudiante ', carnet_in, ' registrado') AS MENSAJE;

END $$



/*                                  Docente                                     */
DELIMITER $$
CREATE FUNCTION ExisteDocente(
    siif INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT 1 FROM docente d WHERE d.siif = siif) INTO existe;
RETURN (existe);
END $$


DELIMITER $$
CREATE PROCEDURE addDocente(
    IN siif_in INT,
    IN nombres_in VARCHAR(100),
    IN apellidos_in VARCHAR(100),
    IN fecha_nac_in DATE,
    IN correo_in VARCHAR(100),
    IN telefono_in INT,
    IN direccion_in VARCHAR(250),
    IN dpi_in BIGINT
)
add_docente:BEGIN

IF (ExisteDocente(siif_in)) THEN
    SELECT 'El docente ya existe' AS ERROR;
    LEAVE add_docente;
end if;

IF (NOT ValidarLetras(nombres_in)) THEN
    SELECT 'El nombre solo debe contener letras' AS ERROR;
    LEAVE add_docente;
end if;
IF (NOT ValidarLetras(apellidos_in)) THEN
    SELECT 'El apellido solo debe contener letras' AS ERROR;
    LEAVE add_docente;
end if;
IF (NOT ValidarCorreo(correo_in)) THEN
    SELECT 'El formato del correo no es valido' AS ERROR;
    LEAVE add_docente;
end if;

INSERT INTO docente(siif, nombres, apellidos, fecha_nac, correo, telefono, direccion, dpi, fecha_creacion) VALUES
(siif_in, nombres_in, apellidos_in, fecha_nac_in, correo_in, telefono_in, direccion_in, dpi_in, SYSDATE());
SELECT CONCAT('Docente ', nombres_in, ' registrado') AS MENSAJE;

END $$





/*                  Curso                                                   */

DELIMITER $$
    CREATE FUNCTION ValidarEnteroPositivo(
    numero INT
    )
    RETURNS BOOLEAN
    DETERMINISTIC
    BEGIN
    DECLARE valido BOOLEAN;
    IF (SELECT REGEXP_INSTR(numero, '^[0-9]+$') = 1) THEN
        SELECT TRUE INTO valido;
    ELSE
        SELECT FALSE INTO valido;
    end if;
    RETURN (valido);
END $$


DELIMITER $$
CREATE FUNCTION ExisteCurso(
    codigo INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT 1 FROM curso c WHERE c.codigo = codigo) INTO existe;

RETURN (existe);
END $$


DELIMITER $$
CREATE PROCEDURE addCurso(
    IN codigo_in INT,
    IN nombre_in VARCHAR(100),
    IN creditosnec_in INT,
    IN creditosotor_in INT,
    IN obligatorio_in TINYINT,
    IN idcarrera_in INT
)
add_curso:BEGIN

IF (ExisteCurso(codigo_in)) THEN
    SELECT CONCAT('El curso ', nombre_in,' ya existe') AS ERROR;
    LEAVE add_curso;
end if;

IF (NOT ValidarEnteroPositivo(creditosnec_in)) THEN
    SELECT 'Los creditos necesarios deben ser enteros positivos' AS ERROR;
    LEAVE add_curso;
end if;

IF (NOT ValidarEnteroPositivo(creditosotor_in)) THEN
    SELECT 'Los creditos otorgados deben ser enteros positivos' AS ERROR;
    LEAVE add_curso;
end if;

IF (NOT ExisteCarrera(idcarrera_in)) THEN
    SELECT 'La carrera no existe' AS ERROR;
    LEAVE add_curso;
end if;

INSERT INTO curso(codigo, nombre, creditos_necesarios, creditos_otorgados, obligatorio, carrera_idcarrera) VALUES
(codigo_in, nombre_in, creditosnec_in, creditosotor_in, obligatorio_in, idcarrera_in);

SELECT CONCAT('Curso ', nombre_in, ' registrado') AS MENSAJE;

END $$



/*      Habilitar Curso para asignacion                     */
DELIMITER $$
CREATE FUNCTION validarCiclo(
    ciclo VARCHAR(2)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE valido BOOLEAN;
IF UPPER(ciclo) = '1S' OR UPPER(ciclo) = '2S' OR UPPER(ciclo) = 'VJ' OR upper(ciclo) = 'VD' THEN
    SELECT TRUE INTO valido;
ELSE
    SELECT FALSE INTO valido;
end if;
RETURN (valido);
END $$



DELIMITER $$
CREATE FUNCTION validarLetraSeccion(
    seccion VARCHAR(1)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE valido BOOLEAN;
IF (SELECT REGEXP_INSTR(seccion, '^[a-zA-Z]$') = 1) THEN
    SELECT TRUE INTO valido;
ELSE
    SELECT FALSE INTO valido;
end if;
RETURN (valido);
END $$


DELIMITER $$
CREATE PROCEDURE addCursoHabilitado(
    IN cursocodigo_in INT,
    IN ciclo_in VARCHAR(2),
    IN docente_in INT,
    IN cupo_in INT,
    IN seccion_in VARCHAR(1)
)
add_cursohabilitado:BEGIN
DECLARE anio INT;
DECLARE ciclo_existe VARCHAR(2);
DECLARE seccion_existe VARCHAR(1);
DECLARE existe BOOLEAN;

SET anio = EXTRACT(YEAR FROM CURDATE());

IF (NOT ExisteCurso(cursocodigo_in)) THEN
    SELECT CONCAT('El curso ', cursocodigo_in, ' para habilitar no existe') AS ERROR;
    LEAVE add_cursohabilitado;
end if;

IF (NOT validarCiclo(ciclo_in)) THEN
   SELECT CONCAT('El formato del ciclo ', ciclo_in, ' no es valido') AS ERROR;
    LEAVE add_cursohabilitado;
end if;

IF (NOT ExisteDocente(docente_in)) THEN
    SELECT 'El docente no existe' AS ERROR;
    LEAVE add_cursohabilitado;
end if;

IF (NOT ValidarEnteroPositivo(cupo_in)) THEN
    SELECT 'El cupo maximo debe ser un numero entero positivo' AS ERROR;
    LEAVE add_cursohabilitado;
end if;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La sección debe ser una letra' AS ERROR;
    LEAVE add_cursohabilitado;
end if;

SELECT ch.ciclo, ch.seccion INTO ciclo_existe, seccion_existe
FROM cursohabilitado ch
INNER JOIN curso c on ch.curso_codigo = c.codigo
WHERE ch.curso_codigo = cursocodigo_in AND ch.ciclo = ciclo_in AND ch.seccion = seccion_in;

IF (UPPER(ciclo_in) = ciclo_existe) AND (UPPER(seccion_in) = seccion_existe) THEN
    SELECT CONCAT('La sección ', seccion_in, ' ya existe para el curso ', cursocodigo_in) AS ERROR;
    LEAVE add_cursohabilitado;
end if;

INSERT INTO cursohabilitado(curso_codigo, ciclo, docente_siif, cupo, seccion, anio, asignados) VALUES
(cursocodigo_in, UPPER(ciclo_in), docente_in, cupo_in, UPPER(seccion_in), anio, 0);

SELECT CONCAT('El curso ', cursocodigo_in, ' se habilito correctamente') AS MENSAJE;
END $$




/*             Horario Curso Habilitado                   */

DELIMITER $$
CREATE FUNCTION validarDiasSemana(
    dia INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE valido BOOLEAN;
IF (SELECT REGEXP_INSTR(dia, '^[1-7]$') = 1) THEN
    SELECT TRUE INTO valido;
ELSE
    SELECT FALSE INTO valido;
end if;
RETURN (valido);
END $$

DELIMITER $$
CREATE FUNCTION existeIdCursoHabilitado(
    idcursohabilitado INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT 1 FROM cursohabilitado ch WHERE ch.idcursohabilitado = idcursohabilitado) INTO existe;
RETURN (existe);
END $$


DELIMITER $$
CREATE PROCEDURE addHorarioCursoHabilitado(
    IN idcursohabilitado_in INT,
    IN dia_in INT,
    IN horario_in VARCHAR(100)
)
addhorario:BEGIN

IF (NOT existeIdCursoHabilitado(idcursohabilitado_in)) THEN
    SELECT 'El id del curso habilitado no existe' AS ERROR;
    LEAVE addhorario;
end if;

IF (NOT validarDiasSemana(dia_in)) THEN
    SELECT 'El dia no esta en el rango [1-7]' AS ERROR;
    LEAVE addhorario;
end if;

INSERT INTO horariocurso(cursohabilitado_idcursohabilitado, dia, horario) VALUES
(idcursohabilitado_in, dia_in, horario_in);
SELECT 'El horario se agrego correctamente' AS MENSAJE;
END $$



/*                  Asignacion Curso                        */

DELIMITER $$
CREATE FUNCTION ValidarAsignacionCiclo(
    carnet BIGINT,
    codigo_curso INT,
    ciclo VARCHAR(2),
    anio INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;

SELECT EXISTS(
    SELECT 1 FROM cursohabilitado ch, estudiante es, asignacioncurso a, curso cu
    WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
    AND a.estudiante_carnet = es.carnet
    AND cu.codigo = ch.curso_codigo
    AND es.carnet = carnet AND ch.curso_codigo = codigo_curso
    AND ch.ciclo = ciclo AND ch.anio = anio
    AND a.status = 1
) INTO existe;
RETURN (existe);
END $$




DELIMITER $$
CREATE PROCEDURE addAsignacionCurso(
    IN codigo_in INT,
    IN ciclo_in VARCHAR(2),
    IN seccion_in VARCHAR(1),
    IN carnet_in BIGINT
)
add_asignacion:BEGIN
DECLARE status_existe TINYINT;
DECLARE asignados_temp INT;
DECLARE cupo_temp INT;
DECLARE carrera_curso INT;
DECLARE carrera_estudiante INT;
DECLARE creditos_nec INT;
DECLARE creditos_estudiante INT;
DECLARE codigo_chabilitado INT;
DECLARE ciclo_chabilitado VARCHAR(2);
DECLARE anio_chabilitado INT;
DECLARE anio_actual INT;
DECLARE idcursohabilitado_temp INT;

IF (NOT ExisteCurso(codigo_in)) THEN
    SELECT CONCAT('El curso ', codigo_in, ' no existe') AS ERROR;
    LEAVE add_asignacion;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE add_asignacion;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La sección debe ser una letra' AS ERROR;
    LEAVE add_asignacion;
END IF;

SET anio_actual = EXTRACT(YEAR FROM CURDATE());

SELECT ch.idcursohabilitado INTO idcursohabilitado_temp
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigo_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_actual
AND ch.seccion = seccion_in
;

IF (NOT existeIdCursoHabilitado(idcursohabilitado_temp)) THEN
    SELECT 'El curso habilitado no existe' AS ERROR;
    LEAVE add_asignacion;
END IF;

IF (NOT ExisteEstudiante(carnet_in)) THEN
    SELECT CONCAT('El carnet ', carnet_in, ' no existe') AS ERROR;
    LEAVE add_asignacion;
END IF;

SELECT c.idcarrera INTO carrera_estudiante
FROM estudiante es, carrera c
WHERE es.carrera_idcarrera = c.idcarrera
AND es.carnet = carnet_in;

SELECT c.idcarrera INTO carrera_curso
FROM carrera c, curso cu, cursohabilitado ch
WHERE c.idcarrera = cu.carrera_idcarrera
AND cu.codigo = ch.curso_codigo
AND ch.idcursohabilitado = idcursohabilitado_temp;

IF (carrera_curso != carrera_estudiante AND carrera_curso != 0) THEN
    SELECT 'El estudiante no se puede asignar un curso de otra carrera' AS ERROR;
    LEAVE add_asignacion;
END IF;

SELECT cu.creditos_necesarios INTO creditos_nec
FROM curso cu, cursohabilitado ch
WHERE cu.codigo = ch.curso_codigo
AND ch.idcursohabilitado = idcursohabilitado_temp;

SELECT es.creditos INTO creditos_estudiante
FROM estudiante es
WHERE es.carnet = carnet_in;

IF (creditos_nec > creditos_estudiante) THEN
    SELECT 'No cuenta con los creditos necesarios para asignarse al curso' AS ERROR;
    LEAVE add_asignacion;
END IF;

SELECT a.status INTO status_existe
FROM asignacioncurso a
WHERE a.estudiante_carnet = carnet_in AND a.status = 1
AND cursohabilitado_idcursohabilitado = idcursohabilitado_temp;

IF (status_existe = 1) THEN
    SELECT CONCAT('El estudiante ', carnet_in, ' ya se encuentra asignado en la sección') AS ERROR;
    LEAVE add_asignacion;
END IF;

SELECT ch.curso_codigo, ch.ciclo, ch.anio
INTO codigo_chabilitado, ciclo_chabilitado, anio_chabilitado
FROM cursohabilitado ch
WHERE ch.idcursohabilitado = idcursohabilitado_temp;

IF (ValidarAsignacionCiclo(carnet_in, codigo_chabilitado, ciclo_chabilitado, anio_chabilitado)) THEN
    SELECT 'No puede asignarser dos veces el mismo curso en un ciclo' AS ERROR;
    LEAVE add_asignacion;
END IF;

SELECT ch.cupo INTO cupo_temp
FROM cursohabilitado ch
WHERE ch.idcursohabilitado = idcursohabilitado_temp;

SELECT ch.asignados INTO asignados_temp
FROM cursohabilitado ch
WHERE ch.idcursohabilitado = idcursohabilitado_temp;

IF (asignados_temp = cupo_temp) THEN
    SELECT 'Se alcanzo el cupo maximo del curso, no puede asignarse' AS ERROR;
    LEAVE add_asignacion;
END IF;

SET asignados_temp = asignados_temp + 1;
UPDATE cursohabilitado SET asignados = asignados_temp
WHERE idcursohabilitado = idcursohabilitado_temp;

INSERT INTO asignacioncurso(cursohabilitado_idcursohabilitado, estudiante_carnet, status)
VALUES (idcursohabilitado_temp, carnet_in, 1);

SELECT 'El estudiante se asigno correctamente' AS MENSAJE;

END $$



/*                              Desasignacion                                              */

DELIMITER $$
CREATE FUNCTION ExisteAsignacion(
    idcursohabilitado INT,
	carnet BIGINT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
-- Sentencias SQL
SELECT EXISTS (
    SELECT 1 FROM asignacioncurso a
            WHERE a.estudiante_carnet = carnet AND a.status = 1
            AND a.cursohabilitado_idcursohabilitado = idcursohabilitado
           ) INTO existe;
RETURN (existe);
END
$$


DELIMITER $$
CREATE PROCEDURE addDesasignacionCurso(
    IN codigo_in INT,
    IN ciclo_in VARCHAR(2),
    IN seccion_in VARCHAR(1),
    IN carnet_in BIGINT
)
add_desasignacion:BEGIN

DECLARE asignados_temp INT;
DECLARE status_temp TINYINT;
DECLARE anio_actual INT;
DECLARE idcursohabilitado_temp INT;

IF (NOT ExisteCurso(codigo_in)) THEN
    SELECT CONCAT('El curso ', codigo_in, ' no existe') AS ERROR;
    LEAVE add_desasignacion;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE add_desasignacion;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La sección debe ser una letra' AS ERORR;
    LEAVE add_desasignacion;
END IF;

SET anio_actual = EXTRACT(YEAR FROM CURDATE());

SELECT ch.idcursohabilitado INTO idcursohabilitado_temp
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigo_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_actual
AND ch.seccion = seccion_in
;

IF (NOT existeIdCursoHabilitado(idcursohabilitado_temp)) THEN
    SELECT 'El curso habilitado no existe' AS ERROR;
    LEAVE add_desasignacion;
END IF;

IF (NOT ExisteEstudiante(carnet_in)) THEN
    SELECT CONCAT('El estudiante ', carnet_in, ' no existe') AS ERROR;
    LEAVE add_desasignacion;
END IF;

SELECT a.status INTO status_temp
FROM cursohabilitado ch, estudiante es, asignacioncurso a
WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
AND a.estudiante_carnet = es.carnet
AND ch.idcursohabilitado = idcursohabilitado_temp
AND es.carnet = carnet_in;

IF (status_temp = 0) THEN
    SELECT 'El estudiante no se encuentra asignado' AS ERROR;
    LEAVE add_desasignacion;
END IF;

IF (NOT ExisteAsignacion(idcursohabilitado_temp, carnet_in)) THEN
    SELECT 'El estudiante no se encuentra asignado' AS ERROR;
    LEAVE add_desasignacion;
END IF;


SELECT ch.asignados INTO asignados_temp
FROM cursohabilitado ch
WHERE ch.idcursohabilitado = idcursohabilitado_temp;

SET asignados_temp = asignados_temp - 1;
UPDATE cursohabilitado SET asignados = asignados_temp
WHERE idcursohabilitado = idcursohabilitado_temp;

UPDATE asignacioncurso a, estudiante e, cursohabilitado ch SET status = 0
WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
AND a.estudiante_carnet = e.carnet
AND ch.idcursohabilitado = idcursohabilitado_temp
AND e.carnet = carnet_in
;

SELECT 'El estudiante se desasigno correctamente' AS MENSAJE;

END $$


/*                                 Notas                                       */

DELIMITER $$
CREATE FUNCTION ExisteNotaCurso(
    idcursohabilitado INT,
    carnet BIGINT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;

SELECT EXISTS(
    SELECT 1 FROM cursohabilitado ch, estudiante e, notas n
    WHERE ch.idcursohabilitado = n.cursohabilitado_idcursohabilitado
    AND n.estudiante_carnet = e.carnet
    AND ch.idcursohabilitado = idcursohabilitado
    AND e.carnet = carnet
           ) INTO existe;

RETURN (existe);
END $$


DELIMITER $$
CREATE PROCEDURE addNotaCurso(
    IN codigo_in INT,
    IN ciclo_in VARCHAR(2),
    IN seccion_in VARCHAR(1),
    IN carnet_in BIGINT,
    IN nota_in DECIMAL
)
add_notas:BEGIN
DECLARE creditos_otorgados INT;
DECLARE nota_rounded INT;
DECLARE creditos_estudiante INT;
DECLARE anio_actual INT;
DECLARE idcursohabilitado_temp INT;
DECLARE status_temp INT;

IF (NOT ExisteCurso(codigo_in)) THEN
    SELECT 'El curso ', codigo_in, ' no existe' AS ERROR;
    LEAVE add_notas;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE add_notas;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La seccion debe ser una letra' AS ERROR;
    LEAVE add_notas;
END IF;

SET anio_actual = EXTRACT(YEAR FROM CURDATE());

SELECT ch.idcursohabilitado INTO idcursohabilitado_temp
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigo_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_actual
AND ch.seccion = seccion_in;

IF (NOT existeIdCursoHabilitado(idcursohabilitado_temp)) THEN
    SELECT 'El id del curso habilitado no existe' AS ERROR;
    LEAVE add_notas;
END IF;

IF (NOT ExisteEstudiante(carnet_in)) THEN
    SELECT CONCAT('El estudiante ', carnet_in, ' no existe') AS ERROR;
    LEAVE add_notas;
END IF;

IF (NOT ExisteAsignacion(idcursohabilitado_temp, carnet_in)) THEN
    SELECT 'El estudiante no esta asignado' AS ERROR;
    LEAVE add_notas;
END IF;

IF (status_temp = 0) THEN
    SELECT CONCAT('El estudiante no se encuentra asignado') AS ERROR;
    LEAVE add_notas;
END IF;

IF (ExisteNotaCurso(idcursohabilitado_temp, carnet_in)) THEN
    SELECT CONCAT('Ya existe una nota ingresada para el estudiante ', carnet_in) AS ERROR;
    LEAVE add_notas;
END IF;

SET nota_rounded = ROUND(nota_in);

IF (NOT ValidarEnteroPositivo(nota_rounded) AND nota_rounded < 0 AND nota_rounded > 100) THEN
    SELECT 'La nota debe ser un entero positivo y estar en el rango [0-100]' AS ERROR;
    LEAVE add_notas;
END IF;

IF (nota_rounded >= 61) THEN
    SELECT c.creditos_otorgados INTO creditos_otorgados
    FROM cursohabilitado ch, curso c
    WHERE ch.curso_codigo = c.codigo
    AND ch.idcursohabilitado = idcursohabilitado_temp;

    SELECT es.creditos INTO creditos_estudiante
    FROM estudiante es
    WHERE es.carnet = carnet_in;

    SET creditos_estudiante = creditos_estudiante + creditos_otorgados;

    UPDATE estudiante SET creditos = creditos_estudiante
    WHERE carnet = carnet_in;
END IF;

INSERT INTO notas(cursohabilitado_idcursohabilitado, estudiante_carnet, nota) VALUES
(idcursohabilitado_temp, carnet_in, nota_rounded);

SELECT CONCAT('Se agrego la nota del estudiante ', carnet_in, ' correctamente') AS MENSAJE;

END $$



/*                          Actas                               */

DELIMITER $$
CREATE FUNCTION ExisteActaCurso(
    idcursohabilitado_in INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(
               SELECT 1
               FROM cursohabilitado ch,
                    actas a
               WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
                 AND ch.idcursohabilitado = idcursohabilitado_in
           ) INTO existe;
RETURN (existe);
END $$


DELIMITER $$
CREATE PROCEDURE addActasCurso(
    IN codigo_in INT,
    IN ciclo_in VARCHAR(2),
    IN seccion_in VARCHAR(1)
)
add_acta:BEGIN
DECLARE asignados INT;
DECLARE notas_ingresadas INT;
DECLARE cantidad INT;
DECLARE anio_actual INT;
DECLARE idcursohabilitado_temp INT;

IF (NOT ExisteCurso(codigo_in)) THEN
    SELECT CONCAT('El curso ', codigo_in, ' no existe') AS ERROR;
    LEAVE add_acta;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE add_acta;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La seccion debe ser una letra' AS ERROR;
    LEAVE add_acta;
END IF;

SET anio_actual = EXTRACT(YEAR FROM CURDATE());

SELECT ch.idcursohabilitado INTO idcursohabilitado_temp
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigo_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_actual
AND ch.seccion = seccion_in;

IF (NOT existeIdCursoHabilitado(idcursohabilitado_temp)) THEN
    SELECT 'El curso habilitado no existe' AS ERROR;
    LEAVE add_acta;
END IF;

IF (existeActaCurso(idcursohabilitado_temp)) THEN
    SELECT 'Ya existe un acta para dicho curso, no se puede modificar' AS ERROR;
    LEAVE add_acta;
END IF;

SELECT COUNT(*) INTO asignados
FROM cursohabilitado ch, asignacioncurso a
WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
AND ch.idcursohabilitado = idcursohabilitado_temp
AND a.status = 1;

SELECT COUNT(*) INTO notas_ingresadas
FROM notas n, cursohabilitado ch
WHERE n.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
AND n.cursohabilitado_idcursohabilitado = idcursohabilitado_temp;

SET cantidad = asignados - notas_ingresadas;

IF (asignados != notas_ingresadas) THEN
    SELECT CONCAT('Aún hay ', cantidad, ' estudiantes pendiente con nota') AS ERROR;
    LEAVE add_acta;
END IF;

INSERT INTO actas(cursohabilitado_idcursohabilitado, fecha_creacion) VALUES
(idcursohabilitado_temp, SYSDATE());

SELECT 'Se genero correctamente el acta del curso' AS MENSAJE;

END $$



/*             Bitacora                   */


CREATE TABLE bitacora(
    idbitacora INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME,
    descripcion VARCHAR(150),
    tabla VARCHAR(50),
    PRIMARY KEY (idbitacora)
);


/*                      Triggers                                */

DELIMITER $$
CREATE TRIGGER bitacora_estudianteinsert
AFTER INSERT ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'estudiante');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_estudianteupdate
AFTER UPDATE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'estudiante');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_estudiantedelete
AFTER DELETE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'estudiante');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_carrerainsert
AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'carrera');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_carrerateupdate
AFTER UPDATE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'carrera');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_carreradelete
AFTER DELETE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'carrera');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_docenteinsert
AFTER INSERT ON docente
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'docente');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_docenteteupdate
AFTER UPDATE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'docente');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_docentedelete
AFTER DELETE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'docente');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursoinsert
AFTER INSERT ON curso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'curso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursoupdate
AFTER UPDATE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'curso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursodelete
AFTER DELETE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'curso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursohabilitadoinsert
AFTER INSERT ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'cursohabilitado');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursohabilitadoupdate
AFTER UPDATE ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'cursohabilitado');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_cursohabilitadodelete
AFTER DELETE ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'cursohabilitado');
END $$


DELIMITER $$
CREATE TRIGGER bitacora_asignacioninsert
AFTER INSERT ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'asignacioncurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_asignacionupdate
AFTER UPDATE ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'asignacioncurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_asignaciondelete
AFTER DELETE ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'asignacioncurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_horarioinsert
AFTER INSERT ON horariocurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'horariocurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_horarioupdate
AFTER UPDATE ON horariocurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'horariocurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_horariodelete
AFTER DELETE ON horariocurso
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'horariocurso');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_notasinsert
AFTER INSERT ON notas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'notas');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_notasupdate
AFTER UPDATE ON notas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'notas');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_notasdelete
AFTER DELETE ON notas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'notas');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_actasinsert
AFTER INSERT ON actas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'actas');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_actasupdate
AFTER UPDATE ON actas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se actualizo un registro', 'actas');
END $$

DELIMITER $$
CREATE TRIGGER bitacora_actasdelete
AFTER DELETE ON actas
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se elimino un registro', 'actas');
END $$


DELIMITER $$
CREATE PROCEDURE consultarPensum(
    IN codigocarrera_in INT
)
consultar_pensum:BEGIN

(SELECT cu.codigo, cu.nombre,
       CASE WHEN cu.obligatorio = 1 THEN 'Si' ELSE 'No' END AS obligatorio,
       cu.creditos_necesarios
FROM carrera c, curso cu
WHERE c.idcarrera = cu.carrera_idcarrera
AND c.idcarrera = codigocarrera_in)
UNION ALL
(SELECT cu.codigo, cu.nombre,
       CASE WHEN cu.obligatorio = 1 THEN 'Si' ELSE 'No' END AS obligatorio,
       cu.creditos_necesarios
FROM carrera c, curso cu
WHERE c.idcarrera = cu.carrera_idcarrera
AND c.idcarrera = 1)
;

END $$


DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    IN carnet_in BIGINT
)
consultar_estudiante:BEGIN

IF (NOT ExisteEstudiante(carnet_in)) THEN
    SELECT CONCAT('El estudiante ', carnet_in, ' no existe') AS ERROR;
    LEAVE consultar_estudiante;
END IF;

SELECT e.carnet, CONCAT(e.nombres, ' ', e.apellidos) AS nombres, e.fecha_nac, e.correo,
e.telefono, e.direccion, e.dpi, c.nombre as carrera, e.creditos
FROM estudiante e, carrera c
WHERE e.carrera_idcarrera = c.idcarrera
AND e.carnet = carnet_in
;
END $$


DELIMITER $$
CREATE PROCEDURE consultarDocente(
    IN siif_in INT
)
consultar_docente:BEGIN

IF (NOT ExisteDocente(siif_in)) THEN
    SELECT 'El docente no existe' AS ERROR;
    LEAVE consultar_docente;
END IF;

SELECT d.siif, CONCAT(d.nombres, ' ', d.apellidos) AS nombres, d.fecha_nac,
       d.correo, d.telefono, d.direccion, d.dpi
FROM docente d
WHERE d.siif = siif_in;

END $$


DELIMITER $$
CREATE PROCEDURE consultarEstudiantesAsignados(
    IN codigocurso_in INT,
    IN ciclo_in VARCHAR(2),
    IN anio_in INT,
    IN seccion_in VARCHAR(1)
)
consultar_asignados:BEGIN

IF (NOT ExisteCurso(codigocurso_in)) THEN
    SELECT CONCAT('El codigo del curso ', codigocurso_in, ' no existe') AS ERROR;
    LEAVE consultar_asignados;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE consultar_asignados;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La seccion debe ser una letra' AS ERROR;
    LEAVE consultar_asignados;
END IF;

SELECT e.carnet, CONCAT(e.nombres, ' ', e.apellidos) AS nombres, e.creditos
FROM cursohabilitado ch, asignacioncurso a, estudiante e
WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
AND a.estudiante_carnet = e.carnet
AND ch.curso_codigo = codigocurso_in
AND ch.anio = anio_in
AND ch.seccion = seccion_in
AND a.status = 1
;
END $$



DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
    IN codigocurso_in INT,
    IN ciclo_in VARCHAR(2),
    IN anio_in INT,
    IN seccion_in VARCHAR(1)
)
consultar_aprobados:BEGIN

IF (NOT ExisteCurso(codigocurso_in)) THEN
    SELECT CONCAT('El curso ', codigocurso_in, ' no existe') AS ERROR;
    LEAVE consultar_aprobados;
END IF;

IF (NOT validarCiclo(ciclo_in)) THEN
    SELECT 'El formato del ciclo no es valido' AS ERROR;
    LEAVE consultar_aprobados;
END IF;

IF (NOT validarLetraSeccion(seccion_in)) THEN
    SELECT 'La seccion debe ser una letra' AS ERROR;
    LEAVE consultar_aprobados;
END IF;

SELECT ch.curso_codigo, e.carnet, CONCAT(e.nombres, ' ', e.apellidos) AS nombres,
       n.nota, CASE WHEN n.nota >= 61 THEN 'APROBADO' ELSE 'DESAPROBADO' END AS estado
FROM cursohabilitado ch, estudiante e, notas n
WHERE ch.idcursohabilitado = n.cursohabilitado_idcursohabilitado
AND n.estudiante_carnet = e.carnet
AND ch.curso_codigo = codigocurso_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_in
AND ch.seccion = seccion_in
;
END $$


DELIMITER $$
CREATE PROCEDURE consultarActas(
    IN codigocurso_in INT
)
consultar_actas:BEGIN

IF (NOT ExisteCurso(codigocurso_in)) THEN
    SELECT CONCAT('El curso ', codigocurso_in, ' no existe') AS ERROR;
    LEAVE consultar_actas;
END IF;

SELECT ch.curso_codigo, ch.seccion as _seccion,
       (CASE WHEN ch.ciclo = '1S' THEN 'PRIMER SEMESTRE'
            WHEN ch.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
            WHEN ch.ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
            WHEN ch.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
        END) AS _ciclo, ch.anio as _anio, a.fecha_creacion,
        (SELECT COUNT(*) FROM cursohabilitado ch, notas n
            WHERE ch.idcursohabilitado = n.cursohabilitado_idcursohabilitado
            AND ch.curso_codigo = codigocurso_in
            AND ch.ciclo = (CASE WHEN _ciclo = 'PRIMER SEMESTRE' THEN '1S'
                WHEN _ciclo = 'VACACIONES DE JUNIO' THEN 'VJ'
                WHEN _ciclo = 'SEGUNDO SEMESTRE' THEN '2S'
                WHEN _ciclo = 'VACACIONES DE DICIEMBRE' THEN 'VD'
                END)
            and ch.anio = _anio
            and ch.seccion = _seccion
            ) AS cantidad_notas
FROM cursohabilitado ch, actas a
WHERE ch.idcursohabilitado = a.cursohabilitado_idcursohabilitado
AND ch.curso_codigo = codigocurso_in
;

END $$


DELIMITER $$
CREATE PROCEDURE consultarTasaDesasignacion(
    IN codigocurso_in INT,
    IN ciclo_in VARCHAR(2),
    IN anio_in INT,
    IN seccion_in VARCHAR(1)
)
consultar_tasa:BEGIN
DECLARE idcursohabilitado_temp INT;

SELECT ch.idcursohabilitado INTO idcursohabilitado_temp
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigocurso_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_in
AND ch.seccion = seccion_in;

IF (NOT existeIdCursoHabilitado(idcursohabilitado_temp)) THEN
    SELECT 'El curso habilitado no existe' AS ERROR;
    LEAVE consultar_tasa;
END IF;

SELECT ch.curso_codigo, ch.seccion,
       (CASE WHEN ch.ciclo = '1S' THEN 'PRIMER SEMESTRE'
           WHEN ch.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
           WHEN ch.ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
           WHEN ch.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE' END) AS ciclo,
    ch.anio,
    (SELECT COUNT(*) FROM cursohabilitado ch, asignacioncurso a
                     WHERE a.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
                     AND ch.idcursohabilitado = idcursohabilitado_temp AND a.status = 1) as asignados,
    (SELECT COUNT(*) FROM cursohabilitado ch, asignacioncurso a
                     WHERE a.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
                     AND ch.idcursohabilitado = idcursohabilitado_temp AND a.status = 0) as desasignados,
    ((SELECT COUNT(*) FROM cursohabilitado ch, asignacioncurso a
                     WHERE a.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
                     AND ch.idcursohabilitado = idcursohabilitado_temp AND a.status = 0)
    /((SELECT COUNT(*) FROM cursohabilitado ch, asignacioncurso a
                     WHERE a.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
                     AND ch.idcursohabilitado = idcursohabilitado_temp AND a.status = 1)
          + (SELECT COUNT(*) FROM cursohabilitado ch, asignacioncurso a
                     WHERE a.cursohabilitado_idcursohabilitado = ch.idcursohabilitado
                     AND ch.idcursohabilitado = idcursohabilitado_temp AND a.status = 0))
     )*100 AS porcentaje_desasignacion
FROM cursohabilitado ch
WHERE ch.curso_codigo = codigocurso_in
AND ch.ciclo = ciclo_in
AND ch.anio = anio_in
AND ch.seccion = seccion_in
;
END $$
