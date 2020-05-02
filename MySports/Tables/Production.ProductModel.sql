CREATE TABLE [Production].[ProductModel]
(
[ProductModelID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CatalogDescription] [xml] NULL,
[Instructions] [xml] NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
