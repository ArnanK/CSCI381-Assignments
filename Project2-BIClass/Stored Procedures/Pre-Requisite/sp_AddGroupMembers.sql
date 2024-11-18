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
