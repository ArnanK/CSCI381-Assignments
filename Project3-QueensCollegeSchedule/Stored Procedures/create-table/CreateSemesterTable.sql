-- =============================================
-- Author: Luis Diaz
-- Create date: 12/2/2024
-- Description: Create Semester Table Stored Procedure
-- =============================================


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateSemesterTable]
GO

CREATE PROCEDURE [Project3].[CreateSemesterTable]
    @UserAuthorizationKey INT
AS BEGIN
    DROP TABLE IF EXISTS [Project3].[Semester]
-- Create a new table
    CREATE TABLE [Project3].[Semester]
        (
        SemesterID int NOT NULL CONSTRAINT [Project3SemesterSeq] DEFAULT (NEXT VALUE FOR [Project3].[SemesterID_Seq]),
        Name VARCHAR(15),
        UserAuthorizationKey int
        );
END
GO