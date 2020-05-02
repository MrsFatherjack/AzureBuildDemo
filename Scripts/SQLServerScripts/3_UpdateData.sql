
/*********************************************************************
Set up linked data

Now add components
**********************************************************************/

DECLARE @LocaleID INT = 5
DECLARE @ProductCategory VARCHAR(100) = 'COMPONENTS'


-- Insert the necessary products
-- Austrlia are now selling bikes and their components

-- Get the Products

INSERT INTO build.locale_product
(LocaleID, Productid)

SELECT DISTINCT @LocaleID, P.ProductID
FROM BUILD.Product p
INNER JOIN build.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN build.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
WHERE pc.Name = @ProductCategory;


-- Get the ProductCategory
INSERT INTO build.locale_productCategory
(LocaleID, ProductCategoryID)

SELECT DISTINCT @LocaleID, Pc.ProductCategoryID
FROM BUILD.Product p
INNER JOIN build.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN build.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
WHERE pc.Name = @ProductCategory;

-- Get the Product Sub Categories
INSERT INTO build.Locale_ProductSubCategory
(
    LocaleID,
    ProductSubCategoryID
)

SELECT DISTINCT @LocaleID, sc.ProductSubcategoryID
FROM BUILD.Product p
INNER JOIN build.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN build.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
WHERE pc.Name = @ProductCategory

/* Get new row counts */

SELECT COUNT(*) FROM BUILD.Locale_Product WHERE LocaleID = @LocaleID
SELECT COUNT(*) FROM BUILD.Locale_ProductCategory WHERE LocaleID = @LocaleID
SELECT COUNT(*) FROM BUILD.Locale_ProductSubCategory WHERE LocaleID = @LocaleID

