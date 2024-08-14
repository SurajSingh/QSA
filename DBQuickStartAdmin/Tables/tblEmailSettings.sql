CREATE TABLE [dbo].[tblEmailSettings]
(
	FKCompanyID		Bigint, 
	SenderEmail		Varchar(200),
	SenderPWD		Varchar(500),
	SMTPServer		Varchar(50),
	SMTPPort		Bigint,
	EnableSSL		Bit
)
