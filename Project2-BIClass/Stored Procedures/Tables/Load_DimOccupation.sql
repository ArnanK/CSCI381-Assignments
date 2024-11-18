SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/16/2024
-- Description:	Recreates the DimOccupation table with a Sequence Object as a key.
-- =============================================
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

DROP PROCEDURE IF EXISTS [Project2].[Load_DimOccupation];
GO
CREATE PROCEDURE [Project2].[Load_DimOccupation]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimOccupation] (
	    Occupation,
	    UserAuthorizationKey
    )
    SELECT
        O.Occupation,
        @UserAuthorizationKey
    FROM (
	SELECT DISTINCT Occupation
        FROM FileUpload.OriginallyLoadedData
    ) AS O;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading data into the DimOccupation Table', 
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
