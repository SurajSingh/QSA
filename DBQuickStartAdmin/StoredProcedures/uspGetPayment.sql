CREATE PROCEDURE [dbo].[uspGetPayment]
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
	@PayID				Varchar(50),	
	@FKPaymentTypeID	Bigint,
	@FKPaymodeID		Bigint,
	@RecType			Varchar(50)
	AS
	Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, A.SNo, A.PayID, A.FKClientID,dbo.fnGetDateFormat(A.TranDate,@DateForStr,''D'') as TranDate, 
	A.FKPaymentTypeID, Isnull(A.FKPaymodeID,0) as FKPaymodeID, 
	A.TranID, A.IsRetainer, A.Amount, A.RetainerAmount,	
	C1.Code As ClientCode,C1.Company as ClientName,C1.CPerson as ClientCPerson,C1.CPersonTitle as ClientCPersonTitle,
	C1.Retainer as ClientBalance,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate,
	Isnull(PM.PaymentMode,'''') as PaymentMode,PT.PaymentType
	From tblPayment A	
	Left Join tblClient C1 on A.FKClientID=C1.PKID	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblPayModeMaster PM on A.FKPaymodeID=PM.PKID
	Left Join tblPaymentType PT on A.FKPaymentTypeID=PT.PKID
	Where  (A.PKID=@PKID or @PKID=0)
	And ((A.TranDate>=@FromDate and A.TranDate<=@ToDate) Or @DateWise=0) 
	And (@PayID='''' Or A.PayID=@PayID) 
	And (@FKPaymentTypeID=0 Or A.FKPaymentTypeID=@FKPaymentTypeID)
	And (@FKPaymodeID=0 Or A.FKPaymodeID=@FKPaymentTypeID)	'

	
	
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKClientID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
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
	
	If(@PKID<>0)
	Begin
		Select @FKClientID=FKClientID From tblPayment where PKID=@PKID
		Set @StrQry=@StrQry+'	Exec uspGetInvForAdjustment @PKID,@FKClientID,0,@FKCompanyID '

	End

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,@FKClientID	Varchar(max),@PayID	Varchar(50),@FKPaymentTypeID	Bigint,@FKPaymodeID Bigint,	@RecType Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKClientID,@PayID,@FKPaymentTypeID,@FKPaymodeID,@RecType,@DateForStr,@FKTimezoneID

	
	
End

