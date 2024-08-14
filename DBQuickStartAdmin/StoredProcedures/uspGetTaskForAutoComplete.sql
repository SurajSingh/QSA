CREATE PROCEDURE [dbo].[uspGetTaskForAutoComplete]
	@PKID     Bigint,
	@FKDeptID			Bigint,
	@TEType				Varchar(50),
	@ActiveStatus Varchar(50),
	@FKCompanyID Bigint
AS
Begin
	Select 1 as Result,A.PKID as PKID,'<div class="colw1">'+A.TaskCode+'</div><div class="colw3">'+A.TaskName+'</div><div class="colw1">'+A.[Description]+'</div>' as [label],A.TaskCode+':'+A.TaskName as  label1,
	A.Description,
	A.IsBillable,A.ActiveStatus,isnull(A.FKDeptID,0) as FKDeptID,A.CostRate,A.BillRate,A.TEType,A.Tax,A.BHours,A.isReimb,A.MuRate
	FRom tblTask A 
	where A.FKCompanyID=@FKCompanyID
	And A.TEType=@TEType
	and (A.PKID=@PKID Or @PKID=0)
	and (A.FKDeptID=@FKDeptID Or @FKDeptID=0)
	And (A.ActiveStatus=@ActiveStatus or @ActiveStatus='')
	Order By A.TaskCode+A.TaskName
End