CREATE TABLE [Production].[ProductDescription]
(
[ProductDescriptionID] [int] NOT NULL,
[Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
