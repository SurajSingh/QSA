CREATE PROCEDURE [dbo].[uspInsertInvoice]
	@PKID					Bigint,
	@InvDate				Date,
	@FKProjectID			Bigint, 
	@SNo					Bigint,	
	@Prefix					VARCHAR (50),
    @Suffix					VARCHAR (50),		
	@CPerson				Varchar(50),
	@CPersonTitle			Varchar(50),
	@Address1				Varchar(200),
	@Address2				Varchar(200),
	@FKTahsilID				Bigint,	
	@FKCityID				Bigint,
	@FKStateID				Bigint, 
	@FKCountryID		    Bigint,
	@ZIP				    Varchar(10),
	@SubAmt					Decimal(18,4),
	@FKTaxID				Bigint, 
	@TaxPer					Decimal(18,4),
	@TaxAmt					Decimal(18,4),
	@Amount					Decimal(18,4),
	@Discount				Decimal(18,4),
	@NetAmount				Decimal(18,4),
	@Retainage				Decimal(18,4),
	@Remarks				NVarchar(2000),
	@FKCurrencyID			Bigint,
	@StrTimeEntries			Varchar(max),
	@StrExpenseEntries		Varchar(max),
	@dtItem					XML,		
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddress				Varchar(50),
	@IsDeleted				Bigint,
	@IsArchieved			Bigint,
	@FKManagerID			Bigint,
	@SubmitType				Varchar(50),
	@Action					Varchar(50),
	@ApproveRemark			Varchar(500),
	@InvFromDate DATE,
	@InvToDate DATE

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
	Declare @FKPClientID Decimal(18,4)
	Declare @FKClientID Decimal(18,4)
	DEclare @PRetainage	Decimal(18,4)
	Declare @InvoiceID	Varchar(500)
	Declare @ISCustomInvoice	Bit=0
	Declare @ProjectSNo	Bigint=0
	Declare @NextInvNo	Bigint=0
	Declare @FKPayTermID Bigint=0
	Declare @PaymentTerm	NVarchar(2000)
	Declare @DueAmount Decimal(18,4)
	Declare @PKTranID Bigint=0
	Declare @TotalExpenseAmnt Decimal(18,4)
	Declare @TotalTaskAmnt Decimal(18,4)
	
	
	 
	--Added by Nilesh for Invoice Approval Feature - start(Replaced @ManagerID to FKSubmitToID)
	If(@Action='Submit')
	Begin
		If(@SubmitType='M')
		Begin	
			Select @FKManagerID=FKManagerID From tblUser where PKUserID=@FKUserID
			
			If(Isnull(@FKManagerID,0)=0)
			Begin
				Select @FKManagerID=PKUserID From tblUser where PKUserID=@FKUserID and FKCompanyID=@FKCompanyID and IsDefaultUser=1
			End
		End
		Else IF(@SubmitType='S')
		Begin
			Set @FKManagerID=@FKManagerID
		End
		Else IF(@SubmitType='PM')
		Begin
			Set @FKManagerID= (select P.FKManagerID from tblProject P where P.PKID = @FKProjectID)
		End
		Else
		Begin
			Set @FKManagerID= (select C.FKManagerID from tblClient C Left Join tblProject P on P.FKClientID=C.PKID Where P.PKID = @FKProjectID)
		End
	End
	--Added by Nilesh for Invoice Approval Feature - End
	
	
	If(@PKID<>0)
	Begin
		Select @Count=Count(*) FRom tblInvoice where PKID=@PKID and FKCompanyID=@FKCompanyID
		If(@Count=0)
		Begin
			Set @Result=0
			Set @Msg='Invalid Operation'
		End
	End

	Create table #tmpDetail(
				PKID			Bigint,	 
				ItemType		varchar(50),
				ItemPKID		Bigint,
				ItemDesc		Nvarchar(2000),
				Rate			Decimal(18,4),
				Qty				Decimal(18,4),
				Amount			Decimal(18,4),
				FKSubmitToID	Bigint,
				ModeForm		Bigint
			)

			Insert Into #tmpDetail(PKID,ItemType,ItemPKID,ItemDesc, Rate, Qty,Amount, ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID,
			AddData.value('ItemType[1]', 'varchar(50)') AS ItemType,
			AddData.value('ItemPKID[1]', 'bigint') AS ItemPKID,
			AddData.value('ItemDesc[1]', 'Nvarchar(2000)') AS ItemDesc,					
			AddData.value('Rate[1]', 'DECIMAL (18,4)') AS Rate,	
			AddData.value('Qty[1]', 'DECIMAL (18,4)') AS Qty,	
			AddData.value('Amount[1]', 'DECIMAL (18,4)') AS Amount,	
			
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)		
		
		If(@SNo<>0)
		Begin
			Select @Count=COUNT(*) From tblInvoice where FKCompanyID=@FKCompanyID and PKID<>@PKID and InvoiceID=@Prefix+COnvert(varchar(50),@SNo)+@Suffix
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Invoice ID is already exists'
			End
		End


		--Reset Data in Case of Edit
		If(@Result=1)
		Begin
			If(@PKID<>0)
			Begin
				Delete FRom tblInvoiceDetail
				Where PKID in (Select PKID From #tmpDetail where ModeForm<>0)

				Update tblTimeSheet Set IsBilled=0,FKInvoiceID=Null where FKInvoiceID=@PKID
				
				Select @PNetAmount=A.NetAmount,@FKPClientID=P.FKClientID,@PRetainage=A.Retainage From tblInvoice A Inner Join tblProject P on A.FKProjectID=P.PKID				
				where A.PKID=@PKID

				Update tblClient Set TotalDr=TotalDr-@PNetAmount,Retainer=Retainer+@PRetainage where PKID=@FKPClientID
				Delete From tblTransaction Where FKInvoiceID=@PKID and TranType='Invoice'

			End
		End

		--Set Next Invoice No
		If(@Result=1)
		Begin
			Select @FKPayTermID=P.FKTermID,@PaymentTerm=Isnull(T.PayTerm,''),@FKClientID=A.FKClientID,@ISCustomInvoice=Isnull(P.ISCustomInvoice,0),@NextInvNo=Isnull(P.InvoiceSNo,0) From tblProject A 
			Left Join tblProjectDetail P on A.PKID=P.FKProjectID
			Left Join tblClient C on A.FKClientID=C.PKID
			Left Join tblPaymentTerm T on P.FKTermID=T.PKID

			If(@ISCustomInvoice=1)
			Begin
				Set @ProjectSNo=@SNo
				Set @SNo=0
				If(@NextInvNo<=@ProjectSNo)
				Begin
					Set @NextInvNo=@ProjectSNo+1
					Update tblProjectDetail Set InvoiceSNo=@NextInvNo where FKProjectID=@FKProjectID
				End

				Set @InvoiceID=@Prefix+Convert(Varchar(50),@ProjectSNo)+@Suffix
			End
			Else
			Begin
				Select @NextInvNo=InvoiceSNo FRom tblCompany Where PKCompanyID=@FKCompanyID
				If(@NextInvNo<=@SNo)
				Begin
					Set @NextInvNo=@SNo+1
					Update tblCompany Set InvoiceSNo=@NextInvNo where PKCompanyID=@FKCompanyID
				End

				Set @InvoiceID=@Prefix+Convert(Varchar(50),@SNo)+@Suffix
			End
		End

		If(@Result=1)
		Begin
			If(@FKPayTermID=0)
			Set @FKPayTermID=Null


			If(@FKCityID=0)
			Set @FKCityID=null
			If(@FKStateID=0)
			Set @FKStateID=null
			If(@FKCountryID=0)
			Set @FKCountryID=null
			If(@FKTaxID=0)
			Set @FKTaxID=Null
			
			--Added by Nilesh to add Tax Percentage value in invoice table - start
			If(@FKTaxID!=0)
			Set @TaxPer=(SELECT T.TaxPercentage FROM tblTaxMaster T WHERE T.PKID = 3)
			--Added by Nilesh to add Tax Percentage value in invoice table - start
			
			If(@PKID=0 AND @Action='Submit')
			Begin
				Set @NetAmount = @NetAmount
				
				Exec uspGetNewID 'tblInvoice','PKID',@PKID output
				Insert Into tblInvoice(PKID, InvDate, FKProjectID, SNo, ProjectSNo, Prefix, Suffix, InvoiceID, CPerson, CPersonTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, SubAmt, FKTaxID, TaxPer,TaxAmt, Amount, Discount, NetAmount, Retainage, RecAmount, WriteOff, FKPayTermID, PaymentTerm, Remarks, FKCurrencyID, FKCompanyID, FKCreatedBy, CreationDate,IsDeleted,IsArchieved,FKSubmitToID,ApprovedStatus)
				Values(@PKID, @InvDate, @FKProjectID, @SNo, @ProjectSNo, @Prefix, @Suffix, @InvoiceID, @CPerson, @CPersonTitle, @Address1, @Address2, @FKTahsilID, @FKCityID, @FKStateID, @FKCountryID, @ZIP, @SubAmt, @FKTaxID,@TaxPer, @TaxAmt, @Amount, @Discount, @NetAmount, @Retainage, 0, 0, @FKPayTermID, @PaymentTerm, @Remarks, @FKCurrencyID, @FKCompanyID, @FKUserID, GETUTCDATE(),@IsDeleted,@IsArchieved,Case when @FKManagerID=0 then Null Else @FKManagerID End,'Pending')				
				
				Set @Operation='New Invoice '+@InvoiceID+' Generated'
			End
			Else 
			Begin
				Set @NetAmount = @NetAmount 
				
				Update tblInvoice Set InvDate=@InvDate, FKProjectID=@FKProjectID, SNo=@SNo, ProjectSNo=@ProjectSNo, Prefix=@Prefix, Suffix=@Suffix, InvoiceID=@InvoiceID, 
				CPerson=@CPerson, CPersonTitle=@CPersonTitle, Address1=@Address1, Address2=@Address2, FKTahsilID=@FKTahsilID, FKCityID=@FKCityID, FKStateID=@FKStateID, FKCountryID=@FKCountryID, ZIP=@ZIP, SubAmt=@SubAmt, FKTaxID=@FKTaxID,TaxPer=@TaxPer, TaxAmt=@TaxAmt, Amount=@Amount, Discount=@Discount, NetAmount=@NetAmount, Retainage=@Retainage, FKPayTermID=@FKPayTermID, PaymentTerm=@PaymentTerm, Remarks=@Remarks, FKCurrencyID=@FKCurrencyID,FKLastModifiedBy=@FKUserID,
				ModificationDate=GETUTCDATE(), ApprovedRemark=@ApproveRemark
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Invoice  '+@InvoiceID+' Updated'

				Update A Set ItemType=B.ItemType,ItemPKID=B.ItemPKID,ItemDesc=B.ItemDesc,Qty=B.Qty,Rate=B.Rate,Amount=B.Amount
				From tblInvoiceDetail A
				Inner Join #tmpDetail B on A.PKID=B.PKID
				Where B.ModeForm=0 and A.FKID=@PKID
			End			

			Insert Into tblInvoiceDetail(FKID,ItemType,ItemPKID,ItemDesc,Qty,Rate,Amount)
			Select @PKID,ItemType,ItemPKID,ItemDesc,Qty,Rate,Amount
			From #tmpDetail where PKID=0
			And ModeForm=0

			--Mark Timesheet
			Update tblTimeSheet Set FKInvoiceID=@PKID,IsBilled=1
			where PKID in (Select Item From dbo.FunSplitString(@StrTimeEntries,',') where Item<>'')
			
			--Mark ExpenseLog (Added by Nilesh to add Unbilled Expense)
			Update tblExpensesLog Set FKInvoiceID=@PKID,IsBilled=1
			where PKID in (Select Item From dbo.FunSplitString(@StrExpenseEntries,',') where Item<>'')


			--Make Transaction Entry
			Exec uspGetNewID 'tblTransaction','PKID',@PKTranID output
			Insert Into tblTransaction(PKID, TranDate, TranType, FKClientID, FKInvoiceID, FKPaymentID, TranDesc, DrAmt, CrAmt, FKCompanyID, FKCreatedBy, CreationDate)
			Values(@PKTranID, @InvDate, 'Invoice', @FKClientID, @PKID, Null, 'Invoice Generated #'+@InvoiceID, @NetAmount, 0, @FKCompanyID, @FKUserID, GETUTCDATE())

			Update tblClient Set TotalDr=TotalDr+@NetAmount,Retainer=Retainer-@Retainage where PKID=@FKClientID

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