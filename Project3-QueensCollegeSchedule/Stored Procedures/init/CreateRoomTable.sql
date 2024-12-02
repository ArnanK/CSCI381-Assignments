SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO 

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Room Table
-- =============================================


-- The three statements below are simply for testing on my local env
DROP TABLE IF EXISTS [Project3].[Room]

DROP SEQUENCE IF EXISTS [Project3].[RoomID_Seq]

CREATE SEQUENCE [Project3].[RoomID_Seq] AS INT
START WITH 0
INCREMENT BY 1
GO
-- local env code finished



DROP PROCEDURE IF EXISTS [Project3].[CreateRoom]
GO

CREATE PROCEDURE [Project3].[CreateRoom]
	-- @UserAuthorizationKey INT
AS
BEGIN
	DROP TABLE IF EXISTS [Project3].[Room]
	CREATE TABLE [Project3].[Room]
		(
			RoomID INT NOT NULL CONSTRAINT [Project3RoomSeq] DEFAULT (NEXT VALUE FOR [Project3].[RoomID_Seq]) PRIMARY KEY,
			RoomNumber VARCHAR(10) NOT NULL,
			UserAuthorizationID INT NOT NULL
		)
END
GO 

-- EXEC [Project3].[CreateRoom]