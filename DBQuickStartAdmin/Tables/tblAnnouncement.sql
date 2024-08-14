CREATE TABLE [dbo].[tblAnnouncement]
(
	PKID				Bigint				Not Null,
	Title				Varchar(500)		Not Null,
	DisplayDate			Date	            Not Null, 
	Announcement		NVarchar(2000)	    Not Null,
	ActiveStatus		Varchar(50) Default 'Active',
	FKCompanyID			Bigint,	
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime,
	BStatus		Bit				Default 1
)
