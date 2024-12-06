USE [QueensClassSchedule]
exec dbo.[create-schema];

exec dbo.[create-udt]

exec dbo.[create-seq]



exec [Project3].[create-init-tables]

exec [Project3].[add-group-members]


SELECT *
FROM [DbSecurity].UserAuthorization

exec [Project3].[CreateBuildingTable] @UserAuthorizationKey = 1 
exec [Project3].[CreateClassDetailsTable] @UserAuthorizationKey = 1
exec [Project3].[CreateInstructorTable] @UserAuthorizationKey = 5 
exec [Project3].[CreateModeOfInstructionTable] @UserAuthorizationKey = 5
exec [Project3].[CreateRoomBuildingTable] @UserAuthorizationKey = 1
exec [Project3].[CreateRoomTable] @UserAuthorizationKey = 1
exec [Project3].[CreateScheduleTable] @UserAuthorizationKey = 1
exec [Project3].[CreateSectionTable] @UserAuthorizationKey = 4
exec [Project3].[CreateDepartmentTable] @UserAuthorizationKey = 2
exec [Project3].[CreateInstructorDeptTable] @UserAuthorizationKey = 2
exec [Project3].[CreateSemesterTable] @UserAuthorizationKey = 3
exec [Project3].[CreateCourseModeTable] @UserAuthorizationKey = 4
exec [Project3].[CreateCourseTable] @UserAuthorizationKey = 5


exec [Project3].[CreateClassTable] @UserAuthorizationKey = 2


exec [Project3].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 2
exec [Project3].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 2

exec [Project3].[TruncateStarSchemaData] @UserAuthorizationKey = 1
