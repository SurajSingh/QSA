CREATE PROCEDURE [dbo].[uspDeleteDesignation]
	@PKDesigID	Bigint,	
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
	Select @count=count(*) From tblUser Where BStatus=1 and FKDesigID=@PKDesigID
	if(@count>0)
	Begin
		Set @Result=0
		Set @Msg='Department associated with the User!'
	End
	if(@Result=1)
	Begin
		SElect @Operation=DesigName From tblDesigMaster Where PKDesigID=@PKDesigID
		Delete From tblDesigMaster Where PKDesigID=@PKDesigID
		Set @Operation='Designation '+@Operation+' deleted'
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKDesigID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			Set @ErrorCount=@ErrorCount+1
			if(@ErrorCount<=1)
			Begin
				Goto AddTran
			End
			Else
			Begin
				Set @Result=0
				Set @Msg = ERROR_MESSAGE()
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog @FKUserID,'SP',@SPName			
				select @Result as Result,@Msg as Msg
			End
	END CATCH
End
