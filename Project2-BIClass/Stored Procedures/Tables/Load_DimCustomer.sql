SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Load DimCustomers table
--
-- @GroupMemberUserAuthorizationKey is the 
-- UserAuthorizationKey of the Group Member who completed 
-- this stored procedure.
--
-- =============================================

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     DROP COLUMN IF EXISTS [UserAuthorizationKey]

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     ADD [UserAuthorizationKey] INT NULL

DROP PROCEDURE IF EXISTS [Project2].[Load_DimCustomer]
GO

CREATE PROCEDURE [Project2].[Load_DimCustomer]
    @UserAuthorizationKey INT
AS
BEGIN 
    SET NOCOUNT ON
    DECLARE @WorkFlowStepTableRowCount INT

    INSERT INTO [CH01-01-Dimension].[DimCustomer] 
    (
        CustomerName, UserAuthorizationKey
    )
    SELECT 
        new.CustomerName,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT 
        old.CustomerName
        FROM FileUpload.OriginallyLoadedData as old
    ) as new

    -- get rowcount of modified dimcustomer talbe
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading Customer into the DimCustomer Table.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO

