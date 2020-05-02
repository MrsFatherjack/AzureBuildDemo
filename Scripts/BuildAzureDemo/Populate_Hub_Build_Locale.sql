
USE HUB

SELECT * FROM build.locale

/*********************************************************************
Insert new locale information
**********************************************************************/

INSERT INTO build.Locale
(
    LocaleName,
    AzureRegion,
    username,
    subscriptionID,
    Tier,
    IsLive,
    TenantID
)
VALUES
(   'Australia East Live',   -- LocalName - varchar(100)
    'Australia East',   -- AzureRegion - varchar(100)
    'annetteallen69@gmail.com',   -- username - varchar(100)
    'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA',   -- Subscription - varchar(100)
    'Basic',   -- Tier - varchar(100)
	 1, -- IsLive - bit
    'AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA'  -- TenantID - uniqueidentifier
    )

DECLARE @LocaleID INT = (SELECT @@IDENTITY AS LocaleID)

SELECT @LocaleID AS LocaleID;

SELECT * FROM BUILD.Locale WHERE LocaleID = @LocaleID

/*********************************************************************
Set up linked data
**********************************************************************/

-- Set the currency conversion

INSERT INTO build.ProductPrice
(
    LocaleID,
    ListPrice,
	DateUpdated
)
VALUES( 
@LocaleID,
1.90, --AS ListPriceConversion, -- Convert £1 to 1.9 Aus $$
GETDATE()
);

-- Insert the necessary products
-- Australia are only selling bikes

-- Get the Products

INSERT INTO build.locale_product
(LocaleID, Productid)

SELECT DISTINCT @LocaleID, P.ProductID
FROM BUILD.Product p
INNER JOIN build.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN build.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
WHERE pc.Name = 'BIKES';


-- Get the ProductCategory
INSERT INTO build.locale_productCategory
(LocaleID, ProductCategoryID)

SELECT DISTINCT @LocaleID, Pc.ProductCategoryID
FROM BUILD.Product p
INNER JOIN build.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN build.ProductCategory pc ON pc.ProductCategoryID = sc.ProductCategoryID
WHERE pc.Name = 'BIKES';

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
WHERE pc.Name = 'BIKES'




/*Tidy up*/

/*

DECLARE @localeID INT = (SELECT TOP 1 localeid FROM build.locale WHERE LocaleName = 'Australia East Live')

DELETE FROM build.Locale_ProductSubCategory
WHERE LocaleID = @LocaleID

DELETE FROM BUILD.Locale_ProductCategory
WHERE LocaleID = @LocaleID

DELETE FROM build.Locale_Product
WHERE LocaleID = @LocaleID

DELETE FROM BUILD.Locale
WHERE LocaleID = @LocaleID

*/



