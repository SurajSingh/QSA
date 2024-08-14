CREATE PROCEDURE [dbo].[uspGetProjectBudget]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
	@FKProjectID		Bigint,
	@FKCompanyID		Bigint
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	
	Set @StrQry=N' Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.BudgetTitle,A.FKProjectID,
	dbo.fnGetDateFormat(A.FromDate,@DateForStr,''D'') as FromDate,
	dbo.fnGetDateFormat(A.ToDate,@DateForStr,''D'') as ToDate,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate,
	B.ProjectCode,B.ProjectName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	Isnull((Select Sum(Hrs) From tblTimeSheet where ApproveStatus=''Approved'' 
	and FKProjectID=A.FKProjectID  and TaskDate between A.FromDate and A.ToDate and FKTaskID in (Select FKTaskID From tblBudgetDetail where FKBudgetID=A.PKID)),0) as TimesheetHrs,
	Isnull((Select Sum(BudHrs) From tblBudgetDetail where FKBudgetID=A.PKID),0) as BudHrs

	From tblProjectBudget A
	Inner Join tblProject B on A.FKProjectID=B.PKID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Where A.FKCompanyID=@FKCompanyID
	And (@PKID=0 Or A.PKID=@PKID)	
	And (@FKProjectID=0 Or A.FKProjectID=@FKProjectID)
	'

	
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

	If(@PKID<>0)
	Begin
		Set @StrQry=@StrQry+N' Select A.PKID,A.FKTaskID,A.BudHrs,A.CostRate,A.BillRate,A.IsBillable,T.TaskCode,T.TaskName,T.Description,
		Isnull((Select Sum(Hrs) From tblTimeSheet where ApproveStatus=''Approved'' 
		and FKProjectID=C.FKProjectID  and TaskDate between C.FromDate and C.ToDate and FKTaskID=A.FKTaskID),0) as TimesheetHrs
		From tblBudgetDetail A
		Inner Join tblTask T on A.FKTaskID=T.PKID
		Inner Join tblProjectBudget C on A.FKBudgetID=C.PKID
		Where (A.FKBudgetID=@PKID)
		Order by T.TaskCode,T.TaskName '		
	End


	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),	@PKID	Bigint,	@FKProjectID Bigint,@FKCompanyID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,	@PKID,	@FKProjectID,@FKCompanyID,@DateForStr,@FKTimezoneID


End
