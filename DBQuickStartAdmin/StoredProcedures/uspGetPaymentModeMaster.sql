CREATE PROCEDURE [dbo].[uspGetPaymentModeMaster]
	
AS
Begin
	Select * From tblPayModeMaster Order By PKID
End