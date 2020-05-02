CREATE TABLE [BUILD].[Locale]
(
[LocaleID] [int] NOT NULL IDENTITY(1, 1),
[LocaleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AzureRegion] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[username] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subscriptionID] [uniqueidentifier] NULL,
[Tier] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsLive] [bit] NULL,
[TenantID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [BUILD].[Locale] ADD CONSTRAINT [PK_Environment] PRIMARY KEY CLUSTERED  ([LocaleID]) ON [PRIMARY]
GO
