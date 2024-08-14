CREATE PROCEDURE [dbo].[uspGetTransaction]
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
	@PayID				Varchar(50),	
	@TranType			Varchar(50),
	@RecType			Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,dbo.fnGetDateFormat(A.TranDate,@DateForStr,''D'') as TranDate, 
	A.TranType, A.FKClientID, A.FKInvoiceID, A.FKPaymentID, A.TranDesc, A.DrAmt, A.CrAmt, 
	Isnull(B.InvoiceID,'''') as InvoiceID,Isnull(B1.PayID,'''') as PayID,
	Case when A.TranType=''Invoice'' then C1.Code Else C2.Code End As ClientCode,Case when A.TranType=''Invoice'' then C1.Company Else C2.Company End as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate,
	Isnull(C.ProjectCode,'''') as ProjectCode,Isnull(C.ProjectName,'''') as ProjectName
	From tblTransaction A	
	Left Join tblInvoice B on A.FKInvoiceID=B.PKID	
	Left Join tblPayment B1 on A.FKPaymentID=B1.PKID		
	Left Join tblProject C on B.FKProjectID=C.PKID	
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblClient C2 on A.FKClientID=C2.PKID	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID		
	Where  (A.PKID=@PKID or @PKID=0)
	And ((A.TranDate>=@FromDate and A.TranDate<=@ToDate) Or @DateWise=0) 
	And (@InvoiceID='''' Or B.InvoiceID=@InvoiceID) 
	And (@PayID='''' Or B1.PayID=@PayID) 
	And (@TranType='''' Or A.TranType=@TranType) '

	
	IF(@FKProjectID<>'')
	Begin
		Set @StrQry=@StrQry+N' And B.FKProjectID in (Select Item From dbo.FunSplitString(@FKProjectID,'','') where Item<>'''') '
	End
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And (A.TranType=''Payment'' And A.FKClientID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') Or (A.TranType=''Invoice'' And C1.PKID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''')))'
	End
	

	
		If(@SortBy='')
		Begin
			Set @SortBy='A.TranDate'
		End			
		Else If(@SortBy='TranDate')
		Begin
			Set @SortBy='A.TranDate'
		End

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
	
	

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,@FKClientID	Varchar(max),@FKProjectID Varchar(max),@InvoiceID	Varchar(50),@PayID	Varchar(50),@TranType Varchar(50),	@RecType Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKClientID,@FKProjectID,@InvoiceID,@PayID,@TranType,@RecType,@DateForStr,@FKTimezoneID

	

End

