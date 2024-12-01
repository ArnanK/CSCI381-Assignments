USE [QueensClassSchedule]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.[create-schema]
AS
BEGIN
    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Project3')
        EXEC('DROP SCHEMA [Project3]')
    EXEC('CREATE SCHEMA [Project3]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'DbSecurity')
        EXEC('DROP SCHEMA [DbSecurity]')
    EXEC('CREATE SCHEMA [DbSecurity]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Process')
        EXEC('DROP SCHEMA [Process]')
    EXEC('CREATE SCHEMA [Process]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Udt')
        EXEC('DROP SCHEMA [Udt]')
    EXEC('CREATE SCHEMA [Udt]')
END
GO