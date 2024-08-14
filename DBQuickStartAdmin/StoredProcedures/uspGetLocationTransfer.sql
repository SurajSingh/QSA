CREATE PROCEDURE [dbo].[uspGetLocationTransfer]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
	@DateWise			Bit,
	@FromDate			Date,
	@ToDate				Date,
	@FKAssetID			Bigint,
	@AssetCode			Varchar(50),
	@FKCategoryID		Bigint,
	@FKConditionID		Bigint, 
	@FKLocationID		Bigint,
	@FKDeptID			Bigint,
	@FKEmpID			Bigint,
	@FKRepairPartyID	Bigint,
	@FKCompanyID		Bigint
	
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, A.FKAssetID,A1.AssetCode, A1.AssetName, A1.AssetDesc, A1.Manufacturer, 
	dbo.fnGetDateFormat(A.TranDate,@DateForStr,''D'') as TranDate, A.EntryID, 
	A1.Barcode, A1.SerialNo, A1.ImgURL, 
	Isnull(A.FKLocationID,0) as FKLocationID, Isnull(A.FKDeptID,0) as FKDeptID, Isnull(A.FKEmpID,0) as FKEmpID, Isnull(A.FKRepairPartyID,0) FKRepairPartyID,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	B.CategCode,B.CategName,Isnull(C.Condition,'''') as Condition,Isnull(D.DeptName,'''') as DeptName,
	Isnull(E.LocationName,'''') as LocationName,Isnull(F.Company,'''') as RepairPartyName,
	Isnull(U3.FName,'''')+'' ''+Isnull(U3.LName,'''') as EmpName,
	dbo.FunGetAssetLocation(Isnull(A.FKLocationID,0),Isnull(U3.FName,'''')+'' ''+Isnull(U3.LName,''''),Isnull(D.DeptName,''''),Isnull(F.Company,'''')) as AssetLocation,
	dbo.FunGetAssetLocation(Isnull(A2.FKLocationID,0),Isnull(U31.FName,'''')+'' ''+Isnull(U31.LName,''''),Isnull(D1.DeptName,''''),Isnull(F1.Company,'''')) as PAssetLocation,
	Isnull(E1.LocationName,'''') as PLocationName
	
	From 
	tblLocationTransfer A Inner Join 
	tblAsset A1 on A.FKAssetID=A1.PKID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID		
	Left Join tblAssetCategory B on A1.FKCategoryID=B.PKID
	Left Join tblAssetConditionMaster C on A1.FKConditionID=C.PKID
	Left Join tblUser U3 on A.FKEmpID=U3.PKUserID	
	Left Join tblDeptMaster D on A.FKDeptID=D.PKDeptID
	Left Join tblLocationMaster E on A.FKLocationID=E.PKID
	Left Join tblPartyMaster F on A.FKRepairPartyID=F.PKID
	Left Join tblLocationTransfer A2 on A2.PKID=A.FKPrevID
	Left Join tblUser U31 on A2.FKEmpID=U31.PKUserID	
	Left Join tblDeptMaster D1 on A2.FKDeptID=D1.PKDeptID
	Left Join tblLocationMaster E1 on A2.FKLocationID=E1.PKID
	Left Join tblPartyMaster F1 on A2.FKRepairPartyID=F1.PKID

	Where (A.PKID=@PKID or @PKID=0)
	And (A1.AssetCode Like ''%''+@AssetCode+''%'' Or @AssetCode='''' Or A1.AssetName Like ''%''+@AssetCode+''%'')
	And (A.FKCompanyID=@FKCompanyID)
	And (A1.FKCategoryID=@FKCategoryID Or @FKCategoryID=0)
	And (A1.FKConditionID=@FKConditionID Or @FKConditionID=0)
	And (A.FKLocationID=@FKLocationID Or @FKLocationID=0)
	And (A.FKDeptID=@FKDeptID Or @FKDeptID=0)
	And (A.FKEmpID=@FKEmpID Or @FKEmpID=0)
	And (A.FKAssetID=@FKAssetID Or @FKAssetID=0)
	And (A.FKRepairPartyID=@FKRepairPartyID Or @FKRepairPartyID=0)
	And (@DateWise=0 Or (A.TranDate between @FromDate and @ToDate))
	And isnull(A.FKPrevID,0)<>0 	'
	
	
		

		If(@SortBy='')
		Begin
			Set @SortBy='A.TranDate'
		End		
		Else If(@SortBy='AssetCode')
		Begin
			Set @SortBy='A1.AssetCode'
		End
		
		Else If(@SortBy='RepairPartyName')
		Begin
			Set @SortBy='F.Company'
		End
		
		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID Bigint,@DateWise	Bit,@FromDate	Date,@ToDate	Date,@FKAssetID	Bigint,@AssetCode	Varchar(50),@FKCategoryID	Bigint,@FKConditionID	Bigint,@FKLocationID Bigint,@FKDeptID	Bigint,@FKEmpID Bigint,@FKRepairPartyID Bigint,	@FKCompanyID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@DateWise,@FromDate,@ToDate,@FKAssetID,@AssetCode,@FKCategoryID,@FKConditionID,@FKLocationID,@FKDeptID,@FKEmpID,@FKRepairPartyID,	@FKCompanyID,@DateForStr,@FKTimezoneID

	

End
