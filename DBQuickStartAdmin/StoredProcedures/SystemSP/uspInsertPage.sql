CREATE PROCEDURE [dbo].[uspInsertPage]
	@PKPageID	Bigint,
	@SNo	Bigint,
	@FKParentID	Bigint,
	@PageName	Varchar(500),
	@PageLink	Varchar(500),
	@QueryString	Varchar(200),
	@IconHTML	Varchar(100),
	@BStatus	Bit=1,
	@IsPageLink Bit=1,
	@RecType		Varchar(10)

AS
Begin
	if Exists(Select PKPageID From tblPageMaster Where PKPageID=@PKPageID)
	Begin
		Update tblPageMaster Set PageName=@PageName,PageLink=@PageLink,QueryString=@QueryString,SNo=@SNo,
		FKParentID=@FKParentID,BStatus=@BStatus,IconHTML=@IconHTML,IsPageLink=@IsPageLink,RecType=@RecType
		Where PKPageID=@PKPageID
	End
	Else
	Begin
		Insert Into tblPageMaster(PKPageID,PageName,PageLink,QueryString,SNo,FKParentID,BStatus,IconHTML,IsPageLink,RecType) 
		Values(@PKPageID,@PageName,@PageLink,@QueryString,@SNo,@FKParentID,@BStatus,@IconHTML,@IsPageLink,@RecType)
	End
End