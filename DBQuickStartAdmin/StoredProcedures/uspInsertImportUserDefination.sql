CREATE PROCEDURE [dbo].[uspInsertImportUserDefination]
	@PKID					Bigint,
	@DefinationName			Varchar(50),
	@FKImportMasterID		Bigint,
	@UploadExt				Varchar(50),
	@DefXML					XML,
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint
	
AS
Begin
if(@PKID=0)
Begin
 Insert into tblImportUserDef(DefinationName, FKImportMasterID, UploadExt, DefXML, FKCompanyID, FKCreatedBy, CreationDate)
 values(@DefinationName, @FKImportMasterID, @UploadExt, @DefXML, @FKCompanyID, @FKUserID, GETUTCDATE())
End
Else
Begin
	Update tblImportUserDef Set DefinationName=@DefinationName, FKImportMasterID=@FKImportMasterID, UploadExt=@UploadExt, DefXML=@DefXML,FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
	Where PKID=@PKID
End
End
