SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/16/2024
-- Description:	Provides the full descriptive name of the marital status character.
-- =============================================
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
    SELECT DISTINCT 
	OLD.MaritalStatus,
	CASE
            WHEN OLD.MaritalStatus = 'M' THEN 'Married'
            WHEN OLD.MaritalStatus = 'S' THEN 'Single'
        END AS MaritalStatusDescription,
        @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowStepDescription =  'Loading Data into the DimMaritalStatus Table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @@ROWCOUNT;

END
GO
