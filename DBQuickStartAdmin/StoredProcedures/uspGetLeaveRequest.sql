Create PROCEDURE [dbo].[uspGetLeaveRequest]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKCompanyID		Bigint,		
	@FKEmpID			Bigint,		
	@FKLeaveID			Bigint,
	@LeaveType			Varchar(50),
	@ApproveStatus		Varchar(50)
	AS
	Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,
	A.PKID,dbo.fnGetDateFormat(A.FromDate,@DateForStr,''D'') as FromDate,dbo.fnGetDateFormat(A.ToDate,@DateForStr,''D'') as ToDate, A.FKEmpID, 
	A.FKLeaveID, A.LeaveCount, A.FKCompanyID, A.ApproveStatus, A.FKApproveBy, A.FKCreatedBy,A.Remarks,Isnull(A.RejectReason,'''') as RejectReason,
	Isnull(U4.FName,'''')+'' ''+Isnull(U4.LName,'''') as EmpName,
	U4.LoginID,U4.EmailID,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate,
	Isnull(U3.FName,'''') as ApproveByName,
	B.LeaveName,B.PayType
	From tblLeaveRequest A	
	Left Join tblPayrollSettingLeave B on A.FKLeaveID=B.PKID	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblUser U3 on A.FKApproveBy=U3.PKUserID	
	Left Join tblUser U4 on A.FKEmpID=U4.PKUserID	
	Where  (A.PKID=@PKID or @PKID=0)
	And A.FKCompanyID=@FKCompanyID
	And (@DateWise=0 Or (((@FromDate>=A.FromDate and @FromDate<=A.ToDate) Or (@ToDate>=A.FromDate and @ToDate<=A.ToDate)))) 	 
	And (@FKEmpID=0 Or A.FKEmpID=@FKEmpID)
	And (@FKLeaveID=0 Or A.FKLeaveID=@FKLeaveID)	
	And (@LeaveType='''' Or B.PayType=@LeaveType)	
	And (@ApproveStatus='''' Or A.ApproveStatus=@ApproveStatus)	'
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.CreationDate'
		End			
		Else If(@SortBy='CreationDate')
		Begin
			Set @SortBy='A.CreationDate'
		End

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
	
	

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Bigint,@FKLeaveID	Bigint,@LeaveType Varchar(50),@ApproveStatus Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,@FKEmpID,@FKLeaveID,@LeaveType,@ApproveStatus,@DateForStr,@FKTimezoneID

	
	
End

