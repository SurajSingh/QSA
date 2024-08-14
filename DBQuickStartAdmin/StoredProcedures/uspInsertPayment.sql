CREATE PROCEDURE [dbo].[uspInsertPayment]
	@PKID					Bigint,
	@FKClientID				Bigint, 
	@TranDate				Date,
	@FKPaymentTypeID		Bigint, 
	@FKPaymodeID			Bigint, 
	@TranID					Varchar(50),
	@IsRetainer				Bit,
	@Amount					Decimal(18,4),
	@RetainerAmount			DEcimal(18,4),
	@dtItem					XML,		
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddress				Varchar(50)	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY	
	Declare @PNetAmount Decimal(18,4)
	Declare @PRetainerAmount			DEcimal(18,4)
	Declare @FKPClientID Decimal(18,4)
	Declare @FKPPaymentType	Bigint
	Declare @SNo	Bigint
	Declare @PayID	Varchar(50)	
	Declare @PKTranID Bigint=0
	
	

	If(@PKID<>0)
	Begin
		Select @Count=Count(*) FRom tblPayment where PKID=@PKID and FKCompanyID=@FKCompanyID
		If(@Count=0)
		Begin
			Set @Result=0
			Set @Msg='Invalid Operation'
		End
	End

	Create table #tmpDetail(
				
				FKInvoiceID	Bigint,				
				Amount		Decimal(18,4)
				
			)

			Insert Into #tmpDetail(FKInvoiceID,Amount)			
			SELECT 			
			AddData.value('FKInvoiceID[1]', 'Bigint') AS FKInvoiceID,
			AddData.value('Amount[1]', 'DECIMAL (18,4)') AS Amount			
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			
		
		

		--Reset Data in Case of Edit
		If(@Result=1)
		Begin
			If(@PKID<>0)
			Begin
				
				Update A Set RecAmount=RecAmount-B.Amount
				From tblInvoice A
				Inner Join tblInvAdjustment B on A.PKID=B.FKInvoiceID and B.FKPaymentID=@PKID
				Where B.FKPaymentID=@PKID
				
				Delete From tblInvAdjustment Where FKPaymentID=@PKID
				
				
				Select @PNetAmount=A.Amount,@FKPClientID=A.FKClientID,@FKPPaymentType=A.FKPaymentTypeID,@PayID=A.PayID,@PRetainerAmount=RetainerAmount From tblPayment A				
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

			End
		End

		

		If(@Result=1)
		Begin
			
			If(@FKPaymodeID=0)
			Set @FKPaymodeID=Null


			
			
			
			If(@PKID=0)
			Begin
				
				Select @SNo=Max(SNo) From tblPayment where FKCompanyID=@FKCompanyID
				Set @SNo=Isnull(@SNo,0)+1

				If(@SNo<10)
				Begin
					Set @PayID='PAY00'+CONVERT(Varchar(50),@SNo)
				End
				Else If(@SNo<100)
				Begin
					Set @PayID='PAY0'+CONVERT(Varchar(50),@SNo)
				End
				Else
				Begin
					Set @PayID='PAY'+CONVERT(Varchar(50),@SNo)
				End

				
				Exec uspGetNewID 'tblPayment','PKID',@PKID output
				Insert Into tblPayment(PKID, SNo, PayID, FKClientID, TranDate, FKPaymentTypeID, FKPaymodeID, TranID, IsRetainer, Amount,RetainerAmount, FKCompanyID, FKCreatedBy, CreationDate)
				Values(@PKID, @SNo, @PayID, @FKClientID, @TranDate, @FKPaymentTypeID, @FKPaymodeID, @TranID, @IsRetainer, @Amount,@RetainerAmount, @FKCompanyID, @FKUserID, GETUTCDATE())				
				
				Set @Operation='New Payment Entry '+@PayID+' Generated'
			End
			Else
			Begin
				Update tblPayment Set FKClientID=@FKClientID, TranDate=@TranDate, FKPaymentTypeID=@FKPaymentTypeID, 
				FKPaymodeID=@FKPaymodeID, TranID=@TranID, IsRetainer=@IsRetainer, Amount=@Amount,RetainerAmount=@RetainerAmount, FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Payment Entry  '+@PayID+' Updated'
				
			End

			If(@FKPaymentTypeID<>2)
			Begin
				Update tblClient Set TotalCr=TotalCr+@Amount where PKID=@FKClientID

				Exec uspGetNewID 'tblTransaction','PKID',@PKTranID output
				Insert Into tblTransaction(PKID, TranDate, TranType, FKClientID, FKInvoiceID, FKPaymentID, TranDesc, DrAmt, CrAmt, FKCompanyID, FKCreatedBy, CreationDate)
				Values(@PKTranID, @TranDate, 'Payment', @FKClientID, Null,@PKID, Case When @FKPaymentTypeID=1 then 'Payment Received #' Else 'Write Off Payment Entry #' End+@PayID, 0,@Amount, @FKCompanyID, @FKUserID, GETUTCDATE())

			End

			If(@IsRetainer=0)
			Begin
				
				Insert Into tblInvAdjustment(FKInvoiceID,FKPaymentID,Amount)
				Select FKInvoiceID,@PKID,Amount FRom #tmpDetail
				
				Update A Set RecAmount=A.RecAmount+B.Amount
				FRom tblInvoice A
				Inner  Join tblInvAdjustment B on A.PKID=B.FKInvoiceID and B.FKPaymentID=@PKID
				Where B.FKPaymentID=@PKID
				
			End

			If(@FKPaymentTypeID=2)
			Begin
				Update tblClient Set Retainer=Retainer-@Amount where PKID=@FKClientID
			End
			Else If(@FKPaymentTypeID=1 and @RetainerAmount>0)
			Begin
				Update tblClient Set Retainer=Retainer+@RetainerAmount where PKID=@FKClientID
			End


			

		End
			

	Select @Result as Result,@Msg as Msg,@PKID as PKID

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
			
			Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE() as [LineNo],@SPName as SPName
	END CATCH
End

