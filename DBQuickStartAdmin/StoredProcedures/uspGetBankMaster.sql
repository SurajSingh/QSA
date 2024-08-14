CREATE PROCEDURE [dbo].[uspGetBankMaster]
	@PKID			Bigint,
	@FKCompanyID			Bigint
AS
Begin

	Select 1 as Result,PKBankID,BankName as label1,'<div class="col-md-12">'+BankName+'</div>'  as label	 From tblBankMaster 
	Where FKCompanyID=@FKCompanyID
	Order By BankName
End
