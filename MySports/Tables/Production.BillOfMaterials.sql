CREATE TABLE [Production].[BillOfMaterials]
(
[BillOfMaterialsID] [int] NOT NULL,
[ProductAssemblyID] [int] NULL,
[ComponentID] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[UnitMeasureCode] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BOMLevel] [smallint] NOT NULL,
[PerAssemblyQty] [decimal] (8, 2) NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
