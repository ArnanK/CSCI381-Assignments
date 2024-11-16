USE BICLASS

DROP SCHEMA IF EXISTS [Process];
GO
CREATE SCHEMA [Process];
GO
DROP TABLE IF EXISTS [Process].[WorkflowSteps];
GO
CREATE TABLE [Process].[WorkflowSteps](
    WorkFlowStepKey INT NOT NULL, -- primary key
    WorkFlowStepDescription NVARCHAR (100) NOT NULL,
    WorkFlowStepTableRowCount INT NULL DEFAULT (0),
    StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
    EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
    ClassTime VARCHAR (5) NULL DEFAULT '10:45',
    UserAuthorizationKey INT NOT NULL 
);
DROP SCHEMA IF EXISTS [DbSecurity];
GO
CREATE SCHEMA [DbSecurity];
GO
DROP TABLE IF EXISTS [DbSecurity].[UserAuthorization]
CREATE TABLE [DbSecurity].[UserAuthorization](
    UserAuthorizationKey INT NOT NULL, -- primary key
    ClassTime nvarchar (5) Null Default'10:45',
    [Individual Project] nvarchar (60) null default 'PROJECT 2 RECREATE THE BICLASS DATABASE STAR SCHEMA',
    GroupMemberLastName nvarchar (35) NOT NULL,
    GroupMemberFirstName nvarchar (25) NOT NULL,
    GroupName nvarchar (20) NOT NULL,
    DateAdded datetime2 null default(SYSDATETIME())
)
GO
DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductCategory]
CREATE TABLE [CH01-01-Dimension].[DimProductCategory](
    [ProductCategoryKey] [int] NOT NULL CONSTRAINT [DF_DimProductCategory_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[DimProductCategorySequenceObject]),
    [ProductCategory] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2] NULL CONSTRAINT [DF_DimProductCategory_DateAdded] DEFAULT (sysdatetime()),
    [DateofLastUpdate] [datetime2] NULL CONSTRAINT [DF_DimProductCategory_DateofLastUpdate] DEFAULT (sysdatetime())
)
GO
DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductSubCategory]
CREATE TABLE [CH01-01-Dimension].[DimProductSubCategory](
    [ProductSubcategoryKey] [int] NOT NULL CONSTRAINT [DF_DimProductSubcategory_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[DimProductSubcategorySequenceObject]),
    [ProductCategoryKey] [int] NOT NULL,
    [ProductSubcategory] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2] NULL CONSTRAINT [DFT_DimProductSubcategory_DateAdded] DEFAULT (sysdatetime()),
    [DateofLastUpdate] [datetime2] NULL CONSTRAINT [DFT_DimProductSubcategory_DateofLastUpdate] DEFAULT (sysdatetime())
)
