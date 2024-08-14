CREATE TABLE [dbo].[tblImportUserDef]
(
	PKID					Bigint Identity(1,1) Not Null,
	DefinationName			Varchar(50),
	FKImportMasterID		Bigint,
	UploadExt				Varchar(50),
	DefXML					XML,
	FKCompanyID				Bigint,	
	FKCreatedBy				Bigint,
	FKLastModifiedBy		Bigint,	
	CreationDate			DateTime	Not Null,
	ModificationDate		DateTime
)
