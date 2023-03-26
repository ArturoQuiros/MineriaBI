/*
	Crear y correr en la DB de Staging los stored procedures para agregar datos de ventas de 1991 a 2020
*/

/*
	Crear stored procedure generate_order
*/

CREATE OR ALTER PROCEDURE generate_order @p_fecha_cierre date
AS

DECLARE @v_existe_pedido INT;
DECLARE @v_cantidad INT;
DECLARE @v_descuento DECIMAL(15,2);
DECLARE @v_codigo_pedido INT;
DECLARE @v_codigo_cliente VARCHAR(5);
DECLARE @v_codigo_empleado INT;
DECLARE @v_codigo_shipper INT;
DECLARE @v_codigo_producto VARCHAR(15);
DECLARE @v_precio_venta DECIMAL(15,2);
DECLARE @v_registros INT;
DECLARE @v_pedidos INT;
DECLARE @v_dia VARCHAR(30);

DECLARE @v_freight MONEY;
DECLARE @v_ship_name VARCHAR(40);
DECLARE @v_ship_address VARCHAR(60);
DECLARE @v_ship_city VARCHAR(15);
DECLARE @v_ship_region VARCHAR(15);
DECLARE @v_ship_postal_code VARCHAR(15);
DECLARE @v_ship_country VARCHAR(15);

DECLARE @cnt INT = 1;
DECLARE @cnt2 INT = 1;

BEGIN

SET @v_pedidos = (Select ceiling(rand()*50));

WHILE @cnt <= @v_pedidos
BEGIN

    SET @v_codigo_cliente = (select top 1 CustomerID from Customers order by NEWID());
   
    SET @v_codigo_empleado = (select top 1 EmployeeID from Employees order by NEWID());

    SET @v_codigo_shipper = (select top 1 ShipperID from Shippers order by NEWID());

    SET @v_codigo_pedido = (select max(OrderID) + 1 from Orders);
    
    SET @v_freight = (select top 1 Freight from Orders order by NEWID());
    SET @v_ship_name = (select top 1 ShipName from Orders order by NEWID());
    SET @v_ship_address = (select top 1 ShipAddress from Orders order by NEWID());
    SET @v_ship_city = (select top 1 ShipCity from Orders order by NEWID());
    SET @v_ship_region = (select top 1 ShipRegion from Orders order by NEWID());
    SET @v_ship_postal_code = (select top 1 ShipPostalCode from Orders order by NEWID());
    SET @v_ship_country = (select top 1 ShipCountry from Orders order by NEWID());

    insert into orders
          (CustomerID,
           EmployeeID,
           OrderDate,
           RequiredDate,
           ShippedDate,
           ShipVia,
           Freight,
           ShipName,
           ShipAddress,
           ShipCity,
           ShipRegion,
           ShipPostalCode,
           ShipCountry)
        values
          (@v_codigo_cliente,
           @v_codigo_empleado,
           @p_fecha_cierre,
           @p_fecha_cierre,
           @p_fecha_cierre,
           @v_codigo_shipper,
           @v_freight,
           @v_ship_name,
           @v_ship_address,
           @v_ship_city,
           @v_ship_region,
           @v_ship_postal_code,
           @v_ship_country);

    SET @v_registros = (Select ceiling(rand()*25));

    WHILE @cnt2 <= @v_registros
    BEGIN
    
    SET @v_codigo_producto = (select top 1 ProductID from Products order by NEWID());
    SET @v_precio_venta = (select top 1 UnitPrice from Products order by NEWID());

    SET @v_cantidad = (Select ceiling(rand()*50));

    SET @v_descuento = (Select floor(rand()*26) / 100);
        
    insert into OrderDetails
    (OrderID,
        ProductID,
        Quantity,
        UnitPrice,
        Discount)
    values
    (@v_codigo_pedido,
        @v_codigo_producto,
        @v_cantidad,
        @v_precio_venta,
        @v_descuento);

    SET @cnt2 = @cnt2 + 1;
    END;

   SET @cnt = @cnt + 1;
END;

END ;





/*
	Crear stored procedure apply_order
*/

CREATE OR ALTER PROCEDURE apply_order AS
BEGIN
    DECLARE @v_fecha_inicio DATE;
    DECLARE @v_fecha_fin DATE;
  
  BEGIN
    /*
      1991-2020
    */
    SET @v_fecha_inicio='1991-01-01'; 
    SET @v_fecha_fin ='2020-12-31';

    WHILE @v_fecha_inicio<=@v_fecha_fin
	BEGIN

        EXEC generate_order @p_fecha_cierre = @v_fecha_inicio;

        SET @v_fecha_inicio=DATEADD(DAY,1,@v_fecha_inicio);
	END ;

  END ;

END;





/*
	Ejecutar stored procedure apply_order
*/

EXEC apply_order






