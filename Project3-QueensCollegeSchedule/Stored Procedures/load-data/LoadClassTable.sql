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