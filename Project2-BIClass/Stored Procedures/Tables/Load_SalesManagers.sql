SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [Project2].[Load_SalesManagers] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO [CH01-01-Dimension].SalesManagers
	(
		SalesManagerKey,
		Category,
		SalesManager,
		Office
	)
	SELECT DISTINCT
		SalesManagerKey,
		old.ProductCategory,
		SalesManager,
		Office = CASE
					 WHEN old.SalesManager LIKE 'Marco%' THEN
						 'Redmond'
					 WHEN old.SalesManager LIKE 'Alberto%' THEN
						 'Seattle'
					 WHEN old.SalesManager LIKE 'Maurizio%' THEN
						 'Redmond'
					 ELSE
						 'Seattle'
				 END
	FROM FileUpload.OriginallyLoadedData AS old
	ORDER BY old.SalesManagerKey;
END
GO
