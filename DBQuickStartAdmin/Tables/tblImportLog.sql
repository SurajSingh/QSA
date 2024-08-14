CREATE TABLE [dbo].[tblImportLog]
(
	PKID					Bigint Not Null,
	FKImportMasterID		Bigint,
	FileType				Varchar(50),
	SavedFileName			Varchar(100),
	OriginalFileName		Varchar(100),
	DefinationXML			XML,
	SubmitedRecXML			XML,
	ApprovedRecXML			XML,
	ErrorRecXML				XML,
	TotalCount				Bigint,
	ApproveCount			Bigint,
	ErrorCount				Bigint,
	FKBranchID				Bigint,
	FKCompanyID				Bigint,	
	FKCreatedBy				Bigint,
	FKLastModifiedBy		Bigint,	
	CreationDate			DateTime	Not Null,
	ModificationDate		DateTime,
	BStatus					Bit	Not Null Default 1	

)
