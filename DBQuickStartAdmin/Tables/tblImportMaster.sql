CREATE TABLE [dbo].[tblImportMaster]
(
	PKID			Bigint Not Null,
	ImportName		Varchar(50),
	ImportType		Varchar(1),
	ImportCols		XML,
	BStatus			Bit 
)
