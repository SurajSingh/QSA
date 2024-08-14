CREATE PROCEDURE [dbo].[uspGetLocationMaster]
	
AS
Begin
	Select 1 as Result,PKID,LocationName From tblLocationMaster where BStatus=1 Order By PKID
End

