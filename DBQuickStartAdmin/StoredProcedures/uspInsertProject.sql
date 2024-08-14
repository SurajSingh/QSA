CREATE PROCEDURE [dbo].[uspInsertProject]
	@PKID               BIGINT,
    @FKClientID         Bigint,
    @ProjectCode        VARCHAR (50),
    @ProjectName        VARCHAR (500), 
    @FKManagerID        Bigint,  
    @FKContractTypeID    Bigint,
    @ProjectStatus      VARCHAR (50) ,
    @ContractAmt        DECIMAL (18, 4),
    @ExpAmt             DECIMAL (18, 4),
    @ServiceAmt         DECIMAL (18, 4),
    @BudgetedHours      Decimal(18,4),
    @Startdate          Date,
    @DueDate            Date ,
    @CompletePercent     DECIMAL (18, 4),  
    @PONo                VARCHAR (50) ,
    @Remark              NVARCHAR (500), 
    @FKCurrencyID         Bigint,
    @ISCustomInvoice     Bit ,
    @InvoicePrefix       VARCHAR (50),
    @InvoiceSuffix       VARCHAR (50),
    @InvoiceSNo          BIGINT ,
	@FKBillingFrequency  Bigint,
    @GRT                 DECIMAL (18, 2),
    @ExpenseTax          DECIMAL (18, 2),
    @FKTaxID             Bigint, 
    @FKTermID            Bigint,  
    @TBillable           Bit ,
    @TMemoRequired       Bit ,
    @EBillable           Bit ,
    @EMemoRequired       Bit ,    
    @TDesReadonly        Bit ,
    @EDesReadOnly        Bit,
	@BillPerCycle		 DECIMAL(18,4),
    @FKCompanyID		 Bigint, 
	@FKUserID			 Bigint,	
	@FKPageID		     Bigint=0,
	@IPAddr			     Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @FKProjectIDInv Bigint --Added by Nilesh
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		
		
		if(@FKManagerID=0)
		set @FKManagerID=null
		If(@FKContractTypeID=0)
		Set @FKContractTypeID=null
		If(@FKBillingFrequency=0)
		Set @FKBillingFrequency=null
		If(@FKTaxID=0)
		Set @FKTaxID=null
		If(@FKTermID=0)
		Set @FKTermID=null
		If(@FKCurrencyID=0)
		--Set Set @FKCurrencyID=null
		--Below Statement Added by Nilesh to set the default currency for project - Start
		Set @FKCurrencyID=(SELECT C.FKCurrencyID FROM tblCompany C WHERE C.PKCompanyID=@FKCompanyID)
		--Below Statement Added by Nilesh to set the default currency for project - Start

		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		

		if(@Result=1)
		Begin
			Select @Count=count(*) from tblProject where PKID<>@PKID and BStatus=1 and ProjectCode=@ProjectCode and FKCompanyID=@FKCompanyID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Project ID already exists!'
			End
		End
		
		If(@Result=1)
		Begin			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblProject','PKID',@PKID output
				Insert Into tblProject(PKID, FKClientID, ProjectCode, ProjectName, FKCompanyID, FKManagerID, FKContractTypeID, ProjectStatus, ContractAmt, ExpAmt, ServiceAmt, BudgetedHours, Startdate, DueDate, CompletePercent, PONo, Remark, FKCreatedBy, CreationDate, BillPerCycle)
				Values(@PKID, @FKClientID, @ProjectCode, @ProjectName, @FKCompanyID, @FKManagerID, @FKContractTypeID, @ProjectStatus, @ContractAmt, @ExpAmt, @ServiceAmt, @BudgetedHours, @Startdate, @DueDate, @CompletePercent, @PONo, @Remark, @FKUserID, GETUTCDATE(), @BillPerCycle)				
				
				Set @Operation='New Project '+@ProjectName+' Added'
			End
			Else
			Begin			
				Update tblProject Set PKID=@PKID,FKClientID=@FKClientID,ProjectCode=@ProjectCode,ProjectName=@ProjectName,
				FKManagerID=@FKManagerID,FKContractTypeID=@FKContractTypeID,ProjectStatus=@ProjectStatus,ContractAmt=@ContractAmt,ExpAmt=@ExpAmt,ServiceAmt=@ServiceAmt,BudgetedHours=@BudgetedHours,Startdate=@Startdate,DueDate=@DueDate,CompletePercent=@CompletePercent,PONo=@PONo,
				Remark=@Remark,FKLastModifiedBy=@FKUserID, BillPerCycle = @BillPerCycle,
				ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Project  '+@ProjectName+' Updated'			
			End

			Select @Count=Count(*) From tblProjectDetail where FKProjectID=@PKID
			If(@Count=0)
			Begin				
				Insert Into tblProjectDetail(FKProjectID, FKCurrencyID, ISCustomInvoice, InvoicePrefix, InvoiceSuffix, InvoiceSNo, FKBillingFrequency, GRT, ExpenseTax, FKTaxID, FKTermID, TBillable, TMemoRequired, EBillable, EMemoRequired, TDesReadonly, EDesReadOnly)
				Values(@PKID, @FKCurrencyID, @ISCustomInvoice, @InvoicePrefix, @InvoiceSuffix, @InvoiceSNo, @FKBillingFrequency, @GRT, @ExpenseTax, @FKTaxID, @FKTermID, @TBillable, @TMemoRequired, @EBillable, @EMemoRequired, @TDesReadonly, @EDesReadOnly)
			End
			Else
			Begin
			--Modified by Nilesh to stop the curremcy changes if Invoice is already generated against the project - START
			--Declare @FKProjectIDInv Bigint
			SET @FKProjectIDInv = (SELECT (CASE WHEN EXISTS(SELECT 1 FKProjectID FROM tblInvoice WHERE FKProjectID = @PKID) THEN '1' ELSE '0' END) AS invoiceExist)
			--print(@FKProjectIDInv)
			if(@FKProjectIDInv = 0) 
			Begin
				Update tblProjectDetail Set FKCurrencyID=@FKCurrencyID,ISCustomInvoice=@ISCustomInvoice,InvoicePrefix=@InvoicePrefix,InvoiceSuffix=@InvoiceSuffix,InvoiceSNo=@InvoiceSNo,FKBillingFrequency=@FKBillingFrequency,GRT=@GRT,ExpenseTax=@ExpenseTax,FKTaxID=@FKTaxID,FKTermID=@FKTermID,TBillable=@TBillable,TMemoRequired=@TMemoRequired,EBillable=@EBillable,EMemoRequired=@EMemoRequired,TDesReadonly=@TDesReadonly,EDesReadOnly=@EDesReadOnly
				Where FKProjectID=@PKID
			End
			Else Begin
				Set @Msg='0'
			End
			--Modified by Nilesh to stop the curremcy changes if Invoice is already generated against the project - End
				
			End
		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKID
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddr
			select @Result as Result,@Msg as Msg
	END CATCH
End

