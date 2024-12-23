SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dillon Chen
-- Create date: 11/16/2024
-- Description:	Provides the full descriptive name of the gender character.
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_DimGender];
GO

CREATE PROCEDURE [Project2].[Load_DimGender]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimGender] (
        Gender,
        GenderDescription,
        UserAuthorizationKey
    )
    SELECT DISTINCT OLD.Gender,
        CASE
            WHEN OLD.Gender = 'M' THEN 'Male'
            WHEN OLD.Gender = 'F' THEN 'Female'
        END AS GenderDescription,
        @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading Gender data into Gender Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
