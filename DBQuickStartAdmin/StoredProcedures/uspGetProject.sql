CREATE PROCEDURE [dbo].[uspGetProject]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
	@FKCompanyID		Bigint,
	@ProjectName		Varchar(50),	
	@FKClientID			Bigint,
	@ActiveStatus		Varchar(50),
	@FKContractTypeID   Bigint
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	--Modified By Nilesh To show the currency symbol as per project on project List(ProjectDetail and CurrencyMaster table)
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.PKID,A.FKClientID,A.ProjectCode,A.ProjectName,Isnull(A.FKManagerID,0) as FKManagerID,A.BillPerCycle,
	Isnull(A.FKContractTypeID,0) as FKContractTypeID,A.ProjectStatus,CM.Symbol,A.ContractAmt,A.ExpAmt,A.ServiceAmt,A.BudgetedHours,
	dbo.fnGetDateFormat(A.Startdate,@DateForStr,''D'') as Startdate,dbo.fnGetDateFormat(A.DueDate,@DateForStr,''D'') as DueDate,
	A.CompletePercent,A.PONo,A.Remark,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	Isnull(A1.FName,'''') as ManagerName,
	C.Code as ClientID,C.Company as ClientCompany,C.CPerson,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	(a.BudgetedHours*a.completePercent/100) as AdjBudgetHrs,
	Isnull((Select sum(Hrs) From tblTimeSheet where FKProjectID=A.PKID and ApproveStatus=''Approved''),0) as ActualHrs,
	Isnull((Select sum(Hrs*TCostRate) From tblTimeSheet where FKProjectID=A.PKID and ApproveStatus=''Approved''),0) as CostToCompany,
	Isnull(CT.ContractType,'''') as ContractType,
	Isnull((Select Sum(NetAmount) From tblInvoice where FKProjectID=A.PKID),0) BilledAmount
	From tblProject A	
	Inner Join tblProjectDetail PD on A.PKID = PD.FKProjectID
	Inner Join tblCurrencyMaster CM on CM.PKCurrencyID = PD.FKCurrencyID 
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblUser A1 on A.FKManagerID=A1.PKUserID
	Left Join tblClient C on A.FKClientID=C.PKID	
	Left Join tblContractType CT on A.FKContractTypeID=CT.PKID
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And (A.ProjectCode Like ''%''+@ProjectName+''%'' Or @ProjectName='''' Or A.ProjectName Like ''%''+@ProjectName+''%'')
	And (A.FKCompanyID=@FKCompanyID)	
	And (A.FKClientID=@FKClientID Or @FKClientID=0)	
	And (A.FKContractTypeID=@FKContractTypeID Or @FKContractTypeID=0)	
	And (A.ProjectStatus=@ActiveStatus Or @ActiveStatus='''') '
	
	
	
	              

		If(@SortBy='')
		Begin
			Set @SortBy='A.ProjectCode,A.ProjectName'
		End		
		Else If(@SortBy='ProjectCode')
		Begin
			Set @SortBy='A.ProjectCode'
		End
		Else If(@SortBy='ProjectName')
		Begin
			Set @SortBy='A.ProjectName'
		End
		Else If(@SortBy='CPerson')
		Begin
			Set @SortBy='C.CPerson'
		End
		Else If(@SortBy='ProjectStatus')
		Begin
			Set @SortBy='A.ProjectStatus'
		End
		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End

		IF(@PKID<>0)
		Begin
			Set @StrQry=@StrQry+' Select Isnull(A.FKCurrencyID,0) as FKCurrencyID,A.ISCustomInvoice,A.InvoicePrefix,A.InvoiceSuffix,A.InvoiceSNo,Isnull(A.FKBillingFrequency,0) as FKBillingFrequency,A.GRT,A.ExpenseTax,Isnull(A.FKTaxID,0) as FKTaxID,Isnull(A.FKTermID,0) as FKTermID,A.TBillable,A.TMemoRequired,A.EBillable,A.EMemoRequired,A.TDesReadonly,A.EDesReadOnly
			From tblProjectDetail A Where A.FKProjectID=@PKID	'
		End
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID Bigint,@FKCompanyID	Bigint,@ProjectName Varchar(50),@ActiveStatus Varchar(50),@FKClientID Bigint,@FKContractTypeID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@FKCompanyID,@ProjectName,@ActiveStatus,@FKClientID,@FKContractTypeID,@DateForStr,@FKTimezoneID

	

End
