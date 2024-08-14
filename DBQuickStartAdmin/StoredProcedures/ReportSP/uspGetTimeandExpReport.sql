CREATE PROCEDURE [dbo].[uspGetTimeandExpReport]
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
	@FKManagerID		Bigint,
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
	
	exec sp_refreshview ViewTimesheetwithExpenses

	Declare @ColStr1 varchar(max)=@ColStr

	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Set @SelectCol=@ColStr
	Set @GroupByCol=@ColStr

			
	Set  @SelectCol=REPLACE(@SelectCol,'[PKID]','A.PKID')	
	Set  @SelectCol=REPLACE(@SelectCol,'[MU]','A.MU')		
	Set  @SelectCol=REPLACE(@SelectCol,'[IsReimb]','A.IsReimb')		

	Set  @SelectCol=REPLACE(@SelectCol,'[TaskDate]','A.TaskDate as TaskDate1,dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'') as TaskDate')
	Set  @GroupByCol=REPLACE(@GroupByCol,'[TaskDate]','A.TaskDate,dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'')')

		
  	Set  @SelectCol=REPLACE(@SelectCol,'[Profit]','Sum(Case When IsBillable=1 then CostAmt*MU/100 Else -1*CostAmt End) as Profit')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[Profit]','')
			
			

	Set  @SelectCol=REPLACE(@SelectCol,'[Hrs]','Sum(A.Hrs) as Hrs')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[Hrs]','')
	Set  @GroupByCol=REPLACE(@GroupByCol,'[Hrs],','')

	Set  @SelectCol=REPLACE(@SelectCol,'[TBHours]','Sum(A.TBHours) as TBHours')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[TBHours]','')
	
	Set  @SelectCol=REPLACE(@SelectCol,'[Amount]','Sum(A.Amount) as Amount')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[Amount]','')
			

	Set  @SelectCol=REPLACE(@SelectCol,'[ExpAmt]','Sum(A.ExpAmt) as ExpAmt')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[ExpAmt]','')

	Set  @SelectCol=REPLACE(@SelectCol,'[ServiceAmt]','Sum(A.ServiceAmt) as ServiceAmt')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[ServiceAmt]','')

	Set  @SelectCol=REPLACE(@SelectCol,'[BillAmt]','Sum(A.BillAmt) as BillAmt')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[BillAmt]','')
			
	Set  @SelectCol=REPLACE(@SelectCol,'[CostAmt]','Sum(A.CostAmt) as CostAmt')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[CostAmt]','')
		
	Set  @SelectCol=REPLACE(@SelectCol,'[BudAmt]','Sum(A.BudAmt) as BudAmt')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[BudAmt]','')

	Set  @SelectCol=REPLACE(@SelectCol,'[BillHrs]','Sum(A.BillHrs) as BillHrs')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[BillHrs]','')

	Set  @SelectCol=REPLACE(@SelectCol,'[UnBillHrs]','Sum(A.UnBillHrs) as UnBillHrs')
	Set  @GroupByCol=REPLACE(@GroupByCol,',[UnBillHrs]','')
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,'+@SelectCol+'
	From ViewTimesheetwithExpenses A
	Where (A.PKID=@PKID or @PKID=0) And (@FKManagerID=0 Or A.FKManagerID=@FKManagerID)
	And ((A.TaskDate>=@FromDate and A.TaskDate<=@ToDate) Or @DateWise=0) '

	If(@RecType<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.TType=@RecType '
	End

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
		Set @StrQry=@StrQry+N' And A.FKClientID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
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
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKTaskID	Varchar(max),@FKManagerID		Bigint,@ApproveStatus Varchar(max),@Billed Varchar(50),@Billable Varchar(50),@RecType	Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKEmpID,@FKClientID,@FKProjectID,@FKTaskID,@FKManagerID,@ApproveStatus,@Billed,@Billable,@RecType,@DateForStr,@FKTimezoneID

	


End