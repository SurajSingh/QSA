CREATE PROCEDURE [dbo].[uspGetDesignation]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),	
	@PKDesigID Bigint,
	@DesigName Varchar(50),	
	@FKCompanyID Bigint=0

AS
Begin
	SET NOCOUNT ON;
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
 
  --;WITH PG AS
  --(
  --  SELECT PKDesigID, C = COUNT(*) OVER()
  --    FROM dbo.tblDesigMaster
	 -- Where (PKDesigID=@PKDesigID Or @PKDesigID=0) and  (DesigName like @DesigName+'%' Or @DesigName='') and  (FKBankID=@FKBankID Or @FKBankID=0) and (FKPartyID=@FKPartyID Or @FKPartyID=0)
	 -- And (FKCompanyID=@FKCompanyID Or @FKCompanyID=0) And (RecordType=@RecordType)
  --    ORDER BY DesigName
  --    OFFSET @PageSize * (@PageNo - 1) ROWS
  --    FETCH NEXT @PageSize ROWS ONLY
  --)
  --SELECT A.PKDesigID,A.DesigName,A.DesigDesc, A.FKBankID, A.FKPartyID, A.RecordType, A.FKCompanyID, TotalRowCount = C
  --FROM dbo.tblDesigMaster AS A
  --INNER JOIN PG ON PG.PKDesigID = A.PKDesigID
  --ORDER BY A.DesigName OPTION (RECOMPILE);


	Set @StrQry=N' SELECT RCount = COUNT(*) OVER(),1 As Result,'''' as Msg,A.PKDesigID,A.DesigName,A.DesigDesc, ISnull(A.FKCompanyID,FKCompanyID)
	FROM dbo.tblDesigMaster AS A
	Where (PKDesigID=@PKDesigID Or @PKDesigID=0) and  (DesigName like @DesigName+''%'' Or @DesigName='''')
	And (FKCompanyID=@FKCompanyID Or @FKCompanyID=0)
	ORDER BY DesigName'
	
	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKDesigID	Bigint,@DesigName Varchar(50),@FKCompanyID Bigint'	
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKDesigID,@DesigName,@FKCompanyID
 

End