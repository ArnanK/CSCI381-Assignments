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
