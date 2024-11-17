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
