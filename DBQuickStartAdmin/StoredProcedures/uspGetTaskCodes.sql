CREATE PROCEDURE [dbo].[uspGetTaskCodes]
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @StrQry1 NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	
	
	Set @StrQry=N'	select d.TaskCode, d.TaskName,d.Description  From tblTask d'
	
	EXEC sp_executesql @StrQry
	

End



