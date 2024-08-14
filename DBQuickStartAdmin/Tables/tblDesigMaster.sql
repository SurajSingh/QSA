CREATE TABLE [dbo].[tblDesigMaster]
(
	PKDesigID	Bigint			Not Null,
	DesigName	Varchar(50)		Not Null,
	DesigDesc	Varchar(200)	Not Null,
	FKCompanyID	Bigint,	
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime,
	BStatus		Bit				Default 1
)
