CREATE PROCEDURE [dbo].[uspSaveCompanyPage]
	@FKCompanyID Bigint,
	@PageStr Varchar(max)=''
AS
Begin
	Delete From tblCompanyPages Where FKCompanyID=@FKCompanyID
	Insert Into tblCompanyPages(FKPageID,FKCompanyID)
	Select Item,@FKCompanyID From dbo.FunSplitString(@PageStr,'#') A
	Where A.Item<>''
	Select 1 as Result
End