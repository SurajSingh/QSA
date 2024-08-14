CREATE PROCEDURE [dbo].[uspGetWorkTypeMaster]
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,PKID,WorkType From tblWorkTypeMaster
	Where FKCompanyID=@FKCompanyID
End