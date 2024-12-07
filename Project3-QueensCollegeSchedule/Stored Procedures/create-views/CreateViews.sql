-- =============================================
-- Author: 
-- Create date: 12/1/2024
-- Description: Create 
-- =============================================
USE [QueensClassSchedule]
GO
CREATE OR ALTER VIEW [Project3].[ClassView] AS 
SELECT DISTINCT 
                CASE CONCAT_WS(' ', I.FirstName, I.LastName) 
                    WHEN ',' THEN 'NA'
                    ELSE CONCAT_WS(' ', I.FirstName, I.LastName) 
                END as [Instructor], 

                S.time as [Time], S.day as [Day], CO.CourseName, D.DeptName as [Department], MoI.ModeName as [Mode of Instruction]
                ,B.BuildingName, R.RoomNumber,
                CD.Enrolled,
                CD.Limit,
                SectionName as [Section]
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