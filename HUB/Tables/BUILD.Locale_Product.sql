CREATE TABLE [BUILD].[Locale_Product]
(
[LocaleID] [int] NULL,
[ProductID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [BUILD].[Locale_Product] ADD CONSTRAINT [Locale_Product_Locale] FOREIGN KEY ([LocaleID]) REFERENCES [BUILD].[Locale] ([LocaleID])
GO
ALTER TABLE [BUILD].[Locale_Product] ADD CONSTRAINT [Locale_Product_Product] FOREIGN KEY ([ProductID]) REFERENCES [BUILD].[Product] ([ProductID])
GO
