/*

EJERCICIO: CREACION DE PROCEDIMIENTO ALMACENADO CON COMPROBACI�N DE ERRORES.

Desarrolle el SP "sp_ventas_anuales", que genera la tabla "tmp_ventas_anuales" que debe contener el total de ventas 
minoristas por art�culo.

La tabla debe tener las columnas ARTICULO, CANTIDAD, IMPORTE. Tenga en cuenta los siguientes puntos:

	- Se deben excluir ventas anuladas.
	- Se debe tomar para el c�lculo del importe CANTIDAD * PRECIO de la tabla VENDET.
	- El procedimiento debe recibir como par�metro de entrada el A�O, y generar la tabla con las ventas de ese a�o solamente.
	- Se debe evaluar la existencia de la tabla. Si no existe usar SELECT..INTO para crearla, y si existe usar TRUNCATE con
	  INSERT..SELECT para vaciarla y llenarla.
	- Realizar control de errores, mostrando el mensaje "La tabla fue generada con �xito, se insertaron [n] filas." en caso de
	  �xito, o en caso contrario mostrar "Se produjo un error durante la inserci�n. Contacte con el administrador".

TIP: para evaluar si la tabla existe o no, utilice la funci�n OBJECT_ID([nombre_objeto]), que retorna NULL si un objeto no
existe, o un n�mero entero que identifica al objeto en caso contrario. Ver el ejemplo debajo.

*/


-- USE Ventas2 DROP TABLE tmp_ventas_anuales

CREATE OR ALTER PROCEDURE sp_ventas_anuales

@A�O INT 

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
		AND YEAR(vc.fecha) = @A�O
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
			AND YEAR(vc.fecha) = @A�O
		END

	COMMIT TRANSACTION

	SELECT 
		@c = COUNT(*)
	FROM 
		tmp_ventas_anuales

	PRINT 'La tabla fue generada con �xito, se insertaron [' + TRIM(STR(@c)) + '] filas.'

END TRY

BEGIN CATCH
	
	ROLLBACK TRANSACTION
	PRINT 'Se produjo un error durante la inserci�n. Contacte con el administrador'
	
END CATCH

EXEC sp_ventas_anuales 2008
