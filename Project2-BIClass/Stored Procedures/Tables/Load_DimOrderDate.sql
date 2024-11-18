SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/17/2024
-- Description:	Recreates DimOrderDate table.
-- =============================================
IF NOT EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'DimOrderDate'
	 AND COLUMN_NAME = 'UserAuthorizationKey'
)
ALTER TABLE [CH01-01-Dimension].[DimOrderDate]
ADD [UserAuthorizationKey] INT NULL;

DROP PROCEDURE IF EXISTS [Project2].[Load_DimOrderDate];
GO
CREATE PROCEDURE [Project2].[Load_DimOrderDate]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
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

    EXEC Process.usp_TrackWorkFlow 
        @WorkFlowStepDescription = 'Loading OrderDate data into DimOrderDate table', 
        @GroupMemberUserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO

