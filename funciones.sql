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
/*Ya existe*/
IF (ExisteCarrera(nombre_in)) THEN
    SELECT 'La carrera ya existe' AS ERROR;
    LEAVE add_carrera;
end if;

IF (NOT ValidarLetras(nombre_in)) THEN
    SELECT 'El nombre solo debe contener letras' AS ERROR;
    LEAVE add_carrera;
end if;

INSERT INTO carrera(nombre) VALUES (nombre_in);
SELECT CONCAT('Carrera ', nombre_in, ' registrado') AS MENSAJE;
END $$


/*             Bitacora                   */
DELIMITER $$
CREATE TRIGGER bitacora_carrera_insert
AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(fecha_hora, descripcion, tabla) VALUES (SYSDATE(), 'Se inserto un nuevo registro', 'carrera');
END $$
