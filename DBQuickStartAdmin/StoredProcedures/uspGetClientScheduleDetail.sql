CREATE PROCEDURE [dbo].[uspGetClientScheduleDetail]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@DateWise			bit,
	@FromDate			Date,
	@ToDate				Date,
	@PKID				Bigint,
	@FKCompanyID		Bigint,	
	@FKEmpID			Varchar(max)='',
	@FKClientID			Varchar(max)='',
	@FKProjectID		Varchar(max)='',
	@FKStatusID			Bigint=0,
	@FKWorkTypeID		Bigint=0,
	@RecType			Varchar(max)=''
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,
	B.FKEmpID,B.IsRead,A.PKID, A.FKProjectID, dbo.fnGetDateFormat(A.FromDate,@DateForStr,''D'') as FromDate,dbo.fnGetDateFormat(A.ToDate,@DateForStr,''D'') as ToDate,	
	dbo.fnGetDateFormat(A.FromTime,@DateForStr,''T'') as FromTime,A.FKWorkTypeID, A.FKStatusID, A.Remarks,	 
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	C.ProjectCode,C.ProjectName,
	C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,	
	S.StatusTitle,W.WorkType,emp.LoginID,emp.FName+'' ''+emp.LName as EmpName,emp.EmailID
	
	From 
	tblClientScheduleDetail B inner join
	tblClientSchedule A on B.FKID=A.PKID
	Inner Join tblProject C on A.FKProjectID=C.PKID	
	Inner Join tblClient C1 on C.FKClientID=C1.PKID		
	Left Join tblUser Emp on B.FKEmpID=Emp.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblScheduleStatus S on A.FKStatusID=S.PKID
	Left Join tblWorkTypeMaster W on A.FKWorkTypeID=W.PKID
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And (@DateWise=0 Or (((@FromDate>=A.FromDate and @FromDate<=A.ToDate) Or (@ToDate>=A.FromDate and @ToDate<=A.ToDate)))) 
	And (@FKWorkTypeID=0 Or A.FKWorkTypeID=@FKWorkTypeID) 
	And (@FKStatusID=0 Or A.FKStatusID=@FKStatusID) '

	IF(@FKEmpID<>'')
	Begin
		Set @StrQry=@StrQry+N' And (Select Count(*) FRom tblClientScheduleDetail where FKID=A.PKID and FKEmpID in (Select Item From dbo.FunSplitString(@FKEmpID,'','') where Item<>''''))>0 '
	End
	IF(@FKProjectID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKProjectID in (Select Item From dbo.FunSplitString(@FKProjectID,'','') where Item<>'''') '
	End
	IF(@FKClientID<>'')
	Begin
		Set @StrQry=@StrQry+N' And C1.PKID in (Select Item From dbo.FunSplitString(@FKClientID,'','') where Item<>'''') '
	End
	IF(@FKEmpID<>'')
	Begin
		Set @StrQry=@StrQry+N' And B.FKEmpID in (Select Item From dbo.FunSplitString(@FKEmpID,'','') where Item<>'''') '
	End
	IF(@RecType<>'')
	Begin
		If(@RecType='Read')
		Begin
			Set @StrQry=@StrQry+N' And B.IsRead=1'
		End
		Else If(@RecType='Unread')
		Begin
			Set @StrQry=@StrQry+N' And B.IsRead=0'
		End
	End
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.FromDate'
		End			
		Else If(@SortBy='FromDate')
		Begin
			Set @SortBy='A.FromDate'
		End
		Else If(@SortBy='ToDate')
		Begin
			Set @SortBy='A.ToDate'
		End

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc ' Else ' Asc ' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
		
	
	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKStatusID	Bigint,@FKWorkTypeID Bigint,@RecType	Varchar(max),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKClientID,	@FKProjectID,@FKStatusID,@FKWorkTypeID,@RecType,@DateForStr,@FKTimezoneID

	

End

