SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [BUILD].[Get_Build_ProductSubCategory] @LocaleID int
	AS
BEGIN
/**********************************************************************************
Description:	Used to get the Product data
           
***********************************************************************************/


SELECT  p.ProductSubcategoryID,
        p.ProductCategoryID,
        p.Name,
        p.rowguid,
        p.ModifiedDate

FROM Build.ProductSubcategory p
INNER JOIN [BUILD].[Locale_ProductSubCategory] l ON p.ProductSubcategoryID = l.ProductSubcategoryID
WHERE l.localeid = @LocaleID
	

END
GO
