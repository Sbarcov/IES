/*

EJERCICIO: CREACION DE PROCEDIMIENTO ALMACENADO CON COMPROBACIÓN DE ERRORES.

Desarrolle el SP "sp_ventas_anuales", que genera la tabla "tmp_ventas_anuales" que debe contener el total de ventas 
minoristas por artículo.

La tabla debe tener las columnas ARTICULO, CANTIDAD, IMPORTE. Tenga en cuenta los siguientes puntos:

	- Se deben excluir ventas anuladas.
	- Se debe tomar para el cálculo del importe CANTIDAD * PRECIO de la tabla VENDET.
	- El procedimiento debe recibir como parámetro de entrada el AÑO, y generar la tabla con las ventas de ese año solamente.
	- Se debe evaluar la existencia de la tabla. Si no existe usar SELECT..INTO para crearla, y si existe usar TRUNCATE con
	  INSERT..SELECT para vaciarla y llenarla.
	- Realizar control de errores, mostrando el mensaje "La tabla fue generada con éxito, se insertaron [n] filas." en caso de
	  éxito, o en caso contrario mostrar "Se produjo un error durante la inserción. Contacte con el administrador".

TIP: para evaluar si la tabla existe o no, utilice la función OBJECT_ID([nombre_objeto]), que retorna NULL si un objeto no
existe, o un número entero que identifica al objeto en caso contrario. Ver el ejemplo debajo.

*/


-- USE Ventas2 DROP TABLE tmp_ventas_anuales

CREATE OR ALTER PROCEDURE sp_ventas_anuales

@AÑO INT 

AS

DECLARE
	@c INT

BEGIN TRY

	BEGIN TRANSACTION

	IF OBJECT_ID('tmp_ventas_anuales') IS NULL
		BEGIN
		SELECT 
			vd.articulo AS "ARTICULO",
			vd.cantidad AS "CANTIDAD",
			vd.cantidad * vd.precio AS "IMPORTE"
		INTO
			tmp_ventas_anuales
		FROM 
			vendet AS vd
			INNER JOIN vencab AS vc
			ON vd.factura = vc.factura
		WHERE
		vc.anulada = 0
		AND YEAR(vc.fecha) = @AÑO
		END

	ELSE

		BEGIN
		TRUNCATE TABLE tmp_ventas_anuales

		INSERT INTO tmp_ventas_anuales (ARTICULO,CANTIDAD,IMPORTE)
		SELECT
			vd.articulo,
			vd.cantidad,
			vd.cantidad * vd.precio
		FROM 
			vendet AS vd
			INNER JOIN vencab AS vc
			ON vd.factura = vc.factura
		WHERE
			vc.anulada = 0
			AND YEAR(vc.fecha) = @AÑO
		END

	COMMIT TRANSACTION

	SELECT 
		@c = COUNT(*)
	FROM 
		tmp_ventas_anuales

	PRINT 'La tabla fue generada con éxito, se insertaron [' + TRIM(STR(@c)) + '] filas.'

END TRY

BEGIN CATCH
	
	ROLLBACK TRANSACTION
	PRINT 'Se produjo un error durante la inserción. Contacte con el administrador'
	
END CATCH

EXEC sp_ventas_anuales 2008
