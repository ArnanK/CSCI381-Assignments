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

    -- Call the workflow tracking procedure to record table creation
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'CreateSectionTable', 0, @UserAuthorizationKey
END
GO

-- Testing the procedure with an example authorization key
-- EXEC [Project3].[CreateSectionTable] @UserAuthorizationKey = 0
-- SELECT * FROM [Project3].[Section]
