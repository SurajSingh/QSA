CREATE PROCEDURE [dbo].[uspInsertEmailSettings]
	@FKCompanyID		Bigint, 
	@SenderEmail		Varchar(200),
	@SenderPWD			Varchar(500),
	@SMTPServer			Varchar(50),
	@SMTPPort			Bigint,
	@EnableSSL			Bit
AS
Begin
	If Exists(Select FKCompanyID From tblEmailSettings where FKCompanyID=@FKCompanyID)
	Begin
		Update tblEmailSettings Set SenderEmail=@SenderEmail,SenderPWD=@SenderPWD,SMTPServer=@SMTPServer,SMTPPort=@SMTPPort,EnableSSL=@EnableSSL
		Where FKCompanyID=@FKCompanyID
	End
	Else
	Begin
		Insert Into tblEmailSettings(FKCompanyID,SenderEmail,SenderPWD,SMTPServer,SMTPPort,EnableSSL)
		Values(@FKCompanyID,@SenderEmail,@SenderPWD,@SMTPServer,@SMTPPort,@EnableSSL)
	End

	Select 1 as Result,'' as Msg
End