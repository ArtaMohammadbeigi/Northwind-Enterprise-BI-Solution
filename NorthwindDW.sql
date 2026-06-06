use NorthwindDW
go
--------------------------------------------
select ROW_NUMBER() over (order by (select null)) as GeographyKey ,* from 
(select 
Country,
Region,
City,
PostalCode,
Address
from Northwind..Customers
union 
select 
Country,
Region,
City,
PostalCode,
Address
from Northwind..Employees
union
select 
Country,
Region,
City,
PostalCode,
Address
from Northwind..Suppliers
union
select 
shipCountry,
shipRegion,
shipCity,
shipPostalCode,
shipAddress
from Northwind..Orders)as X
--------------------------------------------

CREATE TABLE [dbo].[DimShippers](
	[ShipperKey] [int] IDENTITY(1,1) primary key, --Surrogate Key
	[ShipperAlternateKey] [int], --Business Key
	[CompanyName] [nvarchar](40) NULL,
	[Phone] [nvarchar](24) NULL
) 
--------------------------------------------

CREATE TABLE [dbo].[DimGeography](
	[GeographyKey] int identity (1, 1) Primary Key,
	[Country] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[City] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Address] [nvarchar](60) NULL
) 
--------------------------------------------
CREATE TABLE [dbo].[DimCustomers](
	[CustomerKey] int identity (1,1) primary key, --SK
	[CustomerAlternateKey] [nchar](5) NOT NULL, --PK
	[GeographyKey] int null,
	[CompanyName] [nvarchar](40) NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	--[Address] [nvarchar](60) NULL,
	--[City] [nvarchar](15) NULL,
	--[Region] [nvarchar](15) NULL,
	--[PostalCode] [nvarchar](10) NULL,
	--[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[Startdate] datetime default getdate(),
	[Enddate] datetime null
)
--------------------------------------------
CREATE TABLE [dbo].[DimSuppliers](
	[SupplierKey] int Identity (1, 1) primary key,
	[SupplierAlternateKey] [int] NOT NULL,
	[GeographyKey] int not null,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	--[Address] [nvarchar](60) NULL,
	--[City] [nvarchar](15) NULL,
	--[Region] [nvarchar](15) NULL,
	--[PostalCode] [nvarchar](10) NULL,
	--[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[HomePage] [nvarchar](max) NULL,
	[Startdate] datetime default getdate(),
	[Enddate] datetime null
 ) 
--------------------------------------------

CREATE TABLE [dbo].[DimProducts](
	[ProductKey] int identity(1,1) primary key,
	[ProductAlternateKey] [int] not NULL,
	[SupplierKey] [int] NULL,
	[ProductName] [nvarchar](40) NULL,
	[CategoryName] [nvarchar](15) NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[Discontinued] [bit] NULL,
	[Startdate] datetime default getdate(),
	[Enddate] datetime null
)
------------------------------------------------

CREATE TABLE [dbo].[DimEmployees](
	[EmployeeKey] int identity(1, 1) Primary Key,
	[EmployeeAlternateKey] [int],
	[ReportsToKey] int null,
	[GeographyKey] int null,
	[LastName] [nvarchar](20) NULL,
	[FirstName] [nvarchar](10) NULL,
	[Title] [nvarchar](30) NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	--[Address] [nvarchar](60) NULL,
	--[City] [nvarchar](15) NULL,
	--[Region] [nvarchar](15) NULL,
	--[PostalCode] [nvarchar](10) NULL,
	--[Country] [nvarchar](15) NULL,
	[HomePhone] [nvarchar](24) NULL,
	[Extension] [nvarchar](4) NULL,
	[Photo] [varbinary](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL,
	[Startdate] datetime default getdate(),
	[Enddate] datetime null
)
--------------------------------------------------
UPDATE [dbo].[DimEmployees]
   SET [ReportsToKey] = ?
 WHERE EmployeeKey = ?

--------------------------------------------------
CREATE TABLE [dbo].[DimDate] (
    DateKey            INT         NOT NULL PRIMARY KEY,   -- YYYYMMDD
    FullDate           DATE        NOT NULL,

    YearNumber         SMALLINT    NOT NULL,
    QuarterNumber      TINYINT     NOT NULL,
    MonthNumber        TINYINT     NOT NULL,
    MonthName          VARCHAR(20) NOT NULL,

    DayNumberOfMonth   TINYINT     NOT NULL,
    DayOfWeekNumber    TINYINT     NOT NULL,  -- Sunday=1 ... Saturday=7
    DayName            VARCHAR(20) NOT NULL,

    WeekOfYear         TINYINT     NOT NULL
);

CREATE UNIQUE INDEX UX_DimDate_FullDate ON [dbo].[DimDate](FullDate);

----------------------------------------------------

SET DATEFIRST 7; -- Sunday=1 ... Saturday=7

DECLARE @StartDate date = '1996-01-01';
DECLARE @EndDate   date = '1998-12-31';

;WITH d AS (
    SELECT @StartDate AS dt
    UNION ALL
    SELECT DATEADD(day, 1, dt)
    FROM d
    WHERE dt < @EndDate
)
INSERT INTO [dbo].[DimDate] (
    DateKey, FullDate,
    YearNumber, QuarterNumber, MonthNumber, MonthName,
    DayNumberOfMonth, DayOfWeekNumber, DayName,
    WeekOfYear
)
SELECT
    CONVERT(int, CONVERT(char(8), dt, 112)) AS DateKey,
    dt AS FullDate,

    DATEPART(year, dt) AS YearNumber,
    DATEPART(quarter, dt) AS QuarterNumber,
    DATEPART(month, dt) AS MonthNumber,
    DATENAME(month, dt) AS MonthName,

    DATEPART(day, dt) AS DayNumberOfMonth,
    DATEPART(weekday, dt) AS DayOfWeekNumber,   -- respects DATEFIRST
    DATENAME(weekday, dt) AS DayName,

    DATEPART(week, dt) AS WeekOfYear
FROM d
OPTION (MAXRECURSION 0);
----------------------------------------------
use Northwind
Go
select name, is_cdc_enabled from sys.databases
execute sys.sp_cdc_disable_db

select name, is_cdc_enabled from sys.databases
execute sys.sp_cdc_enable_db

select name, is_tracked_by_cdc from sys.tables
execute sys.sp_cdc_disable_table @source_schema = 'dbo',
								@source_name = 'Orders',
								@capture_instance = 'dbo_Orders'
					

execute sys.sp_cdc_disable_table @source_schema = 'dbo',
								@source_name = 'Order Details',
								@capture_instance = 'dbo_Order Details'
								

select name, is_tracked_by_cdc from sys.tables
execute sys.sp_cdc_enable_table @source_schema = 'dbo',
								@source_name = 'Orders',
								@capture_instance = null,
								@role_name = 'cdc'

execute sys.sp_cdc_enable_table @source_schema = 'dbo',
								@source_name = 'Order Details',
								@capture_instance = null,
								@role_name = 'cdc'


--------------------------------------------------------
use Northwind
go

select top 5 TerritoryId, COUNT(RegionID) as CNT_Region from Territories 
group by TerritoryId
-------------------------------------------------------------
use NorthwindDW
go

CREATE TABLE [dbo].[DimTerritory](
	[TerritoryKey] [int] Identity(1,1) Primary Key,
	[TerritoryAlternateKey] [nvarchar](20) NOT NULL,
	[TerritoryDescription] [nvarchar](50) NULL,
	[RegionDescription] [nvarchar] (50) NULL,
	[Startdate] datetime default getdate(),
	[Enddate] datetime null
)

--------------------------------------------------------------

CREATE TABLE [dbo].[FactEmployeeTerritory](
	[EmployeeKey] int,
	[TerritoryKey] int
) 

--------------------------------------------------------

CREATE TABLE [dbo].[FactOrders](
	[OrderID] [int] ,
	[ProductKey] [int],
	[CustomerKey] int NULL,
	[EmployeeKey] [int] NULL,
	[GeographyKey] int NULL,
	[OrderDateKey] int NULL,
	[RequiredDateKey] int NULL,
	[ShippedDateKey] int Null,
	[ShipperKey] [int] NULL,
	[ShipName] [nvarchar](40) NULL,
	--[ShipAddress] [nvarchar](60) NULL,
	--[ShipCity] [nvarchar](15) NULL,
	--[ShipRegion] [nvarchar](15) NULL,
	--[ShipPostalCode] [nvarchar](10) NULL,
	--[ShipCountry] [nvarchar](15) NULL,
	[UnitPrice] [money] NULL,
	[Quantity] [smallint] NULL,
	[Discount] [real] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
) 

-------------------------------------------------------

UPDATE [dbo].[FactOrders]
   SET [CustomerKey] = ?
      ,[EmployeeKey] = ?
      ,[GeographyKey] = ?
      ,[OrderDateKey] = ?
      ,[RequiredDateKey] = ?
      ,[ShippedDateKey] = ?
      ,[ShipperKey] = ?
      ,[ShipName] = ?
      ,[OrderDate] = ?
      ,[RequiredDate] = ?
      ,[ShippedDate] = ?
 WHERE [OrderID] = ?


 ---------------------------------------

 UPDATE [dbo].[FactOrders]
   SET [UnitPrice] = ?
      ,[Quantity] = ?
      ,[Discount] = ?
 WHERE [OrderID] = ? and [ProductKey] = ?

 ---------------------------------------
 
DELETE FROM [dbo].[FactOrders]
      WHERE OrderID = ?

 ---------------------------------------

DELETE FROM [dbo].[FactOrders]
      WHERE OrderID = ? and ProductKey = ?