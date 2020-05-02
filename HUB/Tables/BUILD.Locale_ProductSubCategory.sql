CREATE TABLE [BUILD].[Locale_ProductSubCategory]
(
[LocaleID] [int] NULL,
[ProductSubCategoryID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [BUILD].[Locale_ProductSubCategory] ADD CONSTRAINT [Locale_ProductSubCategory_Locale] FOREIGN KEY ([LocaleID]) REFERENCES [BUILD].[Locale] ([LocaleID])
GO
ALTER TABLE [BUILD].[Locale_ProductSubCategory] ADD CONSTRAINT [Locale_ProductSubCategory_PSCID] FOREIGN KEY ([ProductSubCategoryID]) REFERENCES [BUILD].[ProductSubcategory] ([ProductSubcategoryID])
GO
