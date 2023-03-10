Dimensiones:

DIM_EMPLOYEE_TERRITORIES CON REGION
DIM_EMPLOYEES SIN TERRITORY
DIM_ORDERS CON SHIPPER Y PHONE
DIM_CUSTOMERS
DIM_PRODUCTS
DIM_CATEGORIES
DIM_SUPPLIERS
DIM_TIME 1996-1998
FACT_SALES CON FECHA (ORDER_DATE), UNIT_PRICE, QUANTITY, DISCOUNT





DROP TABLE DIM_EMPLOYEE_TERRITORIES;
DROP TABLE DIM_EMPLOYEES;
DROP TABLE DIM_ORDERS;
DROP TABLE DIM_CUSTOMERS;
DROP TABLE DIM_PRODUCTS;
DROP TABLE DIM_CATEGORIES;
DROP TABLE DIM_SUPPLIERS;
DROP TABLE DIM_TIME;
DROP TABLE FACT_SALES;





CREATE TABLE DIM_TIME(
	ID_TIME int IDENTITY NOT NULL CONSTRAINT PK_TIME PRIMARY KEY,
	DATE date NULL,
	YEAR int NULL,
	MONTH int NULL,
	DAY int NULL,
	NDAY varchar(30) NULL,
	NMONTH varchar(20) NULL,
	DAY_YEAR int NULL,
	PERIOD varchar(30) NULL
)

select * from DIM_TIME
delete from DIM_TIME
DBCC CHECKIDENT (DIM_TIME, RESEED, 0)




 
BEGIN
SET LANGUAGE English;
DECLARE @FECHA_INICIO DATE;
DECLARE @FECHA_FINAL DATE;
SET @FECHA_INICIO='1996-01-01';
SET @FECHA_FINAL ='1998-12-31';

DECLARE @PFECHA DATE;
DECLARE @PANNIO INT;
DECLARE @PMES INT;
DECLARE @PNMES VARCHAR(20);
DECLARE @PDIA  INT;
DECLARE @PDIA_ANNIO INT  ;
DECLARE @PERIODO VARCHAR(30);
DECLARE @PNDIA VARCHAR(30);

WHILE @FECHA_INICIO<=@FECHA_FINAL
	BEGIN

		SET @PFECHA      = @FECHA_INICIO;
		SET @PANNIO 	 = YEAR(@FECHA_INICIO);
		SET @PMES 		 = MONTH(@FECHA_INICIO);
		SET @PNMES		 = DATENAME(MONTH, @FECHA_INICIO);
		SET @PNDIA		 = DATENAME(dw,@FECHA_INICIO);
		SET @PDIA  		 = DAY(@FECHA_INICIO);
		SET @PDIA_ANNIO  = DATENAME(dayofyear, @FECHA_INICIO) ;
		SET @PERIODO     =CONCAT( CASE WHEN @PMES BETWEEN 1 and 9  THEN 	
							CONCAT('0',cast(@PMES as varchar(1))) ELSE 
								cast( @PMES as varchar(2)) END ,' - ',DATENAME(MONTH, @FECHA_INICIO))
		
		INSERT INTO DIM_TIME (DATE,
								YEAR,
								MONTH,
								DAY,
								NDAY,
								NMONTH,
								DAY_YEAR,
								PERIOD
								)
								VALUES
								(@PFECHA ,	
								@PANNIO ,
								@PMES ,
								@PDIA,
								upper(@PNDIA),
								upper(@PNMES),	
								@PDIA_ANNIO ,
								upper(@PERIODO)
								)
				SET @FECHA_INICIO=DATEADD(DAY,1,@FECHA_INICIO);
	END ;

END ;






CREATE TABLE DIM_EMPLOYEE_TERRITORIES(
	ID_EMPLOYEE_TERRITORY int IDENTITY NOT NULL CONSTRAINT PK_EMPLOYEE_TERRITORY PRIMARY KEY,
	TERRITORY_ID nvarchar(10) NOT NULL,
    EMPLOYEE_ID INT NOT NULL,
	TERRITORY nchar(50) NOT NULL,
    EMPLOYEE nvarchar(80) NOT NULL,
    REGION nchar(30) NOT NULL
)

CREATE TABLE DIM_EMPLOYEES(
	ID_EMPLOYEE int IDENTITY NOT NULL CONSTRAINT PK_EMPLOYEE PRIMARY KEY,
	EMPLOYEE_ID INT NOT NULL,
	EMPLOYEE_NAME nvarchar(80) NOT NULL,
	TITLE nvarchar(40) NOT NULL,
    BIRTH_DATE DATETIME NOT NULL,
    HIRE_DATE DATETIME NOT NULL,
    CITY nvarchar(20) NOT NULL,
    REGION nvarchar(20) NOT NULL,
    COUNTRY nvarchar(20) NOT NULL,
    REPORTS_TO nvarchar(60) NOT NULL
)

CREATE TABLE DIM_ORDERS(
	ID_ORDER int IDENTITY NOT NULL CONSTRAINT PK_ORDER PRIMARY KEY,
	ORDER_ID int NOT NULL,
	CUSTOMER nvarchar(80) NOT NULL,
	EMPLOYEE nvarchar(80) NOT NULL,
    ORDER_DATE DATETIME NOT NULL,
    REQUIRED_DATE DATETIME NOT NULL,
    SHIPPED_DATE DATETIME NOT NULL,
    SHIPPER nvarchar(30) NOT NULL,
    FREIGHT money NOT NULL,
    SHIP_CITY nvarchar(30) NOT NULL,
    SHIP_REGION nvarchar(20) NOT NULL,
    SHIP_COUNTRY nvarchar(30) NOT NULL
)

CREATE TABLE DIM_CUSTOMERS(
	ID_CUSTOMER int IDENTITY NOT NULL CONSTRAINT PK_CUSTOMER PRIMARY KEY,
	CUSTOMER_ID nchar(15) NOT NULL,
	COMPANY_NAME nvarchar(80) NOT NULL,
	CONTACT_NAME nvarchar(80) NOT NULL,
    CONTACT_TITLE nvarchar(80) NOT NULL,
    CITY nvarchar(40) NOT NULL,
    REGION nvarchar(40) NOT NULL,
    COUNTRY nvarchar(40) NOT NULL,
    CATEGORY varchar(40) NOT NULL,
    ENTRY_DATE DATETIME NOT NULL
)

CREATE TABLE DIM_PRODUCTS(
	ID_PRODUCT int IDENTITY NOT NULL CONSTRAINT PK_PRODUCT PRIMARY KEY,
	PRODUCT_ID INT NOT NULL,
	PRODUCT_NAME nvarchar(80) NOT NULL,
	CATEGORY nvarchar(30) NOT NULL,
	SUPPLIER nvarchar(100) NOT NULL,
    REORDER_LEVEL smallint NOT NULL
)

CREATE TABLE DIM_CATEGORIES(
	ID_CATEGORY int IDENTITY NOT NULL CONSTRAINT PK_CATEGORY PRIMARY KEY,
	CATEGORY_ID INT NOT NULL,
	CATEGORY_NAME nvarchar(50) NOT NULL,
	DESCRIPTION nvarchar(MAX) NOT NULL
)

CREATE TABLE DIM_SUPPLIERS(
	ID_SUPPLIER int IDENTITY NOT NULL CONSTRAINT PK_SUPPLIER PRIMARY KEY,
	SUPPLIER_ID INT NOT NULL,
	COMPANY_NAME nvarchar(80) NOT NULL,
	CONTACT_NAME nvarchar(80) NOT NULL,
    CONTACT_TITLE nvarchar(80) NOT NULL,
    CITY nvarchar(40) NOT NULL,
    REGION nvarchar(40) NOT NULL,
    COUNTRY nvarchar(40) NOT NULL
)

CREATE TABLE FACT_SALES(
	ID_SALE int IDENTITY NOT NULL CONSTRAINT PK_SALE PRIMARY KEY CLUSTERED,
	ID_EMPLOYEE int NOT NULL,
	ID_ORDER int NOT NULL,
	ID_CUSTOMER int NOT NULL,
	ID_PRODUCT int NOT NULL,
	ID_CATEGORY INT NOT NULL,
    ID_SUPPLIER int NOT NULL,
	ID_TIME INT NOT NULL,
	QUANTITY smallint NOT NULL,
	UNIT_PRICE money NOT NULL,
    DISCOUNT real NOT NULL,
    ORDER_DATE DATETIME NOT NULL
) 

CREATE TABLE ORDER_DETAILS (
	OrderID int NOT NULL,
	ProductID int NOT NULL,
    UnitPrice money NOT NULL,
	Quantity smallint NOT NULL,
    Discount real NOT NULL
)






ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_EMPLOYEES FOREIGN KEY(ID_EMPLOYEE)
REFERENCES DIM_EMPLOYEES (ID_EMPLOYEE)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_ORDERS FOREIGN KEY(ID_ORDER)
REFERENCES DIM_ORDERS (ID_ORDER)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_CUSTOMERS FOREIGN KEY(ID_CUSTOMER)
REFERENCES DIM_CUSTOMERS (ID_CUSTOMER)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_PRODUCTS FOREIGN KEY(ID_PRODUCT)
REFERENCES DIM_PRODUCTS (ID_PRODUCT)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_CATEGORIES FOREIGN KEY(ID_CATEGORY)
REFERENCES DIM_CATEGORIES (ID_CATEGORY)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_SUPPLIERS FOREIGN KEY(ID_SUPPLIER)
REFERENCES DIM_SUPPLIERS (ID_SUPPLIER)

ALTER TABLE FACT_SALES  WITH CHECK ADD  CONSTRAINT FK_SALES_TIME FOREIGN KEY(ID_TIME)
REFERENCES DIM_TIME (ID_TIME)






DIM_EMPLOYEE_TERRITORIES:

SELECT
UPPER(T.TERRITORYID) TERRITORY_ID,
UPPER(E.EMPLOYEEID) EMPLOYEE_ID,
UPPER(T.TERRITORYDESCRIPTION) TERRITORY_DESCRIPTION,
UPPER(CONCAT(E.FIRSTNAME, ' ', E.LASTNAME)) EMPLOYEE,
UPPER(REGIONDESCRIPTION) REGION
FROM EMPLOYEES E
INNER JOIN EMPLOYEETERRITORIES ET
ON E.EMPLOYEEID = ET.EMPLOYEEID
INNER JOIN TERRITORIES T
ON T.TERRITORYID = ET.TERRITORYID
INNER JOIN REGION G
ON G.REGIONID = T.REGIONID
ORDER BY EMPLOYEE_ID

DIM_EMPLOYEES:

SELECT
UPPER(E.EMPLOYEEID) EMPLOYEE_ID,
UPPER(CONCAT(E.FIRSTNAME, ' ', E.LASTNAME)) EMPLOYEE_NAME,
UPPER(E.TITLE) TITLE,
E.BIRTHDATE BIRTH_DATE,
E.HIREDATE HIRE_DATE,
UPPER(E.CITY) CITY,
UPPER(isnull(E.REGION,'NO REGION')) REGION,
UPPER(E.COUNTRY) COUNTRY,
COALESCE(NULLIF(
UPPER(CONCAT(J.FIRSTNAME, ' ', J.LASTNAME)),''), 'NO BOSS') REPORTS_TO
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES J
ON E.REPORTSTO = J.EMPLOYEEID
ORDER BY EMPLOYEE_ID

DIM_ORDERS:

SELECT
UPPER(O.ORDERID) ORDER_ID,
UPPER(C.COMPANYNAME) CUSTOMER,
UPPER(CONCAT(E.FIRSTNAME, ' ', E.LASTNAME)) EMPLOYEE,
O.ORDERDATE ORDER_DATE,
O.REQUIREDDATE REQUIRED_DATE,
isnull(O.SHIPPEDDATE,cast(getdate() as date)) SHIPPED_DATE,
UPPER(S.COMPANYNAME) SHIPPER,
UPPER(O.FREIGHT) FREIGHT,
UPPER(O.SHIPCITY) SHIP_CITY,
UPPER(isnull(O.SHIPREGION,'NO SHIP REGION')) SHIP_REGION,
UPPER(O.SHIPCOUNTRY) SHIP_COUNTRY
FROM ORDERS O
INNER JOIN EMPLOYEES E
ON E.EMPLOYEEID = O.EMPLOYEEID
INNER JOIN CUSTOMERS C
ON C.CUSTOMERID = O.CUSTOMERID
INNER JOIN SHIPPERS S
ON S.SHIPPERID = O.SHIPVIA
ORDER BY ORDER_ID

DIM_CUSTOMERS:

SELECT
UPPER(C.CUSTOMERID) CUSTOMER_ID,
UPPER(C.COMPANYNAME) COMPANY_NAME,
UPPER(C.CONTACTNAME) CONTACT_NAME,
UPPER(C.CONTACTTITLE) CONTACT_TITLE,
UPPER(C.CITY) CITY,
UPPER(isnull(C.REGION,'NO REGION')) REGION,
UPPER(C.COUNTRY) COUNTRY,
isnull(
case when cc.grupo=1 then
'A'
when cc.grupo=2 then
'B'
when cc.grupo=3 then
'C'
when cc.grupo=4 then
'D'
end ,'E' ) CATEGORY,
isnull(IC.ENTRY,cast(getdate() as date)) ENTRY_DATE
FROM CUSTOMERS C
LEFT JOIN ( 
SELECT MIN(ORDERDATE) ENTRY, CUSTOMERID FROM ORDERS 
GROUP BY CUSTOMERID 
) IC
ON C.CUSTOMERID=IC.CUSTOMERID 
left join (
 select CUSTOMERID, sum(QUANTITY*UNITPRICE) SALES,
 NTILE(4) OVER(ORDER BY sum(QUANTITY*UNITPRICE) DESC) AS grupo 
 from ORDERS O
 inner join [Order Details] OD
 on O.ORDERID = OD.ORDERID
 where SHIPPEDDATE IS NOT NULL
 group by CUSTOMERID) CC
 on C.CUSTOMERID = CC.CUSTOMERID
ORDER BY CUSTOMER_ID

DIM_PRODUCTS:

SELECT
UPPER(P.PRODUCTID) PRODUCT_ID,
UPPER(P.PRODUCTNAME) PRODUCT_NAME,
UPPER(C.CATEGORYNAME) CATEGORY,
UPPER(S.COMPANYNAME) SUPPLIER,
UPPER(P.REORDERLEVEL) REORDER_LEVEL
FROM PRODUCTS P
INNER JOIN SUPPLIERS S
ON S.SUPPLIERID = P.SUPPLIERID
INNER JOIN CATEGORIES C
ON C.CATEGORYID = P.CATEGORYID
ORDER BY PRODUCT_ID

DIM_CATEGORIES:

SELECT
UPPER(CATEGORYID) CATEGORY_ID,
UPPER(CATEGORYNAME) CATEGORY_NAME,
UPPER(DESCRIPTION) DESCRIPTION
FROM CATEGORIES 
ORDER BY CATEGORY_ID

DIM_SUPPLIERS:

SELECT
UPPER(SUPPLIERID) SUPPLIER_ID,
UPPER(COMPANYNAME) COMPANY_NAME,
UPPER(CONTACTNAME) CONTACT_NAME,
UPPER(CONTACTTITLE) CONTACT_TITLE,
UPPER(CITY) CITY,
UPPER(isnull(REGION,'NO REGION')) REGION,
UPPER(COUNTRY) COUNTRY
FROM SUPPLIERS 
ORDER BY SUPPLIER_ID

FACT_SALES:

SELECT 
E.ID_EMPLOYEE,
O.ID_ORDER,
C.ID_CUSTOMER,
PR.ID_PRODUCT,
CA.ID_CATEGORY,
S.ID_SUPPLIER,
TI.ID_TIME,
OD.QUANTITY,
OD.UNITPRICE UNIT_PRICE,
OD.DISCOUNT,
O.ORDER_DATE
FROM ORDER_DETAILS OD
INNER JOIN DIM_ORDERS O
ON OD.ORDERID = O.ORDER_ID
INNER JOIN DIM_PRODUCTS PR
ON OD.PRODUCTID = PR.PRODUCT_ID
INNER JOIN DIM_TIME TI
ON TI.DATE = O.ORDER_DATE
INNER JOIN DIM_CUSTOMERS C
ON C.COMPANY_NAME = O.CUSTOMER
INNER JOIN DIM_EMPLOYEES E
ON E.EMPLOYEE_NAME = O.EMPLOYEE
INNER JOIN DIM_CATEGORIES CA
ON CA.CATEGORY_NAME = PR.CATEGORY
INNER JOIN DIM_SUPPLIERS S
ON S.COMPANY_NAME = PR.SUPPLIER