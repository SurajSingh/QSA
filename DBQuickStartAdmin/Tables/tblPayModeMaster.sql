CREATE TABLE [dbo].[tblPayModeMaster]
(
	PKID		Bigint Not Null,
	PaymentMode Varchar(50),
	PayType		Varchar(2),
	BStatus		Bit Default 1
)
