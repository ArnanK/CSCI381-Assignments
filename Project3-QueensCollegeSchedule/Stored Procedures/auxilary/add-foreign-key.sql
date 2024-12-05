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
    

    --Class Section SCHEMA FK's
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
    WHERE t.name = 'ClassSection' AND c.name NOT LIKE '%ClassSection%' AND c.name NOT LIKE '%UserAuthorizationKey%' AND s.name = 'Project3'
    OPEN PrimaryKeyCursor
    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName, @PrimaryKey, @TableName
    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [Project3].[ClassSection] ADD CONSTRAINT FK_'+@TableName+' FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @FTableName + '(' + @PrimaryKey + ')'
        EXEC (@SQL)
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName, @PrimaryKey, @TableName
    END
    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor


    --Bridge Tables
    ALTER TABLE [Project3].[RoomBuilding] ADD CONSTRAINT FK_Building FOREIGN KEY(BuildingID) REFERENCES [Project3].[Building](BuildingID)
    ALTER TABLE [Project3].[RoomBuilding] ADD CONSTRAINT FK_Room FOREIGN KEY(RoomID) REFERENCES [Project3].[Room](RoomID)


    ALTER TABLE [Project3].[CourseMode] ADD CONSTRAINT FK_Course FOREIGN KEY(CourseID) REFERENCES [Project3].[Course](CourseID)
    ALTER TABLE [Project3].[CourseMode] ADD CONSTRAINT FK_Mode FOREIGN KEY(ModeID) REFERENCES [Project3].[ModeOfInstruction](ModeOfInstructionID)

    ALTER TABLE [Project3].[InstructorDept] ADD CONSTRAINT FK_Instructor FOREIGN KEY(InstructorID) REFERENCES [Project3].[Instructor](InstructorID)
    ALTER TABLE [Project3].[InstructorDept] ADD CONSTRAINT FK_Department FOREIGN KEY(DepartmentID) REFERENCES [Project3].[Department](DepartmentID)

    ALTER TABLE [Project3].[Course] ADD CONSTRAINT FK_Department2 FOREIGN KEY(DepartmentID) REFERENCES [Project3].[Department](DepartmentID)    

    
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Add Foreign Keys.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;
GO
