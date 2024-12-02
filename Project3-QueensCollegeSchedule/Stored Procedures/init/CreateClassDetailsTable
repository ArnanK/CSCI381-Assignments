-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create ClassDetails Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

-- delete some of the lines below, they are needed for independent execution on a local env
DROP TABLE IF EXISTS [Project3].[ClassDetails]
GO

DROP SEQUENCE IF EXISTS [Project3].[ClassDetailsID_Seq]
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadClassDetails]
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassDetails]
GO

DROP SCHEMA IF EXISTS [Project3]
GO 

CREATE SCHEMA [Project3]
GO

CREATE SEQUENCE[Project3].[ClassDetailsID_Seq]
AS INT 
START WITH 0
INCREMENT BY 1
GO

CREATE PROCEDURE [Project3].[CreateClassDetails]
    -- @UserAuthorizationKey INT
AS 
BEGIN 
    CREATE TABLE [Project3].[ClassDetails]
        (
            ClassDetailsID INT NOT NULL CONSTRAINT [Project3ClassDetailsSeq] DEFAULT (NEXT VALUE FOR [Project3].[ClassDetailsID_Seq]) PRIMARY KEY,
            Code INT NOT NULL,
            [Limit] INT,
            [Enrolled] INT,
            UserAuthorizationKey INT NOT NULL
        )
    PRINT 'Hello World'
END
GO 

EXEC [Project3].[CreateClassDetails]
GO

