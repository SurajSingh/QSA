CREATE PROCEDURE [dbo].[uspGetConfiguration]
	@FKCompanyID Bigint,
	@ApplyOn	Varchar(50),
	@FKBranchID	Bigint
AS
Begin
	
	Select PKID,KayName,KayVal from tblConfiguration
	Where FKCompanyID=@FKCompanyID 
	And ( @ApplyOn='' Or ApplyOn in (Select Item From dbo.FunSplitString(@ApplyOn,',')))
	And (Isnull(FKBranchID,0)=0 Or FKBranchID=@FKBranchID)
End
