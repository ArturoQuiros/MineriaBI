-- Categories

CREATE TABLE Categories(
	CategoryID INT,
	CategoryName VARCHAR(15),
	Description VARCHAR(MAX),
	Picture VARCHAR(MAX)
	)

-- Customers

CREATE TABLE Customers(
	CustomerID VARCHAR(5),
	CompanyName VARCHAR(40),
	ContactName VARCHAR(30),
	ContactTitle VARCHAR(30),
	Address VARCHAR(60),
	City VARCHAR(15),
	Region VARCHAR(15),
	PostalCode VARCHAR(10),
	Country VARCHAR(15),
	Phone VARCHAR(24),
	Fax VARCHAR(24)
	)

-- Employees

CREATE TABLE Employees(
	EmployeeID INT,
	LastName VARCHAR(20),
	FirstName VARCHAR(10),
	Title VARCHAR(30),
	TitleOfCourtesy VARCHAR(25),
	BirthDate DATETIME ,
	HireDate DATETIME ,
	Address VARCHAR(60),
	City VARCHAR(15),
	Region VARCHAR(15),
	PostalCode VARCHAR(10),
	Country VARCHAR(15),
	HomePhone VARCHAR(24),
	Extension VARCHAR(4),
	Photo VARCHAR(MAX),
	Notes VARCHAR(MAX),
	ReportsTo INT,
	PhotoPath VARCHAR(255)
	)

-- EmployeeTerritories

CREATE TABLE EmployeeTerritories(
	EmployeeID INT,
	TerritoryID VARCHAR(20)
	)

-- OrderDetails

CREATE TABLE OrderDetails(
	OrderID INT,
	ProductID INT,
	UnitPrice DECIMAL(25,2),
	Quantity INT,
	Discount DECIMAL(25,2)
	)

-- Orders

CREATE TABLE Orders(
	OrderID INT,
	CustomerID VARCHAR(5),
	EmployeeID INT,
	OrderDate DATETIME ,
	RequiredDate DATETIME ,
	ShippedDate DATETIME ,
	ShipVia INT,
	Freight DECIMAL(25,2),
	ShipName VARCHAR(40),
	ShipAddress VARCHAR(60),
	ShipCity VARCHAR(15),
	ShipRegion VARCHAR(15),
	ShipPostalCode VARCHAR(10),
	ShipCountry VARCHAR(15)
	)

-- Products

CREATE TABLE Products(
	ProductID INT,
	ProductName VARCHAR(40),
	SupplierID INT,
	CategoryID INT,
	QuantityPerUnit VARCHAR(20),
	UnitPrice DECIMAL(25,2),
	UnitsInStock INT,
	UnitsOnOrder INT,
	ReorderLevel INT,
	Discontinued INT
	)

-- Region

CREATE TABLE Region(
	RegionID INT,
	RegionDescription VARCHAR(50)
	)

-- Shippers

CREATE TABLE Shippers(
	ShipperID INT,
	CompanyName VARCHAR(40),
	Phone VARCHAR(24)
	)

-- Suppliers

CREATE TABLE Suppliers(
	SupplierID INT,
	CompanyName VARCHAR(40),
	ContactName VARCHAR(30),
	ContactTitle VARCHAR(30),
	Address VARCHAR(60),
	City VARCHAR(15),
	Region VARCHAR(15),
	PostalCode VARCHAR(10),
	Country VARCHAR(15),
	Phone VARCHAR(24),
	Fax VARCHAR(24),
	HomePage VARCHAR(MAX)
	)

-- Territories

CREATE TABLE Territories(
	TerritoryID VARCHAR(20),
	TerritoryDescription VARCHAR(50),
	RegionID INT
	)