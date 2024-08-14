CREATE PROCEDURE [dbo].[uspGetClientForAutoComplete]
	@PKID     Bigint,
	@ActiveStatus Varchar(50),
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,A.PKID as PKID,'<div class="colw1">'+A.Code+'</div><div class="colw3">'+A.Company+'</div><div class="colw1">'+A.ActiveStatus+'</div>' as [label],A.Company as  label1,
	Isnull(A.FKManagerID,0) as FKManagerID,Isnull(B.FName+' '+B.LName,'') as ManagerName,A.Balance,A.Retainer
	FRom tblClient A 
	Left Join tblUser B on A.FKManagerID=B.PKUserID
	where A.FKCompanyID=@FKCompanyID

	and (A.PKID=@PKID Or @PKID=0)
	And (A.ActiveStatus=@ActiveStatus or @ActiveStatus='')
	Order By A.Code,A.Company
End