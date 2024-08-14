CREATE PROCEDURE [dbo].[uspGetProjectForAutoComplete]
@PKID     Bigint,
@ActiveStatus Varchar(50),
@FKClientID		Bigint,
@FKCompanyID	Bigint
AS
Begin
	Select 1 as Result,A.PKID as PKID,'<div class="colw1">'+A.ProjectCode+'</div><div class="colw3">'+A.ProjectName+'</div><div class="colw1">'+B.Code+'</div>' as [label],A.ProjectCode as  label1,
	A.ProjectName,
	Isnull(A1.TBillable,0) as TBillable,Isnull(A1.TMemoRequired,0) as TMemoRequired,Isnull(A1.EBillable,0) as EBillable,
	Isnull(A1.EMemoRequired,0) as EMemoRequired,Isnull(A1.TDesReadonly,0) as TDesReadonly,Isnull(A1.EDesReadOnly,0) as EDesReadOnly
	FRom tblProject A 
	Left Join tblClient B on A.FKClientID=B.PKID
	Left Join tblProjectDetail A1 on A1.FKProjectID=A.PKID
	where A.FKCompanyID=@FKCompanyID
	and (A.PKID=@PKID Or @PKID=0)
	and (A.FKClientID=@FKClientID Or @FKClientID=0)
	And (A.ProjectStatus=@ActiveStatus or @ActiveStatus='')
	Order By A.ProjectCode,B.Code

End