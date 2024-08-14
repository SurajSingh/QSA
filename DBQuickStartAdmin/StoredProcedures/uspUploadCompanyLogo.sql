CREATE PROCEDURE [dbo].[uspUploadCompanyLogo]
	@RecType			Varchar(50),
	@ImageURL			Varchar(50),
    @FKCompanyID		 Bigint, 
	@FKUserID			 Bigint,	
	@FKPageID		     Bigint=0,
	@IPAddr			     Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		

		
		
		If(@Result=1)
		Begin	
			If(@RecType='Logo')
			Begin
				Update tblCompany Set LogoURL=@ImageURL where PKCompanyID=@FKCompanyID
			End
			Else
			Begin
				Update tblCompany Set SmallLogoURL=@ImageURL where PKCompanyID=@FKCompanyID
			End
			Set @Operation='Upload Profile Picture'
			
		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@FKCompanyID
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddr
			select @Result as Result,@Msg as Msg
	END CATCH
End

