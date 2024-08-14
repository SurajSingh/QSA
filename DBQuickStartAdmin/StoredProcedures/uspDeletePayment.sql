CREATE PROCEDURE [dbo].[uspDeletePayment]
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
	Declare @FKPClientID Bigint
	Declare @FKPPaymentType Bigint
	Declare @PNetAmount Decimal(18,4)
	Declare @PRetainerAmount Decimal(18,4)
	Select @count=count(*) From tblPayment Where PKID=@PKID and FKCompanyID=@FKCompanyID
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End

	--If(@Result=1)
	--Begin
	--	Select @count=count(*) From tblProject Where BStatus=1 and FKClientID=@PKID and FKCompanyID=@FKCompanyID
	--	if(@count=0)
	--	Begin
	--		Set @Result=0
	--		Set @Msg='Unable to Delete Client. Project Exists!'
	--	End
	--End

	if(@Result=1)
	Begin
		

		
				
				Update A Set RecAmount=RecAmount-B.Amount
				From tblInvoice A
				Inner Join tblInvAdjustment B on A.PKID=B.FKInvoiceID and B.FKPaymentID=@PKID
				Where B.FKPaymentID=@PKID
				
				Delete From tblInvAdjustment Where FKPaymentID=@PKID
				
				
				Select @PNetAmount=A.Amount,@FKPClientID=A.FKClientID,@FKPPaymentType=A.FKPaymentTypeID,@Operation=PayID,@PRetainerAmount=RetainerAmount From tblPayment A				
				where A.PKID=@PKID

				If(@FKPPaymentType<>2)
				Update tblClient Set TotalCr=TotalCr-@PNetAmount where PKID=@FKPClientID

				If(@FKPPaymentType=2)
				Begin
					Update tblClient Set Retainer=Retainer+@PNetAmount where PKID=@FKPClientID
				End
				Else If(@FKPPaymentType=1 and @PRetainerAmount>0)
				Begin
					Update tblClient Set Retainer=Retainer-@PRetainerAmount where PKID=@FKPClientID
				End



				Delete From tblTransaction Where FKPaymentID=@PKID and TranType='Payment'

				Delete From tblPayment Where  PKID=@PKID
				Set @Operation='Payment Entry '+@Operation+' deleted'
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


