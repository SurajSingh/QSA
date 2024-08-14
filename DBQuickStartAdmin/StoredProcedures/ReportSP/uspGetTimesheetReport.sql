CREATE PROCEDURE [dbo].[uspGetTimesheetReport]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@ColStr				Varchar(Max),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,	
	@PKID				Bigint,
	@FKCompanyID		Bigint,	
	@FKEmpID			Varchar(max),
	@FKClientID			Varchar(max),
	@FKProjectID		Varchar(max),
	@FKTaskID			Varchar(max),
	@ApproveStatus		Varchar(max),
	@Billed				Varchar(50),
	@Billable			Varchar(50),
	@RecType			Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @SelectCol varchar(max)=''
	Declare @GroupByCol	varchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	

	Declare @ColStr1 varchar(max)=@ColStr

	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	

	if(@ColStr='')
	Begin
		Set @SelectCol=	'A.PKID, dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'') as TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, A.Description, A.IsBillable, 
		A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus, 
		dbo.fnGetDateFormat(A.ApproveDate,@DateForStr,''D'') as ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,
		dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
		dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
		C.ProjectCode,C.ProjectName,Isnull(C2.TMemoRequired,0) as TMemoRequired,Isnull(C2.TDesReadonly,0) as TDesReadonly,
		D.TaskCode+'':''+D.TaskName as TaskName,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,
		Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
		Isnull(U.FName,'''') as SubmitToName,
		Isnull(U3.FName,'''') as ApproveByName,
		Emp.FName,Emp.LName,emp.LoginID'
		Set @GroupByCol=''
	End
	Else
	Begin
			Set @SelectCol=@ColStr
			Set @GroupByCol=@ColStr

			
			Set  @SelectCol=REPLACE(@SelectCol,'[PKID]','A.PKID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[PKID]','A.PKID')

			Set  @SelectCol=REPLACE(@SelectCol,'[TaskDate]','dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'')')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[TaskDate]','dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'')')

		

			Set  @SelectCol=REPLACE(@SelectCol,'[FKTaskID]','A.FKTaskID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[FKTaskID]','A.FKTaskID')

			Set  @SelectCol=REPLACE(@SelectCol,'[FKEmpID]','A.FKEmpID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[FKEmpID]','A.FKEmpID')

			Set  @SelectCol=REPLACE(@SelectCol,'[FKProjectID]','A.FKProjectID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[FKProjectID]','A.FKProjectID')

			Set  @SelectCol=REPLACE(@SelectCol,'[Description]','A.Description')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[Description]','A.Description')

			Set  @SelectCol=REPLACE(@SelectCol,'[IsBillable]','A.IsBillable')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[IsBillable]','A.IsBillable')

			Set  @SelectCol=REPLACE(@SelectCol,'[Memo]','A.Memo')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[Memo]','A.Memo')


			Set  @SelectCol=REPLACE(@SelectCol,'[IsBilled]','A.IsBilled')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[IsBilled]','A.IsBilled')

			Set  @SelectCol=REPLACE(@SelectCol,'[ProjectCode]','C.ProjectCode')		
			Set  @SelectCol=REPLACE(@SelectCol,'[ProjectName]','C.ProjectName')		

			Set  @GroupByCol=REPLACE(@GroupByCol,'[ProjectCode]','C.ProjectCode')
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ProjectName]','C.ProjectName')

			Set  @SelectCol=REPLACE(@SelectCol,'[TaskName]','D.TaskCode+'':''+D.TaskName as TaskName')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[TaskName]','D.TaskCode+'':''+D.TaskName')

			
			Set  @SelectCol=REPLACE(@SelectCol,'[ClientCode]','C1.Code As ClientCode')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ClientCode]','C1.Code')

			
			Set  @SelectCol=REPLACE(@SelectCol,'[ClientName]','C1.Company as ClientName')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ClientName]','C1.Company')

			Set  @SelectCol=REPLACE(@SelectCol,'[TCostRate]','A.TCostRate')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[TCostRate]','A.TCostRate')

			Set  @SelectCol=REPLACE(@SelectCol,'[TBillRate]','A.TBillRate')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[TBillRate]','A.TBillRate')

			Set  @SelectCol=REPLACE(@SelectCol,'[PBudgetedHours]','C.BudgetedHours as PBudgetedHours')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[PBudgetedHours]','C.BudgetedHours')

			Set  @SelectCol=REPLACE(@SelectCol,'[ServiceAmt]','C.ServiceAmt as ServiceAmt')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ServiceAmt]','C.ServiceAmt')
			
			

			Set  @SelectCol=REPLACE(@SelectCol,'[Hrs]','Sum(A.Hrs) as Hrs')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[Hrs]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[TBHours]','Sum(A.TBHours) as TBHours')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[TBHours]','')

			Set  @SelectCol=REPLACE(@SelectCol,'[LoginID]','emp.LoginID as LoginID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[LoginID]','emp.LoginID')

			Set  @SelectCol=REPLACE(@SelectCol,'[EmpName]','Emp.FName+'' ''+Emp.LName as EmpName')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[EmpName]','Emp.FName+'' ''+Emp.LName')

			Set  @SelectCol=REPLACE(@SelectCol,'[SubmitToID]','U.LoginID as SubmitToID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[SubmitToID]','U.LoginID')

			Set  @SelectCol=REPLACE(@SelectCol,'[SubmitToName]','U.FName+'' ''+U.LName as SubmitToName')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[SubmitToName]','U.FName+'' ''+U.LName')

			Set  @SelectCol=REPLACE(@SelectCol,'[ManagerID]','U4.LoginID as ManagerID')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ManagerID]','U4.LoginID')

			Set  @SelectCol=REPLACE(@SelectCol,'[ManagerName]','U4.FName+'' ''+U4.LName as ManagerName')		
			Set  @GroupByCol=REPLACE(@GroupByCol,'[ManagerName]','U4.FName+'' ''+U4.LName')

			Set  @SelectCol=REPLACE(@SelectCol,'[BillAmt]','Sum(A.Hrs*A.TBillRate) as BillAmt')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[BillAmt]','')
			
			Set  @SelectCol=REPLACE(@SelectCol,'[CostAmt]','Sum(A.Hrs*A.TCostRate) as CostAmt')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[CostAmt]','')
		
			Set  @SelectCol=REPLACE(@SelectCol,'[BudAmt]','Sum(A.TBHours*A.TBillRate) as BudAmt')
			Set  @GroupByCol=REPLACE(@GroupByCol,',[BudAmt]','')
					
	End
	
	Set @StrQry=N'Select '+@SelectCol+'
	From tblTimeSheet A
	
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID
	Left Join tblProjectDetail C2 on C2.FKProjectID=C.PKID
	Left Join tblUser Emp on A.FKEmpID=emp.PKUserID
	Left Join tblUser U on A.FKSubmitToID=U.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblUser U3 on A.FKApproveByID=U3.PKUserID	
	Left Join tblUser U4 on C.FKManagerID=U4.PKUserID
	Where A.BStatus=1 And Emp.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And ((A.TaskDate>=@FromDate and A.TaskDate<=@ToDate) Or @DateWise=0) '

	IF(@FKEmpID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKEmpID in (Select Item From dbo.FunSplitString(@FKEmpID,'','') where Item<>'''') '
	End
	IF(@FKProjectID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKProjectID in (Select Item From dbo.FunSplitString(@FKProjectID,'','') where Item<>'''') '
	End
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And C1.PKID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
	End
	IF(@FKTaskID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKTaskID in (Select Item From dbo.FunSplitString(@FKTaskID,'','') where Item<>'''') '
	End
	IF(@ApproveStatus<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.ApproveStatus in (Select Item From dbo.FunSplitString(@ApproveStatus,'','') where Item<>'''') '
	End
	IF(@Billed<>'')
	Begin
		If(@Billed='1')
		Begin	
			Set @StrQry=@StrQry+N' And A.IsBilled=1'
		End
		Else
		Begin	
			Set @StrQry=@StrQry+N' And A.IsBilled=0'
		End
		
	End
	IF(@Billable<>'')
	Begin
		If(@Billable='1')
		Begin	
			Set @StrQry=@StrQry+N' And A.IsBillable=1'
		End
		Else
		Begin	
			Set @StrQry=@StrQry+N' And A.IsBillable=0'
		End
		
	End


	if(@GroupByCol<>'')
	Begin
		Set @StrQry=@StrQry+' Group By '+@GroupByCol
	End	

	if(@SortDir='')
	Begin
			Set @SortDir='A'
	End

	If(@SortBy='')
	Begin
		Set @SortBy='A.TaskDate'
	End			
	Else If(@SortBy='ApproveStatus')
	Begin
		Set @SortBy='A.ApproveStatus'
	End

	Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
	if(@PageSize>0)
	Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
	End
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKTaskID	Varchar(max),@ApproveStatus Varchar(max),@Billed Varchar(50),@Billable Varchar(50),@RecType	Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKClientID,	@FKProjectID,@FKTaskID,@ApproveStatus,@Billed,@Billable,@RecType,@DateForStr,@FKTimezoneID

	


End