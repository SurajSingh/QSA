CREATE PROCEDURE [dbo].[uspGetBudgetReport]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKProjectID		Varchar(max),
	@FKClientID		    Varchar(max),
	@FKCompanyID		Bigint
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	Set @StrQry=N' Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.BudgetTitle,
	dbo.fnGetDateFormat(A.FromDate,@DateForStr,''D'') as FromDate,
	dbo.fnGetDateFormat(A.ToDate,@DateForStr,''D'') as ToDate,	
	B.ProjectCode,B.ProjectName,
	C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,
	A1.BudHrs,A1.CostRate,A1.BillRate,A1.IsBillable,T.TaskCode,T.TaskName,T.Description,
	Isnull((Select Sum(Hrs) From tblTimeSheet where ApproveStatus=''Approved'' 
	and FKProjectID=A.FKProjectID  and TaskDate between A.FromDate and A.ToDate and FKTaskID=A1.FKTaskID),0) as TimesheetHrs
	From 
	tblBudgetDetail A1
	Inner Join tblTask T on A1.FKTaskID=T.PKID
	Inner Join tblProjectBudget A on A1.FKBudgetID=A.PKID
	Inner Join tblProject B on A.FKProjectID=B.PKID
	Inner Join tblClient C1 on B.FKClientID=C1.PKID		
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Where A.FKCompanyID=@FKCompanyID
	And (@PKID=0 Or A.PKID=@PKID)	
	And (@DateWise=0 Or (A.FromDate<=@FromDate and A.ToDate>=@ToDate) or ( A.ToDate>=@ToDate and A.FromDate<=@ToDate) or (A.FromDate>@FromDate and A.ToDate<@ToDate)) 	'
	
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
		Set @SortBy='A.BudgetTitle'
	End		
	Else If(@SortBy='ProjectCode')
	Begin
		Set @SortBy='B.ProjectCode'
	End

	Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
	if(@PageSize>0)
	Begin
		Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
	End

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,	@PKID	Bigint,	@FKProjectID Varchar(max),@FKClientID	Varchar(max),@FKCompanyID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,	@PKID,	@FKProjectID,@FKClientID,@FKCompanyID,@DateForStr,@FKTimezoneID

End
