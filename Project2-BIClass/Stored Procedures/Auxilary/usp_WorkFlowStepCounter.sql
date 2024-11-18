-- =============================================
-- Author: Luis Diaz
-- Create date: 11/16/2024
-- Description: 
/* 
stored procedure creates a sequence named Process.WorkFlowStepTableRowCountBy1 
that generates integers starting at 1 and increments by 1, likely for tracking 
or numbering workflow steps in a systematic order.
*/
-- =============================================



DROP PROCEDURE IF EXISTS [Project2].[usp_WorkFlowStepCounter]
-- This removes any stored procedure named usp_WorkFlowStepCounter in the Project2 schema.
GO
CREATE PROCEDURE [Project2].[usp_WorkFlowStepCounter]
-- New stored procedure named usp_WorkFlowStepCounter
AS
BEGIN
    CREATE SEQUENCE Process.WorkFlowStepTableRowCountBy1
        AS INT
        START WITH 1
        INCREMENT BY 1
END

/*
Defines a stored procedure that creates a sequence
for generating auto-incrementing numeric values
*/


