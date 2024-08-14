CREATE PROCEDURE [dbo].[uspInsertTaxMaster]
	@PKID	        Bigint,
	@TaxName	    Varchar(50),
	@TaxPercentage	decimal(18,4),	
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
		
		Select @Count=Count(*) From tblTaxMaster where TaxName=@TaxName And FKCompanyID=@FKCompanyID And (PKID<>@PKID)
		
		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Tax Already Exists'
		End

	If(@Result=1)
	Begin
		

		If(@PKID=0)
		Begin
				Exec uspGetNewID 'tblTaxMaster','PKID',@PKID output
				Insert Into tblTaxMaster(PKID, TaxName, TaxPercentage,FKCompanyID,CreationDate,ModificationDate)
				Values(@PKID, @TaxName, @TaxPercentage,  @FKCompanyID,GETUTCDATE(),null)
				Set @Operation='New Tax Master '+@TaxName+' Added'
		End
		Else
		Begin
				Update tblTaxMaster Set  TaxName=@TaxName, TaxPercentage=@TaxPercentage,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Tax Master '+@TaxName+' Updated'
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

