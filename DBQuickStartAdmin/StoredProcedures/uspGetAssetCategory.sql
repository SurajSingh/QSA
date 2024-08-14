CREATE PROCEDURE [dbo].[uspGetAssetCategory]
@PKID			Bigint,
@CategCode		Varchar(50),
@FKCompanyID	Bigint
AS
Begin
	Select RCount = COUNT(*) OVER(),1 as Result,PKID,CategCode,CategName,CategDesc
	From tblAssetCategory Where FKCompanyID=@FKCompanyID
	And (PKID=@PKID Or @PKID=0)
	And (CategCode=@CategCode Or @CategCode='')
	Order By CategName

End