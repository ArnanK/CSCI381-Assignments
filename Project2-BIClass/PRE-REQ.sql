SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description:	add foreign keys to star schema
-- =============================================
ALTER PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]
	@UserAuthorizationKey int

AS
BEGIN
    SET NOCOUNT ON
    DECLARE @PrimaryKey VARCHAR(255)
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @FTableName VarChar(255)
    DECLARE @TableName VarChar(255)

    DECLARE PrimaryKeyCursor CURSOR FOR

    SELECT DISTINCT
        '[' + kcu.CONSTRAINT_SCHEMA + '].[' + kcu.TABLE_NAME + ']' as fullqualifiedtablename,
        kcu.COLUMN_NAME as primarykeycolumn,
        kcu.TABLE_NAME as tablename
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    WHERE TABLE_SCHEMA LIKE '%DIMENSION%' AND CONSTRAINT_NAME LIKE '%PK%' AND LOWER(TABLE_NAME) NOT LIKE '%category%'

    OPEN PrimaryKeyCursor

    FETCH NEXT FROM PrimaryKeyCursor INTO  @FTableName, @PrimaryKey, @TableName

    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE [CH01-01-Fact].[Data] ADD CONSTRAINT FK_'+@TableName+' FOREIGN KEY (' + @PrimaryKey + ') REFERENCES ' + @FTableName + '(' + @PrimaryKey + ')'
        EXEC (@SQL)
        FETCH NEXT FROM PrimaryKeyCursor INTO @FTableName, @PrimaryKey, @TableName
    END

    CLOSE PrimaryKeyCursor
    DEALLOCATE PrimaryKeyCursor

    --Manual Constraints for DimProduct Table.
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD CONSTRAINT FK_DimProductSubcategory Foreign Key(ProductSubcategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductSubcategory](ProductSubcategoryKey)

    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]
    ADD CONSTRAINT FK_DimProductCategory Foreign Key(ProductCategoryKey)
    REFERENCES [CH01-01-Dimension].[DimProductCategory](ProductCategoryKey)

    
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Add Foreign Keys.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Add the PK Constraint.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_AddPkConstraint]
	@UserAuthorizationKey int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 
   
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]  ADD CONSTRAINT PK_CustomerKey PRIMARY KEY(CustomerKey);
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]  ADD CONSTRAINT PK_OccupationKey PRIMARY KEY(OccupationKey);
    ALTER TABLE [CH01-01-Dimension].[DimProduct]  ADD CONSTRAINT PK_ProductKey PRIMARY KEY(ProductKey);
    ALTER TABLE [CH01-01-Dimension].[DimTerritory]  ADD CONSTRAINT PK_TerritoryKey PRIMARY KEY(TerritoryKey);
    ALTER TABLE [CH01-01-Dimension].[SalesManagers]  ADD CONSTRAINT PK_SalesManagerKey PRIMARY KEY(SalesManagerKey);
    ALTER TABLE [CH01-01-Fact].[Data]  ADD CONSTRAINT PK_SalesKey PRIMARY KEY(SalesKey);

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Add PK Constraint.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Benjamin
-- Create date: 
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
-- GRANT DROP ON  ON SCHEMA:CH01-01-Fact TO sa

DROP PROCEDURE IF EXISTS [Project2].[DropForeignKeysFromStarSchemaData]

GO

CREATE PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData]
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

    --Manual Process for Dim.Product Table
    ALTER TABLE [CH01-01-Dimension].[DimProduct] DROP CONSTRAINT IF EXISTS FK_DimProductSubcategory;
    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] DROP CONSTRAINT IF EXISTS FK_DimProductCategory;

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
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Drops the PK Constraint.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_DropPkConstraint]
	@UserAuthorizationKey int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 
    -- List of tables where the column needs to be added
    DECLARE @tables TABLE (TableName NVARCHAR(128));
    INSERT INTO @tables (TableName)
    VALUES 
        ('DimCustomer'),
        ('DimOccupation'),
        ('DimProduct'),
        ('DimTerritory'),
        ('SalesManagers'),
        ('Data'),
        ('Fact');
      


    Declare @ConstraintName NVARCHAR(128), @TableName NVARCHAR(128), @SQL1 VARCHAR(MAX);

    DECLARE DropPkCursor CURSOR FOR 
    SELECT '['+kcu.TABLE_SCHEMA+'].['+kcu.TABLE_NAME+']' as [TableName], kcu.CONSTRAINT_NAME as [ConstrainName]
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
    WHERE kcu.CONSTRAINT_NAME LIKE '%PK%' AND kcu.TABLE_NAME IN (SELECT * FROM @tables)
    


    
    Open DropPkCursor 
    FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName

    WHILE @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL1 = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + '['+@ConstraintName+']'+';'
		EXEC(@SQL1)
        FETCH NEXT FROM DropPkCursor INTO @TableName, @ConstraintName
    END
    
    CLOSE DropPkCursor
	DEALLOCATE DropPkCursor

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Drop PK Constraints.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;

END;


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Arnan Khan
-- Create date: 11/16/2024
-- Description:	Reset Sequence Objects to Lowest Key
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[ResetSequenceObjects]
GO 

CREATE PROCEDURE [Project2].[ResetSequenceObjects]
	@UserAuthorizationKey int
AS 
BEGIN 
	SET NOCOUNT ON
	DECLARE SequenceObjectCursor CURSOR FOR
	SELECT DISTINCT 
		'[' + schema_name(schema_id) + '].[' + [name] + ']' as SequenceObjectName
	FROM sys.sequences
	

	OPEN SequenceObjectCursor
	DECLARE @SequenceObjectName NVARCHAR(255)
	DECLARE @SQL VARCHAR(MAX)

	FETCH NEXT FROM SequenceObjectCursor INTO @SequenceObjectName

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @SQL = 'ALTER SEQUENCE ' + @SequenceObjectName + ' RESTART WITH 1;'
		EXEC(@SQL)

		FETCH NEXT FROM SequenceObjectCursor INTO @SequenceObjectName
	END

	CLOSE SequenceObjectCursor

	DEALLOCATE SequenceObjectCursor

	EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Reset Sequence Objects.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = -1;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Project2].[ShowTableStatusRowCount] 
@UserAuthorizationKey INT,
@TableStatus VARCHAR(64)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimCustomer', COUNT(*) FROM [CH01-01-Dimension].DimCustomer
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimGender', COUNT(*) FROM [CH01-01-Dimension].DimGender
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimMaritalStatus', COUNT(*) FROM [CH01-01-Dimension].DimMaritalStatus
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOccupation', COUNT(*) FROM [CH01-01-Dimension].DimOccupation
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOrderDate', COUNT(*) FROM [CH01-01-Dimension].DimOrderDate
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProduct', COUNT(*) FROM [CH01-01-Dimension].DimProduct
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductCategory', COUNT(*) FROM [CH01-01-Dimension].DimProductCategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductSubcategory', COUNT(*) FROM [CH01-01-Dimension].DimProductSubcategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimTerritory', COUNT(*) FROM [CH01-01-Dimension].DimTerritory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.SalesManagers', COUNT(*) FROM [CH01-01-Dimension].SalesManagers
	select TableStatus = @TableStatus, TableName ='CH01-01-Fact.Data', COUNT(*) FROM [CH01-01-Fact].Data

	EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Show Table Status Row Count.',
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
-- Create date: 11/16/2024
-- Description:	Truncate Star Schema
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[TruncateStarSchemaData]
GO 

CREATE PROCEDURE [Project2].[TruncateStarSchemaData]
	@UserAuthorizationKey int
AS 
BEGIN 
	SET NOCOUNT ON
	DECLARE TableCursor CURSOR FOR
	SELECT DISTINCT 
		'[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' as FullyQualifiedTableName
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'Base Table' AND TABLE_SCHEMA LIKE '%CH01%'

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



-- =============================================
-- Author: Luis Diaz
-- Create date: 11/16/2024
-- Description: 
/* 
Stores procedure logs workflow steps into the Process.WorkFlowSteps
 table by inserting a description, user authorization key, 
 and the number of rows affected during a specific workflow step.
*/
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Process')
BEGIN
    EXEC('CREATE SCHEMA [Process]');
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	Adds all the required columns with the default.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_AddColumns]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 
    -- List of tables where the column needs to be added
    DECLARE @TableName VARCHAR(500), @SQL VARCHAR(MAX);
    DECLARE AddCursor CURSOR FOR

    SELECT DISTINCT
        '[' + t.TABLE_SCHEMA + '].[' + t.TABLE_NAME + ']' as fullqualifiedtablename
    FROM INFORMATION_SCHEMA.Tables as t
    WHERE TABLE_SCHEMA LIKE '%CH01%'

    OPEN AddCursor

    FETCH NEXT FROM AddCursor INTO  @TableName

    While @@FETCH_STATUS = 0
    BEGIN 
        SET @SQL = 'ALTER TABLE ' + @TableName + + 'ADD [UserAuthorizationKey] [int] NOT NULL;'
        EXEC (@SQL)
        FETCH NEXT FROM AddCursor INTO @TableName
    END

    CLOSE AddCursor
    DEALLOCATE AddCursor


    --Convert Keys to Sequence Objects
    ALTER TABLE [CH01-01-Dimension].[DimCustomer]
    ADD CustomerKey INT NOT NULL CONSTRAINT DF_DimCustomer_Key DEFAULT (NEXT VALUE FOR [PKSequence].[DimCustomerSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD OccupationKey INT NOT NULL CONSTRAINT DF_DimOccupation_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimOccupationSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD ProductKey INT NOT NULL CONSTRAINT DF_DimProduct_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimProductSequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[DimTerritory]
    ADD TerritoryKey INT NOT NULL CONSTRAINT DF_DimTerritory_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DimTerritorySequenceObject]);
    ALTER TABLE [CH01-01-Dimension].[SalesManagers]
    ADD SalesManagerKey INT NOT NULL CONSTRAINT DF_SalesManager_Key DEFAULT(NEXT VALUE FOR [PKSequence].[SalesManagersSequenceObject]);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD SalesKey INT NOT NULL CONSTRAINT DF_Sales_Key DEFAULT(NEXT VALUE FOR [PKSequence].[DataSequenceObject]);
    


    
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
CREATE OR ALTER PROCEDURE [Project2].[sp_AddGroupMembers]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	
--
-- Creates all the required Sequence Objects
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_CreateSO]

AS
BEGIN
    
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'PKSequence')
    BEGIN
        EXEC('CREATE SCHEMA [PKSequence]');
    END
    
    CREATE SEQUENCE [PKSequence].[DataSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
    
    CREATE SEQUENCE [PKSequence].[DimCustomerSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
    
   
    CREATE SEQUENCE [PKSequence].[DimOccupationSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
   
    CREATE SEQUENCE [PKSequence].[DimProductSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE 
    
    CREATE SEQUENCE [PKSequence].[DimProductCategorySequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
   
    CREATE SEQUENCE [PKSequence].[DimProductSubcategorySequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
   
    CREATE SEQUENCE [PKSequence].[DimTerritorySequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
 
    CREATE SEQUENCE [PKSequence].[SalesManagersSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE

  
    CREATE SEQUENCE [PKSequence].[WorkflowStepsSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
   
    CREATE SEQUENCE [PKSequence].[UserAuthorizationSequenceObject]
        AS int
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 2147483647
        NO CYCLE
        CACHE
  
END;


GO
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
CREATE OR ALTER PROCEDURE [Project2].[sp_CreateTables]
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
        WorkFlowStepKey INT NOT NULL CONSTRAINT [DF_WorkflowSteps_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[WorkflowStepsSequenceObject]), -- primary key
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
        UserAuthorizationKey INT NOT NULL CONSTRAINT [DF_UserAuthorization_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[UserAuthorizationSequenceObject]), -- primary key
        ClassTime nvarchar (5) Null Default'10:45',
        [Individual Project] nvarchar (60) null default 'PROJECT 2 RECREATE THE BICLASS DATABASE STAR SCHEMA',
        GroupMemberLastName nvarchar (35) NOT NULL,
        GroupMemberFirstName nvarchar (25) NOT NULL,
        GroupName nvarchar (20) NOT NULL default 'Group 1',
        DateAdded datetime2 null default(SYSDATETIME())
    )
   
    DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductCategory]
    CREATE TABLE [CH01-01-Dimension].[DimProductCategory](
        [ProductCategoryKey] [int] NOT NULL CONSTRAINT [DF_DimProductCategory_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[DimProductCategorySequenceObject]),
        [ProductCategory] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
        --[UserAuthorizationKey] [int] NOT NULL,
        [DateAdded] [datetime2] NULL CONSTRAINT [DF_DimProductCategory_DateAdded] DEFAULT (sysdatetime()),
        [DateofLastUpdate] [datetime2] NULL CONSTRAINT [DF_DimProductCategory_DateofLastUpdate] DEFAULT (sysdatetime()),
        CONSTRAINT [PK_DimProductCategory] PRIMARY KEY ([ProductCategoryKey])
    )
   
    DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductSubcategory]
    CREATE TABLE [CH01-01-Dimension].[DimProductSubcategory](
        [ProductSubcategoryKey] [int] NOT NULL CONSTRAINT [DF_DimProductSubcategory_Key] DEFAULT (NEXT VALUE FOR [PKSequence].[DimProductSubcategorySequenceObject]),
        [ProductCategoryKey] [int] NOT NULL,
        [ProductSubcategory] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
        --[UserAuthorizationKey] [int] NOT NULL,
        [DateAdded] [datetime2] NULL CONSTRAINT [DFT_DimProductSubcategory_DateAdded] DEFAULT (sysdatetime()),
        [DateofLastUpdate] [datetime2] NULL CONSTRAINT [DFT_DimProductSubcategory_DateofLastUpdate] DEFAULT (sysdatetime()),
        CONSTRAINT [PK_DimProductSubcategory] PRIMARY KEY ([ProductSubcategoryKey])
    )

END;


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	 Drops the columns that utilize identity keys.
--
-- 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_DropColumns]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
 

    ALTER TABLE [CH01-01-Dimension].[DimCustomer] DROP COLUMN CustomerKey
    ALTER TABLE [CH01-01-Dimension].[DimOccupation] DROP COLUMN OccupationKey
    ALTER TABLE [CH01-01-Dimension].[DimProduct] DROP COLUMN ProductKey
    ALTER TABLE [CH01-01-Dimension].[DimTerritory] DROP COLUMN TerritoryKey
    ALTER TABLE [CH01-01-Dimension].[SalesManagers] DROP COLUMN SalesManagerKey
    ALTER TABLE [CH01-01-Fact].[Data] DROP COLUMN SalesKey



END;


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnan Khan
-- Create date: 11/16/2024
-- Description:	
--
-- Gloabl Setup. Run this ONCE ONLY. 
--
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[sp_InitSetup]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    exec [Project2].[sp_CreateSO]
    exec [Project2].[sp_CreateTables]
    exec [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 2;
    exec [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 2;
    exec [Project2].[sp_DropPkConstraint] @UserAuthorizationKey = 2;
    exec [Project2].[sp_DropColumns]
    exec [Project2].[sp_AddColumns]
    exec [Project2].[sp_AddPkConstraint] @UserAuthorizationKey = 2;
    exec [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 2; 
    exec [Project2].[sp_AddGroupMembers]
    
END;


GO


exec [Project2].[sp_InitSetup]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Inderpreet Singh
-- Create date: 11/17/2024
-- Description: Loads data into the SalesManagers table.
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_SalesManagers]
GO
CREATE PROCEDURE [Project2].[Load_SalesManagers]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    INSERT INTO [CH01-01-Dimension].[SalesManagers] (
        Category,
        SalesManager,
        Office,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        ProductCategory, -- Adjust this according to the data
        SalesManager,
        CASE
            WHEN SalesManager LIKE N'Maurizio%' OR SalesManager LIKE N'Marco%' THEN 'Redmond'
            WHEN SalesManager LIKE N'Alberto%' OR SalesManager LIKE N'Luis%' THEN 'Seattle'
            ELSE 'Seattle'
        END AS Office,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT ProductCategory, SalesManager
        FROM [FileUpload].OriginallyLoadedData
    ) AS S;

    SET @WorkFlowStepTableRowCount = @@ROWCOUNT; -- Assigning a value to the variable

    EXEC [Process].[usp_TrackWorkFlow] 
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepDescription = 'Loading data into the SalesManager Table',
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Calling the stored procedure

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimTerritory table.
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[Load_DimTerritory]
GO
CREATE PROCEDURE [Project2].[Load_DimTerritory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    INSERT INTO [CH01-01-Dimension].[DimTerritory] (
        TerritoryGroup,
        TerritoryCountry,
        TerritoryRegion,
        UserAuthorizationKey
    )
    SELECT
        TerritoryGroup,
        TerritoryCountry,
        TerritoryRegion,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT 
            TerritoryGroup, 
            TerritoryCountry, 
            TerritoryRegion
        FROM [FileUpload].OriginallyLoadedData
    ) AS T;

    -- Assigning a value to the variable
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimTerritory Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:    Nafisul Islam, debugged by:Inderpreet Singh
-- Create date: 11/17/2024
-- Description: Loads data into the DimProductSubcategory table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project2].[Load_DimProductSubcategory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable
    
    -- Insert the data from the FileUpload
    INSERT INTO [CH01-01-Dimension].[DimProductSubcategory] (
        ProductSubcategory,
        ProductCategoryKey,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        OLD.ProductSubcategory,
        OLD.ProductCategoryKey,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT d.ProductSubcategory, c.ProductCategoryKey
        FROM [FileUpload].OriginallyLoadedData d
        INNER JOIN [CH01-01-Dimension].DimProductCategory c ON d.ProductCategory = c.ProductCategory      
    ) AS OLD;

    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProductSubcategory Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount;

END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimProductCategory table.
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductCategory]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable


    -- Insert data into DimProductCategory table
    INSERT INTO [CH01-01-Dimension].[DimProductCategory] (
        ProductCategory,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        new.ProductCategory,
        @UserAuthorizationKey
    FROM (

        SELECT DISTINCT
            old.ProductCategory
            FROM [FileUpload].OriginallyLoadedData AS old 
        )AS new;

    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProductSubcategory Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Nafisul Islam
-- Create date: 11/17/2024
-- Description: Loads data into the DimProduct table.
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProduct]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WorkFlowStepTableRowCount INT; -- Declaring the variable

    -- Insert data into DimProduct table
    INSERT INTO [CH01-01-Dimension].[DimProduct] (
        ProductSubcategoryKey,
        ProductCategory,
        ProductSubcategory,
        ProductCode,
        ProductName,
        Color,
        ModelName,
        UserAuthorizationKey
    )
    SELECT DISTINCT
        new.ProductSubcategoryKey,
        new.ProductCategory,
        new.ProductSubcategory,
        new.ProductCode,
        new.ProductName,
        new.Color,
        new.ModelName,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT
            dps.ProductSubcategoryKey,
            dpc.ProductCategory,
            dps.ProductSubcategory,
            ProductCode,
            ProductName,
            Color,
            ModelName
        FROM [FileUpload].OriginallyLoadedData AS old
        INNER JOIN [CH01-01-Dimension].[DimProductCategory] AS dpc ON old.ProductCategory = dpc.ProductCategory
        INNER JOIN [CH01-01-Dimension].[DimProductSubcategory] as dps ON old.ProductSubcategory = dps.ProductSubcategory
    ) AS new;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow] 
        @WorkFlowStepDescription = 'Loading data into the DimProduct Table',
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @WorkFlowStepTableRowCount; -- Use the variable in EXEC statement

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/17/2024
-- Description:	Recreates DimOrderDate table.
-- =============================================
IF NOT EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'CH01-01-Dimension'
	    AND TABLE_NAME = 'DimOrderDate'
	   AND COLUMN_NAME = 'UserAuthorizationKey'
)
BEGIN
    ALTER TABLE [CH01-01-Dimension].[DimOrderDate]
    ADD [UserAuthorizationKey] INT NULL;
END;

DROP PROCEDURE IF EXISTS [Project2].[Load_DimOrderDate];
GO
CREATE PROCEDURE [Project2].[Load_DimOrderDate]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimOrderDate] (
	    OrderDate,
	    MonthName,
	    MonthNumber,
	    [Year],
	    UserAuthorizationKey
    )
    SELECT DISTINCT
        OrderDate,
        MonthName,
        MonthNumber,
        [Year],
        @UserAuthorizationKey
    FROM [FileUpload].OriginallyLoadedData;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC Process.usp_TrackWorkFlow 
        @WorkFlowStepDescription = 'Loading OrderDate data into DimOrderDate table', 
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/16/2024
-- Description:	Recreates the DimOccupation table with a Sequence Object as a key.
-- =============================================
IF NOT EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'CH01-01-Dimension'
	    AND TABLE_NAME = 'DimOccupation'
	   AND COLUMN_NAME = 'UserAuthorizationKey'
)
BEGIN
    ALTER TABLE [CH01-01-Dimension].[DimOccupation]
    ADD [UserAuthorizationKey] INT NULL;
END;

DROP PROCEDURE IF EXISTS [Project2].[Load_DimOccupation];
GO
CREATE PROCEDURE [Project2].[Load_DimOccupation]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimOccupation] (
	    Occupation,
	    UserAuthorizationKey
    )
    SELECT
        O.Occupation,
        @UserAuthorizationKey
    FROM (
	SELECT DISTINCT Occupation
        FROM FileUpload.OriginallyLoadedData
    ) AS O;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading data into the DimOccupation Table', 
        @UserAuthorizationKey = @UserAuthorizationKey, 
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Dillon Chen
-- Create date: 11/16/2024
-- Description:	Provides the full descriptive name of the marital status character.
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_DimMaritalStatus];
GO
CREATE PROCEDURE [Project2].[Load_DimMaritalStatus]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimMaritalStatus] (
		MaritalStatus,
		MaritalStatusDescription,
		UserAuthorizationKey
    )
    SELECT DISTINCT 
	OLD.MaritalStatus,
	CASE
            WHEN OLD.MaritalStatus = 'M' THEN 'Married'
            WHEN OLD.MaritalStatus = 'S' THEN 'Single'
        END AS MaritalStatusDescription,
        @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
		@WorkFlowStepDescription =  'Loading Data into the DimMaritalStatus Table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @@ROWCOUNT;

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Dillon Chen
-- Create date: 11/16/2024
-- Description:	Provides the full descriptive name of the gender character.
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_DimGender];
GO

CREATE PROCEDURE [Project2].[Load_DimGender]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE @WorkFlowStepTableRowCount INT;
    INSERT INTO [CH01-01-Dimension].[DimGender] (
        Gender,
        GenderDescription,
        UserAuthorizationKey
    )
    SELECT DISTINCT OLD.Gender,
        CASE
            WHEN OLD.Gender = 'M' THEN 'Male'
            WHEN OLD.Gender = 'F' THEN 'Female'
        END AS GenderDescription,
        @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading Gender data into Gender Table',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Load DimCustomers table
--
-- @GroupMemberUserAuthorizationKey is the 
-- UserAuthorizationKey of the Group Member who completed 
-- this stored procedure.
--
-- =============================================

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     DROP COLUMN IF EXISTS [UserAuthorizationKey]

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     ADD [UserAuthorizationKey] INT NULL

DROP PROCEDURE IF EXISTS [Project2].[Load_DimCustomer]
GO

CREATE PROCEDURE [Project2].[Load_DimCustomer]
    @UserAuthorizationKey INT
AS
BEGIN 
    SET NOCOUNT ON
    DECLARE @WorkFlowStepTableRowCount INT

    INSERT INTO [CH01-01-Dimension].[DimCustomer] 
    (
        CustomerName, UserAuthorizationKey
    )
    SELECT 
        new.CustomerName,
        @UserAuthorizationKey
    FROM (
        SELECT DISTINCT 
        old.CustomerName
        FROM FileUpload.OriginallyLoadedData as old
    ) as new

    -- get rowcount of modified dimcustomer talbe
    SELECT @WorkFlowStepTableRowCount = @@ROWCOUNT;

    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Loading Customer into the DimCustomer Table.',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @@ROWCOUNT;
END
GO




