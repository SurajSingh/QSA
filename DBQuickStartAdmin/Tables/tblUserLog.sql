CREATE TABLE [dbo].[tblUserLog]
(
	PKID		Bigint Identity(1,1)		Not Null,
	FKUserID	Bigint		Not Null,
	FKPageID	Bigint		Not Null,
	IPAddress	Varchar(50),
	[FKID]		Bigint,
	LogDate		DateTime,
	Operation	Varchar(100)	
)