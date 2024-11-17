CREATE OR ALTER PROCEDURE [Process].[usp_TrackWorkFlow]
    @GroupMemberUserAuthorizationKey INT,
    @WorkFlowStepTableRowCount INT,
    @WorkFlowStepDescription NVARCHAR(100)
AS
BEGIN
    INSERT INTO Process.WorkFlowSteps
        (WorkFlowStepDescription, UserAuthorizationKey, WorkFlowStepTableRowCount)
    VALUES(@WorkFlowStepDescription, @GroupMemberUserAuthorizationKey, @WorkFlowStepTableRowCount);
END
GO
