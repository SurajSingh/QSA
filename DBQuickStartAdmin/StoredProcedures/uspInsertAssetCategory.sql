CREATE PROCEDURE [dbo].[uspInsertAssetCategory]
	@PKID				Bigint,
	@CategCode			Varchar(50),
	@CategName			Varchar(50),
	@CategDesc			Varchar(max),
	@FKCompanyID		Bigint,
	@FKUserID			Bigint,
	@FKPageID			Bigint=0,
	@IPAddress			Varchar(50)
	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(50)
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		Declare @Count Bigint
		
		Select @Count=Count(*) From tblAssetCategory where CategCode=@CategCode And FKCompanyID=@FKCompanyID And (PKID<>@PKID)
		
		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Code Already Exists'
		End

	

	If(@Result=1)
	Begin
		

		If(@PKID=0)
		Begin
				Exec uspGetNewID 'tblAssetCategory','PKID',@PKID output
				Insert Into tblAssetCategory(PKID, CategCode, CategName,CategDesc,FKCompanyID,CreationDate,ModificationDate)
				Values(@PKID, @CategCode, @CategName,@CategDesc,  @FKCompanyID,GETUTCDATE(),null)
				Set @Operation='New Asset Category '+@CategName+' Added'
		End
		Else
		Begin
				Update tblAssetCategory Set  CategCode=@CategCode, CategName=@CategName,CategDesc=@CategDesc,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Asset Category '+@CategName+' Updated'
		End
	End

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
	End
		
	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH		
		ROLLBACK TRANSACTION
			
			Set @Result=0
			Set @Msg = ERROR_MESSAGE()	
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End


