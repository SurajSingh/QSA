CREATE PROCEDURE [dbo].[uspGetPaymentTerm]
@PKID			Bigint,
@FKCompanyID	Bigint
AS
Begin
	Select 1 as Result,PKID,TermTitle,PayTerm,GraceDays
	From tblPaymentTerm Where FKCompanyID=@FKCompanyID
	And (PKID=@PKID Or @PKID=0) and BStatus=1
	Order By TermTitle

End
