CREATE PROCEDURE [dbo].[uspGetBillingFrequency]
	
AS
Begin
	Select PKID,Frequency From tblBillingFrequency Order by PKID
End
