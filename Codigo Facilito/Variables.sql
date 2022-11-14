-- Como declarar variables
SET @nombre = 'Juan'
SET @apellido = 'Perez'
SET @edad = 25
SET @fecha = '2018-01-01'
-- Como obtener el valor de una variable

SELECT @nombre, @apellido, @edad, @fecha;

-- Como crear funciones
USE LearningSQL;

SET @now = CURDATE();
DELIMITER //
    CREATE FUNCTION agregar_dias( # nombre de la funcion
        fecha DATE, # parametros de la funcion
        dias INT # parametros de la funcion
    )
    RETURNS DATE # tipo de dato que retorna la funcion
    DETERMINISTIC # indica que la funcion siempre retorna el mismo valor
    BEGIN # inicio del bloque de codigo
        DECLARE variable DATE; # declaracion de variables
        SET variable = fecha + INTERVAL dias DAY; # asignacion de valor a la variable
        RETURN variable; # retorno de la variable
    END; # fin del bloque de codigo
//
DELIMITER ;

-- Como invocar una funcion
SELECT agregar_dias(@now, 10);

-- Como listar las funciones que existen en la base de datos
SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'LearningSQL';

-- ### Ejecutar sentencias dentro de funciones
-- Como crear una funcion que ejecuta una sentencia
USE LearningSQL;
DELIMITER //
    CREATE FUNCTION obtener_paginas()
    RETURNS INT
    DETERMINISTIC
    BEGIN
        SET @paginas = (SELECT (ROUND(RAND() * 100) * 4));
        RETURN @paginas;
    END //
DELIMITER ;

-- Como invocar una funcion que ejecuta una sentencia
SELECT obtener_paginas();

-- Como crear un trigger
USE LearningSQL;
DELIMITER //
    CREATE TRIGGER insertar_libro
    AFTER INSERT ON libros
    FOR EACH ROW
    BEGIN
        INSERT INTO libros_paginas (id_libro, paginas) VALUES (NEW.id, obtener_paginas());
    END //
DELIMITER ;