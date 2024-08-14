CREATE PROCEDURE [dbo].[uspInsertPaymentTerm]
	@PKID	        Bigint,
	@TermTitle		NVARCHAR (200),
	@PayTerm		NVARCHAR (Max),
    @GraceDays		BIGINT  ,
	@FKCompanyID	Bigint,
	@FKUserID	    Bigint,
	@FKPageID	    Bigint=0,
	@IPAddress	    Varchar(50)
	
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
		
		Select @Count=Count(*) From tblPaymentTerm where TermTitle=@TermTitle And FKCompanyID=@FKCompanyID And (PKID<>@PKID)
		
		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Term Title Already Exists'
		End

	If(@Result=1)
	Begin
		

		If(@PKID=0)
		Begin
				Exec uspGetNewID 'tblPaymentTerm','PKID',@PKID output
				Insert Into tblPaymentTerm(PKID, TermTitle,PayTerm, GraceDays,FKCompanyID,CreationDate,ModificationDate)
				Values(@PKID, @TermTitle, @PayTerm,@GraceDays,  @FKCompanyID,GETUTCDATE(),null)
				Set @Operation='New Payment Term '+@TermTitle+' Added'
		End
		Else
		Begin
				Update tblPaymentTerm Set  TermTitle=@TermTitle, PayTerm=@PayTerm,GraceDays=@GraceDays,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Payment Term '+@TermTitle+' Updated'
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

