USE [QueensClassSchedule]
exec dbo.[create-schema];

exec dbo.[create-udt]

exec dbo.[create-seq]



exec [Project3].[CreateBuildingTable] @UserAuthorizationKey =1 
exec [Project3].[CreateClassDetailsTable] @UserAuthorizationKey =1
exec [Project3].[CreateInstructorTable] @UserAuthorizationKey =1 
exec [Project3].[CreateModeOfInstructionTable] @UserAuthorizationKey =1
exec [Project3].[CreateRoomBuildingTable] @UserAuthorizationKey =1
exec [Project3].[CreateRoomTable] @UserAuthorizationKey =1
exec [Project3].[CreateScheduleTable] @UserAuthorizationKey =1
exec [Project3].[CreateSectionTable] @UserAuthorizationKey =1