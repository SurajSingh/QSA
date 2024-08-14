CREATE PROCEDURE [dbo].[uspGetEmpForAutoComplate]	
	@PKID     Bigint,
	@ActiveStatus Varchar(50),
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,A.PKUserID as PKID,'<div class="colw1">'+A.LoginID+'</div><div class="colw3">'+A.FName+' '+A.LName+'</div><div class="colw1">'+A.ActiveStatus+'</div>' as [label],A.FName+' '+A.LName as  label1
	FRom tblUser A where A.FKCompanyID=@FKCompanyID
	and (A.PKUserID=@PKID Or @PKID=0)
	And (A.ActiveStatus=@ActiveStatus or @ActiveStatus='' Or (@ActiveStatus='ForAppointment' and A.IsAppointment=1 and A.ActiveStatus='Active'))
	Order By A.LoginID,A.FName+' '+A.LName
End