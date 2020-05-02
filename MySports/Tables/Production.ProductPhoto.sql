CREATE TABLE [Production].[ProductPhoto]
(
[ProductPhotoID] [int] NOT NULL,
[ThumbNailPhoto] [varbinary] (max) NULL,
[ThumbnailPhotoFileName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LargePhoto] [varbinary] (max) NULL,
[LargePhotoFileName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
