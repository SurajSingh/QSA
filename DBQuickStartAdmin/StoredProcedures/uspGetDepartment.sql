CREATE PROCEDURE [dbo].[uspGetDepartment]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),	
	@PKDeptID Bigint,
	@DeptName Varchar(50),
	@FKCompanyID Bigint
	
AS
Begin
	SET NOCOUNT ON;
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
 
  --;WITH PG AS
  --(
  --  SELECT PKDeptID, C = COUNT(*) OVER()
  --    FROM dbo.tblDeptMaster
	 -- Where (PKDeptID=@PKDeptID Or @PKDeptID=0) and  (DeptName like @DeptName+'%' Or @DeptName='') and  (FKBankID=@FKBankID Or @FKBankID=0) and (FKPartyID=@FKPartyID Or @FKPartyID=0)
	 -- And (FKCompanyID=@FKCompanyID Or @FKCompanyID=0) And (RecordType=@RecordType)
  --    ORDER BY DeptName
  --    OFFSET @PageSize * (@PageNo - 1) ROWS
  --    FETCH NEXT @PageSize ROWS ONLY
  --)
  --SELECT A.PKDeptID,A.DeptName,A.DeptDesc, A.FKBankID, A.FKPartyID, A.RecordType, A.FKCompanyID, TotalRowCount = C
  --FROM dbo.tblDeptMaster AS A
  --INNER JOIN PG ON PG.PKDeptID = A.PKDeptID
  --ORDER BY A.DeptName OPTION (RECOMPILE);



	Set @StrQry=N' SELECT RCount = COUNT(*) OVER(),1 As Result,'''' as Msg,A.PKDeptID,A.DeptName,A.DeptDesc, A.FKCompanyID,Isnull(A.FKManagerID,0) as FKManagerID,Isnull(B.FName+'' ''+B.LName,'''') as ManagerName
	FROM dbo.tblDeptMaster AS A
	LeFt join tblUser B on A.FKManagerID=B.PKUserID
	Where (PKDeptID=@PKDeptID Or @PKDeptID=0) and  (DeptName like @DeptName+''%'' Or @DeptName='''') 
	And (A.FKCompanyID=@FKCompanyID Or @FKCompanyID=0) 
	ORDER BY DeptName'

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKDeptID	Bigint,@DeptName Varchar(50),@FKCompanyID Bigint'	
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKDeptID,@DeptName,@FKCompanyID
 

End