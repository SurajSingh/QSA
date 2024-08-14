CREATE TABLE [dbo].[tblPage]
(
	PKID		Bigint Not Null,
	PageName	Varchar(50),
	PageAlies	Varchar(50),
	BStatus		Bit Default 1
)
