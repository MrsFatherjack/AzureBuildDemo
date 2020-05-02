CREATE TABLE [Production].[ProductReview]
(
[ProductReviewID] [int] NOT NULL,
[ProductID] [int] NOT NULL,
[ReviewerName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReviewDate] [datetime] NOT NULL,
[EmailAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Rating] [int] NOT NULL,
[Comments] [nvarchar] (3850) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
