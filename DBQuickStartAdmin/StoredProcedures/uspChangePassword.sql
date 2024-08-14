CREATE PROCEDURE [dbo].[uspChangePassword]
	@PKID				Bigint ,	
	@PWD				Varchar(50),
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
		if(@PKID<>0)
		Begin
			Select @count=count(PKUserID) From tblUser 
			Where PKUserID=@PKID And PWD=@PWD
			if(@Count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Old Password'
			End
		End

		
		
		if(@Result=1)
		Begin
			Update tblUser Set PWD=@NewPWD Where PKUserID=@PKID
			
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
