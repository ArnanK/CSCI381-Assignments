SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/16/2024
-- Description:	Provides the full descriptive name of the marital status character.
-- =============================================
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'CH01-01-Dimension'
    AND TABLE_NAME = 'DimMaritalStatus'
    AND COLUMN_NAME = 'UserAuthorizationKey'
)
BEGIN
    ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]
    ADD [UserAuthorizationKey] INT NULL;
END;

DROP PROCEDURE IF EXISTS [Project2].[Load_DimMaritalStatus];
GO
CREATE PROCEDURE [Project2].[Load_DimMaritalStatus]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimMaritalStatus] (
		MaritalStatus,
		MaritalStatusDescription,
		UserAuthorizationKey
    )
    SELECT DISTINCT OLD.MaritalStatus,
        CASE
            WHEN OLD.MaritalStatus = 'M' THEN 'Married'
            WHEN OLD.MaritalStatus = 'S' THEN 'Single'
        END AS MaritalStatusDescription,
        @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;

    EXEC Process.usp_TrackWorkFlow
		@WorkFlowStepDescription =  'Loading Data into the DimMaritalStatus Table',
		@GroupMemberUserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
