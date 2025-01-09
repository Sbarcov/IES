



Use Ventas2 -- Ejecutar antes de la primera consulta





/*

CONSULTA 1: Recuperación de datos desde una tabla.

Liste los articulos que contengan la cadena CINTO en su nombre, dados de alta en el año 2006 (creado), cuyo precio mayorista 
(preciomayor) sea menor a su precio minorista. Tener en cuenta que la marca sea 'A','F' o 'Q', y que ambos precios sean mayores
a cero. Presente: código, nombre, marca, precio x mayor, precio x menor, y diferencia entre ambos. Ordene en forma decreciente 
por la diferencia de precios.

TABLAS: articulos.

*/

SELECT
   articulo as "Codigo",
   nombre AS "Nombre",
   marca AS "Marca",
   preciomayor AS "Precio x Mayor",
   preciomenor AS "Precio x Menor",
   preciomenor - preciomayor AS "Diferencia"
FROM
   articulos
WHERE
   nombre LIKE '%CINTO%'
   AND marca IN ('A', 'F', 'Q')
   AND creado BETWEEN '2006-01-01' AND '2006-12-31'
   AND preciomayor < preciomenor
   AND preciomayor > 0
   AND preciomenor > 0
ORDER BY
   6 DESC

/*

CONSULTA 2: Uso de SUBCONSULTAS.

Presente el código, el nombre y la sucursal de los vendedores que sean encargados (encargado = 'S'), que estén activos
(activo = 'S'), y que realizaron alguna vez una venta que fue anulada (anulada = 1). Ordene por nombre de vendedor.

TABLAS: vendedores, vencab.

*/

SELECT
	vendedor AS "Código",
	nombre AS "Nombre",
	sucursal AS "Sucursal"
FROM
	vendedores
WHERE
	vendedor IN (SELECT vendedor FROM vencab WHERE anulada = 1)
	AND encargado = 'S'
ORDER BY
	nombre

/*

CONSULTA 3: Recuperación de datos desde varias tablas.

Buscar para el mes de Setiembre de 2005, el nombre del vendedor, el nombre de la sucursal, la letra y número de factura,
el código del articulo y su nombre, mostrando el precio vendido (precio) y el precio estipulado de venta (precioventa),
para aquellos artículos que se vendieron a un precio menor al precio estipulado para la venta con un 10% de descuento aplicado.

TABLAS: vencab, vendet, vendedores, articulos, sucursales.

*/

SELECT DISTINCT
	v.nombre AS "Vendedor",
	s.denominacion AS "Sucursal",
	vc.letra AS "Letra",
	vc.factura AS "Numero de factura",
	a.articulo AS "Codigo",
	a.nombre AS "Nombre articulo",
	vd.precio AS "Precio Vendido",
	vd.precioventa AS "precio estipulado"
FROM
	vencab AS vc
	INNER JOIN vendedores AS v ON vc.vendedor = v.vendedor
	INNER JOIN sucursales AS s ON vc.sucursal = s.sucursal
	INNER JOIN vendet AS vd ON vc.factura = vd.factura AND vc.letra = vd.letra
	INNER JOIN articulos AS a ON vd.articulo = a.articulo
WHERE
	MONTH(vc.fecha) = 9
	AND (vd.precioventa * 0.90) = vd.precio


/*

CONSULTA 4: Agrupamiento de datos con HAVING.

Determinar la comision por ventas para cada local, mostrando año, el nombre de local, importe total de ventas y calcular
la comision de 2% del total para cada año (total vendido * 0.02). Excluir las ventas anuladas, y solamente calcular las
comisiones para las sucursales que superaron el importe de ventas anuales de $200.000. Ordenar por año y sucursal.

TABLAS: SUCURSALES (sucursal) VENCAB (sucursal)

*/

SELECT
	s.denominacion AS "Sucursal",
	YEAR(vc.fecha) AS "Año",
	SUM(vc.total) AS "Importe Total",
	SUM(vc.total * 0.02) AS "Comision"
FROM
	vencab AS vc
	INNER JOIN sucursales AS s
	ON vc.sucursal = s.sucursal
WHERE 
	vc.anulada = 0
GROUP BY
	s.denominacion,
	YEAR(vc.fecha)
HAVING 
	SUM(vc.total) > 200000
ORDER BY
	1,2

/*

CONSULTA 5: UNION.

Listar sin duplicados todas las facturas del año 2008 en donde se incluyó el artículo A108210051, tanto por ventas
mayoristas como minoristas. Presentar la letra y la factura, y excluir las ventas anuladas.

TABLAS: mayorcab y mayordet para VENTAS MAYORISTAS, vencab y vendet para VENTAS MINORISTAS. Las tablas mayorcab y vencab
son conceptualmente equivalentes, la primera tiene ventas mayoristas y la segunda minoristas. Lo mismo en el caso de 
mayordet y vendet, donde se presentan el detalle de los artículos facturados en forma mayorista y minorsita respectivamente.

PISTA: se deben generar dos conjuntos de datos y luego unirlos.

*/

SELECT DISTINCT
	mc.letra AS "Letra",
	mc.factura AS "Factura",
	'Mayorista' AS "Mayorista/Minorista"
FROM
	mayorcab AS mc
	INNER JOIN mayordet AS md ON mc.factura = md.factura AND mc.letra = md.letra AND md.articulo = 'A108210051'
WHERE
	mc.anulada = 0
	AND YEAR(mc.fecha) = 2008
--
UNION	-- Se debe utilizar UNION ALL si se quieren mostrar todas las filas (incluyendo duplicadas)
--
SELECT DISTINCT
	vc.letra AS "Letra",
	vc.factura AS "Factura",
	'Minorista' AS "Mayorista/Minorista"
FROM
	vencab AS vc
	INNER JOIN vendet AS vd ON vc.factura = vd.factura AND vc.letra = vd.letra AND vd.articulo = 'A108210051'
WHERE
	vc.anulada = 0
	AND YEAR(vc.fecha) = 2008
--
ORDER BY
	1, 2