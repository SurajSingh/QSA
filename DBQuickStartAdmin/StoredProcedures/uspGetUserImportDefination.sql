CREATE PROCEDURE [dbo].[uspGetUserImportDefination]
	@PKID			Bigint,
	@FKImportMasterID Bigint,
	@UploadExt		Varchar(50),
	@FKCompanyID		Bigint,	
	@FKUserID		Bigint
AS
Begin
	
	Select PKID,DefinationName,FKImportMasterID,UploadExt,Case When @PKID=0 Then null else DefXML end as DefXML
	From tblImportUserDef
	Where (FKCompanyID=@FKCompanyID)
	And FKImportMasterID=@FKImportMasterID
	And (UploadExt=@UploadExt Or @UploadExt='')
	And (PKID=@PKID Or @PKID=0)
	Order by CreationDate Desc
End
