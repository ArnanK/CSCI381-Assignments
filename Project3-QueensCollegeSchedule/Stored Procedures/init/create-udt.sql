USE [QueensClassSchedule]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.[create-udt]
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Key' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Key] FROM [int] NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Day' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Day] FROM VARCHAR(10) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Time' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Time] FROM VARCHAR(20) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3NameString' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3NameString] FROM VARCHAR(MAX) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Bool' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Bool] FROM CHAR(2) NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3DateTime' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3DateTime] FROM datetime2(7) NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Int' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Int] FROM int NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3HourCredit' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3HourCredit] FROM DECIMAL(5,2) NULL');


END
GO