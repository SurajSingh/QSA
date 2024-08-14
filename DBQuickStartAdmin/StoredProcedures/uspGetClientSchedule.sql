CREATE PROCEDURE [dbo].[uspGetClientSchedule]
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
	@FKStatusID			Bigint,
	@FKWorkTypeID		Bigint
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	 
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,
	convert(varchar(3),DATENAME(dw,A.FromDate)) as DayName1,DATEPART(d, a.FromDate) as Day1,DATEPART(yy, a.FromDate) as Year1,Left(DATENAME(mm,a.FromDate),3) Month1,
	convert(varchar(3),DATENAME(dw,A.ToDate)) as DayName2,DATEPART(d, a.ToDate) as Day2,DATEPART(yy, a.ToDate) as Year2,Left(DATENAME(mm,a.ToDate),3) Month2,
	A.PKID, A.FKProjectID, dbo.fnGetDateFormat(A.FromDate,@DateForStr,''D'') as FromDate,dbo.fnGetDateFormat(A.ToDate,@DateForStr,''D'') as ToDate,	
	dbo.fnGetDateFormat(A.FromTime,@DateForStr,''T'') as FromTime,A.FKWorkTypeID, A.FKStatusID, A.Remarks,	 
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	C.ProjectCode,C.ProjectName,C1.PKID as FKClientID,
	C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,	
	S.StatusTitle,W.WorkType,
	dbo.FunGetScheduledEmp(A.PKID) as EmpList
	From tblClientSchedule A
	Inner Join tblProject C on A.FKProjectID=C.PKID	
	Inner Join tblClient C1 on C.FKClientID=C1.PKID		
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblScheduleStatus S on A.FKStatusID=S.PKID
	Left Join tblWorkTypeMaster W on A.FKWorkTypeID=W.PKID
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And (@DateWise=0 Or (A.FromDate<=@FromDate and A.ToDate>=@ToDate) or ( A.ToDate>=@ToDate and A.FromDate<=@ToDate) or (A.FromDate>@FromDate and A.ToDate<@ToDate)) 
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

		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
	If(@PKID<>0)
	Begin
		Set @StrQry=@StrQry+' exec uspGetClientScheduleDetail 0,0,'''','''',0,null,null,@PKID,@FKCompanyID,'''','''','''',0,0,'''''
	End

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKClientID Varchar(max),	@FKProjectID Varchar(max),@FKStatusID	Bigint,@FKWorkTypeID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKClientID,	@FKProjectID,@FKStatusID,@FKWorkTypeID,@DateForStr,@FKTimezoneID

	

End
