SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Inderpreet Singh
-- Create date: 11/17/2024
-- Description: Loads data into the SalesManagers table.
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_SalesManagers]
GO
CREATE PROCEDURE [Project2].[Load_SalesManagers]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    INSERT INTO [CH01-01-Dimension].[SalesManagers] (
        Category,
        SalesManager,
        Office,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        ProductCategory, -- Adjust this according to the data
        SalesManager,
        CASE
            WHEN SalesManager LIKE N'Maurizio%' OR SalesManager LIKE N'Marco%' THEN 'Redmond'
            WHEN SalesManager LIKE N'Alberto%' OR SalesManager LIKE N'Luis%' THEN 'Seattle'
            ELSE 'Seattle'
        END AS Office,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT ProductCategory, SalesManager
        FROM [FileUpload].OriginallyLoadedData
    ) AS S;

    SET @WorkFlowStepTableRowCount = @@ROWCOUNT; -- Assigning a value to the variable

    EXEC [Process].[usp_TrackWorkFlow] 
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepDescription = 'Loading data into the SalesManager Table',
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Calling the stored procedure

END
GO
