-- =============================================
-- Author: Inderpreet Singh
-- Create date: 11/16/2024
-- Description: 
-- Retrieves and displays the workflow steps from the [Process].[WorkflowSteps] table,
-- ordered by the starting date and time.
-- =============================================

DROP PROCEDURE IF EXISTS [Process].[usp_ShowWorkflowSteps];
GO

CREATE PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
    SET NOCOUNT ON;

    -- Retrieve workflow steps
    SELECT 
        WorkFlowStepKey AS StepID,
        WorkFlowStepDescription AS Description,
        WorkFlowStepTableRowCount AS [RowCount], -- Use square brackets to escape the keyword
        StartingDateTime AS StartTime,
        EndingDateTime AS EndTime,
        UserAuthorizationKey AS UserKey
    FROM [Process].[WorkflowSteps]
    ORDER BY StartingDateTime DESC;

    PRINT 'Workflow steps displayed successfully.';
END;
GO
