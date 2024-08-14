CREATE PROCEDURE [dbo].[uspGetImportLog]
	@PKImportID Bigint=0,
	@FKImportTypeID	Bigint=0,
	@FKCompanyID Bigint=0,
	@FKBranchID	Bigint=0,	
	@FileType Varchar(50)='',
	@FKUserID Bigint,
	@DataType Varchar(50)
AS
Begin
	Declare @FKTimezoneID Bigint
	SElect @FKTimezoneID=FKTimezoneID from tblCompany Where PKCompanyID=@FKCompanyID
	Select 1 as Result,A.PKID, A.FKImportMasterID, A.FileType, A.SavedFileName, A.OriginalFileName, A.DefinationXML, A.TotalCount, A.ApproveCount, A.ErrorCount, A.FKCreatedBy, A.FKLastModifiedBy, A.CreationDate, 
	U.FName as CreatedByName,U1.FName as ModifiedByName,UT.ImportName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@FKUserID,'dt') as CreationDataLocal
	From tblImportLog A
	
	Left Join tblUser U  on A.FKCreatedBy=U.PKUserID
	Left Join tblUser U1 on A.FKLastModifiedBy=U1.PKUserID
	Left Join tblImportMaster UT on A.FKImportMasterID=UT.PKID
	Where a.BStatus=1 And A.FKCompanyID=@FKCompanyID  And (A.FKBranchID=@FKBranchID or @FKBranchID=0)
	And (A.PKID=@PKImportID OR @PKImportID=0)
	And (A.FileType=@FileType OR @FileType='')

	if(@PKImportID<>0)
	Begin
		if(@DataType='')
		Begin
			Select SubmitedRecXML,ApprovedRecXML,ErrorRecXML
			From tblImportLog
			Where PKID=@PKImportID
		End
		Else if(@DataType='Total')
		Begin
			Select SubmitedRecXML
			From tblImportLog
			Where PKID=@PKImportID
		End
		Else if(@DataType='Approve')
		Begin
			Select ApprovedRecXML
			From tblImportLog
			Where PKID=@PKImportID
		End
		Else if(@DataType='Error')
		Begin
			Select ErrorRecXML
			From tblImportLog
			Where PKID=@PKImportID
		End
			
	End
End
