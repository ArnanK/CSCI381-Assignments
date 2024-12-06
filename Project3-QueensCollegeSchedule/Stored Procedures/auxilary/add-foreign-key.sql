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
