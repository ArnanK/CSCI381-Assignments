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
    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Benjamin', 'Zhong');

    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Arnan', 'Khan');

    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Luis', 'Diaz');

    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Nafisul', 'Islam');

    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Dillon', 'Chen');

    INSERT INTO DbSecurity.UserAuthorization(GroupMemberFirstName, GroupMemberLastName)
    VALUES('Inderpreet', 'Singh');



END;


GO
