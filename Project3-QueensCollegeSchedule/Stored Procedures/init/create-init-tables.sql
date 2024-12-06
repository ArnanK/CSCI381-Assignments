SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	
--
-- Creates All the requried Tables and associated Schemas.
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[create-init-tables]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Process')
    BEGIN
        EXEC('CREATE SCHEMA [Process]');
    END
    
    DROP TABLE IF EXISTS [Process].[WorkflowSteps];
    
    CREATE TABLE [Process].[WorkflowSteps](
        WorkFlowStepKey [Udt].[P3Key] NOT NULL CONSTRAINT [DF_WorkflowSteps_Key] DEFAULT (NEXT VALUE FOR [Project3].[WorkflowStepsID_Seq]) PRIMARY KEY, -- primary key
        WorkFlowStepDescription NVARCHAR (100) NOT NULL,
        WorkFlowStepTableRowCount INT NULL DEFAULT (0),
        StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
        EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
        ClassTime VARCHAR (5) NULL DEFAULT '10:45',
        UserAuthorizationKey INT NOT NULL 
    );
    DROP SCHEMA IF EXISTS [DbSecurity];
    
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'DbSecurity')
    BEGIN
        EXEC('CREATE SCHEMA [DbSecurity]');
    END
   
    DROP TABLE IF EXISTS [DbSecurity].[UserAuthorization]

    CREATE TABLE [DbSecurity].[UserAuthorization](
        UserAuthorizationKey [Udt].[P3Key] NOT NULL CONSTRAINT [DF_UserAuthorization_Key] DEFAULT (NEXT VALUE FOR [Project3].[UserAuthorizationKey_Seq]) PRIMARY KEY, -- primary key
        ClassTime nvarchar (5) Null Default'10:45',
        [Individual Project] nvarchar (60) null default 'PROJECT 3 QueensCollegeSchedule',
        GroupMemberLastName nvarchar (35) NOT NULL,
        GroupMemberFirstName nvarchar (25) NOT NULL,
        GroupName nvarchar (20) NOT NULL default 'Group 1',
        DateAdded datetime2 null default(SYSDATETIME())
    )
   
  
END;


GO
