SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [BUILD].[Get_Build_Product] @LocaleID int
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
