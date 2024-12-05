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
    DROP SEQUENCE IF EXISTS [Project3].[ClassSectionID_Seq]
    CREATE SEQUENCE [Project3].[ClassSectionID_Seq]
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



END;
GO
