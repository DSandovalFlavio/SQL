# Curso de Base de Datos en Codigo Facilito

## Temas Basicos

### Como declarar una variable

Utilizamos la palabra reservada SET despues un @, luego el nombre de la variable 
y el valor que queremos asignarle.
    
```sql
    SET @nombre = 'Juan';
    SET @apellido = 'Perez';
    SET @edad = 20;
    SET @fecha_nacimiento = '1990-01-01';
    SET @sueldo = 1000.50;
```
o tambien podriamos asiganarlo de la siguiente manera
```sql
    SET @nombre = 'Juan', @apellido = 'Perez', @edad = 20, @fecha_nacimiento = '1990-01-01', @sueldo = 1000.50;
```

para obtener el valor de la variable utilizamos la palabra reservada SELECT
```sql
    SELECT @nombre;
``` 

### Como crear tablas a partir de otras tablas

```sql
    CREATE TABLE tabla_nueva AS
    SELECT * FROM tabla_existente;
```

tambien podemos utilizar la palabra reservada LIKE para crear una tabla a partir de otra
```sql
    CREATE TABLE tabla_nueva LIKE tabla_existente;
```

### Como condicionar la ejecucion de una sentencia
Utilizamos las palabras reservadas IF EXISTS o IF NOT EXISTS

```sql
    DROP DATABASE IF EXISTS nombre_base_datos;
    CREATE DATABASE IF NOT EXISTS nombre_base_datos;
    CREATE TABLE IF NOT EXISTS nombre_tabla;
```

### Como restringir la insercion de datos en una tabla con ENUM
```sql
    CREATE TABLE nombre_tabla(
        nombre_campo ENUM('valor1', 'valor2', 'valor3')
    );
```

## Temas Intermedios

### Como crear una funcion en SQL
La estructura de una funcion es la siguiente
```sql
    DELIMITER //
    CREATE FUNCTION nombre_funcion( # nombre de la funcion
        parametro1 DATE, # parametros de la funcion
        parametro2 INT # parametros de la funcion
    )
    RETURNS DATE # tipo de dato que retorna la funcion
    DETERMINISTIC # indica que la funcion siempre retorna el mismo valor
    BEGIN # inicio del bloque de codigo
        DECLARE variable DATE; # declaracion de variables
        SET variable = parametro1 + INTERVAL parametro2 DAY; # asignacion de valor a la variable
        RETURN variable; # retorno de la variable
    END; # fin del bloque de codigo
    //
    DELIMITER ;
```
### Como listar las funciones que existen en una base de datos
```sql
    SELECT * FROM mysql.proc WHERE db = 'nombre_base_datos';
```

### Ejecutar sentencias dentro de funciones
```sql
    DELIMITER //
    CREATE FUNCTION nombre_funcion()
    RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE variable INT;
        SET variable = (SELECT COUNT(*) FROM nombre_tabla);
        RETURN variable;
    END;
    //
    DELIMITER ;
```

### Como ejecutar una funcion
```sql
    SELECT nombre_funcion();
```

## Temas Avanzados

### Como crear un procedimiento almacenado en SQL
Un procedimiento almacenado es una funcion que no retorna ningun valor, es decir, es una funcion que solo ejecuta sentencias.

La estructura de un procedimiento almacenado es la siguiente
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento( # nombre del procedimiento
        parametro1 DATE, # parametros del procedimiento
        parametro2 INT # parametros del procedimiento
    )
    BEGIN # inicio del bloque de codigo
        DECLARE variable DATE; # declaracion de variables
        SET variable = parametro1 + INTERVAL parametro2 DAY; # asignacion de valor a la variable
        INSERT INTO nombre_tabla VALUES (variable); # ejecucion de sentencias
    END; # fin del bloque de codigo
    //
    DELIMITER ;
```

### Como ejecutar un procedimiento almacenado
```sql
    CALL nombre_procedimiento(parametro1, parametro2);
```

### Store procedure con parametros de entrada y salida
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento(
        IN parametro1 DATE,
        IN parametro2 INT,
        OUT parametro3 DATE
    )
    BEGIN
        DECLARE variable DATE;
        SET variable = parametro1 + INTERVAL parametro2 DAY;
        SET parametro3 = variable;
    END;
    //
    DELIMITER ;
```

### Condiciones en procedimientos almacenados
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento(
        IN parametro1 DATE,
        IN parametro2 INT,
        OUT parametro3 DATE
    )
    BEGIN
        DECLARE variable DATE;
        IF parametro2 > 0 THEN
            SET variable = parametro1 + INTERVAL parametro2 DAY;
        ELSE
            SET variable = parametro1 - INTERVAL parametro2 DAY;
        END IF;
        SET parametro3 = variable;
    END;
    //
    DELIMITER ;
```

### Ciclos en procedimientos almacenados
Ciclo WHILE
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento(
        IN parametro1 DATE,
        IN parametro2 INT,
        OUT parametro3 DATE
    )
    BEGIN
        DECLARE variable DATE;
        DECLARE i INT DEFAULT 0;
        WHILE i < parametro2 DO # mientras i sea menor que parametro2
            SET variable = parametro1 + INTERVAL i DAY;
            SET i = i + 1;
        END WHILE;
        SET parametro3 = variable;
    END;
    //
    DELIMITER ;
```
Ciclo REPEAT
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento(
        IN parametro1 DATE,
        IN parametro2 INT,
        OUT parametro3 DATE
    )
    BEGIN
        DECLARE variable DATE;
        DECLARE i INT DEFAULT 0;
        REPEAT # repetir el bloque de codigo
            SET variable = parametro1 + INTERVAL i DAY;
            SET i = i + 1;
        UNTIL i >= parametro2 END REPEAT; # hasta que i sea mayor o igual que parametro2
        SET parametro3 = variable;
    END;
    //
    DELIMITER ;
```

### Transacciones en SQL

Una transaccion es un conjunto de sentencias que se ejecutan de forma atomica, es decir, si una de las sentencias falla, todas las sentencias fallan.

Uso de COMMIT
```sql
    START TRANSACTION; # inicio de la transaccion
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    COMMIT; # confirmacion de la transaccion
```

Uso de ROLLBACK
```sql
    START TRANSACTION;
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    ROLLBACK; # cancelacion de la transaccion
```

Transacciones en procedimientos almacenados
```sql
    DELIMITER //
    CREATE PROCEDURE nombre_procedimiento(
        IN parametro1 INT
        )
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN # inicio del bloque de codigo
                ROLLBACK; # cancelacion de la transaccion
                SELECT 'Error en la transaccion'; # mensaje de error
            END; # fin del bloque de codigo
        START TRANSACTION;
        INSERT INTO nombre_tabla VALUES (parametro1); # sentencia 1
        COMMIT; # confirmacion de la transaccion
    END;
    //
    DELIMITER ;
```

### Como crear un trigger en SQL
Un trigger es una funcion que se ejecuta cuando se ejecuta una accion en una tabla.

La estructura de un trigger es la siguiente
```sql
    DELIMITER //
    CREATE TRIGGER nombre_trigger
    BEFORE | AFTER INSERT | UPDATE | DELETE ON nombre_tabla
    FOR EACH ROW # se ejecuta por cada fila afectada
    BEGIN # inicio del bloque de codigo
        INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);
    END; # fin del bloque de codigo
    //
    DELIMITER ;
```
