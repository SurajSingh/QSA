CREATE PROCEDURE [dbo].[uspInsertImportLog]	
	@FKImportMasterID			Bigint,
	@FileType				Varchar(50),
	@SavedFileName			Varchar(100),
	@OriginalFileName		Varchar(100),
	@DefinationXML			XML,
	@SubmitedRecXML			XML,
	@ApprovedRecXML			XML,
	@ErrorRecXML				XML,
	@TotalCount				Bigint,
	@ApproveCount			Bigint,
	@ErrorCount				Bigint,
	@FKUserID				Bigint,
	@FKCompanyID				Bigint,
	@FKBranchID				Bigint,	
	@PKImportID				Bigint Output
	
	
AS
Begin
		Exec uspGetNewID 'tblImportLog','PKID',@PKImportID output
		
		Insert into tblImportLog(PKID, FKImportMasterID, FileType, SavedFileName, OriginalFileName, DefinationXML, SubmitedRecXML, ApprovedRecXML, ErrorRecXML, TotalCount, ApproveCount, ErrorCount, FKCreatedBy, FKLastModifiedBy, CreationDate, FKCompanyID,FKBranchID)
		values(@PKImportID, @FKImportMasterID, @FileType, @SavedFileName, @OriginalFileName, @DefinationXML, @SubmitedRecXML, @ApprovedRecXML, @ErrorRecXML, @TotalCount, @ApproveCount, @ErrorCount, @FKUserID, @FKUserID, GETUTCDATE(),@FKCompanyID,@FKBranchID)
		return
End