USE [QueensClassSchedule]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.[create-schema]
AS
BEGIN
    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Project3')
        EXEC('DROP SCHEMA [Project3]')
    EXEC('CREATE SCHEMA [Project3]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'DbSecurity')
        EXEC('DROP SCHEMA [DbSecurity]')
    EXEC('CREATE SCHEMA [DbSecurity]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Process')
        EXEC('DROP SCHEMA [Process]')
    EXEC('CREATE SCHEMA [Process]')

    IF EXISTS(SELECT * FROM sys.schemas WHERE name = 'Udt')
        EXEC('DROP SCHEMA [Udt]')
    EXEC('CREATE SCHEMA [Udt]')
END
GO

exec dbo.[create-schema];

GO 
CREATE OR ALTER PROCEDURE [dbo].[create-seq]
AS
BEGIN

    -- Sequence for RoomID in Project3.Room
    DROP SEQUENCE IF EXISTS [Project3].[RoomID_Seq]
    CREATE SEQUENCE [Project3].[RoomID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for BuildingID in Project3.Building
    DROP SEQUENCE IF EXISTS [Project3].[BuildingID_Seq]
    CREATE SEQUENCE [Project3].[BuildingID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

     -- Sequence for RoomID in Project3.RoomBuilding
    DROP SEQUENCE IF EXISTS [Project3].[RoomBuildingID_Seq]
    CREATE SEQUENCE [Project3].[RoomBuildingID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;


    -- Sequence for LocationID in Project3.RoomBuilding
    DROP SEQUENCE IF EXISTS [Project3].[LocationID_Seq]
    CREATE SEQUENCE [Project3].[LocationID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for SectionID in Project3.Section
    DROP SEQUENCE IF EXISTS [Project3].[SectionID_Seq]
    CREATE SEQUENCE [Project3].[SectionID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for ClassSectionID in Project3.ClassSection
    DROP SEQUENCE IF EXISTS [Project3].[ClassID_Seq]
    CREATE SEQUENCE [Project3].[ClassID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for CourseID in Project3.Course
    DROP SEQUENCE IF EXISTS [Project3].[CourseID_Seq]
    CREATE SEQUENCE [Project3].[CourseID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for ModeID in Project3.ModeOfInstruction
    DROP SEQUENCE IF EXISTS [Project3].[ModeOfInstructionID_Seq]
    CREATE SEQUENCE [Project3].[ModeOfInstructionID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for ScheduleID in Project3.Schedule
    DROP SEQUENCE IF EXISTS [Project3].[ScheduleID_Seq]
    CREATE SEQUENCE [Project3].[ScheduleID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for ClassDetailsID in Project3.ClassDetails
    DROP SEQUENCE IF EXISTS [Project3].[ClassDetailsID_Seq]
    CREATE SEQUENCE [Project3].[ClassDetailsID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for SemesterID in Project3.Semester
    DROP SEQUENCE IF EXISTS [Project3].[SemesterID_Seq]
    CREATE SEQUENCE [Project3].[SemesterID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for InstructorID in Project3.Instructor
    DROP SEQUENCE IF EXISTS [Project3].[InstructorID_Seq]
    CREATE SEQUENCE [Project3].[InstructorID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for DepartmentID in Project3.Department
    DROP SEQUENCE IF EXISTS [Project3].[DepartmentID_Seq]
    CREATE SEQUENCE [Project3].[DepartmentID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for InstructorDeptID in Project3.InstructorDept
    DROP SEQUENCE IF EXISTS [Project3].[InstructorDeptID_Seq]
    CREATE SEQUENCE [Project3].[InstructorDeptID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    -- Sequence for CourseModeID in Project3.CourseMode
    DROP SEQUENCE IF EXISTS [Project3].[CourseModeID_Seq]
    CREATE SEQUENCE [Project3].[CourseModeID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;


    DROP SEQUENCE IF EXISTS [Project3].[UserAuthorizationKey_Seq]
    CREATE SEQUENCE [Project3].[UserAuthorizationKey_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;

    DROP SEQUENCE IF EXISTS [Project3].[WorkflowStepsID_Seq]
    CREATE SEQUENCE [Project3].[WorkflowStepsID_Seq]
    AS [Udt].[P3Key]
    START WITH 1
    INCREMENT BY 1;
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	
--
-- Creates All the requried Tables and associated Schemas.
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[create-init-tables]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Process')
    BEGIN
        EXEC('CREATE SCHEMA [Process]');
    END
    
    DROP TABLE IF EXISTS [Process].[WorkflowSteps];
    
    CREATE TABLE [Process].[WorkflowSteps](
        WorkFlowStepKey [Udt].[P3Key] NOT NULL CONSTRAINT [DF_WorkflowSteps_Key] DEFAULT (NEXT VALUE FOR [Project3].[WorkflowStepsID_Seq]) PRIMARY KEY, -- primary key
        WorkFlowStepDescription NVARCHAR (100) NOT NULL,
        WorkFlowStepTableRowCount INT NULL DEFAULT (0),
        StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
        EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME ()),
        ClassTime VARCHAR (5) NULL DEFAULT '10:45',
        UserAuthorizationKey INT NOT NULL 
    );
    DROP SCHEMA IF EXISTS [DbSecurity];
    
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'DbSecurity')
    BEGIN
        EXEC('CREATE SCHEMA [DbSecurity]');
    END
   
    DROP TABLE IF EXISTS [DbSecurity].[UserAuthorization]

    CREATE TABLE [DbSecurity].[UserAuthorization](
        UserAuthorizationKey [Udt].[P3Key] NOT NULL CONSTRAINT [DF_UserAuthorization_Key] DEFAULT (NEXT VALUE FOR [Project3].[UserAuthorizationKey_Seq]) PRIMARY KEY, -- primary key
        ClassTime nvarchar (5) Null Default'10:45',
        [Individual Project] nvarchar (60) null default 'PROJECT 3 QueensCollegeSchedule',
        GroupMemberLastName nvarchar (35) NOT NULL,
        GroupMemberFirstName nvarchar (25) NOT NULL,
        GroupName nvarchar (20) NOT NULL default 'Group 1',
        DateAdded datetime2 null default(SYSDATETIME())
    )
   
  
END;


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/17/2024
-- Description:	
--
-- Add Group Members. 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[add-group-members]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    ALTER SEQUENCE [Project3].[UserAuthorizationKey_Seq] RESTART WITH 1

    INSERT INTO DbSecurity.UserAuthorization (GroupMemberFirstName, GroupMemberLastName)
    VALUES 
        ('Benjamin', 'Zhong'),
        ('Arnan', 'Khan'),
        ('Luis', 'Diaz'),
        ('Nafisul', 'Islam'),
        ('Dillon', 'Chen'),
        ('Inderpreet', 'Singh');




END;


GO

USE [QueensClassSchedule]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.[create-udt]
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Key' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Key] FROM [int] NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Day' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Day] FROM VARCHAR(10) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Time' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Time] FROM VARCHAR(20) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3NameString' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3NameString] FROM VARCHAR(MAX) NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Bool' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Bool] FROM CHAR(2) NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3DateTime' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3DateTime] FROM datetime2(7) NOT NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3Int' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3Int] FROM int NULL');

    IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name='P3HourCredit' AND schema_id = SCHEMA_ID('Udt'))
        EXEC('CREATE TYPE [Udt].[P3HourCredit] FROM DECIMAL(5,2) NULL');


END
GO


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


GO




exec dbo.[create-udt]

exec dbo.[create-seq]



exec [Project3].[create-init-tables]

exec [Project3].[add-group-members]


SELECT *
FROM [DbSecurity].UserAuthorization




-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Building Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateBuildingTable]
GO

CREATE PROCEDURE [Project3].[CreateBuildingTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Building]
	CREATE TABLE [Project3].[Building]
		(
			BuildingID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Building] DEFAULT (NEXT VALUE FOR [Project3].BuildingID_Seq) PRIMARY KEY,
			BuildingName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Building Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create ClassDetails Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassDetailsTable]
GO
CREATE PROCEDURE [Project3].[CreateClassDetailsTable]
    @UserAuthorizationKey INT
AS 
BEGIN 
    DROP TABLE IF EXISTS [Project3].[ClassDetails]
    CREATE TABLE [Project3].[ClassDetails]
        (
            ClassDetailsID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_ClassDetails] DEFAULT (NEXT VALUE FOR [Project3].[ClassDetailsID_Seq]) PRIMARY KEY,
            Code [Udt].[P3Int] NOT NULL,
            [Limit] [Udt].[P3Int],
            [Enrolled] [Udt].[P3Int],
            UserAuthorizationKey INT NULL
        )
    
    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Class Details Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 

GO

-- =============================================
-- Author: Arnan Khan
-- Create date: 12/5/2024
-- Description: Create ClassSection Table
-- =============================================

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateClassTable]
GO
CREATE PROCEDURE [Project3].[CreateClassTable]
    @UserAuthorizationKey INT
AS 
BEGIN 
    DROP TABLE IF EXISTS [Project3].[Class]
    CREATE TABLE [Project3].[Class]
        (
            ClassID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Class] DEFAULT (NEXT VALUE FOR [Project3].[ClassID_Seq]) PRIMARY KEY,
            [InstructorID] [Udt].[P3Key],
            [ScheduleID] [Udt].[P3Key],
            [SemesterID] [Udt].[P3Key],
            [RoomBuildingID] [Udt].[P3Key],
            [CourseID] [Udt].[P3Key],
            [ModeOfInstructionID] [Udt].[P3Key],
            [SectionID] [Udt].[P3Key],
            [ClassDetailsID] [Udt].[P3Key],
            UserAuthorizationKey INT  NULL
        )
    
    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Class Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 

GO

-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Create CourseMode Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[CreateCourseModeTable]
GO

CREATE PROCEDURE [Project3].[CreateCourseModeTable]
    @UserAuthorizationKey INT
AS 
BEGIN
    -- Drop the table if it already exists
    DROP TABLE IF EXISTS [Project3].[CourseMode]

    -- Create the CourseMode table
    CREATE TABLE [Project3].[CourseMode]
    (
        CourseModeID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_CourseModeID] DEFAULT (NEXT VALUE FOR [Project3].CourseModeID_Seq) PRIMARY KEY,
        CourseID [Udt].[P3Key] NOT NULL,
        ModeID [Udt].[P3Key] NOT NULL,
        UserAuthorizationKey INT  NULL,
    )

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create CourseMode Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- =============================================
-- Author: Dillon Chen
-- Create date: 12/3/2024
-- Description: Create Course Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateCourseTable]
GO
CREATE PROCEDURE [Project3].[CreateCourseTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Course]
	CREATE TABLE [Project3].[Course]
		(
			CourseID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Course] DEFAULT (NEXT VALUE FOR [Project3].CourseID_Seq) PRIMARY KEY,
			CourseName [Udt].[P3NameString] NULL,
			CourseNum [Udt].[P3NameString] NULL,
            DepartmentID [Udt].[P3Int] NOT NULL,
            Hours [Udt].[P3HourCredit] NULL,
            Credits [Udt].[P3HourCredit] NULL,
            WritingIntensive [Udt].[P3Bool] NULL,
			UserAuthorizationKey INT NULL,
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Course Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- EXEC [Project3].[CreateCourseTable] @UserAuthorizationKey=1


-- =============================================
-- Author: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load Department Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateDepartmentTable]
GO

CREATE PROCEDURE [Project3].[CreateDepartmentTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Department]
	CREATE TABLE [Project3].[Department]
		(
			DepartmentID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Department] DEFAULT (NEXT VALUE FOR [Project3].DepartmentID_Seq) PRIMARY KEY,
			[DeptName] [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Dept Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- =============================================
-- Author: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load InstructorDept Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateInstructorDeptTable]
GO

CREATE PROCEDURE [Project3].[CreateInstructorDeptTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[InstructorDept]
	CREATE TABLE [Project3].[InstructorDept]
		(
			InstructorDeptID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_InstructorDept] DEFAULT (NEXT VALUE FOR [Project3].InstructorDeptID_Seq) PRIMARY KEY,
			[InstructorID] [Udt].[P3Key] NULL,
            [DepartmentID] [Udt].[P3Key] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create InstructorDept Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Create Instructor Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateInstructorTable]
GO

CREATE PROCEDURE [Project3].[CreateInstructorTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[Instructor]
	CREATE TABLE [Project3].[Instructor]
		(
			InstructorID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Instructor] DEFAULT (NEXT VALUE FOR [Project3].InstructorID_Seq) PRIMARY KEY,
			FirstName [Udt].[P3NameString] NULL,
			LastName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Instructor Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Create Mode Of Instruction Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[CreateModeOfInstructionTable]
GO

CREATE PROCEDURE [Project3].[CreateModeOfInstructionTable]
	@UserAuthorizationKey INT
AS 
BEGIN
	DROP TABLE IF EXISTS [Project3].[ModeOfInstruction]
	CREATE TABLE [Project3].[ModeOfInstruction]
		(
			ModeOfInstructionID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_ModeOfInstruction] DEFAULT (NEXT VALUE FOR [Project3].ModeOfInstructionID_Seq) PRIMARY KEY,
			ModeName [Udt].[P3NameString] NULL,
			UserAuthorizationKey INT NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Mode of Instruction Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Create RoomBuilding Bridge Table
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[CreateRoomBuildingTable]
GO

CREATE PROCEDURE [Project3].[CreateRoomBuildingTable]
     @UserAuthorizationKey INT 
AS
BEGIN
    -- Drop the table if it already exists
    DROP TABLE IF EXISTS [Project3].[RoomBuilding]


    -- Create the RoomBuilding bridge table
    CREATE TABLE [Project3].[RoomBuilding]
    (
        RoomBuildingID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_RoomBuilding] DEFAULT (NEXT VALUE FOR [Project3].[RoomBuildingID_Seq]) PRIMARY KEY,
        RoomID [Udt].[P3Key] NOT NULL,
        BuildingID [Udt].[P3Key] NOT NULL,
        UserAuthorizationKey INT  NULL,
    )

-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create RoomBuilding Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO 

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Room Table
-- =============================================


DROP PROCEDURE IF EXISTS [Project3].[CreateRoomTable]
GO

CREATE PROCEDURE [Project3].[CreateRoomTable]
	@UserAuthorizationKey INT
AS
BEGIN
	DROP TABLE IF EXISTS [Project3].[Room]
	CREATE TABLE [Project3].[Room]
		(
			RoomID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Room] DEFAULT (NEXT VALUE FOR [Project3].[RoomID_Seq]) PRIMARY KEY,
			RoomNumber [Udt].[P3NameString] NOT NULL,
			UserAuthorizationKey INT  NULL
		)

	-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Room Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO 
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Create Schedule Table
-- =============================================

USE QueensClassSchedule
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 


DROP PROCEDURE IF EXISTS [Project3].[CreateScheduleTable]
GO 

CREATE PROCEDURE [Project3].[CreateScheduleTable]
    @UserAuthorizationKey INT 
AS
BEGIN 
    DROP TABLE IF EXISTS [Project3].[Schedule]
    CREATE TABLE [Project3].[Schedule]
        (
            ScheduleID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Schedule] DEFAULT (NEXT VALUE FOR [Project3].[ScheduleID_Seq]) PRIMARY KEY,
            [time] [Udt].[P3Time],
            [day] [Udt].[P3Day],
            UserAuthorizationKey INT  NULL
        )


    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Schedule Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END
GO 


Go
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
        SemesterID [Udt].[P3Key] NOT NULL CONSTRAINT [DF_Semester] DEFAULT (NEXT VALUE FOR [Project3].[SemesterID_Seq]) PRIMARY KEY,
        [Name] Udt.[P3NameString],
        UserAuthorizationKey int
        );

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Create Semester Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO


exec [Project3].[CreateBuildingTable] @UserAuthorizationKey = 1 
exec [Project3].[CreateClassDetailsTable] @UserAuthorizationKey = 1
exec [Project3].[CreateInstructorTable] @UserAuthorizationKey = 5 
exec [Project3].[CreateModeOfInstructionTable] @UserAuthorizationKey = 5
exec [Project3].[CreateRoomBuildingTable] @UserAuthorizationKey = 1
exec [Project3].[CreateRoomTable] @UserAuthorizationKey = 1
exec [Project3].[CreateScheduleTable] @UserAuthorizationKey = 1
exec [Project3].[CreateSectionTable] @UserAuthorizationKey = 4
exec [Project3].[CreateDepartmentTable] @UserAuthorizationKey = 2
exec [Project3].[CreateInstructorDeptTable] @UserAuthorizationKey = 2
exec [Project3].[CreateSemesterTable] @UserAuthorizationKey = 3
exec [Project3].[CreateCourseModeTable] @UserAuthorizationKey = 4
exec [Project3].[CreateCourseTable] @UserAuthorizationKey = 5
exec [Project3].[CreateClassTable] @UserAuthorizationKey = 2



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Arnan Khan
-- Create date: 12/5/2024
-- Description:	add foreign keys to star schema
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[AddForeignKeysToStarSchemaData]
	@UserAuthorizationKey int

AS
BEGIN
    SET NOCOUNT ON
    

    --Class SCHEMA FK's
    DECLARE @PrimaryKey VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @FTableName VarChar(255)
    DECLARE @TableName VarChar(255)

    DECLARE PrimaryKeyCursor CURSOR FOR

    SELECT DISTINCT 
        '[' + s.name + '].[' + SUBSTRING(c.name,0,CHARINDEX('ID',c.name)) + ']' as fullqualifiedtablename, 
        c.name as [primarykeycolumn], 
        SUBSTRING(c.name,0,CHARINDEX('ID',c.name)) as [tablename]     
    FROM sys.tables t
    INNER JOIN sys.all_columns c on t.object_id = c.object_id
    INNER JOIN sys.schemas s on s.schema_id = t.schema_id
    WHERE t.name = 'Class' AND c.name NOT LIKE '%Class%' AND c.name NOT LIKE '%UserAuthorizationKey%' AND s.name = 'Project3'
    OPEN PrimaryKeyCursor
    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName, @PrimaryKey, @TableName
    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [Project3].[Class] ADD CONSTRAINT FK_'+@TableName+' FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @FTableName + '(' + @PrimaryKey + ')'
        EXEC (@SQL)
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName, @PrimaryKey, @TableName
    END
    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor


    --Bridge Tables
    ALTER TABLE [Project3].[RoomBuilding] ADD CONSTRAINT FK_Building FOREIGN KEY(BuildingID) REFERENCES [Project3].[Building](BuildingID)
    ALTER TABLE [Project3].[RoomBuilding] ADD CONSTRAINT FK_Room FOREIGN KEY(RoomID) REFERENCES [Project3].[Room](RoomID)


    ALTER TABLE [Project3].[CourseMode] ADD CONSTRAINT FK_Course2 FOREIGN KEY(CourseID) REFERENCES [Project3].[Course](CourseID)
    ALTER TABLE [Project3].[CourseMode] ADD CONSTRAINT FK_Mode FOREIGN KEY(ModeID) REFERENCES [Project3].[ModeOfInstruction](ModeOfInstructionID)

    ALTER TABLE [Project3].[InstructorDept] ADD CONSTRAINT FK_Instructor2 FOREIGN KEY(InstructorID) REFERENCES [Project3].[Instructor](InstructorID)
    ALTER TABLE [Project3].[InstructorDept] ADD CONSTRAINT FK_Department FOREIGN KEY(DepartmentID) REFERENCES [Project3].[Department](DepartmentID)

    ALTER TABLE [Project3].[Course] ADD CONSTRAINT FK_Department2 FOREIGN KEY(DepartmentID) REFERENCES [Project3].[Department](DepartmentID)    

    
    --UserAuth FK
    DECLARE @SQL2 VARCHAR(MAX)
    DECLARE @FTableName2 VarChar(255)
    DECLARE @TableName2 VarChar(255)


    DECLARE PrimaryKeyCursor CURSOR FOR

    SELECT DISTINCT 
        '[' + s.name + '].[' + t.name + ']' as fullqualifiedtablename,
        t.name as tablename
    FROM sys.tables t
    INNER JOIN sys.schemas s on s.schema_id = t.schema_id
    WHERE s.name = 'Project3' OR s.name = 'Process'
    
    OPEN PrimaryKeyCursor
    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName2, @TableName2
    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL2 = 'ALTER TABLE '+ @FTableName2 +' ADD CONSTRAINT FK_'+@TableName2+'_UserAuthKey FOREIGN KEY (UserAuthorizationKey) REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)'
        EXEC (@SQL2)
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName2, @TableName2
    END
    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor




    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Add Foreign Keys.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;
GO


--ALTER TABLE [Process].[WorkflowSteps]  ADD CONSTRAINT FK_WorkflowSteps_UserAuthKey FOREIGN KEY (UserAuthorizationKey) REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Arnan / Benjamin
-- Create date: 
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
-- GRANT DROP ON  ON SCHEMA:CH01-01-Fact TO sa

DROP PROCEDURE IF EXISTS [Project3].[DropForeignKeysFromStarSchemaData]

GO

CREATE PROCEDURE [Project3].[DropForeignKeysFromStarSchemaData]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    Declare @ForeignKeyName VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @TableName VARCHAR(255)
    DECLARE ForeignKeyCursor CURSOR FOR 
    
    SELECT fk.name as ForeignKeyName,
        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.'+t.name as TableName
    FROM sys.foreign_keys as fk
    INNER JOIN sys.tables as t on fk.parent_object_id = t.object_id

    OPEN ForeignKeyCursor

    FETCH NEXT FROM ForeignKeyCursor INTO @ForeignKeyName, @TableName

    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT IF EXISTS ' + @ForeignKeyName + ';'
        EXEC(@SQL)
        
        FETCH NEXT FROM ForeignKeyCursor INTO @ForeignKeyName, @TableName
    END

    CLOSE ForeignKeyCursor
    DEALLOCATE ForeignKeyCursor

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Drop Foreign Keys.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description:	Truncate Star Schema
-- =============================================

DROP PROCEDURE IF EXISTS [Project3].[TruncateStarSchemaData]
GO 

CREATE PROCEDURE [Project3].[TruncateStarSchemaData]
	@UserAuthorizationKey int
AS 
BEGIN 
	SET NOCOUNT ON
	DECLARE TableCursor CURSOR FOR
	SELECT DISTINCT 
		'[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' as FullyQualifiedTableName
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'Base Table' AND TABLE_SCHEMA LIKE '%Project3%'

	OPEN TableCursor
	DECLARE @TableName NVARCHAR(255)
	DECLARE @SQL VARCHAR(MAX)

	FETCH NEXT FROM TableCursor INTO @TableName

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @SQL = 'TRUNCATE TABLE ' + @TableName
		EXEC(@SQL)

		FETCH NEXT FROM TableCursor INTO @TableName
	END

	CLOSE TableCursor

	DEALLOCATE TableCursor

	EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Truncate Star Schema Data.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

-- EXEC [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 1

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Building Table Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadBuilding]
GO

CREATE PROCEDURE [Project3].[LoadBuilding]
	@UserAuthorizationKey INT
AS 
BEGIN 

	INSERT INTO [Project3].[Building]
	(BuildingName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				CASE
					WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, 0, CHARINDEX(' ', o.location, 0))
					ELSE 'UNKNOWN'
				END AS buildingname,
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS o
		)
	-- EXEC workflowsteps procedure
END
GO

-- EXEC [LoadData].[LoadBuildingData] @UserAuthorizationKey = 1
-- SELECT *
-- FROM [Project3].[Building]


-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load ClassDetails Table
-- =============================================

USE QueensClassSchedule
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

DROP PROCEDURE IF EXISTS [Project3].[LoadClassDetails]
GO

CREATE PROCEDURE [Project3].[LoadClassDetails] 
    @UserAuthorizationKey INT
AS
BEGIN 

    INSERT INTO [Project3].[ClassDetails]
        ( 
            Code, [Limit], Enrolled, UserAuthorizationKey
        )
    (
        Select DISTINCT code,
        CASE 
            WHEN Limit < Enrolled THEN Enrolled
            ELSE LIMIT
        END AS [limit],
        Enrolled,
        @UserAuthorizationKey
        FROM UploadFile.CurrentSemesterCourseOfferings
    )
    
    PRINT 'done'
END 
GO



-- ========test code below for local env
-- EXEC [Project3].[LoadClassDetails] @UserAuthorizationKey=1
-- GO 

-- Select *
-- FROM [Project3].[ClassDetails]

-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Load CourseMode Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadCourseMode]
GO

CREATE PROCEDURE [Project3].[LoadCourseMode]
    @UserAuthorizationKey INT
AS 
BEGIN
    -- Variable to store row count
    DECLARE @RowCount INT;

    -- Truncate the CourseMode table to remove old data
    TRUNCATE TABLE [Project3].[CourseMode];

    -- Insert data into the CourseMode table
    INSERT INTO [Project3].[CourseMode] (CourseID, ModeID, UserAuthorizationKey)
    SELECT DISTINCT
        c.CourseID,
        m.ModeOfInstructionID,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    INNER JOIN [Project3].[Course] AS c ON c.CourseName = o.[Description]
    INNER JOIN [Project3].[ModeOfInstruction] AS m ON m.ModeName = o.[Mode of Instruction];

    -- Get the row count
    SELECT @RowCount = COUNT(*) FROM [Project3].[CourseMode];

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load CourseMode Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @RowCount;
END
GO

-- To execute the procedure:
-- EXEC [Project3].[LoadCourseModeData] @UserAuthorizationKey = 1;

-- =============================================
-- Author: Dillon Chen
-- Create date: 12/3/2024
-- Description: Load Course Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadCourse]
GO

CREATE PROCEDURE [Project3].[LoadCourse]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Course]
	(CourseName, CourseNum, DepartmentID, Hours, Credits, WritingIntensive, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				C.[Description],
                SUBSTRING(C.[Course (hr, crd)], CHARINDEX(' ', C.[Course (hr, crd)]), CHARINDEX('(', C.[Course (hr, crd)]) - CHARINDEX(' ', C.[Course (hr, crd)])-1),
                D.DepartmentID,
                CAST(SUBSTRING(C.[Course (hr, crd)], CHARINDEX('(', C.[Course (hr, crd)])+1, CHARINDEX(',', C.[Course (hr, crd)]) - CHARINDEX('(', C.[Course (hr, crd)])-1) AS DECIMAL(5,2)),
                CAST(SUBSTRING(C.[Course (hr, crd)], CHARINDEX(',', C.[Course (hr, crd)])+1, CHARINDEX(')', C.[Course (hr, crd)]) - CHARINDEX(',', C.[Course (hr, crd)])-1) AS DECIMAL(5,2)),
                (CASE
                    WHEN C.[Course (hr, crd)] LIKE N'%[0-9]%W%' THEN 1
                    ELSE 0
                 END),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
            INNER JOIN [Project3].[Department] AS D
                ON SUBSTRING(C.[Course (hr, crd)],0,CHARINDEX(' ',C.[Course (hr, crd)], 0)) = D.DeptName
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Course Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

-- SELECT C.[Description]
-- FROM Uploadfile.CurrentSemesterCourseOfferings AS C

-- =============================================
-- Author: Arnan Khan
-- Create date: 12/3/2024
-- Description: Load Department Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadDepartment]
GO

CREATE PROCEDURE [Project3].[LoadDepartment]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Department]
	(DeptName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				SUBSTRING(C.[Course (hr, crd)],0,CHARINDEX(' ',C.[Course (hr, crd)], 0)),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Department Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

-- =============================================
-- Author: Arnan Khan
-- Create date: 12/3/2024
-- Description: Load InstructorDept Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadInstructorDept]
GO

CREATE PROCEDURE [Project3].[LoadInstructorDept]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[InstructorDept]
	(InstructorID,DepartmentID,UserAuthorizationKey)
		(   
            SELECT  
                    DISTINCT 
                    I.InstructorID,
                    D.DepartmentID,
                    @UserAuthorizationKey
            FROM Uploadfile.CurrentSemesterCourseOfferings c
            INNER JOIN Project3.Instructor I on CONCAT(SUBSTRING(C.Instructor, CHARINDEX(' ',C.Instructor,0)+1, LEN(C.Instructor) ), SUBSTRING(C.Instructor, 0, CHARINDEX(',',C.Instructor,0))) = CONCAT(I.FirstName,I.LastName)
            INNER JOIN Project3.Department D on SUBSTRING(C.[Course (hr, crd)],0,CHARINDEX(' ',C.[Course (hr, crd)], 0))=D.DeptName
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load InstructorDept Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO


-- =============================================
-- Author: Dillon Chen | Edited By: Arnan Khan
-- Create date: 12/2/2024
-- Description: Load Instructor Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadInstructor]
GO

CREATE PROCEDURE [Project3].[LoadInstructor]
	@UserAuthorizationKey INT
AS 
BEGIN 
	DECLARE @WorkFlowStepTableRowCount INT;
	INSERT INTO [Project3].[Instructor]
	(FirstName, LastName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				SUBSTRING(C.Instructor, CHARINDEX(' ',C.Instructor,0)+1, LEN(C.Instructor) ), 
				SUBSTRING(C.Instructor, 0, CHARINDEX(',',C.Instructor,0)),
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Instructor Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
END
GO

-- =============================================
-- Author: Dillon Chen
-- Create date: 12/2/2024
-- Description: Load Mode Of Instruction Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadModeOfInstruction]
GO

CREATE PROCEDURE [Project3].[LoadModeOfInstruction]
	@UserAuthorizationKey INT
AS 
BEGIN 
	
	INSERT INTO [Project3].[ModeOfInstruction]
	(ModeName, UserAuthorizationKey)
		(   
			SELECT DISTINCT
				C.[Mode of instruction] AS ModeName,
				@UserAuthorizationKey
			FROM Uploadfile.CurrentSemesterCourseOfferings AS C
		)
	-- EXEC workflowsteps procedure
END
GO

-- EXEC [LoadData].[LoadModeOfInstruction] @UserAuthorizationKey = 1
-- SELECT *
-- FROM [Project3].[ModeOfInstruction]
-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Load RoomBuilding Bridge Table
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadRoomBuilding]
GO

CREATE PROCEDURE [Project3].[LoadRoomBuilding]
    @UserAuthorizationKey INT
AS
BEGIN
    -- Truncate the RoomBuilding table to remove old data

    -- Insert data into RoomBuilding by matching Room and Building
    INSERT INTO [Project3].[RoomBuilding] (RoomID, BuildingID, UserAuthorizationKey)
    SELECT DISTINCT
        r.RoomID,
        b.BuildingID,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    INNER JOIN [Project3].[Building] AS b ON
        b.BuildingName = CASE
            WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, 0, CHARINDEX(' ', o.location))
            ELSE 'UNKNOWN'
        END
    INNER JOIN [Project3].[Room] AS r ON
        r.RoomNumber = CASE
            WHEN DATALENGTH(o.location) > 0 THEN SUBSTRING(o.location, CHARINDEX(' ', o.location) + 1, LEN(o.location))
            ELSE 'UNKNOWN'
        END

    -- Optional: Call workflow tracking procedure
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'LoadRoomBuildingData', (SELECT COUNT(*) FROM [Project3].[RoomBuilding]), @UserAuthorizationKey
END
GO


-- EXEC [Project3].[LoadRoomBuildingData] @UserAuthorizationKey = 1

SET ANSI_NULLS ON 
GO 

SET QUOTED_IDENTIFIER ON
GO 

-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Room Table
-- =============================================


DROP PROCEDURE IF EXISTS [Project3].[LoadRoom]
GO

CREATE PROCEDURE [Project3].[LoadRoom]
	@UserAuthorizationKey INT
AS
BEGIN

	INSERT INTO [Project3].[Room]
		(RoomNumber, UserAuthorizationKey)
	(
		SELECT DISTINCT
			CASE 
				WHEN DATALENGTH(Location) > 0 THEN SUBSTRING(Location, CHARINDEX(' ', Location, 0)+1, DATALENGTH(Location)-CHARINDEX(' ', Location, 0))
				ELSE 'Undecided'
			END AS RoomNum,
			@UserAuthorizationKey		
		FROM Uploadfile.CurrentSemesterCourseOfferings
	)

	PRINT 'Hello World'
END
GO 

-- EXEC [Project3].[LoadRoom] @UserAuthorizationKey = 1

-- SELECT * 
-- FROM [Project3].[Room]


-- =============================================
-- Author: Benjamin Zhong
-- Create date: 12/1/2024
-- Description: Load Schedule Table
-- =============================================
USE QueensClassSchedule
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadSchedule]
GO

CREATE PROCEDURE [Project3].[LoadSchedule]
    @UserAuthorizationKey INT 
AS
BEGIN
    INSERT INTO [Project3].[Schedule]
        (
            [time],[day],UserAuthorizationKey
        )
    SELECT 
        CASE
            WHEN DATALENGTH(o.time) > 2 THEN o.time
            ELSE 'NA'
        END AS [time],
        CASE
            WHEN DATALENGTH(o.[Day]) > 1  THEN o.day 
            ELSE 'NA'
        END AS [day],
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings as o
    Print 'done'
END
GO 
-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/2/2024
-- Description: Load Section Table Stored Procedure
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadSection]
GO

CREATE PROCEDURE [Project3].[LoadSection]
    @UserAuthorizationKey INT
AS 
BEGIN 

    -- Insert distinct data into the Section table
    INSERT INTO [Project3].[Section]
    (SectionName, UserAuthorizationKey)
    SELECT DISTINCT
        CASE
            WHEN DATALENGTH(o.sec) > 0 THEN o.sec
            ELSE 'UNKNOWN'
        END AS SectionName,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    
    -- Call the workflow steps procedure to track this operation
    -- EXEC [Process].[usp_TrackWorkFlow] @StartTime, 'LoadSectionData', (SELECT COUNT(*) FROM [Project3].[Section]), @UserAuthorizationKey
END
GO


-- Testing the procedure with an example authorization key
-- EXEC [Project3].[LoadSectionData] @UserAuthorizationKey = 1
-- SELECT * FROM [Project3].[Section]


-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Load Semester Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


DROP PROCEDURE IF EXISTS [Project3].[LoadSemester]
GO

CREATE PROCEDURE [Project3].[LoadSemester]
    @UserAuthorizationKey INT
AS BEGIN
    DECLARE @RowCount INT;

    TRUNCATE TABLE [Project3].[Semester];

    INSERT INTO [Project3].[Semester] ([Name], UserAuthorizationKey)
    SELECT DISTINCT
        CASE
            WHEN DATALENGTH(o.semester) > 0 THEN o.semester
            ELSE 'UNKNOWN'
        END AS [Name],
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o;

    -- Get the row count
    SELECT @RowCount = COUNT(*) FROM [Project3].[Semester];

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Semester Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @RowCount;
END
GO

-- =============================================
-- Author: Arnan
-- Create date: 12/1/2024
-- Description: Load Class Table
-- =============================================

USE QueensClassSchedule
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

DROP PROCEDURE IF EXISTS [Project3].[LoadClass]
GO

CREATE PROCEDURE [Project3].[LoadClass] 
    @UserAuthorizationKey INT
AS
BEGIN 
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [Project3].[Class]
        ( 
            InstructorID,ScheduleID,SemesterID,RoomBuildingID,CourseID,ModeOfInstructionID,SectionID,ClassDetailsID, UserAuthorizationKey
        )
    (
        SELECT DISTINCT I.InstructorID, ScheduleID, SemesterID, RoomBuildingID, CourseID, ModeOfInstructionID, SectionID, ClassDetailsID, @UserAuthorizationKey
        FROM Uploadfile.CurrentSemesterCourseOfferings as UF
        INNER JOIN [Project3].[Instructor] as I on CONCAT(SUBSTRING(UF.Instructor, CHARINDEX(' ',UF.Instructor,0)+1, LEN(UF.Instructor) ), SUBSTRING(UF.Instructor, 0, CHARINDEX(',',UF.Instructor,0))) = CONCAT(I.FirstName,I.LastName)
        INNER JOIN [Project3].[Schedule] as S on   CONCAT((CASE WHEN DATALENGTH(UF.time) > 2 THEN UF.time ELSE 'NA' END) ,CASE WHEN DATALENGTH(UF.[Day]) > 1  THEN UF.day ELSE 'NA' END )=CONCAT(S.time,S.day)
        INNER JOIN [Project3].[Semester]as S2 on (CASE WHEN DATALENGTH(UF.semester) > 0 THEN UF.semester ELSE 'UNKNOWN' END ) = S2.Name
        INNER JOIN [Project3].[Room] as R on (CASE WHEN DATALENGTH(UF.location) > 0 THEN SUBSTRING(UF.location, CHARINDEX(' ', UF.location) + 1, LEN(UF.location)) ELSE 'UNKNOWN' END) = r.RoomNumber
        INNER JOIN [Project3].[Building] as B on (CASE WHEN DATALENGTH(UF.location) > 0 THEN SUBSTRING(UF.location, 0, CHARINDEX(' ', UF.location)) ELSE 'UNKNOWN' END) = B.BuildingName
        INNER JOIN [Project3].[RoomBuilding] as RB on CONCAT(R.RoomID,B.BuildingID) = CONCAT(RB.RoomID,RB.BuildingID)
        INNER JOIN [Project3].[Course] as C on UF.[Description] = C.CourseName
        INNER JOIN [Project3].[ModeOfInstruction] as MoI on UF.[Mode of Instruction] = MoI.ModeName
        INNER JOIN [Project3].[Section] as S3 on (CASE WHEN DATALENGTH(UF.sec) > 0 THEN UF.sec ELSE 'UNKNOWN' END) = S3.SectionName
        INNER JOIN [Project3].[ClassDetails] as CD on CD.Code = UF.Code
    )
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
		-- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load Department Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;
    
END 
GO



-- ========test code below for local env
-- EXEC [Project3].[LoadClass] @UserAuthorizationKey=1
-- GO 

-- Select *
-- FROM [Project3].[ClassDetails]

-- To execute the procedure:
-- EXEC [Project3].[LoadSemesterData] @UserAuthorizationKey = 1;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[LoadStarSchemaData]
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


EXEC [Project3].[LoadStarSchemaData]
GO
CREATE OR ALTER VIEW [Project3].[SemesterView] AS 
SELECT DISTINCT 
                CASE CONCAT_WS(' ', I.FirstName, I.LastName) 
                    WHEN ',' THEN 'NA'
                    ELSE CONCAT_WS(' ', I.FirstName, I.LastName) 
                END as [Instructor], 

                S.time as [Time], S.day as [Day], CO.CourseName, D.DeptName as [Department], MoI.ModeName as [Mode of Instruction]
                ,B.BuildingName, R.RoomNumber,
                CD.Enrolled,
                CD.Limit,
                SectionName as [Section],
                SEM.Name as [Semester]
FROM Project3.Class as C
INNER JOIN Project3.Instructor as I on C.InstructorID = I.InstructorID
INNER JOIN Project3.Schedule as S on C.ScheduleID = S.ScheduleID
INNER JOIN Project3.RoomBuilding as RB on RB.RoomBuildingID = C.RoomBuildingID
INNER JOIN Project3.Room as R on R.RoomID = RB.RoomID
INNER JOIN Project3.Building as B on RB.BuildingID = B.BuildingID
INNER JOIN Project3.Course as CO on C.CourseID = CO.CourseID
INNER JOIN Project3.Department as D on CO.DepartmentID = D.DepartmentID
INNER JOIN Project3.[ModeOfInstruction]as MoI on MoI.ModeOfInstructionID = C.ModeOfInstructionID
INNER JOIN Project3.ClassDetails as CD on CD.ClassDetailsID = C.ClassDetailsID
INNER JOIN Project3.Section as SE on SE.SectionID = C.SectionID
INNER JOIN Project3.Semester as SEM on SEM.SemesterID = C.SemesterID
GO