
-- =============================================
-- Author: Luis Diaz
-- Create date: 11/16/2024
-- Description: 
/* 
Stores procedure logs workflow steps into the Process.WorkFlowSteps
 table by inserting a description, user authorization key, 
 and the number of rows affected during a specific workflow step.
*/
-- =============================================

CREATE OR ALTER PROCEDURE [Process].[usp_TrackWorkFlow]
    @UserAuthorizationKey INT,
    @WorkFlowStepTableRowCount INT,
    @WorkFlowStepDescription NVARCHAR(100)
AS
BEGIN
    INSERT INTO Process.WorkFlowSteps
        (WorkFlowStepDescription, UserAuthorizationKey, WorkFlowStepTableRowCount)
    VALUES(@WorkFlowStepDescription, @UserAuthorizationKey, @WorkFlowStepTableRowCount);
END
GO
