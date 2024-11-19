SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Dillon Chen/ Debugged by: Inderpreet Singh
-- Create date: 11/17/2024
-- Description:	Recreates DimOrderDate table if missing and updates procedure.
-- =============================================
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
