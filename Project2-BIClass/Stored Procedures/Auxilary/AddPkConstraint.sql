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
