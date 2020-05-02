CREATE TABLE [HumanResources].[JobCandidate]
(
[JobCandidateID] [int] NOT NULL,
[BusinessEntityID] [int] NULL,
[Resume] [xml] NULL,
[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
