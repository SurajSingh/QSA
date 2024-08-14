create PROCEDURE [dbo].[uspGetClientCodesWithTask]
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @StrQry1 NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	--Declare @DateForStr Varchar(50)
	--Declare @FKTimezoneID Bigint	
	--Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'	select Distinct d.TaskCode, d.TaskName,d.Description  From tblTimeSheet
	A
	
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID'
	
	Set @StrQry1=N'	select c1.code as clientCode, c1.Company as clientName From tblClient c1'
	
	EXEC sp_executesql @StrQry1
	EXEC sp_executesql @StrQry
	

End