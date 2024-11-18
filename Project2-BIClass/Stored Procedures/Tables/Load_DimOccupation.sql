SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Dillon Chen/Debugged by: Inderpreet Singh
-- Create date: 11/16/2024
-- Description:	Recreates the DimOccupation table with a Sequence Object as a key.
-- =============================================

-- Create DimOccupation table if it doesn't exist
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = 'CH01-01-Dimension' 
      AND TABLE_NAME = 'DimOccupation'
)
BEGIN
    CREATE TABLE [CH01-01-Dimension].[DimOccupation] (
        Occupation NVARCHAR(100) NOT NULL,
        UserAuthorizationKey INT NULL
    );
END;

-- Add the UserAuthorizationKey column if it doesn't exist
IF NOT EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'CH01-01-Dimension'
	    AND TABLE_NAME = 'DimOccupation'
	    AND COLUMN_NAME = 'UserAuthorizationKey'
)
BEGIN
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD [UserAuthorizationKey] INT NULL;
END;

-- Drop and recreate the procedure
DROP PROCEDURE IF EXISTS [Project2].[Load_DimOccupation];
GO
CREATE PROCEDURE [Project2].[Load_DimOccupation]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT;

    -- Insert data into DimOccupation table
    INSERT INTO [CH01-01-Dimension].[DimOccupation] (
        Occupation,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        O.Occupation,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT Occupation
        FROM [FileUpload].[OriginallyLoadedData]
    ) AS O;

    -- Get the row count of inserted rows
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    -- Track the workflow step
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading data into the DimOccupation Table', 
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO
