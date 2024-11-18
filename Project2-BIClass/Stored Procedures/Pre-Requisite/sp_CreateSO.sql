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
