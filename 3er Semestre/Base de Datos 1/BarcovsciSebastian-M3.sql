/*

EJERCICIO 1: INSERTAR FILAS

a) Cree la tabla ACCESORIOS (rubros 76, 85, 77, 97, 70, 72, 87, 88) que tenga las columnas ARTICULO, NOMBRE,
PRECIOMAYOR y PRECIOMENOR tomando los datos de la tabla artículos. Utilice SELECT INTO.
b) Agregue a la tabla ACCESORIOS los artículos del rubro 89. Utilice INSERT SELECT.
c) Inserte un nuevo artículo con el código 'E000000001', denominado 'ELEMENTO ACCESORIO' con los precios 15 y 23.50
para ventas mayoristas y minoristas respectivamente.

En todos los casos verifique la correcta inserción de las filas mediante instrucciones SELECT de comprobación.

*/

USE Ventas2

-- A)

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
INTO 
	accesorios -- eliminar tabla para ejecutar: DROP TABLE accesorios
FROM
	articulos 
WHERE 
	rubro IN (76, 85, 77, 97, 70, 72, 87, 88) 

-- SELECT de comprobación

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios

-- B)

INSERT INTO accesorios
SELECT 
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	articulos 
WHERE
	rubro = 89

-- SELECT de comprobación

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios
WHERE
	articulo IN (SELECT articulo FROM articulos WHERE rubro = 89)

-- C)

INSERT INTO accesorios
	(articulo, nombre, preciomayor, preciomenor)
VALUES
	('E000000001','ELEMENTO ACCESORIO', 15, 23.50)

-- SELECT de comprobación

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios
WHERE
	articulo = 'E000000001'

/*

EJERCICIO 2: MODIFICACIÓN DE DATOS

a) Usando la tabla ACCESORIOS creada anteriormente, modifique los artículos que tengan PRECIOMAYOR negativo
(menor a cero), reemplazando el valor negativo por cero (0)
b) Usando la tabla ACCESORIOS, reemplace el valor del PRECIOMENOR por PRECIOMAYOR * 1.10 (10% más) para
aquellos artículos en los que el PRECIOMENOR sea menor o igual al PRECIOMAYOR.

*/

-- A)

UPDATE 
	accesorios
SET 
	preciomayor = 0
WHERE
	preciomayor < 0

-- SELECT de comprobación (Ejecutar antes y despues para comprobar modificaciones)

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios
WHERE
	preciomayor < 0


-- B)


UPDATE 
	accesorios
SET 
	preciomenor = preciomayor * 1.10
WHERE
	preciomenor <= preciomayor

-- SELECT de comprobación (Ejecutar antes y despues para comprobar modificaciones)

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios
WHERE
	preciomenor <= preciomayor -- Solo quedan los elementos con ambos precios en 0

/*

EJERCICIO 3: ELIMINACION DE FILAS

a) Usando la tabla ACCESORIOS, borre las filas que correspondan a artículos que contengan la palabra OUTLET en su nombre
o que tengan valor cero en ambos precios (preciomayor y preciomenor)
b) Elimine la tabla ACCESORIOS.


*/

-- A)

DELETE 
	accesorios
WHERE
	nombre LIKE '%OUTLET%' OR (preciomenor + preciomayor) = 0

-- SELECT de comprobación (Ejecutar antes y  despues)

SELECT
	articulo,
	nombre,
	preciomayor,
	preciomenor
FROM 
	accesorios
WHERE
	nombre LIKE '%OUTLET%'
	OR (preciomenor + preciomayor) = 0

-- B)

DROP TABLE accesorios