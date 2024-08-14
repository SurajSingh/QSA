CREATE PROCEDURE [dbo].[uspGetTimesheet]
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
	@ApproveStatus		Varchar(max),
	@Billed				Varchar(50),
	@FKInvoiceID		Bigint,
	@FKSubmitToID		Bigint,
	@FKAssignLogID		Bigint,
	@RecType			Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, dbo.fnGetDateFormat(A.TaskDate,@DateForStr,''D'') as TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, A.Description, A.IsBillable, 
	A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus, 
	dbo.fnGetDateFormat(A.ApproveDate,@DateForStr,''D'') as ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	C.ProjectCode,C.ProjectName,Isnull(C2.TMemoRequired,0) as TMemoRequired,Isnull(C2.TDesReadonly,0) as TDesReadonly,
	D.TaskCode+'':''+D.TaskName as TaskName,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	Isnull(U.FName,'''') as SubmitToName,
	Isnull(U3.FName,'''') as ApproveByName,
	Emp.FName,Emp.LName,emp.LoginID
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
	Where A.BStatus=1 And Emp.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And ((A.TaskDate>=@FromDate and A.TaskDate<=@ToDate) Or @DateWise=0) 
	And (@FKInvoiceID=0 Or A.FKInvoiceID=@FKInvoiceID) 
	And (@FKSubmitToID=0 Or A.FKSubmitToID=@FKSubmitToID) 
	And (@FKAssignLogID=0 Or A.FKAssignLogID=@FKAssignLogID) '

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
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKTaskID	Varchar(max),@ApproveStatus Varchar(max),@Billed Varchar(50),@FKInvoiceID Bigint,@FKSubmitToID Bigint,@FKAssignLogID Bigint,@RecType	Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKClientID,	@FKProjectID,@FKTaskID,@ApproveStatus,@Billed,@FKInvoiceID ,@FKSubmitToID,@FKAssignLogID,@RecType,@DateForStr,@FKTimezoneID

	

End
