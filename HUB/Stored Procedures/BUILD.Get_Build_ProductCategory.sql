SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROC [BUILD].[Get_Build_ProductCategory] @LocaleID int
	AS
BEGIN
/**********************************************************************************
Description:	Used to get the Product data
           
***********************************************************************************/


SELECT  p.ProductCategoryID,
        p.Name,
        p.rowguid,
        p.ModifiedDate

FROM Build.ProductCategory p
INNER JOIN build.Locale_Productcategory l ON p.ProductCategoryID = l.productcategoryid
WHERE l.localeid = @LocaleID
	

END
GO
