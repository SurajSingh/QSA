CREATE PROCEDURE [dbo].[uspDeleteCountryStateCity]
	@PKID		Bigint,	
	@RecType	Bigint,
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
	
	if(@Result=1)
	Begin
		If(@RecType=1)
		Begin
			Delete From tblCountryMaster where PKCountryID=@PKID
		End
		Else If(@RecType=2)
		Begin
			Delete From tblStateMaster where PKStateID=@PKID
		End
		Else If(@RecType=3)
		Begin
			Delete From tblCityMaster where PKCityID=@PKID
		End
		Else If(@RecType=4)
		Begin
			Delete From tblTahsilMaster where PKTahsilID=@PKID
		End
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End
