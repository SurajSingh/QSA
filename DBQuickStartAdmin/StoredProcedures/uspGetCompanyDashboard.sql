CREATE PROCEDURE [dbo].[uspGetCompanyDashboard]
	@FKCompanyID Bigint	
AS
Begin
	Declare @Dashboard Varchar(max)=''

	Select @Dashboard=KayVal FRom tblConfiguration Where KayName='Dashboard' and FKCompanyID=@FKCompanyID
	Set @Dashboard=Isnull(@Dashboard,'')
	Select 1 as Result,PKID,DisplayName,PageURL From tblDashboard where (@Dashboard='' Or PKID in (Select Item from dbo.FunSplitString(@Dashboard,',') where Item<>''))
End
