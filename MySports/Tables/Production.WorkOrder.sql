CREATE TABLE [Production].[WorkOrder]
(
[WorkOrderID] [int] NOT NULL,
[ProductID] [int] NOT NULL,
[OrderQty] [int] NOT NULL,
[StockedQty] [int] NOT NULL,
[ScrappedQty] [smallint] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[DueDate] [datetime] NOT NULL,
[ScrapReasonID] [smallint] NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
