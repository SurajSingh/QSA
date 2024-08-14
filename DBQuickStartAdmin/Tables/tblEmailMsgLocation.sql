CREATE TABLE [dbo].[tblEmailMsgLocation]
(
	PKID			Bigint Not Null,
	LocationName	Varchar(50),
	IsEmail			Bit,
	IsMsg			Bit,
	BStatus			Bit
)
