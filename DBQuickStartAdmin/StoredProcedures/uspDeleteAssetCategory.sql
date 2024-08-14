CREATE PROCEDURE [dbo].[uspDeleteAssetCategory]
	@PKID	Bigint,	
	@FKCompanyID	Bigint,	
	@FKUserID	Bigint,
	@FKPageID	Bigint=0,
	@IPAddress	Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(50)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @count Bigint
	Select @count=count(*) From tblAssetCategory Where  PKID=@PKID and FKCompanyID=@FKCompanyID
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End

	If(@Result=1)
	Begin
		Select @count=count(*) From tblAsset Where  FKCategoryID=@PKID and FKCompanyID=@FKCompanyID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Unable to delete, Associated with the asset.'
		End
	End
	if(@Result=1)
	Begin
		SElect @Operation=CategName From tblAssetCategory Where PKID=@PKID
		Delete From tblAssetCategory Where  PKID=@PKID
		Set @Operation='Asset Category '+@Operation+' deleted'
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			Set @ErrorCount=@ErrorCount+1
			Set @Result=0
			Set @Msg = ERROR_MESSAGE()
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName			
			select @Result as Result,@Msg as Msg
	END CATCH
End

