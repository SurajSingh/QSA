CREATE PROCEDURE [dbo].[uspGetAppointment]
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
	@FKIntervalID		Bigint,	
	@ApproveStatus   Varchar(50)
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	--Removed A.Purpose from query becoz it is not int the table coloumn
	Set @StrQry=N'	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, dbo.fnGetDateFormat(A.OnDate,@DateForStr,''D'') as OnDate, 
	convert(varchar(3),DATENAME(dw,A.OnDate)) as DayName1,DATEPART(d, a.OnDate) as Day1,DATEPART(yy, a.OnDate) as Year1,Left(DATENAME(mm,a.OnDate),3) Month1,
	A.FKEmpID, A.FKIntervalID, dbo.fnGetDateFormat(A.FromTime,@DateForStr,''T'') as FromTime, dbo.fnGetDateFormat(A.ToTime,@DateForStr,''T'') As ToTime, A.TotalMinutes,dbo.fnMinutesToTime(A.TotalMinutes) as TimeStr, A.CutomerName, A.CompanyName, 
	A.EmailID, A.Mobile, A.Remarks, A.ApproveStatus, 
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	B.LoginID,B.FName+'' ''+B.LName as EmpName,B.EmailID as EmpEmailID,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName	
	From tblAppoinment A
	Inner Join tblUser B on A.FKEmpID=B.PKUserID
	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And (A.FKIntervalID=@FKIntervalID or @FKIntervalID=0)
	And ((A.OnDate>=@FromDate and A.OnDate<=@ToDate) Or @DateWise=0) 	
	And (@ApproveStatus='''' Or A.ApproveStatus=@ApproveStatus) '

	IF(@FKEmpID<>'')
	Begin
		Set @StrQry=@StrQry+N' And A.FKEmpID in (Select Item From dbo.FunSplitString(@FKEmpID,'','') where Item<>'''') '
	End
	
	
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.OnDate'
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
	

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@DateWise	bit,@FromDate	Date,@ToDate Date,@PKID	Bigint,@FKCompanyID Bigint,	@FKEmpID Varchar(max),@FKIntervalID		Bigint,	@ApproveStatus   Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@DateWise,@FromDate,@ToDate,@PKID,@FKCompanyID,	@FKEmpID,@FKIntervalID,	@ApproveStatus,@DateForStr,@FKTimezoneID

	

End


