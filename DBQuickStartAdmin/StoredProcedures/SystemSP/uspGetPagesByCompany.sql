CREATE PROCEDURE [dbo].[uspGetPagesByCompany]
	@FKCompany	Bigint,
	@OrgType   Varchar(50)
AS
Begin
	Select A.PKPageID,A.PageName,A.PageLink,A.FKParentID,Isnull(C.PageName,'') as ParentName From tblPageMaster A	
	Left Join tblPageMaster C on A.FKParentID=C.PKPageID
	where A.RecType=@OrgType
	Order By FKParentID,A.SNo

	
End
