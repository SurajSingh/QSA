CREATE PROCEDURE [dbo].[uspGetEmailSettings]
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,A.SenderEmail,A.SenderPWD,A.SMTPPort,A.SMTPServer,A.EnableSSL,B.CompanyName,B.LogoURL
	From tblEmailSettings A 
	Left JOin tblCompany B on A.FKCompanyID=B.PKCompanyID
	Where A.FKCompanyID=@FKCompanyID
End
