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
    exec [Project2].[sp_CreateTables]
    exec [Project2].[sp_CreateSO]


END;


GO
