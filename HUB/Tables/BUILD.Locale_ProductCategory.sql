CREATE TABLE [BUILD].[Locale_ProductCategory]
(
[LocaleID] [int] NULL,
[ProductCategoryID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [BUILD].[Locale_ProductCategory] ADD CONSTRAINT [Locale_ProductCategory_Locale] FOREIGN KEY ([LocaleID]) REFERENCES [BUILD].[Locale] ([LocaleID])
GO
ALTER TABLE [BUILD].[Locale_ProductCategory] ADD CONSTRAINT [Locale_ProductCategory_ProductCategory] FOREIGN KEY ([ProductCategoryID]) REFERENCES [BUILD].[ProductCategory] ([ProductCategoryID])
GO
