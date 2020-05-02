/* The table that holds all the information required to bu8ld the environemnt */

SELECT * FROM build.Locale

/* The data tables don't need to be identical as long as the SP that
   is used to populate the destination matches the destination  */

SELECT TOP 1 * FROM hub.build.Product
SELECT TOP 1 * FROM MySports.build.Product

/*  Could handle different languages with minor amendment  */

SELECT TOP 100 * FROM build.Locale_Product

/* Handling currency conversion  */
SELECT * FROM build.ProductPrice

/* Need to tell the powerpoint what we need to populate  */
SELECT * FROM build.TableList

/*
View build.get_Build_Product
*/
USE HUB
GO

ALTER PROC [BUILD].[Get_Build_Product] @LocaleID int
	AS
BEGIN
/**********************************************************************************
Description:	Used to get the Product data
           
***********************************************************************************/


SELECT p.ProductID,
       p.Name,
       p.ProductNumber,
       p.MakeFlag,
       p.FinishedGoodsFlag,
       p.Color,
       p.SafetyStockLevel,
       p.ReorderPoint,
       p.StandardCost,
       CASE WHEN pp.LocaleID IS NULL THEN p.ListPrice ELSE p.ListPrice * pp.ListPrice END AS ListPrice, -- Adjusted List Price to incorporate exchange range
       p.Size,
       p.SizeUnitMeasureCode,
       p.WeightUnitMeasureCode,
       p.Weight,
       p.DaysToManufacture,
       p.ProductLine,
       p.Class,
       p.Style,
       p.ProductSubcategoryID,
       p.ProductModelID,
       p.SellStartDate,
       p.SellEndDate,
       p.DiscontinuedDate,
       p.rowguid,
       p.ModifiedDate	 

FROM Build.Product p
INNER JOIN build.Locale_Product l ON p.productid = l.productid
LEFT OUTER JOIN build.ProductPrice pp ON pp.LocaleID = l.LocaleID
WHERE l.localeid = @LocaleID
	

END
GO




