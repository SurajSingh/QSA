CREATE PROCEDURE [dbo].[uspGetInvoiceDeleted]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKCompanyID		Bigint,		
	@FKClientID			Varchar(max),
	@FKProjectID		Varchar(max),	
	@InvoiceID			Varchar(50),	
	@FKPaymentID		Bigint
	--@RecType			Varchar(50),
	--@InvStatus			Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Declare @TotalTaskAmt Bigint
	Declare @TotalItemAmt Bigint
	Declare @TotalExpenseAmt Bigint
	Declare @TotalAmount Bigint
	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.InvDate as InvDate1,dbo.fnGetDateFormat(A.InvDate,@DateForStr,''D'') as InvDate, 
	A.FKProjectID, A.SNo, A.ProjectSNo, A.Prefix, A.Suffix, A.InvoiceID, A.CPerson, A.CPersonTitle, A.Address1, A.Address2, Isnull(A.FKTahsilID,0) as FKTahsilID, Isnull(A.FKCityID,0) as FKCityID, Isnull(A.FKStateID,0) as FKStateID, Isnull(A.FKCountryID,0) as FKCountryID, A.ZIP, A.SubAmt, A.FKTaxID,A.TaxPer, A.TaxAmt, A.Amount, A.Discount, A.NetAmount, A.Retainage, 
	A.DueAmount, A.RecAmount, A.WriteOff, A.NetDueAmount,  A.PaymentTerm, A.Remarks, A.IsCancel, A.CancelReason, A.FKCurrencyID,
	C1.Code As ClientCode,C1.Company as ClientName,C1.CPerson as ClientCPerson,C1.CPersonTitle as ClientCPersonTitle,
	C1.EMailID,C1.Phone1,C1.Phone2,C1.Mobile,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 
	Isnull(ADC.CountryName,'''') as CountryName,Isnull(ADS.StateName,'''') as StateName,ISnull(ADC1.CityName,'''') as CityName,ISnull(ADT.TahsilName,'''') as TahsilName,
	CM.Symbol,C.ProjectCode,C.ProjectName,
	Isnull((Select Sum(Hrs*TCostRate) FRom tblTimeSheet where ApproveStatus=''Approved'' and FKInvoiceID=A.PKID),0) as InvoiceCost,
	Isnull((Select Sum(Amount) FRom tblExpensesLog where ApproveStatus=''Approved'' and FKInvoiceID=A.PKID),0) as InvoiceExpenses
	From tblInvoice A	
	Inner Join tblProject C on A.FKProjectID=C.PKID	
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
	Left JOin tblCurrencyMaster	CM on A.FKCurrencyID=CM.PKCurrencyID
	Where  (A.PKID=@PKID or @PKID=0)
	And ((A.InvDate>=@FromDate and A.InvDate<=@ToDate) Or @DateWise=0) 
	And (@InvoiceID='''' Or A.InvoiceID=@InvoiceID)	
	And A.IsDeleted = 1'

	
	


	IF(@FKProjectID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKProjectID in (Select Item From dbo.FunSplitString(@FKProjectID,'','') where Item<>'''') '
	End
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And C1.PKID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
	End
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.InvDate,A.PKID'
		End			
		Else If(@SortBy='InvDate')
		Begin
			Set @SortBy='A.InvDate'
		End

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
	
	

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,@FKClientID	Varchar(max),@FKProjectID Varchar(max),@InvoiceID	Varchar(50),@FKPaymentID	Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKClientID,@FKProjectID,@InvoiceID,@FKPaymentID,@DateForStr,@FKTimezoneID

	

End

