-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Create Section Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[CreateSectionTable]
GO

CREATE PROCEDURE [Project3].[CreateSectionTable]
    @UserAuthorizationKey INT
AS 
BEGIN
    -- Drop the table if it already exists
    DROP TABLE IF EXISTS [Project3].[Section]
    
    -- Create the Section table
    CREATE TABLE [Project3].[Section]
    (
        SectionID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Section] DEFAULT (NEXT VALUE FOR [Project3].SectionID_Seq) PRIMARY KEY,
        SectionName [Udt].[P3NameString] NULL,
        UserAuthorizationKey INT NULL
    )

-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Section Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

