-- =============================================
-- Debugged: Inderpreet Singh
-- Create date: 11/16/2024
-- Description: 
/* 
stored procedure creates a sequence named Process.WorkFlowStepTableRowCountBy1 
that generates integers starting at 1 and increments by 1, likely for tracking 
or numbering workflow steps in a systematic order.
*/
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



