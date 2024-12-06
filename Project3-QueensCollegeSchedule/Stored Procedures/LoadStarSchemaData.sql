SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [Project3].[LoadStarSchemaData]
    -- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;

     --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
 	--
    EXEC  [Project3].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 1;
    --

      --	Always truncate the Star Schema Data
    --
    EXEC  [Project3].[TruncateStarSchemaData] @UserAuthorizationKey = 2; 
    --
    --	Load the star schema
    --
    EXEC  [Project3].[LoadBuilding] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadClassDetails] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadDepartment] @UserAuthorizationKey = 2;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadInstructor] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadInstructorDept] @UserAuthorizationKey = 2;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadModeOfInstruction] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadCourse] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadRoom] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadRoomBuilding] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadSchedule] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadSection] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadSemester] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project3].[LoadCourseMode] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey


    EXEC [Project3].[LoadClass] @UserAuthorizationKey = 2;

  --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
 	--

   EXEC [Project3].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 2;  -- Change -1 to the appropriate UserAuthorizationKey
    --
END;
GO
