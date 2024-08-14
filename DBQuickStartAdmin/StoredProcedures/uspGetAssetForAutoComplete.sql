CREATE PROCEDURE [dbo].[uspGetAssetForAutoComplete]
	@PKID		 Bigint,
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,
	A.PKID, A.AssetCode, A.AssetName, 
	'<div class="colw1">'+A.AssetCode+':'+A.AssetName+'</div><div class="colw3">'+B.CategName+'</div><div class="colw1">'+dbo.FunGetAssetLocation(Isnull(A.FKLocationID,0),Isnull(U3.FName,'')+' '+Isnull(U3.LName,''),Isnull(D.DeptName,''),Isnull(F.Company,''))+'</div>' as [label],A.AssetCode+':'+A.AssetName as  label1,
	A.PurchaseRate,
	Isnull(A.FKConditionID,0) as FKConditionID, Isnull(A.FKLocationID,0) as FKLocationID, Isnull(A.FKDeptID,0) as FKDeptID, Isnull(A.FKEmpID,0) as FKEmpID, Isnull(A.FKRepairPartyID,0) FKRepairPartyID
	From tblAsset A		
	Left Join tblAssetCategory B on A.FKCategoryID=B.PKID
	Left Join tblAssetConditionMaster C on A.FKConditionID=C.PKID
	Left Join tblUser U3 on A.FKEmpID=U3.PKUserID	
	Left Join tblDeptMaster D on A.FKDeptID=D.PKDeptID
	Left Join tblLocationMaster E on A.FKLocationID=E.PKID
	Left Join tblPartyMaster F on A.FKRepairPartyID=F.PKID
	Where (A.PKID=@PKID or @PKID=0)
	and A.FKCompanyID=@FKCompanyID
End
