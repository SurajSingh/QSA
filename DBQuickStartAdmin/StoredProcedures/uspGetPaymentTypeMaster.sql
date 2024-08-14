CREATE PROCEDURE [dbo].[uspGetPaymentTypeMaster]
	
AS
Begin
	Select * From tblPaymentType Order by PKID
End
