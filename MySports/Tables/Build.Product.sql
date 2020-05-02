CREATE TABLE [Build].[Product]
(
[ProductID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProductNumber] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MakeFlag] [bit] NOT NULL,
[FinishedGoodsFlag] [bit] NOT NULL,
[Color] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SafetyStockLevel] [smallint] NOT NULL,
[ReorderPoint] [smallint] NOT NULL,
[StandardCost] [money] NOT NULL,
[ListPrice] [money] NOT NULL,
[Size] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SizeUnitMeasureCode] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeightUnitMeasureCode] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weight] [decimal] (8, 2) NULL,
[DaysToManufacture] [int] NOT NULL,
[ProductLine] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Class] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Style] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductSubcategoryID] [int] NULL,
[ProductModelID] [int] NULL,
[SellStartDate] [datetime] NOT NULL,
[SellEndDate] [datetime] NULL,
[DiscontinuedDate] [datetime] NULL,
[rowguid] [uniqueidentifier] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
