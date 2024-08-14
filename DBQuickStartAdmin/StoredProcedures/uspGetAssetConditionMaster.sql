CREATE PROCEDURE [dbo].[uspGetAssetConditionMaster]
	
AS
Begin
	Select 1 as Result,PKID,Condition From tblAssetConditionMaster where BStatus=1 Order By PKID
End
