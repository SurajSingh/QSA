CREATE PROCEDURE [dbo].[uspGetBudgetForAutoComplete]
@FKProjecTID	Bigint,
@FKCompanyID	Bigint
AS
Begin
	Select 1 as Result,A.PKID as PKID,'<div class="colw1">'+A.BudgetTitle+'</div><div class="colw3">'+B.ProjectCode+'</div><div class="colw1">'+B.ProjectName+'</div>' as [label],A.BudgetTitle as  label1,
	B.ProjectName
	FRom tblProjectBudget A 
	Left Join tblProject B on A.FKProjectID=B.PKID	
	where A.FKCompanyID=@FKCompanyID
	and (A.FKProjectID=@FKProjecTID Or @FKProjecTID=0)
	Order By A.BudgetTitle,B.ProjectCode

End
