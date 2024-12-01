CREATE OR ALTER PROCEDURE [dbo].[CreateSequences]
AS
BEGIN
    -- Sequence for RoomID in Project3.Room
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'RoomID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[RoomID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for BuildingID in Project3.Building
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'BuildingID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[BuildingID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for LocationID in Project3.RoomBuilding
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'LocationID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[LocationID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for SectionID in Project3.Section
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'SectionID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[SectionID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for ClassSectionID in Project3.ClassSection
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'ClassSectionID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[ClassSectionID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for CourseID in Project3.Course
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'CourseID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[CourseID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for ModeID in Project3.ModeOfInstruction
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'ModeID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[ModeID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for ScheduleID in Project3.Schedule
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'ScheduleID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[ScheduleID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for ClassDetailsID in Project3.ClassDetails
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'ClassDetailsID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[ClassDetailsID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for SemesterID in Project3.Semester
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'SemesterID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[SemesterID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for InstructorID in Project3.Instructor
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'InstructorID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[InstructorID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;

    -- Sequence for DepartmentID in Project3.Department
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'DepartmentID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[DepartmentID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;
    
    -- Sequence for CourseModeID in Project3.CourseMode
    IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'CourseModeID_Seq' AND schema_id = SCHEMA_ID('Project3'))
        CREATE SEQUENCE [Project3].[CourseModeID_Seq]
        AS INT
        START WITH 1
        INCREMENT BY 1;
END;
GO
