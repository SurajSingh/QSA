Create PROCEDURE [dbo].[uspGetProjectDetail]
	@PKID			Bigint,
	@FKProjectID			Bigint,
	@FKCompanyID	Bigint,
	@InvFromDate DATE,
	@InvToDate DATE
AS
Begin
	
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Declare @ISCustomInvoice	Bit=0
	Declare @InvoiceSNo	Bigint
	Declare @InvoicePrefix Varchar(50)
	Declare @InvoiceSuffix  Varchar(50)
	Declare @Sufix Varchar(50)
	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	Select @ISCustomInvoice=ISCustomInvoice,@InvoicePrefix=InvoicePrefix,@InvoiceSuffix=InvoiceSuffix,@InvoiceSNo=InvoiceSNo From tblProjectDetail where FKProjectID=@FKProjectID

	if (@InvFromDate = '1-1-1900' And @InvToDate = '1-1-1900') begin
	Set @InvFromDate = (Select top 1 dbo.fnGetDateFormat(A.InvDate,@DateForStr,'D') as LastInvDate From tblInvoice A where A.FKProjectID=@FKProjectID ORDER BY InvDate Desc);
	set @InvToDate = GETDATE();
	end


	--Table 0
	Select A.PKID,A.PKID,A.FKClientID,A.ProjectCode,A.ProjectName,Isnull(A.FKManagerID,0) as FKManagerID,
	Isnull(A.FKContractTypeID,0) as FKContractTypeID,A.ProjectStatus,A.ContractAmt,A.ExpAmt,A.ServiceAmt,A.BudgetedHours,A.BillPerCycle,
	dbo.fnGetDateFormat(A.Startdate,@DateForStr,'D') as Startdate,dbo.fnGetDateFormat(A.DueDate,@DateForStr,'D') as DueDate,
	A.CompletePercent,A.PONo,A.Remark,	
	C.Code as ClientID,C.Company,C.Retainer as Retainer,C.Balance,C.CPerson,C.CPersonTitle,Isnull(Ct.ContractType,'') as ContractType,
	C.Address1,C.Address2,Isnull(C.FKTahsilID,0) as FKTahsilID, Isnull(C.FKCityID,0) as FKCityID, Isnull(C.FKStateID,0) as FKStateID, Isnull(C.FKCountryID,0) as FKCountryID,C.ZIP,
	Isnull(ADC.CountryName,'') as CountryName,Isnull(ADS.StateName,'') as StateName,ISnull(ADC1.CityName,'') as CityName,ISnull(ADT.TahsilName,'') as TahsilName
	From tblProject A	
	Left Join tblClient C on A.FKClientID=C.PKID	
	Left Join tblContractType CT on a.FKContractTypeID=CT.PKID
	Left Join tblCountryMaster ADC on C.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on C.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on C.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on C.FKTahsilID=ADT.PKTahsilID
	Where A.BStatus=1 And A.PKID=@FKProjectID

	

	--Table 1
	Select Isnull(A.FKCurrencyID,0) as FKCurrencyID,A.ISCustomInvoice,A.InvoicePrefix,A.InvoiceSuffix,A.InvoiceSNo,Isnull(A.FKBillingFrequency,0) as FKBillingFrequency,A.GRT,A.ExpenseTax,Isnull(A.FKTaxID,0) as FKTaxID,Isnull(A.FKTermID,0) as FKTermID,Isnull(C.Symbol,'') as Symbol,T.TaxPercentage as TaxPer
	From tblProjectDetail A 
	Left JOin tblCurrencyMaster	C on A.FKCurrencyID=C.PKCurrencyID
	Left Join tblTaxMaster T on A.FKTaxID = T.PKID
	Where A.FKProjectID=@FKProjectID

	--Table 2
	Select Isnull(Sum(Hrs),0) as TotalHrs,Isnull(SUM(Hrs*TBillRate),0) as TotalBillAmt From tblTimeSheet where FKProjectID=@FKProjectID and ApproveStatus='Approved' and IsBillable=1
	
	--Table 3
	Select Isnull(SUM(Amount),0) as TotalExpAmt FRom tblExpensesLog where FKProjectID=@FKProjectID and ApproveStatus='Approved' and IsBillable=1
	


	--Table 4
	Select Isnull(Sum(NetAmount),0) as TotalBillAmt FRom tblInvoice where FKProjectID=@FKProjectID And IsCancel=0 And IsDeleted=0

	--Table 5
	Select top 1 A.InvoiceID,dbo.fnGetDateFormat(A.InvDate,@DateForStr,'D') as InvDate,A.NetAmount From tblInvoice A where A.FKProjectID=@FKProjectID ORDER BY InvDate

	
	
		--Table 6
	If(Isnull(@ISCustomInvoice,0)=1)
	Begin

		if(Isnull(@InvoiceSNo,0)=0)
		Set @InvoiceSNo=1
	
		Select @ISCustomInvoice as ISCustomInvoice,@InvoicePrefix as InvoicePrefix,@InvoiceSuffix as InvoiceSuffix,@InvoiceSNo as InvoiceSNo
	
	End
	Else
	Begin
		Set @ISCustomInvoice=0
		Select InvoicePrefix,InvoiceSuffix,Case When Isnull(InvoiceSNo,0)=0 then 1 Else  InvoiceSNo End as InvoiceSNo From tblCompany
	End

	--Table 7
	Exec uspGetUnBilledTasks @PKID,@FKProjectID,@FKCompanyID,@InvFromDate, @InvToDate
	
	--Table 8 Added by Nilesh to show unbilled ExpenseTax
	Exec uspGetUnBilledExpense @FKCompanyID,@PKID,@FKProjectID,@InvFromDate, @InvToDate 

End
