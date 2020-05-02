CREATE TABLE [Production].[Location]
(
[LocationID] [smallint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CostRate] [smallmoney] NOT NULL,
[Availability] [decimal] (8, 2) NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
