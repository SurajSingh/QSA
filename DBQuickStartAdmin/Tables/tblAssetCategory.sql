CREATE TABLE [dbo].[tblAssetCategory]
(
	PKID				Bigint Not Null,
	CategCode			Varchar(50),
	CategName			Varchar(50),
	CategDesc			Varchar(max),
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime
)
