/*    Clean Up    */



/*Tidy up*/


Use HUB
go

DECLARE @localeID INT = (SELECT TOP 1 localeid FROM build.locale WHERE LocaleName = 'Australia East Live')

DELETE FROM build.Locale_ProductSubCategory
WHERE LocaleID = @LocaleID

DELETE FROM BUILD.Locale_ProductCategory
WHERE LocaleID = @LocaleID

DELETE FROM build.Locale_Product
WHERE LocaleID = @LocaleID

DELETE FROM BUILD.Locale
WHERE LocaleID = @LocaleID

DELETE FROM build.ProductPrice
WHERE LocaleID= @localeID

DBCC CHECKIDENT ('Build.Locale', RESEED, 4);
GO


/*  Tidy Up My Sports       */ 



Use MySports
go
alter table person.address
drop column country



