CREATE PROCEDURE [dbo].[uspGetAsset]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
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
	
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, A.AssetCode, A.AssetName, A.AssetDesc, A.FKCategoryID, A.Manufacturer, 
	Isnull(A.FKPartyID,0) as FKPartyID,dbo.fnGetDateFormat(A.PurchaseDate,@DateForStr,''D'') as PurchaseDate, A.CurrentRate, 
	A.PurchaseRate, A.InvoiceID, A.PONo, A.Barcode, A.SerialNo, A.Remarks, A.ImgURL, 
	Isnull(A.FKConditionID,0) as FKConditionID, Isnull(A.FKLocationID,0) as FKLocationID, Isnull(A.FKDeptID,0) as FKDeptID, Isnull(A.FKEmpID,0) as FKEmpID, Isnull(A.FKRepairPartyID,0) FKRepairPartyID,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	Isnull(U1.FName,''N/A'') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	Isnull(P.Company,''N/A'') as Company,B.CategCode,B.CategName,Isnull(C.Condition,''N/A'') as Condition,Isnull(D.DeptName,''N/A'') as DeptName,
	Isnull(E.LocationName,''N/A'') as LocationName,Isnull(F.Company,'''') as RepairPartyName,
	Isnull(U3.FName,''N/A'')+'' ''+Isnull(U3.LName,'''') as EmpName,
	dbo.FunGetAssetLocation(Isnull(A.FKLocationID,0),Isnull(U3.FName,'''')+'' ''+Isnull(U3.LName,''''),Isnull(D.DeptName,''''),Isnull(F.Company,'''')) as AssetLocation
	From tblAsset A	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblPartyMaster P on A.FKPartyID=P.PKID
	Left Join tblAssetCategory B on A.FKCategoryID=B.PKID
	Left Join tblAssetConditionMaster C on A.FKConditionID=C.PKID
	Left Join tblUser U3 on A.FKEmpID=U3.PKUserID	
	Left Join tblDeptMaster D on A.FKDeptID=D.PKDeptID
	Left Join tblLocationMaster E on A.FKLocationID=E.PKID
	Left Join tblPartyMaster F on A.FKRepairPartyID=F.PKID
	Where (A.PKID=@PKID or @PKID=0)
	And (A.AssetCode Like ''%''+@AssetCode+''%'' Or @AssetCode='''' Or A.AssetName Like ''%''+@AssetCode+''%'')
	And (A.FKCompanyID=@FKCompanyID)
	And (A.FKCategoryID=@FKCategoryID Or @FKCategoryID=0)
	And (A.FKConditionID=@FKConditionID Or @FKConditionID=0)
	And (A.FKLocationID=@FKLocationID Or @FKLocationID=0)
	And (A.FKDeptID=@FKDeptID Or @FKDeptID=0)
	And (A.FKEmpID=@FKEmpID Or @FKEmpID=0)
	And (A.FKRepairPartyID=@FKRepairPartyID Or @FKRepairPartyID=0)
	'
	
	
		

		If(@SortBy='')
		Begin
			Set @SortBy='A.AssetCode,A.AssetName'
		End		
		Else If(@SortBy='AssetCode')
		Begin
			Set @SortBy='A.AssetCode'
		End
		Else If(@SortBy='Company')
		Begin
			Set @SortBy='P.Company'
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
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID Bigint,@AssetCode	Varchar(50),@FKCategoryID	Bigint,@FKConditionID	Bigint,@FKLocationID Bigint,@FKDeptID	Bigint,@FKEmpID Bigint,@FKRepairPartyID Bigint,	@FKCompanyID Bigint,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@AssetCode,@FKCategoryID,@FKConditionID,@FKLocationID,@FKDeptID,@FKEmpID,@FKRepairPartyID,	@FKCompanyID,@DateForStr,@FKTimezoneID

	

End
