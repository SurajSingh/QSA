CREATE PROCEDURE [dbo].[uspResetPassword]
	@ResetPwdTokenID Varchar(50),
	@NewPWD				Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(500)
	Declare @Count Bigint=0
	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		if(@ResetPwdTokenID <> '')
		Begin
			Select @count=count(ResetPwdToken) From tblUser 
			Where ResetPwdToken=@ResetPwdTokenID
			if(@Count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Token'
			End
		End
		
		if(@Result=1)
		Begin
			Update tblUser Set PWD=@NewPWD, ResetPwdToken=NULL Where ResetPwdToken=@ResetPwdTokenID			
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
				select @Result as Result,@Msg as Msg
	END CATCH
End
