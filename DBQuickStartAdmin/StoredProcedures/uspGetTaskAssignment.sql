CREATE PROCEDURE [dbo].[uspGetTaskAssignment]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKCompanyID		Bigint,	
	@FKEmpID			Varchar(max),
	@FKClientID			Varchar(max),
	@FKProjectID		Varchar(max),
	@FKTaskID			Varchar(max),
	@CurrentStatus		Varchar(max),
	@FKManagerID		Bigint,	
	@RecType			Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, dbo.fnGetDateFormat(A.AssignDate,@DateForStr,''D'') as AssignDate, 
	A.FKTaskID, A.FKEmpID, A.FKProjectID, A.BHrs, A.TimeTaken, A.Description, A.CurrentStatus, A.FKManagerID, A.FKCreatedBy,A.Remark,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	B.LoginID,B.FName+'' ''+B.LName as EmpName,C.ProjectCode,C.ProjectName,
	D.TaskCode+'':''+D.TaskName as TaskName,C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	Isnull(U.FName+'' ''+U.LName,'''') as ManagerName,(Select count(*) From tbltimesheet where FKAssignLogID=A.PKID) as LogCount	
	From tblTaskAssignment A
	Inner Join tblUser B on A.FKEmpID=B.PKUserID
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser U on A.FKManagerID=U.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And ((A.AssignDate>=@FromDate and A.AssignDate<=@ToDate) Or @DateWise=0) 	
	And (@FKManagerID=0 Or A.FKManagerID=@FKManagerID) '

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
	IF(@CurrentStatus<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.CurrentStatus in (Select Item From dbo.FunSplitString(@CurrentStatus,'','') where Item<>'''') '
	End
	
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.AssignDate'
		End			
		Else If(@SortBy='CurrentStatus')
		Begin
			Set @SortBy='A.CurrentStatus'
		End

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
	If(@PKID<>0)
	Begin
		Set @StrQry=@StrQry+' Select A.PKID, dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'') as TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, A.Description, A.IsBillable, 
	A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus, 
	dbo.fnGetDateFormat(A.ApproveDate,@DateForStr,''D'') as ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate FRom tblTimesheet A where A.FKAssignLogID=@PKID '
	End

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKTaskID	Varchar(max),@CurrentStatus Varchar(max),@FKManagerID Bigint,@RecType	Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKClientID,	@FKProjectID,@FKTaskID,@CurrentStatus,@FKManagerID,@RecType,@DateForStr,@FKTimezoneID

	

End

