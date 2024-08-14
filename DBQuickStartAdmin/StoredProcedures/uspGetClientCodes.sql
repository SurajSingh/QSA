CREATE PROCEDURE [dbo].[uspGetClientCodes]
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @StrQry1 NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	
	Set @StrQry=N'	select c1.code as clientCode, c1.Company as clientName From tblClient c1'
	
	EXEC sp_executesql @StrQry
	

End

