CREATE TABLE [dbo].[tblTableLayout]
(
	PKID				Bigint Identity(1,1) Not Null,
	FKPageID			Bigint,
	TableID				Varchar(50),
	XMLDef				XML,
	FKCompanyID			Bigint,
	FKUserID			Bigint,	
	ForAllUser			Bit,
	CreationDate		DateTime,
	ModificationDate	DateTime,
	BStatus				Bit	Default 1
)
