CREATE PROCEDURE [dbo].[uspDeleteDesignMaster]
	@PKID			Bigint,	
	@FKCompanyID	Bigint,	
	@FKUserID		Bigint,
	@FKPageID		Bigint=0,
	@IPAddress		Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @count Bigint
	if(@PKID<>0)
	Begin
			Select @count=count(PKDesigID) From tblDesigMaster 
			Where PKDesigID=@PKID And FKCompanyID=@FKCompanyID
			if(@Count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation'
			End
	End
	

	if(@Result=1)
	Begin
		Select @Operation=DesigName From tblDesigMaster Where PKDesigID=@PKID
		Delete From tblDesigMaster Where  PKDesigID=@PKID and FKCompanyID=@FKCompanyID
		Set @Operation='Design '+@Operation+' deleted'
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			Set @Result=0
				Set @Msg = ERROR_MESSAGE()
				Declare @SPName Varchar(50)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog @FKUserID,'SP',@SPName		
				select @Result as Result,@Msg as Msg
	END CATCH
End



