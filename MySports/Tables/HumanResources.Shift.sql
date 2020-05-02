CREATE TABLE [HumanResources].[Shift]
(
[ShiftID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTime] [time] NOT NULL,
[EndTime] [time] NOT NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
