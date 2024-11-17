SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimTerritory table.
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[Load_DimTerritory]
GO
CREATE PROCEDURE [Project2].[Load_DimTerritory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    INSERT INTO [CH01-01-Dimension].[DimTerritory] (
        TerritoryGroup,
        TerritoryCountry,
        TerritoryRegion,
        UserAuthorizationKey
    )
    SELECT
        NEXT VALUE FOR [Project2].[DimTerritorySequenceKeys],
        TerritoryGroup,
        TerritoryCountry,
        TerritoryRegion,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT 
            TerritoryGroup, 
            TerritoryCountry, 
            TerritoryRegion
        FROM [FileUpload].OriginallyLoadedData
    ) AS T;

    -- Assigning a value to the variable
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC Process.usp_TrackWorkFlow 
        @WorkFlowStepDescription = 'Loading data into the DimTerritory Table',
        @GroupMemberUserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO