SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Dillon Chen/ Debugged by: Inderpreet Singh
-- Create date: 11/17/2024
-- Description:	Recreates DimOrderDate table if missing and updates procedure.
-- =============================================

-- Create DimOrderDate table if it doesn't exist
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = 'CH01-01-Dimension' 
      AND TABLE_NAME = 'DimOrderDate'
)
BEGIN
    CREATE TABLE [CH01-01-Dimension].[DimOrderDate] (
        OrderDate DATE NOT NULL,
        MonthName NVARCHAR(50) NULL,
        MonthNumber INT NULL,
        [Year] INT NULL,
        UserAuthorizationKey INT NULL
    );
END;

-- Add the UserAuthorizationKey column if it doesn't exist
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'CH01-01-Dimension'
      AND TABLE_NAME = 'DimOrderDate'
      AND COLUMN_NAME = 'UserAuthorizationKey'
)
BEGIN
    ALTER TABLE [CH01-01-Dimension].[DimOrderDate]
    ADD [UserAuthorizationKey] INT NULL;
END;

-- Drop and recreate the procedure
DROP PROCEDURE IF EXISTS [Project2].[Load_DimOrderDate];
GO
CREATE PROCEDURE [Project2].[Load_DimOrderDate]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT;

    -- Insert data into DimOrderDate table
    INSERT INTO [CH01-01-Dimension].[DimOrderDate] (
        OrderDate,
        MonthName,
        MonthNumber,
        [Year],
        UserAuthorizationKey
    )
    SELECT DISTINCT
        OrderDate,
        MonthName,
        MonthNumber,
        [Year],
        @UserAuthorizationKey
    FROM [FileUpload].OriginallyLoadedData;

    -- Get the row count of inserted rows
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    -- Track the workflow step
    EXEC Process.usp_TrackWorkFlow 
        @WorkFlowStepDescription = 'Loading OrderDate data into DimOrderDate table', 
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO
