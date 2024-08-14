CREATE PROCEDURE [dbo].[uspGetAgingReport]
	@PageSize				bigint=0,
	@PageNo					Bigint=0,
	@SortBy					Varchar(Max),
	@SortDir				Varchar(50),
	@ColStr					Varchar(Max),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKCompanyID		Bigint,		
	@FKClientID			Varchar(max),
	@FKProjectID		Varchar(max),	
	@InvoiceID			Varchar(50),
	@RecType			Varchar(50)
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint
	Declare @SelectCol varchar(max)=''
	Declare @GroupByCol	varchar(max)=''
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @SelectCQty varchar(max)=''
	Declare @SelectOpBal varchar(max)=''
	Declare @SelectInQty varchar(max)=''
	Declare @SelectOutQty varchar(max)=''	


	Declare @ColStr1 varchar(max)=@ColStr

	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	if(@SortDir='')
	Begin
			Set @SortDir='A'
	End
	
	


	if(@ColStr='')
	Begin
		Set @SelectCol=	'A.InvoiceID,dbo.fnGetDateFormat(A.InvDate,@DateForStr,''D'') as InvDate,A.NetAmount'
		Set @GroupByCol=''
	End
	Else
	Begin
			Set @SelectCol=@ColStr
			Set @GroupByCol=@ColStr

			Set  @SelectCol=REPLACE(@SelectCol,'[PKID]','A.PKID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[PKID]','A.PKID')
						
			Set  @SelectCol=REPLACE(@SelectCol,'[projectid]','A.FKProjectID as projectid')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[projectid]','A.FKProjectID')

			Set  @SelectCol=REPLACE(@SelectCol,'[projectname]','C.ProjectName as projectname')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[projectname]','C.ProjectName')

			Set  @SelectCol=REPLACE(@SelectCol,'[projectcode]','C.ProjectCode as projectcode')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[projectcode]','C.ProjectCode')


			Set  @SelectCol=REPLACE(@SelectCol,'[managername]','Isnull(U3.FName,'''')+'' ''+Isnull(U3.FName,'''')  as managername')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[managername]','Isnull(U3.FName,'''')+'' ''+Isnull(U3.FName,'''')')

			Set  @SelectCol=REPLACE(@SelectCol,'[clientid]','C.FKClientID as clientid')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[clientid]','C.FKClientID')


			Set  @SelectCol=REPLACE(@SelectCol,'[clientname]','C1.Company as clientname')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[clientname]','C1.Company')

			Set  @SelectCol=REPLACE(@SelectCol,'[clientcode]','C1.Code as clientcode')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[clientcode]','C1.Code')

			Set  @SelectCol=REPLACE(@SelectCol,'[invoiceno]','A.InvoiceID as invoiceno')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[invoiceno]','A.InvoiceID')

			Set  @SelectCol=REPLACE(@SelectCol,'[invoicedate]','dbo.fnGetDateFormat(A.InvDate,@DateForStr,''D'') as invoicedate')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[invoicedate]','dbo.fnGetDateFormat(A.InvDate,@DateForStr,''D'')')
			
			
			
			Set  @SelectCol=REPLACE(@SelectCol,'[clientaddress]','dbo.FunGetClientAddress(C1.PKID,''C'') as clientaddress')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[clientaddress]','dbo.FunGetClientAddress(C1.PKID,''C'')')
			
			
			Set  @SelectCol=REPLACE(@SelectCol,'[totalamount]','Sum(A.NetAmount) as totalamount')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[totalamount]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[invoicepaidamount]','Sum(dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,'''')) as invoicepaidamount')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[invoicepaidamount]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[currentamt]','Sum(case when datediff(dd,A.InvDate,@todate)<=30 then dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'') else 0 end) as currentamt')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[currentamt]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[amount1]','sum(case when datediff(dd,A.InvDate,@todate)>30 and datediff(dd,A.InvDate,@todate)<=60 then dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'') else 0 end) as amount1')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[amount1]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[amount2]','sum(case when datediff(dd,A.InvDate,@todate)>60 and datediff(dd,A.InvDate,@todate)<=90 then dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'') else 0 end) as amount2')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[amount2]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[amount3]','sum(case when datediff(dd,A.InvDate,@todate)>90 then dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'') else 0 end) as amount3')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[amount3]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[balance]','sum(dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'')) as balance')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[balance]','')



					
	End
			
	
	
	If(@SortBy='')
	Begin
			Set @SortBy='C1.Company'
	End
	
	Set @StrQry=N'Select '+@SelectCol+'
	From tblInvoice A	
	Inner Join tblProject C on A.FKProjectID=C.PKID	
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblUser U3 on C.FKManagerID=U3.PKUserID
	Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
	Left JOin tblCurrencyMaster	CM on A.FKCurrencyID=CM.PKCurrencyID
	Where  ((A.InvDate>=@FromDate and A.InvDate<=@ToDate) Or @DateWise=0) 
	And (@InvoiceID='''' Or A.InvoiceID=@InvoiceID) 
	And dbo.FunGetInvoiceDueonDate(A.PKID,1,@ToDate,A.DueAmount,''Due'')>0	'
	
	IF(@FKProjectID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKProjectID in (Select Item From dbo.FunSplitString(@FKProjectID,'','') where Item<>'''') '
	End
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And C1.PKID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
	End

	

	if(@GroupByCol<>'')
	Begin
		Set @StrQry=@StrQry+' Group By '+@GroupByCol
	End	
	
	
	

	Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End
	
	
	if(@PageSize>0)
	Begin
		Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
	End
	
	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,@FKClientID	Varchar(max),@FKProjectID Varchar(max),@InvoiceID	Varchar(50),	@RecType Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKClientID,@FKProjectID,@InvoiceID,@RecType,@DateForStr,@FKTimezoneID

	
End 

