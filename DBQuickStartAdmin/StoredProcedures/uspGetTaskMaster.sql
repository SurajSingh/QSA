CREATE PROCEDURE [dbo].[uspGetTaskMaster]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
	@FKCompanyID		Bigint,
	@TaskCode			Varchar(50),
	@FKDeptID			Bigint,
	@TEType				Varchar(50),
	@ActiveStatus		Varchar(50)
AS
Begin
Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.TaskCode,A.TaskName,A.Description,A.IsBillable,A.ActiveStatus,isnull(A.FKDeptID,0) as FKDeptID,A.CostRate,A.BillRate,A.TEType,A.Tax,A.BHours,A.isReimb,A.MuRate,0 as TaxAmt,A.BHours*A.BillRate as BillAmt,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	ISnull(B.DeptName,'''') as DeptName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName
	From tblTask A
	Left Join tblDeptMaster B on A.FKDeptID=B.PKDeptID		
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)
	And (A.TaskCode+'':''+A.TaskName Like ''%''+@TaskCode+''%'' Or @TaskCode='''')
	And (A.FKCompanyID=@FKCompanyID)		
	And (A.FKDeptID=@FKDeptID Or @FKDeptID=0)	
	And (A.ActiveStatus=@ActiveStatus Or @ActiveStatus='''') 
	And ((A.TEType=@TEType) Or (@TEType=''BT'' And A.BHours>0 And A.TEType=''T'' ) Or @TEType='''') '
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.TaskCode,A.TaskName'
		End		
		Else If(@SortBy='TaskCode')
		Begin
			Set @SortBy='A.TaskCode'
		End
		Else If(@SortBy='DeptName')
		Begin
			Set @SortBy='B.DeptName'
		End
		
		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET (@PageNo)*@PageSize ROW FETCH NEXT @PageSize ROWS ONLY '
		End
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID Bigint,@FKCompanyID	Bigint,@TaskCode Varchar(50),@FKDeptID	Bigint,@TEType	Varchar(50),@ActiveStatus Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@FKCompanyID,@TaskCode,@FKDeptID,@TEType,@ActiveStatus,@DateForStr,@FKTimezoneID

	

End
