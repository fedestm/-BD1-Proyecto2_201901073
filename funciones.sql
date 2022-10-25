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
    carnet INT
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

SELECT CONCAT('El curso ', cursocodigo_in, ' se habilito correctamente');
END $$











/*             Bitacora                   */
DELIMITER $$
CREATE TRIGGER bitacora_carrera_insert
AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'carrera');
END $$