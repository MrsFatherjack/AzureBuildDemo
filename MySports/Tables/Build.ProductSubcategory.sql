CREATE TABLE [Build].[ProductSubcategory]
(
[ProductSubcategoryID] [int] NOT NULL,
[ProductCategoryID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
